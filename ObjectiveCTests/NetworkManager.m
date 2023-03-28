//
//  RequestManager.m
//  ObjectiveC
//
//  Created by hello on 2019/3/24.
//  Copyright © 2019 William. All rights reserved.
//

#import "NetworkManager.h"

static NetworkManager *staticInstance = nil;

@implementation NetworkManager

+ (instancetype)sharedManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        staticInstance = [[super allocWithZone:NULL] init]; // 与下面两个方匹配
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
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[self getConfig]];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error != nil) {
            failure(error);
        }else {
            NSString *result = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            success(result);
        }
    }];
    // 执行
    [task resume];
}

#pragma mark - post请求
- (void)postUrl:(NSString *)urlStr parameters:(NSDictionary *)params success:(void (^)(id _Nonnull))success failure:(void (^)(NSError * _Nonnull))failure {
    NSURL *url = [NSURL URLWithString:urlStr];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    
    NSError *error;
    NSData *param_data = [NSJSONSerialization dataWithJSONObject:params options:NSJSONWritingPrettyPrinted error:&error];
    if (error) {
        failure(error);
    }
    request.HTTPBody = param_data;
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[self getConfig]];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error != nil) {
            failure(error);
        }else {
            NSString *result = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            success(result);
        }
    }];
    // 执行
    [task resume];
}

#pragma mark - 文件上传
- (void)uploadUrl:(NSString *)url images:(NSArray *)images parameters:(id)parameters progress:(void (^)(NSProgress * _Nonnull))progress success:(void (^)(id _Nonnull))success failure:(void (^)(NSError * _Nonnull))failure{
    //    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //    [self setRequestWithManager:manager];
    //    [manager POST:url parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
    //        for (UIImage *image in images) {
    //            //压缩图片
    //            NSData *data = UIImageJPEGRepresentation(image, 0.4);
    //            //多张图片是需要在name中加“[]”，单张上传时不用
    //            [formData appendPartWithFileData:data name:@"file[]" fileName:[NSString stringWithFormat:@"%@.jpg",[NSDate date]] mimeType:@"image/jpeg"];
    //
    //        }
    //    } progress:^(NSProgress * _Nonnull uploadProgress) {
    //        progress(uploadProgress);
    //    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
    //        success(responseObject);
    //    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    //        failure(error);
    //    }];
}

@end
