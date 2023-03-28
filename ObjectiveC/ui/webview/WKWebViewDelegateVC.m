//
//  WKWebView2VC.m
//  ObjectiveC
//
//  Created by Dio Brand on 2022/8/20.
//  Copyright © 2022 my. All rights reserved.
//

#import "WKWebViewDelegateVC.h"
#import <WebKit/WebKit.h>

@interface WKWebViewDelegateVC ()<WKNavigationDelegate,WKUIDelegate,WKScriptMessageHandler>

@property(nonatomic, strong)WKWebView *webView;
@property(nonatomic, strong)UIProgressView *progressView;

@end

@implementation WKWebViewDelegateVC

// 隐藏toolbar
- (BOOL)prefersStatusBarHidden {
    return YES;
}

// 工具栏状态
//-(UIStatusBarStyle)preferredStatusBarStyle {
//    return UIStatusBarStyleDefault;
//}

// 隐藏 navigationBar
-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:YES];
}

// web进度条
-(UIProgressView *)progressView {
    if (!_progressView) {
        self.progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, 0)];
        self.progressView.tintColor = [UIColor greenColor];     // 进度条颜色
        self.progressView.backgroundColor = [UIColor redColor]; // 进度条背景色
        //设置进度条的高度，下面这句代码表示进度条的宽度变为原来的1倍，高度变为原来的1.5倍.
        self.progressView.transform = CGAffineTransformMakeScale(1.0f, 1.5f);
        [self.view addSubview:self.progressView];
    }
    return _progressView;
}

// 监控 web 进度
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"estimatedProgress"]) {
        self.progressView.alpha = 1.0;
        self.progressView.hidden = NO;
        [self.progressView setProgress:self.webView.estimatedProgress animated:YES];
        if (self.progressView.progress >= 1) {
            /*
             *添加一个简单的动画，将progressView的Height变为1.4倍，在开始加载网页的代理中会恢复为1.5倍
             *动画时长0.25s，延时0.3s后开始动画
             *动画结束后将progressView隐藏
             */
            __weak typeof (self)weakSelf = self;
            [UIView animateWithDuration:0.25f delay:0.3f options:UIViewAnimationOptionCurveEaseOut animations:^{
                weakSelf.progressView.transform = CGAffineTransformMakeScale(1.0f, 1.4f);
                weakSelf.progressView.alpha = 0;
            } completion:^(BOOL finished) {
                weakSelf.progressView.hidden = YES;
                [weakSelf.progressView setProgress:0 animated:NO];
            }];
        }
    }else{
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //    wkwebview属性的集合
    WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc]init];
    //    webview一些首选项的配置
    WKPreferences *preferences = [[WKPreferences alloc]init];
    //    在没有用户交互的情况下，是否允许js打开窗口，macOS默认是yes，iOS默认是no
    preferences.javaScriptCanOpenWindowsAutomatically = YES;
    //    webview的最小字体大小
    //    preferences.minimumFontSize = 40.0;
    configuration.preferences = preferences;
    
    self.webView = [[WKWebView alloc] initWithFrame:self.view.frame configuration:configuration];
    // 是否允许手势左滑返回上一级, 类似导航控制的左滑返回
    self.webView.allowsBackForwardNavigationGestures = YES;
    [self.view addSubview:self.webView];
    self.webView.UIDelegate = self;            // UI代理
    self.webView.navigationDelegate = self;    // 导航代理
    
    // 监控web加载进度
    [self.webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
    
    // 加载 url
    NSString *urlStr = @"https://oa.hahaya.top/touch";
    urlStr = [urlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSURL *url = [NSURL URLWithString:urlStr];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
}

#pragma mark - WKNavigationDelegate
// 页面开始加载时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation{
    NSLog(@"%s",__FUNCTION__);
}
// 当内容开始返回时调用
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation{
    NSLog(@"%s",__FUNCTION__);
}
// 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    NSLog(@"%s",__FUNCTION__);
    NSLog(@"webView.title:%@",webView.title); //获取webview的title
}
// 页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation{
    NSLog(@"%s",__FUNCTION__);
}
// 接收到服务器跳转请求之后调用
- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(WKNavigation *)navigation{
    NSLog(@"%s",__FUNCTION__);
}
// 在发送请求之前，决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler{
    NSLog(@"%s",__FUNCTION__);
    NSLog(@"%@",navigationAction.request.URL.absoluteString);
    //允许跳转
    decisionHandler(WKNavigationActionPolicyAllow);
    //不允许跳转
    //decisionHandler(WKNavigationActionPolicyCancel);
}
// 在收到响应后，决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler{
    NSLog(@"%s",__FUNCTION__);
    NSLog(@"%@",navigationResponse.response.URL.absoluteString);
    //允许跳转
    decisionHandler(WKNavigationResponsePolicyAllow);
    //不允许跳转
    //decisionHandler(WKNavigationResponsePolicyCancel);
}
#pragma mark - WKUIDelegate
// 创建一个新的WebView
- (WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures{
    NSLog(@"%s",__FUNCTION__);
    NSLog(@"%@",navigationAction.request.URL.absoluteString);
    //    //targetFrame的mainFrame属性为NO，将会新开一个页面
    if (!navigationAction.targetFrame.mainFrame) {
        /*
         1. 放弃原来页面直接打开新的页面
         可以左滑返回上一级页面，对纯web的应用是可以的。如果是当前这种把 webview 当成一个控件的情况，左滑会返回上一次跳转到这个 WKWebViewDelegateVC 的 ViewController
         */
        [webView loadRequest:navigationAction.request];
        
        /*
         2. 新建一个 webview 加载新 web
         */
        //        WKWebView *newWebView = [[WKWebView alloc] initWithFrame:CGRectMake(30, 100, 300, 100) configuration:configuration];
        //        newWebView.allowsBackForwardNavigationGestures = YES;
        //        [newWebView loadRequest:navigationAction.request];
        //        [self.view addSubview:newWebView];
        //        return newWebView;
    }
    
    return nil;
}

// 警告框。显示一个按钮。点击后调用completionHandler回调
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler{
    NSLog(@"%s",__FUNCTION__);
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:message message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        completionHandler();
    }]];
    [self presentViewController:alertController animated:YES completion:nil];
}

// 确认框。 显示两个按钮，通过completionHandler回调判断用户点击的确定还是取消按钮
- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL))completionHandler{
    NSLog(@"%s",__FUNCTION__);
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:message message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(YES);
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(NO);
    }]];
    [self presentViewController:alertController animated:YES completion:nil];
}

// 输入框。显示一个带有输入框和一个确定按钮的，通过completionHandler回调用户输入的内容
- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * _Nullable))completionHandler{
    NSLog(@"%s",__FUNCTION__);
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"输入框" message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        
    }];
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(alertController.textFields.lastObject.text);
    }]];
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark - WKScriptMessageHandler
// 通过接收JS传出消息的name进行捕捉的回调方法
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    NSLog(@"%s",__FUNCTION__);
    if ([message.name isEqualToString:@"showMessage"]) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"title" message:@"messgae" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"同意" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            NSString *jsStr = [NSString stringWithFormat:@"setLocation('%@')",@"同意了."];
            [self.webView evaluateJavaScript:jsStr completionHandler:^(id _Nullable result, NSError * _Nullable error) {
                NSLog(@"%@----%@",result, error);
            }];
        }];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            NSLog(@"cancel");
            
        }];
        UIAlertAction *errorAction = [UIAlertAction actionWithTitle:@"拒绝" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            NSString *jsStr = [NSString stringWithFormat:@"setLocation('%@')",@"拒绝了."];
            [self.webView evaluateJavaScript:jsStr completionHandler:^(id _Nullable result, NSError * _Nullable error) {
                NSLog(@"%@----%@",result, error);
            }];
        }];
        [alertController addAction:errorAction];
        [alertController addAction:okAction];
        [alertController addAction:cancelAction];
        
        // 出现
        [self presentViewController:alertController animated:YES completion:^{
            
        }];
        
    }
}

// dealloc中取消监听
- (void)dealloc {
    [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
}

@end
