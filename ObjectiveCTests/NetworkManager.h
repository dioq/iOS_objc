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

/**get请求*/
- (void)getUrl:(NSString *)urlStr
    success:(void(^)(id response))success
    failure:(void(^)(NSError *error))failure;

/**post请求*/
- (void)postUrl:(NSString *)urlStr
         parameters:(NSDictionary *)params
            success:(void(^)(id response))success
            failure:(void(^)(NSError *error))failure;
/**文件上传*/
- (void)uploadUrl:(NSString *)url
              images:(NSArray *)images
          parameters:(id)parameters
            progress:(void(^)(NSProgress *progress))progress
             success:(void(^)(id response))success
             failure:(void(^)(NSError *error))failure;

@end

NS_ASSUME_NONNULL_END
