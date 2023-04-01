//
//  DownloadManager.m
//  ObjectiveC
//
//  Created by hello on 2019/11/4.
//  Copyright © 2019 William. All rights reserved.
//

#import "DownloadManager.h"

@implementation DownloadManager

- (void)downloadWithURL:(NSString *)URL parameters:(NSDictionary *)parameters handler:(DownloadHandler)handler
{
    NSURLRequest * request = [NSURLRequest requestWithURL:[NSURL URLWithString:URL]];
    NSURLSession * session = [NSURLSession sharedSession];
    
    //执行请求任务
    NSURLSessionDataTask * task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (handler) {
            dispatch_async(dispatch_get_main_queue(), ^{
                handler(data,error);
            });
        }
    }];
    [task resume];
}

@end
