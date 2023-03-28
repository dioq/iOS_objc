//
//  AES256Util.m
//  ObjectiveC
//
//  Created by Dio Brand on 2022/11/12.
//  Copyright © 2022 my. All rights reserved.
//

#import "AES256Util.h"
#import <CommonCrypto/CommonCrypto.h>

@implementation AES256Util

/*AES256加密方法*/
+(NSData *)AEC256EncryptWithPlainText:(NSData *)plaintext withKey:(NSData *)key iv:(NSString *)IV{
    if (plaintext == nil) {
        return nil;
    }
    
    char keyPtr[kCCKeySizeAES256+1];
    bzero(keyPtr, sizeof(keyPtr));
    
    NSUInteger dataLength = [plaintext length];
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    bzero(buffer, sizeof(buffer));
    
    size_t numBytesEncrypted = 0;
    
    const char *iv = [IV UTF8String];
    
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt,
                                          kCCAlgorithmAES,
                                          kCCOptionPKCS7Padding,
                                          [key bytes],
                                          [key length],
                                          iv /* initialization vector (optional) */,
                                          [plaintext bytes], dataLength, /* input */
                                          buffer, bufferSize, /* output */
                                          &numBytesEncrypted);
    NSData *encryptData;
    if (cryptStatus == kCCSuccess) {
        encryptData = [NSData dataWithBytesNoCopy:buffer length:numBytesEncrypted];
    }
    
    return encryptData;
}

/*AES256解密方法*/
+ (NSData *)AES256DecryptWithCipherData:(NSData *)ciphertext withKey:(NSData *)key iv:(NSString *)IV{
    if (ciphertext == nil || (ciphertext.length % 0x10 != 0)) {
        return nil;
    }
    
    // 'key' should be 32 bytes for AES256, will be null-padded otherwise
    char keyPtr[kCCKeySizeAES256 + 1]; // room for terminator (unused)
    bzero(keyPtr, sizeof(keyPtr)); // fill with zeroes (for padding)
    
    NSUInteger dataLength = [ciphertext length];
    
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    
    const char *iv = [IV UTF8String];
    
    size_t numBytesDecrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt,
                                          kCCAlgorithmAES,
                                          kCCOptionPKCS7Padding,
                                          [key bytes],
                                          [key length],
                                          iv ,/* initialization vector (optional) */
                                          [ciphertext bytes],
                                          dataLength, /* input */
                                          buffer, bufferSize, /* output */
                                          &numBytesDecrypted);
    NSData *encryptData;
    if (cryptStatus == kCCSuccess) {
        encryptData= [NSData dataWithBytesNoCopy:buffer length:numBytesDecrypted];
    }
    return encryptData;
}

@end
