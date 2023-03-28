//
//  CryptoUtil.h
//  ObjectiveC
//
//  Created by lzd_free on 2020/12/23.
//  Copyright © 2020 William. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CryptoUtil : NSObject

// base64字符串 编码
+(NSString *)base64Encode:(NSData * _Nonnull)data;
// base64字符串 解码
+(NSData *)base64Decode:(NSString * _Nonnull)str;

// data 进行  16进制字符串 编码
+ (NSString *)hexEncode:(NSData * _Nonnull)data;
// 16进制字符串 进行解码
+ (NSData *)hexDecode:(NSString * _Nonnull)str;

+(NSString *)md5:(NSString * _Nonnull)string;
+(NSString*)sha256:(NSString * _Nonnull)string;

@end

NS_ASSUME_NONNULL_END
