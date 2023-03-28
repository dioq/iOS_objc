//
//  DownloadManager.h
//  ObjectiveC
//
//  Created by hello on 2019/11/4.
//  Copyright © 2019 William. All rights reserved.
//

/*
 Block回调是关于Block最常用的内容，比如网络下载，我们可以用Block实现下载成功与失败的反馈。开发者在block没发布前，实现回调基本都是通过代理的方式进行的，比如负责网络请求的原生类NSURLConnection类，通过多个协议方法实现请求中的事件处理。而在最新的环境下，使用的NSURLSession已经采用block的方式处理任务请求了。各种第三方网络请求框架也都在使用block进行回调处理。这种转变很大一部分原因在于block使用简单，逻辑清晰，灵活等原因。
 **/

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DownloadManager : NSObject

// block 重命名
typedef void (^DownloadHandler)(NSData * receiveData, NSError * error);

- (void)downloadWithURL:(NSString *)URL parameters:(NSDictionary *)parameters handler:(DownloadHandler)handler;

@end

NS_ASSUME_NONNULL_END
