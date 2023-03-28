//
//  AES256Util.h
//  ObjectiveC
//
//  Created by Dio Brand on 2022/11/12.
//  Copyright © 2022 my. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AES256Util : NSObject

+(NSData *)AEC256EncryptWithPlainText:(NSData *)plaintext withKey:(NSData *)key iv:(NSString *)IV;
+(NSData *)AES256DecryptWithCipherData:(NSData *)ciphertext withKey:(NSData *)key iv:(NSString *)IV;

@end

NS_ASSUME_NONNULL_END
