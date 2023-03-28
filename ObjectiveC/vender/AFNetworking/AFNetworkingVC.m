//
//  AFNetworkingVC.m
//  ObjectiveC
//
//  Created by hello on 2019/1/9.
//  Copyright © 2019 William. All rights reserved.
//

#import "AFNetworkingVC.h"
#import <AFNetworking.h>

@interface AFNetworkingVC ()<NSURLSessionDataDelegate>

@property (weak, nonatomic) IBOutlet UILabel *show;

@end

@implementation AFNetworkingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (IBAction)getAc:(UIButton *)sender {
    NSString *urlStr = @"http://jobs8.cn:8081/getdata";
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer.timeoutInterval = 30;
    [manager.securityPolicy setAllowInvalidCertificates:YES];
    AFJSONResponseSerializer *response = [AFJSONResponseSerializer serializer];
    response.removesKeysWithNullValues = YES;
    manager.responseSerializer = response;
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", @"text/plain",nil];
    //设置请求头
//    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [self showTip:@""];
    [manager GET:urlStr parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //        NSLog(@"type of responseObject :%@", [responseObject class]);
        NSLog(@"%@", responseObject);
        NSError *error;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:responseObject options:NSJSONWritingPrettyPrinted error:&error];
        NSString *jsonString;
        if (error) {
            NSLog(@"%@",[error localizedDescription]);
            [self showTip:[error localizedDescription]];
        }else{
            jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
            [self showTip:jsonString];
        }
        NSLog(@"\n%@", jsonString);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (error) {
            NSLog(@"error = %@",error);
        }
    }];
}

- (IBAction)postAction:(UIButton *)sender {
    NSString *urlStr = @"http://jobs8.cn:8081/postdata";
    
    NSMutableDictionary<NSString *,NSObject *> *params = [NSMutableDictionary dictionary];
    [params setValue:@"Dio" forKey:@"name"];
    [params setValue:@18 forKey:@"age"];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    AFJSONResponseSerializer *response = [AFJSONResponseSerializer serializer];
    response.removesKeysWithNullValues = YES;
    manager.responseSerializer = response;
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    manager.requestSerializer.timeoutInterval = 30;
    [manager.securityPolicy setAllowInvalidCertificates:YES];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", @"text/plain",nil];
    //设置请求头
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    
    [self showTip:@""];
    [manager POST:urlStr parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //        NSLog(@"type of responseObject :%@", [responseObject class]);
        NSLog(@"%@", responseObject);
        NSError *error;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:responseObject options:NSJSONWritingPrettyPrinted error:&error];
        NSString *jsonString;
        if (error) {
            NSLog(@"%@",[error localizedDescription]);
            [self showTip:[error localizedDescription]];
        }else{
            jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
            [self showTip:jsonString];
        }
        NSLog(@"\n%@", jsonString);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@", error);
    }];
}

- (IBAction)postSSL:(UIButton *)sender {
    NSString *urlStr = @"https://jobs8.cn:8082/postdata";
    
    NSMutableDictionary<NSString *,NSObject *> *params = [NSMutableDictionary dictionary];
    [params setValue:@"Dio" forKey:@"name"];
    [params setValue:@18 forKey:@"age"];
    
 
    // 1.初始化单例类
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    // 2.设置非校验证书模式
    manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    manager.securityPolicy.allowInvalidCertificates = YES;
    [manager.securityPolicy setValidatesDomainName:NO];

//    // 1.初始化单例类
//    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
////    manager.securityPolicy.SSLPinningMode = AFSSLPinningModeCertificate;
//    // 2.设置证书模式
//    NSString * cerPath = [[NSBundle mainBundle] pathForResource:@"server" ofType:@"cer"];
//    NSData * cerData = [NSData dataWithContentsOfFile:cerPath];
//    manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate withPinnedCertificates:[[NSSet alloc] initWithObjects:cerData, nil]];
//    // 客户端是否信任非法证书
//    manager.securityPolicy.allowInvalidCertificates = YES;
//    // 是否在证书域字段中验证域名
//    [manager.securityPolicy setValidatesDomainName:NO];

    
    AFJSONResponseSerializer *response = [AFJSONResponseSerializer serializer];
    response.removesKeysWithNullValues = YES;
    manager.responseSerializer = response;
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    manager.requestSerializer.timeoutInterval = 30;
    [manager.securityPolicy setAllowInvalidCertificates:YES];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", @"text/plain",nil];
    //设置请求头
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    
    [self showTip:@""];
    [manager POST:urlStr parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //        NSLog(@"type of responseObject :%@", [responseObject class]);
        NSLog(@"%@", responseObject);
        NSError *error;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:responseObject options:NSJSONWritingPrettyPrinted error:&error];
        NSString *jsonString;
        if (error) {
            NSLog(@"%@",[error localizedDescription]);
            [self showTip:[error localizedDescription]];
        }else{
            jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
            [self showTip:jsonString];
        }
        NSLog(@"\n%@", jsonString);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@", error);
    }];
}

- (IBAction)uploadAction:(UIButton *)sender {
    AFHTTPSessionManager *manager=[AFHTTPSessionManager manager];
    AFJSONResponseSerializer *response=[AFJSONResponseSerializer serializer];
    response.removesKeysWithNullValues=YES;
    manager.responseSerializer=response;
    manager.requestSerializer=[AFJSONRequestSerializer serializer];
    //设置请求头类型
    [manager.requestSerializer setValue:@"multipart/form-data" forHTTPHeaderField:@"Content-Type"];
    [manager.requestSerializer setValue:@"1" forHTTPHeaderField:@"d"];
    [manager.requestSerializer setValue:@"1" forHTTPHeaderField:@"c"];
    //设置请求头, 授权码
    [manager.requestSerializer setValue:@"Bearer_eyJhbGciOiJIUzUxMiJ9.eyJyYW5kb21LZXkiOiJzaGU3NWEiLCJzdWIiOiJ7XCJ1c2VySWRcIjoyNzN9IiwiZXhwIjoxNTQ3NjI0MTA1LCJpYXQiOjE1NDcwMTkzMDV9.FcrL5Og8Kebd80QhuhiOY0ShCRyekEYaHWPlE_XtpxpZujfCelI1H5BRvdgwPy_uiE9BOSDVw_rA2rWBBc9PgA" forHTTPHeaderField:@"Authorization"];
    
    //上传服务器接口
    NSString *url = [NSString stringWithFormat:@"http://slavex.3dabuliu.com/bbs/gcuser/uploadHeadImg"];
    
    //开始上传
    [manager POST:url parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        UIImage *image = [UIImage imageNamed:@"home"];
        NSData *imageData = UIImagePNGRepresentation(image);
        [formData appendPartWithFileData:imageData name:@"photoFile" fileName:@"1231.png" mimeType:@"image/png"];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        NSLog(@"上传进度: %f", uploadProgress.fractionCompleted);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"成功返回: %@", responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"上传失败: %@", error);
    }];
}

-(void)showTip:(NSString *)content {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.show setText:content];
    });
}

-(void)URLSession:(NSURLSession *)session didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition, NSURLCredential * _Nullable))completionHandler
{
    NSLog(@"--didReceiveChallenge--%@",challenge.protectionSpace);
    /*
     NSURLSessionAuthChallengeUseCredential = 0,      使用
     NSURLSessionAuthChallengePerformDefaultHandling = 1,   忽略(默认)
     NSURLSessionAuthChallengeCancelAuthenticationChallenge = 2,忽略(会取消请求)
     NSURLSessionAuthChallengeRejectProtectionSpace = 3, 忽略(下次继续询问)
     */
    // NSURLAuthenticationMethodServerTrust 服务器信任
    if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
        //创建证书
        NSURLCredential *credentoal = [[NSURLCredential alloc]initWithTrust:challenge.protectionSpace.serverTrust];
        completionHandler(NSURLSessionAuthChallengeUseCredential,credentoal);
    }
}

@end
