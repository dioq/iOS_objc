//
//  WebViewJSBridgeVC.m
//  ObjectiveC
//
//  Created by zd on 10/3/2026.
//  Copyright © 2026 my. All rights reserved.
//

#import "WebViewJSBridgeVC.h"
#import <WebKit/WebKit.h>

#define msg_name @"nativeBridge"

@interface WebViewJSBridgeVC ()<WKScriptMessageHandler, WKNavigationDelegate>

@property(nonatomic,strong)WKWebView *myWebView;

@end

@implementation WebViewJSBridgeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"call_js" style:UIBarButtonItemStylePlain target:self action:@selector(call_js_func)];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    [self setWebView];
}

-(void)setWebView {
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    // 非常重要：添加消息处理器（可以添加多个 name）
    [config.userContentController addScriptMessageHandler:self name:msg_name];
    // 可以添加多个通道
    // [config.userContentController addScriptMessageHandler:self name:@"pay"];
    
    self.myWebView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight) configuration:config];
    [self.view addSubview:self.myWebView];
    self.myWebView.navigationDelegate = self;
    
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"jsbridge" withExtension:@"html"];
    [self.myWebView loadFileURL:url allowingReadAccessToURL:url.URLByDeletingLastPathComponent];
}

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    // message.name 就是注册的名字
    if ([message.name isEqualToString:msg_name]) {
        id body = message.body;
        NSLog(@"received:%@", body);
    }
}

-(void)call_js_func {
    NSString *msg = @"msg from oc";
    NSString *method = [NSString stringWithFormat:@"js_func_for_call('%@');",msg];
    [self.myWebView evaluateJavaScript:method completionHandler:^(id _Nullable result, NSError * _Nullable error) {
        if (error) {
            NSLog(@"执行 JS 失败: %@", error);
        } else {
            NSLog(@"JS 返回: %@", result);
        }
    }];
}

// 避免内存泄漏
- (void)dealloc {
    [self.myWebView.configuration.userContentController removeScriptMessageHandlerForName:msg_name];
}

@end
