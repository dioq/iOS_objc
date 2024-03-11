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

// post body 是 二进制数据
- (void)postUrl:(NSString *)urlStr
      paramData:(NSData * _Nonnull)params
        success:(void (^)(id _Nonnull))success
        failure:(void (^)(NSError * _Nonnull))failure;

// post body 是 json
- (void)postUrl:(NSString *)urlStr
      paramDict:(NSDictionary * _Nonnull)params
        success:(void (^)(id _Nonnull))success
        failure:(void (^)(NSError * _Nonnull))failure;

// 提交表单
- (void)submitUrl:(NSString *)urlStr
         textDict:(NSDictionary<NSString *, NSString *> *)textDict
         fileDict:(NSDictionary<NSString *, NSData *> *)fileDict
          success:(void (^)(id _Nonnull))success
          failure:(void (^)(NSError * _Nonnull))failure;

@end

NS_ASSUME_NONNULL_END
