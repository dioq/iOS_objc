//
//  HTTPS1WayViewController.m
//  ObjectiveC
//
//  Created by Dio Brand on 2022/11/18.
//  Copyright © 2022 my. All rights reserved.
//

#import "HTTPS1WayViewController.h"

#define url_prefix "http://" hostname ":8091"

/*
 不可信任的证书 要在 Info.plist 里把域名加入白名单
 
 <?xml version="1.0" encoding="UTF-8"?>
 <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
 <plist version="1.0">
 <dict>
 <key>NSAllowsArbitraryLoads</key>
 <true/>
 <key>NSExceptionDomains</key>
 <dict>
 <key>jobs8.cn</key>
 <dict>
 <key>NSExceptionAllowsInsecureHTTPLoads</key>
 <true/>
 <key>NSIncludesSubdomains</key>
 <true/>
 </dict>
 </dict>
 </dict>
 </plist>
 **/
@interface HTTPS1WayViewController ()<UITextViewDelegate,NSURLSessionDelegate>

@property (weak, nonatomic) IBOutlet UITextView *show;

@end

@implementation HTTPS1WayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"Https 单向验证";
    self.show.delegate = self;
}

- (IBAction)getAction:(UIButton *)sender {
    [self.show setText:@""];
    NSString *urlStr = [NSString stringWithFormat:@"%s/get", url_prefix];
    NSURL *url = [NSURL URLWithString:urlStr];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setValue:@"application/json; charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"iOS" forHTTPHeaderField:@"User-Agent"];
    [request setValue:@"gzip, deflate, br" forHTTPHeaderField:@"Accept-Encoding"];
    [request setValue:@"*/*" forHTTPHeaderField:@"Accept"];
    
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    config.timeoutIntervalForRequest = 30;
    config.requestCachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        NSString *result = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.show setText:result];
        });
    }];
    
    // 执行
    [task resume];
}

- (IBAction)postAction:(UIButton *)sender {
    [self.show setText:@""];
    NSString *urlStr = [NSString stringWithFormat:@"%s/post", url_prefix];
    NSURL *url = [NSURL URLWithString:urlStr];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json; charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"iOS" forHTTPHeaderField:@"User-Agent"];
    [request setValue:@"gzip, deflate, br" forHTTPHeaderField:@"Accept-Encoding"];
    [request setValue:@"*/*" forHTTPHeaderField:@"Accept"];
    
    NSString *param_json = @"{\"name\":\"JOJO\",\"age\":27}";
    NSData *param_data = [param_json dataUsingEncoding:NSUTF8StringEncoding];
    request.HTTPBody = param_data;
    
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    config.timeoutIntervalForRequest = 30;
    config.requestCachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        NSString *result = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.show setText:result];
        });
    }];
    
    // 执行
    [task resume];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]) {
        [self.view endEditing:YES];
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

-(void)URLSession:(NSURLSession *)session didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition, NSURLCredential * _Nullable))completionHandler {
    NSString *host = challenge.protectionSpace.host;
    NSLog(@"host:%@", host);
    if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
        NSLog(@"--------- check server cert ---------");
        SecTrustRef serverTrust = challenge.protectionSpace.serverTrust;
        // 获取 服务器证书(server cert) 类型
        SecTrustResultType result;
        SecTrustEvaluate(serverTrust, &result);
        NSLog(@"SecTrustResultType: %u", result);
        // 是否是 CA 颁发的证书
        BOOL certificateIsValid = (result == kSecTrustResultUnspecified || result == kSecTrustResultProceed);
        if(certificateIsValid) {
            NSLog(@"CA 机构颁发的证书");
            NSURLCredential *credential = [NSURLCredential credentialForTrust:serverTrust];
            completionHandler(NSURLSessionAuthChallengeUseCredential,credential);
        }else {
            NSLog(@"不是 CA 机构颁发的证书");
            // 如果有 CA证书 就应用调用这个方法,这个方法不让服务器进行通信
            //completionHandler(NSURLSessionAuthChallengeCancelAuthenticationChallenge,NULL);
            
            // 目前没有CA证书,就不验证了，所有证书都让通过(只是权宜之计)
            NSURLCredential *credential = [NSURLCredential credentialForTrust:serverTrust];
            completionHandler(NSURLSessionAuthChallengeUseCredential,credential);
        }
    }
}

@end
