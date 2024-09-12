//
//  HTTPS2WayViewController.m
//  ObjectiveC
//
//  Created by Dio Brand on 2022/11/18.
//  Copyright © 2022 my. All rights reserved.
//

#import "HTTPS2WayViewController.h"

#define url_prefix "https://" hostname ":8092"

@interface HTTPS2WayViewController ()<UITextViewDelegate,NSURLSessionDelegate>

@property (weak, nonatomic) IBOutlet UITextView *show;

@end

@implementation HTTPS2WayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"Https 双向验证";
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
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:[[NSOperationQueue alloc] init]];
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
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:[[NSOperationQueue alloc] init]];
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

- (void)URLSession:(NSURLSession *)session didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge
 completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential * _Nullable credential))completionHandler
{
    NSString *host = challenge.protectionSpace.host;
    NSLog(@"%@", host);
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
        if ([remoteCertificateSha256 isEqual:@"cb5374022dc37f108ab31884fd5b12ba5fd839ec3808c968e12c55a3361457ee"]) {
            NSLog(@"SSL ping is pass!");
            NSURLCredential *credential = [NSURLCredential credentialForTrust:serverTrust];
            completionHandler(NSURLSessionAuthChallengeUseCredential,credential);
        }else {
            NSLog(@"SSL ping is not pass!");
            completionHandler(NSURLSessionAuthChallengeCancelAuthenticationChallenge,NULL);
        }
    } else if([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodClientCertificate]) {
        //客户端证书认证
        //TODO:设置客户端证书认证
        //load cert
        NSLog(@"--------- send client cert ---------");
        NSString *path = [[NSBundle mainBundle]pathForResource:@"client" ofType:@"p12"];
        NSData *p12data = [NSData dataWithContentsOfFile:path];
        CFDataRef inP12data = (__bridge CFDataRef)p12data;
        SecIdentityRef myIdentity;
        OSStatus status = [self extractIdentity:inP12data toIdentity:&myIdentity];
        if (status != 0) {
            return;
        }
        SecCertificateRef myCertificate;
        SecIdentityCopyCertificate(myIdentity, &myCertificate);
        const void *certs[] = { myCertificate };
        CFArrayRef certsArray = CFArrayCreate(NULL, certs,1,NULL);
        NSURLCredential *credential = [NSURLCredential credentialWithIdentity:myIdentity certificates:(__bridge NSArray*)certsArray persistence:NSURLCredentialPersistencePermanent];
        
        completionHandler(NSURLSessionAuthChallengeUseCredential, credential);
    }
}

- (OSStatus)extractIdentity:(CFDataRef)inP12Data toIdentity:(SecIdentityRef*)identity {
    NSLog(@"%d:%@",__LINE__, [NSThread currentThread]);
    OSStatus securityError = errSecSuccess;
    CFStringRef password = CFSTR("p12pwd");
    const void *keys[] = { kSecImportExportPassphrase };
    const void *values[] = { password };
    CFDictionaryRef options = CFDictionaryCreate(NULL, keys, values, 1, NULL, NULL);
    CFArrayRef items = CFArrayCreate(NULL, 0, 0, NULL);
    securityError = SecPKCS12Import(inP12Data, options, &items);// p12 只支持 openssl < 3.0 生成
    if (securityError == 0) {
        NSLog(@"clinet.p12 success!");
        CFDictionaryRef ident = CFArrayGetValueAtIndex(items,0);
        const void *tempIdentity = NULL;
        tempIdentity = CFDictionaryGetValue(ident, kSecImportItemIdentity);
        *identity = (SecIdentityRef)tempIdentity;
    }else {
        NSLog(@"clinet.p12 error! status:%d",securityError);
    }
    
    if (options) {
        CFRelease(options);
    }
    return securityError;
}

@end
