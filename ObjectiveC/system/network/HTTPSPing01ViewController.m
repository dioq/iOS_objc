//
//  HTTPSPing01ViewController.m
//  ObjectiveC
//
//  Created by Dio Brand on 2022/11/18.
//  Copyright © 2022 my. All rights reserved.
//

#import "HTTPSPing01ViewController.h"

@interface HTTPSPing01ViewController ()<UITextViewDelegate,NSURLSessionDelegate>

@property (weak, nonatomic) IBOutlet UITextView *show;

@end

@implementation HTTPSPing01ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"Https 证书绑定 SSL ping 实现一";
    self.show.delegate = self;
}

- (IBAction)getAction:(UIButton *)sender {
    [self.show setText:@""];
    NSString *urlStr = @"https://jobs8.cn:8091/get";
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
    NSString *urlStr = @"https://jobs8.cn:8091/post";
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

// 验证 Https 的 SSL 证书
- (void)URLSession:(NSURLSession *)session didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge
 completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential * _Nullable credential))completionHandler
{
    NSString *host = challenge.protectionSpace.host;
    NSLog(@"host: %@", host);
    
    if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
        NSLog(@"--------- check server cert ---------");
        /*
         Server 证书认证
         可以只认证 CA 证书,
         也可以更进一步不光认证 CA证书,还得是自己服务器的CA证书,这就是证书绑定
         **/
        
        SecTrustRef serverTrust = challenge.protectionSpace.serverTrust;
        
        // 获取 服务器证书(server cert) 类型
        SecTrustResultType result;
        SecTrustEvaluate(serverTrust, &result);
        NSLog(@"SecTrustResultType: %u", result);
        // 是否是 CA 颁发的证书
        BOOL certificateIsValid = (result == kSecTrustResultUnspecified || result == kSecTrustResultProceed);
        if(certificateIsValid) {
            NSLog(@"CA 机构颁发的证书");
        }else {
            NSLog(@"不是 CA 机构颁发的证书");
        }
        // 获取服务器传过来的 服务器证书(server cert)
        SecCertificateRef certificate = SecTrustGetCertificateAtIndex(serverTrust, 0);
        NSData *remoteCertificate = CFBridgingRelease(SecCertificateCopyData(certificate));
        NSLog(@"remoteCertificate:\n%@",[remoteCertificate base64EncodedStringWithOptions:0]);
        
        // 获取本地保存的 服务器证书(server cert)
        NSString *pathToCer = [[NSBundle mainBundle] pathForResource:@"server" ofType:@"cer"];
        NSData *localCertificate = [NSData dataWithContentsOfFile:pathToCer];
        NSString *localCerticateString = [[NSString alloc] initWithData:localCertificate encoding:NSUTF8StringEncoding];
        NSLog(@"localCertificate:\n%@",localCerticateString);
        localCerticateString = [localCerticateString stringByReplacingOccurrencesOfString:@"-----BEGIN CERTIFICATE-----" withString:@""];
        localCerticateString = [localCerticateString stringByReplacingOccurrencesOfString:@"-----END CERTIFICATE-----" withString:@""];
        localCerticateString = [localCerticateString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        NSLog(@"localCertificate:\n%@",localCerticateString);
        localCertificate = [[NSData alloc]initWithBase64EncodedString:localCerticateString options:0];
        
        // SSL Ping 根据本地保存的服务器证书 与 从服务器传过来的服务器证书 两个二进制文件作判断。这种实现方式本地需要保存一份服务器的证书
        if ([remoteCertificate isEqualToData:localCertificate]) {
            NSLog(@"SSL ping is pass!");
            NSURLCredential *credential = [NSURLCredential credentialForTrust:serverTrust];
            completionHandler(NSURLSessionAuthChallengeUseCredential,credential);
        }else {
            NSLog(@"SSL ping is not pass!");
            completionHandler(NSURLSessionAuthChallengeCancelAuthenticationChallenge,NULL);
        }
    }
}

@end
