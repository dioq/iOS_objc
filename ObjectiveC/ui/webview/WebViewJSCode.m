//
//  WebViewJSCode.m
//  ObjectiveC
//
//  Created by Dio Brand on 2023/2/8.
//  Copyright © 2023 my. All rights reserved.
//

#import "WebViewJSCode.h"
#import <WebKit/WebKit.h>

@interface WebViewJSCode ()<WKNavigationDelegate,WKUIDelegate,WKScriptMessageHandler>

@property(nonatomic,strong)WKWebView *myWebView;

@end

@implementation WebViewJSCode

- (void)viewDidLoad {
    [super viewDidLoad];
    
    WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
    configuration.userContentController = [[WKUserContentController alloc] init];
    /**
     监控 webview 中的 js 方法 callNativeFunc,当 callNativeFunc 触发后会调用 -[WebViewJSCode userContentController:didReceiveScriptMessage:]
     */
    [configuration.userContentController addScriptMessageHandler:self name:@"callNativeFunc"];
    self.myWebView = [[WKWebView alloc] initWithFrame:self.view.frame configuration:configuration];
    [self.view addSubview:self.myWebView];
    self.myWebView.navigationDelegate = self;
    self.myWebView.UIDelegate = self;
    
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"show" ofType:@"html"];
    NSURL *url = [NSURL fileURLWithPath:path];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.myWebView loadRequest: request];
}

#pragma mark - WKNavigationDelegate
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    NSLog(@"webView.title:%@",webView.title); //获取webview的title
    // JS代码 (获取show.html 中input标签中的值)
    NSString *jscode1 = @"document.getElementsByName('input')[0].attributes['value'].value";
    //执行JS
    [webView evaluateJavaScript:jscode1 completionHandler:^(id _Nullable response, NSError * _Nullable error) {
        if(error != nil) {
            NSLog(@"error:%@",[error localizedFailureReason]);
        }else {
            NSLog(@"get value from web:%@", response);
        }
    }];
    
    // JS代码 (更改show.html 中input标签中的值)
    NSString *jscode2 = @"document.getElementsByName('input')[0].attributes['value'].value = 'new value from app'";
    //执行JS
    [webView evaluateJavaScript:jscode2 completionHandler:^(id _Nullable response, NSError * _Nullable error) {
        if(error != nil) {
            NSLog(@"error:%@",[error localizedFailureReason]);
        }else {
            NSLog(@"app change vaule to web:%@", response);
        }
    }];
}

#pragma mark - WKUIDelegate
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message{
    NSLog(@"message.name:%@\nmessage.body:%@",message.name,message.body);
    if ([message.name isEqualToString:@"callNativeFunc"]) {
        // 调用原生扫码
        NSLog(@"此处调用原生代码");
        
        NSString *jscode = @"scanResult('应该返回扫描结果的,不过没实现')";
        // 执行JS,返回扫描结果给 web
        [self.myWebView evaluateJavaScript:jscode completionHandler:^(id _Nullable response, NSError * _Nullable error) {
            if(error != nil) {
                NSLog(@"error:%@",[error localizedFailureReason]);
            }else {
                NSLog(@"web function scanResult return value:%@", response);
            }
        }];
    }
}

-(void)dealloc {
    // 为了避免循环引用，导致控制器无法被释放，需要移除
    [self.myWebView.configuration.userContentController removeScriptMessageHandlerForName:@"callNativeFunc"];
}

@end
