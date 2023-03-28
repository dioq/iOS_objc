//
//  WKJSWebView.h
//  ObjectiveC
//
//  Created by Dio Brand on 2023/2/8.
//  Copyright © 2023 my. All rights reserved.
//

#import <WebKit/WebKit.h>
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

#pragma mark - WKJSWebView

@interface WKJSWebView : WKWebView

- (instancetype)initWithFrame:(CGRect)frame configuration:(WKWebViewConfiguration*)configuration scripts:(NSArray<NSString*>*)scripts withJavascriptInterfaces:(NSDictionary*)interfaces;

/// 主线程执行js
- (void)wk_evaluateJavaScript:(NSString *)javaScriptString completionHandler:(void (^)(id, NSError *))completionHandler;

/// native 调用 h5 方法
- (void)invokeJSFunction:(NSString*)jsFuncName params:(id)params completionHandler:(void (^)(id response, NSError *error))completionHandler;

@end

#pragma mark - WKJSListener

@interface WKJSListener : NSObject<WKNavigationDelegate,WKScriptMessageHandler>
@property (nonatomic) NSDictionary *javascriptInterfaces;
@end


#pragma mark - WKJSDataFunction

@interface WKJSDataFunction : NSObject

@property (nonatomic, copy) NSString* funcID;
@property (nonatomic, strong) WKJSWebView *webView;
@property (nonatomic, assign) BOOL removeAfterExecute;

- (instancetype)initWithWebView:(WKJSWebView*)webView;

// 回调JS
- (void)execute:(void (^)(id response, NSError* error))completionHandler;
- (void)executeWithParam:(NSString *)param completionHandler:(void (^)(id response, NSError* error))completionHandler;
- (void)executeWithParams:(NSArray *)params completionHandler:(void (^)(id response, NSError* error))completionHandler;

@end

NS_ASSUME_NONNULL_END
