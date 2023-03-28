//
//  WebViewJSCode2.m
//  ObjectiveC
//
//  Created by Dio Brand on 2023/2/8.
//  Copyright © 2023 my. All rights reserved.
//

#import "WebViewJSCode2.h"
#import <WebKit/WebKit.h>

@interface WebViewJSCode2 ()<WKNavigationDelegate,WKUIDelegate,WKScriptMessageHandler>

@property (weak, nonatomic) IBOutlet WKWebView *myWebView;

@end

@implementation WebViewJSCode2

- (void)viewDidLoad {
    [super viewDidLoad];
    self.myWebView.navigationDelegate = self;
    self.myWebView.UIDelegate = self;
    
    // 监控从js调用的4个方法，分别传过来不同类型的参数
    [self.myWebView.configuration.userContentController addScriptMessageHandler:self name:@"showAlert"];
    [self.myWebView.configuration.userContentController addScriptMessageHandler:self name:@"postString"];
    [self.myWebView.configuration.userContentController addScriptMessageHandler:self name:@"postArray"];
    [self.myWebView.configuration.userContentController addScriptMessageHandler:self name:@"postDictionary"];
    
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"show2" ofType:@"html"];
    NSURL *url = [NSURL fileURLWithPath:path];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.myWebView loadRequest: request];
}

#pragma mark - WKUIDelegate
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler {
    //WKWebView中使用弹窗
    UIAlertController *alertCrontroller = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
    [alertCrontroller addAction:[UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        completionHandler();
    }]];
    [self presentViewController:alertCrontroller animated:YES completion:nil];
}

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message{
    NSLog(@"%s",__FUNCTION__);
    NSLog(@"message.name:%@\nmessage.body:%@",message.name,message.body);
    
    if ([message.name isEqualToString:@"showAlert"]) {
        [self alert];
    }else if ([message.name isEqualToString:@"postString"]) {
        [self changeColorWithString:message.body];
    }else if ([message.name isEqualToString:@"postArray"]) {
        [self changeColorWithArray:message.body];
    }else if ([message.name isEqualToString:@"postDictionary"]) {
        [self changeColorWithDictionary:message.body];
    }
}

- (void)alert {
    // OC调用JS
    NSString *jsStr = [NSString stringWithFormat:@"alertWithMessage('%@')", @"OC调用JS的方法"];
    [self.myWebView evaluateJavaScript:jsStr completionHandler:^(id _Nullable response, NSError * _Nullable error) {
        if(error != nil) {
            NSLog(@"error:%@",[error localizedFailureReason]);
        }else {
            NSLog(@"web function return value:%@", response);
        }
    }];
}

- (void)changeColorWithString:(NSString *)string {
    NSArray *params =[string componentsSeparatedByString:@","];
    
    NSMutableDictionary *tempDic = [NSMutableDictionary dictionary];
    for (NSString *paramStr in params) {
        NSArray *dicArray = [paramStr componentsSeparatedByString:@"="];
        if (dicArray.count > 1) {
            NSString *decodeValue = [dicArray[1] stringByRemovingPercentEncoding];
//            NSString *decodeValue = [dicArray[1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            [tempDic setObject:decodeValue forKey:dicArray[0]];
        }
    }
    CGFloat r = [[tempDic objectForKey:@"r"] floatValue];
    CGFloat g = [[tempDic objectForKey:@"g"] floatValue];
    CGFloat b = [[tempDic objectForKey:@"b"] floatValue];
    CGFloat a = [[tempDic objectForKey:@"a"] floatValue];
    
    self.navigationController.navigationBar.backgroundColor = [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a];
}

- (void)changeColorWithArray:(NSArray *)array {
    CGFloat r = [array[0] floatValue]/255.0;
    CGFloat g = [array[1] floatValue]/255.0;
    CGFloat b = [array[2] floatValue]/255.0;
    CGFloat alpha = [array[3] floatValue];
    self.navigationController.navigationBar.backgroundColor = [UIColor colorWithRed:r green:g blue:b alpha:alpha];
}

- (void)changeColorWithDictionary:(NSDictionary *)dict {
    CGFloat r = [dict[@"red"] floatValue]/255.0;
    CGFloat g = [dict[@"green"] floatValue]/255.0;
    CGFloat b = [dict[@"blue"] floatValue]/255.0;
    CGFloat alpha = [dict[@"alpha"] floatValue];
    self.navigationController.navigationBar.backgroundColor = [UIColor colorWithRed:r green:g blue:b alpha:alpha];
}

-(void)dealloc {
    // 为了避免循环引用，导致控制器无法被释放，需要移除
    [self.myWebView.configuration.userContentController removeScriptMessageHandlerForName:@"showAlert"];
    [self.myWebView.configuration.userContentController removeScriptMessageHandlerForName:@"postString"];
    [self.myWebView.configuration.userContentController removeScriptMessageHandlerForName:@"postArray"];
    [self.myWebView.configuration.userContentController removeScriptMessageHandlerForName:@"postDictionary"];
}

@end
