//
//  HTTPSPingViewController.m
//  ObjectiveC
//
//  Created by Dio Brand on 2022/11/18.
//  Copyright © 2022 my. All rights reserved.
//

#import "HTTPSPing02ViewController.h"

@interface HTTPSPing02ViewController ()<UITextViewDelegate,NSURLSessionDelegate>

@property (weak, nonatomic) IBOutlet UITextView *show;

@end

@implementation HTTPSPing02ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"Https 证书绑定 SSL ping 实现二";
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
        
        // 判断服务器证书是否是 CA认证过的
        SecTrustRef trust = NULL;
        CFErrorRef error = NULL;
        BOOL certificateIsValid = SecTrustEvaluateWithError(trust, &error);
        if(error) {
            NSLog(@"CFErrorRef:%@",error);
            return;
        }
        // 是否是 CA 颁发的证书
        if(certificateIsValid) {
            NSLog(@"CA 机构颁发的证书");
        }else {
            NSLog(@"不是 CA 机构颁发的证书");
        }
        
        // 获取服务器传过来的 服务器证书(server cert)
        SecTrustRef serverTrust = challenge.protectionSpace.serverTrust;
        SecCertificateRef certificate = SecTrustGetCertificateAtIndex(serverTrust, 0);
        NSData *remoteCertificate = CFBridgingRelease(SecCertificateCopyData(certificate));
        NSLog(@"remoteCertificate:\n%@",[remoteCertificate base64EncodedStringWithOptions:0]);
        
        NSString *remoteCertificateBase64 = [remoteCertificate base64EncodedStringWithOptions:0];
        NSString *remoteCertificateSha256 = [CryptoUtil sha256:remoteCertificateBase64];
        
        // SSL Ping 本地不存放证书,获取服务器传来的证书后 直接base64再sha256 再对这个值做唯一性判断
        if ([remoteCertificateSha256 isEqual:@"b562609ad94eddce1995f97250c310d50bec14eadf08741a04506c9f18171780"]) {
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
