//
//  RequestManager.m
//  ObjectiveC
//
//  Created by hello on 2019/3/24.
//  Copyright © 2019 William. All rights reserved.
//

#import "NetworkManager.h"

@interface NetworkManager()<NSURLSessionDelegate>

@end

@implementation NetworkManager

+ (instancetype)sharedManager {
    static NetworkManager *staticInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        staticInstance = [[super allocWithZone:NULL] init];
    });
    return staticInstance;
}

+(id)allocWithZone:(struct _NSZone *)zone{
    return [[self class] sharedManager];
}

-(id)copyWithZone:(struct _NSZone *)zone{
    return [[self class] sharedManager];
}

#pragma mark - 设置请求的配置
- (NSURLSessionConfiguration *)getConfig {
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    config.timeoutIntervalForRequest = 30;
    config.requestCachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
    // 也可以在这里设置 http 请求头
    NSMutableDictionary *headers =[NSMutableDictionary dictionary];
    [headers setValue:@"application/json; charset=UTF-8" forKey:@"Content-Type"];
    [headers setValue:@"iOS" forKey:@"User-Agent"];
    [headers setValue:@"gzip, deflate, br" forKey:@"Accept-Encoding"];
    [headers setValue:@"*/*" forKey:@"Accept"];
    config.HTTPAdditionalHeaders = headers;
    
    return config;
}

#pragma mark - get请求
- (void)getUrl:(NSString *)urlStr success:(void (^)(id _Nonnull))success failure:(void (^)(NSError * _Nonnull))failure {
    NSURL *url = [NSURL URLWithString:urlStr];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    //    NSURLSession *session = [NSURLSession sessionWithConfiguration:[self getConfig]];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[self getConfig] delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            failure(error);
        }else {
            NSString *result = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            success(result);
        }
    }];
    // 执行
    [task resume];
}

#pragma mark - post 参数是 NSData
- (void)postUrl:(NSString *)urlStr parameters:(NSData *)params success:(void (^)(id _Nonnull))success failure:(void (^)(NSError * _Nonnull))failure {
    NSURL *url = [NSURL URLWithString:urlStr];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    
    if(params) {
        request.HTTPBody = params;
    }
    
    //    NSURLSession *session = [NSURLSession sessionWithConfiguration:[self getConfig]];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[self getConfig] delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            failure(error);
        }else {
            success(data);
        }
    }];
    // 执行
    [task resume];
}

// post 参数是json格式
- (void)postUrl:(NSString *)urlStr paramJson:(NSDictionary * _Nullable)params success:(void (^)(id _Nonnull))success failure:(void (^)(NSError * _Nonnull))failure {
    NSURL *url = [NSURL URLWithString:urlStr];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    
    NSError *error;
    NSData *param_data = [NSJSONSerialization dataWithJSONObject:params options:NSJSONWritingPrettyPrinted error:&error];
    if (error) {
        failure(error);
        return;
    }
    
    [self postUrl:urlStr parameters:param_data success:^(id  _Nonnull response) {
        NSString *result = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
        success(result);
    } failure:^(NSError * _Nonnull error) {
        failure(error);
    }];
}

-(void)submitUrl:(NSString *)urlStr textDict:(NSDictionary<NSString *,NSString *> *)textDict fileDict:(NSDictionary<NSString *,NSData *> *)fileDict success:(void (^)(id _Nonnull))success failure:(void (^)(NSError * _Nonnull))failure {
    NSURL *url = [NSURL URLWithString:urlStr];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.timeoutInterval = 30;
    request.HTTPMethod = @"POST";
    
    NSString *uuidStr = [[NSUUID UUID] UUIDString];
    NSString *boundary = [uuidStr stringByReplacingOccurrencesOfString:@"-" withString:@""];
    
    NSString *content_type = [NSString stringWithFormat:@"multipart/form-data;boundary=%@", boundary];
    [request setValue:content_type forHTTPHeaderField:@"Content-Type"];
    
    NSString *line_break = @"\r\n"; // 换行
    NSString *item_start = [NSString stringWithFormat:@"--%@%@",boundary,line_break]; // form-data 每一项开始标志
    NSString *body_end = [NSString stringWithFormat:@"%@--%@--%@",line_break,boundary,line_break]; // body 结束标志
    
    // TEXT 类型数据拼装
    NSMutableData *textMutData = [[NSMutableData alloc] init];
    // 遍历 textMutData
    for (NSString *key in [textDict allKeys]) {
        // 1. 每一项的开始
        [textMutData appendData:[item_start dataUsingEncoding:NSUTF8StringEncoding]];
        // 2. 每一项的描述信息
        NSString *content_disposition = [NSString stringWithFormat:@"Content-Disposition: form-data; name=%@",key];
        [textMutData appendData:[content_disposition dataUsingEncoding:NSUTF8StringEncoding]];
        // 3. 描述信息和数据之间 换2行
        [textMutData appendData:[line_break dataUsingEncoding:NSUTF8StringEncoding]];
        [textMutData appendData:[line_break dataUsingEncoding:NSUTF8StringEncoding]];
        // 4. 每一项的数据
        NSString *value = [textDict objectForKey:key];
        [textMutData appendData:[value dataUsingEncoding:NSUTF8StringEncoding]];
        // 5. 每一项结束时换行
        [textMutData appendData:[line_break dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    // FILE 类型数据拼装
    NSMutableData *fileMutData = [[NSMutableData alloc] init];
    // 遍历 textMutData
    for (NSString *key in [fileDict allKeys]) {
        // 1. 每一项的开始
        [fileMutData appendData:[item_start dataUsingEncoding:NSUTF8StringEncoding]];
        // 2. 每一项的描述信息
        NSString *content_disposition = [NSString stringWithFormat:@"Content-Disposition: form-data; name=%@; filename=%@;",key, key];
        [fileMutData appendData:[content_disposition dataUsingEncoding:NSUTF8StringEncoding]];
        // 3. 描述信息和数据之间 换2行
        [fileMutData appendData:[line_break dataUsingEncoding:NSUTF8StringEncoding]];
        [fileMutData appendData:[line_break dataUsingEncoding:NSUTF8StringEncoding]];
        // 4. 每一项的数据
        NSData *value = [fileDict objectForKey:key];
        [fileMutData appendData:value];
        // 5. 每一项结束时换行
        [fileMutData appendData:[line_break dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    // body 二进制数据
    NSMutableData *bodyMutData = [[NSMutableData alloc] init];
    [bodyMutData appendData:[textMutData copy]];
    [bodyMutData appendData:[fileMutData copy]];
    
    // body 结束标志
    [bodyMutData appendData:[body_end dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[self getConfig]];
    NSURLSessionUploadTask *dataTask = [session uploadTaskWithRequest:request fromData:[bodyMutData copy] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            NSLog(@"%@",[error localizedDescription]);
        }else {
            NSString *resultString = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
            NSLog(@"%@", resultString);
        }
    }];
    [dataTask resume];
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
