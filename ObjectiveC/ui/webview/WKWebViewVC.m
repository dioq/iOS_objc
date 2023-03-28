//
//  WKWebViewVC.m
//  ObjC_UI
//
//  Created by William on 2018/9/28.
//  Copyright © 2018年 William. All rights reserved.
//

#import "WKWebViewVC.h"
#import <WebKit/WebKit.h>

@interface WKWebViewVC ()

@property (weak, nonatomic) IBOutlet WKWebView *webview;

@end

@implementation WKWebViewVC

// .storyboard 依赖库
// TARGETS -> AppName -> General -> Frameworks, Libraries, and Embedded Content 添加 WebKit.framework
- (void)viewDidLoad {
    [super viewDidLoad];
}

- (IBAction)loadOnlineUrl:(UIButton *)sender {
    NSString *urlString = @"https://www.baidu.com";
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    //    NSLog(@"url :%@", request.URL.host);
    [self.webview loadRequest:request];
}

- (IBAction)loadLocalUrl:(UIButton *)sender {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"show" ofType:@"html"];
    NSURL *url = [NSURL fileURLWithPath:path];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.webview loadRequest: request];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
