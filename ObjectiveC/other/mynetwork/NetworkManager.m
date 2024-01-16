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

-(void)submitUrlStr:(NSString *)urlStr params:(NSDictionary *)paramsDict fileNames:(NSArray<NSString *> *)fileNames fileDatas:(NSArray<NSData *> *)fileDatas success:(void (^)(id _Nonnull))success failure:(void (^)(NSError * _Nonnull))failure {
    NSURL *url = [NSURL URLWithString:urlStr];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.timeoutInterval = 30;
    request.HTTPMethod = @"POST";
    
    NSString *boundary = [[NSUUID UUID] UUIDString];
    boundary = [boundary stringByReplacingOccurrencesOfString:@"-" withString:@""];
    
    NSString *content_type = [NSString stringWithFormat:@"multipart/form-data;boundary=%@", boundary];
    [request setValue:content_type forHTTPHeaderField:@"Content-Type"];
    
    NSMutableData *body_data = [[NSMutableData alloc] init];
    
    NSString *line_feed = @"\r\n"; // 换行
    NSString *item_start = [NSString stringWithFormat:@"--%@%@",boundary,line_feed]; // form-data 每一项的开始
    NSString *item_end = [NSString stringWithFormat:@"%@--%@--%@",line_feed,boundary,line_feed]; // form-data 每一项的结束
    
    //http body的字符串
    NSMutableString *bodyMutStr = [[NSMutableString alloc]init];
    //参数的集合的所有key的集合
    NSArray *keys = [paramsDict allKeys];
    //遍历keys
    for(int i = 0; i < [keys count]; i++) {
        //添加分界线
        [bodyMutStr appendString:boundary];
        [bodyMutStr appendString:line_feed];
        //得到当前key
        NSString *key = [keys objectAtIndex:i];
        //添加字段名称，换2行
        [bodyMutStr appendFormat:@"Content-Disposition: form-data; name=%@",key];
        [bodyMutStr appendString:line_feed];
        [bodyMutStr appendString:line_feed];
        //添加字段的值
        [bodyMutStr appendString:[paramsDict objectForKey:key]];
    }
    //    NSLog(@"%@",bodyMutStr);
    [body_data appendData:[item_start dataUsingEncoding:NSUTF8StringEncoding]];
    [body_data appendData:[bodyMutStr dataUsingEncoding:NSUTF8StringEncoding]];
    [body_data appendData:[line_feed dataUsingEncoding:NSUTF8StringEncoding]];// 每一项结束 \r\n
    
    for (int i = 0; i < fileNames.count; i++) {
        [body_data appendData:[item_start dataUsingEncoding:NSUTF8StringEncoding]];
        
        //        NSLog(@"fileNames[%d] = %@", i, fileNames[i]);
        NSString *content = [NSString stringWithFormat:@"Content-Disposition: form-data; name=%@; filename=%@;",fileNames[i], fileNames[i]];
        [body_data appendData:[content dataUsingEncoding:NSUTF8StringEncoding]];
        [body_data appendData:[line_feed dataUsingEncoding:NSUTF8StringEncoding]];
        [body_data appendData:[line_feed dataUsingEncoding:NSUTF8StringEncoding]];
        
        NSData *fileData = fileDatas[i];
        [body_data appendData:fileData];
        
        [body_data appendData:[line_feed dataUsingEncoding:NSUTF8StringEncoding]];// 每一项结束 \r\n
    }
    [body_data appendData:[item_end dataUsingEncoding:NSUTF8StringEncoding]];
    //    NSLog(@"body_data.length : %lu",body_data.length);
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[self getConfig]];
    NSURLSessionUploadTask *dataTask = [session uploadTaskWithRequest:request fromData:body_data completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
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
