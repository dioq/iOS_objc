//
//  RequestManager.h
//  ObjectiveC
//
//  Created by hello on 2019/3/24.
//  Copyright © 2019 William. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NetworkManager : NSObject

+ (instancetype)sharedManager;

// get请求
- (void)getUrl:(NSString *)urlStr
       success:(void(^)(id response))success
       failure:(void(^)(NSError *error))failure;

// post 参数是 NSData
- (void)postUrl:(NSString *)urlStr
     parameters:(NSData *)params
        success:(void (^)(id _Nonnull))success
        failure:(void (^)(NSError * _Nonnull))failure;

// post 参数是 json格式
- (void)postUrl:(NSString *)urlStr
      paramJson:(NSDictionary * _Nullable)params
        success:(void (^)(id _Nonnull))success
        failure:(void (^)(NSError * _Nonnull))failure;

@end

NS_ASSUME_NONNULL_END
