#import "RSAUtil.h"
#import <Security/Security.h>

@implementation RSAUtil

+ (NSData *)decryptData:(NSData *)data privateKey:(NSData *)key {
    if (!(data && data.length > 0 && key && key.length > 0)) {
        return nil;
    }
    
    // 生成的证书头要去掉,中间的才是 RSA 公钥有效部分
    NSMutableData *mutData = [key mutableCopy];
    [mutData replaceBytesInRange:NSMakeRange(0, 26) withBytes:NULL length:0];
    NSData *stripData = [mutData copy];
    
    SecKeyRef keyRef = [RSAUtil getRSAkey:stripData keyClass:kSecAttrKeyClassPrivate];
    if(!keyRef){
        return nil;
    }
    return [RSAUtil decryptData:data withKeyRef:keyRef];
}

+ (NSData *)encryptData:(NSData *)data publicKey:(NSData *)key {
    if (!(data && data.length > 0 && key && key.length > 0)) {
        return nil;
    }
    
    // 生成的证书头要去掉,中间的才是 RSA 公钥有效部分
    NSMutableData *mutData = [key mutableCopy];
    [mutData replaceBytesInRange:NSMakeRange(0, 22) withBytes:NULL length:0];
    NSData *stripData = [mutData copy];
    
    SecKeyRef keyRef = [RSAUtil getRSAkey:stripData keyClass:kSecAttrKeyClassPublic];
    if(!keyRef){
        return nil;
    }
    return [RSAUtil encryptData:data withKeyRef:keyRef];
}

+(SecKeyRef)getRSAkey:(NSData *)key keyClass:(CFStringRef)keyClass {
    CFStringRef keys[] = {kSecAttrKeyType, kSecAttrKeyClass, kSecAttrKeySizeInBits};
    CFTypeRef values[] = {kSecAttrKeyTypeRSA, keyClass, CFSTR("2048")};
    
    CFDictionaryRef dict = CFDictionaryCreate(CFAllocatorGetDefault(), (const void **)keys, (const void **)values, 2, &kCFTypeDictionaryKeyCallBacks, &kCFTypeDictionaryValueCallBacks);
    //    NSLog(@"dict:\n%@",dict);
    
    CFErrorRef errorRef = NULL;
    SecKeyRef ret = SecKeyCreateWithData((__bridge CFDataRef)key, dict, &errorRef);
    if (errorRef != NULL) {
        NSError *error = (__bridge_transfer NSError *)errorRef;
        NSLog(@"error NO:%ld des:%@", error.code, [error localizedDescription]);
    }
    return ret;
}

+ (NSData *)encryptData:(NSData *)data withKeyRef:(SecKeyRef) keyRef{
    const uint8_t *srcbuf = (const uint8_t *)[data bytes];
    size_t srclen = (size_t)data.length;
    
    size_t block_size = SecKeyGetBlockSize(keyRef) * sizeof(uint8_t);
    void *outbuf = malloc(block_size);
    size_t src_block_size = block_size - 11;
    
    NSMutableData *ret = [[NSMutableData alloc] init];
    for(int idx=0; idx<srclen; idx+=src_block_size){
        size_t data_len = srclen - idx;
        if(data_len > src_block_size){
            data_len = src_block_size;
        }
        
        size_t outlen = block_size;
        OSStatus status = noErr;
        status = SecKeyEncrypt(keyRef,
                               kSecPaddingPKCS1,
                               srcbuf + idx,
                               data_len,
                               outbuf,
                               &outlen
                               );
        if (status != 0) {
            NSLog(@"SecKeyEncrypt fail. Error Code: %d", status);
            ret = nil;
            break;
        }else{
            [ret appendBytes:outbuf length:outlen];
        }
    }
    
    free(outbuf);
    CFRelease(keyRef);
    return ret;
}

+ (NSData *)decryptData:(NSData *)data withKeyRef:(SecKeyRef) keyRef{
    const uint8_t *srcbuf = (const uint8_t *)[data bytes];
    size_t srclen = (size_t)data.length;
    
    size_t block_size = SecKeyGetBlockSize(keyRef) * sizeof(uint8_t);
    UInt8 *outbuf = malloc(block_size);
    size_t src_block_size = block_size;
    
    NSMutableData *ret = [[NSMutableData alloc] init];
    for(int idx=0; idx<srclen; idx+=src_block_size){
        size_t data_len = srclen - idx;
        if(data_len > src_block_size){
            data_len = src_block_size;
        }
        
        size_t outlen = block_size;
        OSStatus status = noErr;
        status = SecKeyDecrypt(keyRef,
                               kSecPaddingNone,
                               srcbuf + idx,
                               data_len,
                               outbuf,
                               &outlen
                               );
        if (status != 0) {
            NSLog(@"SecKeyEncrypt fail. Error Code: %d", status);
            ret = nil;
            break;
        }else{
            int idxFirstZero = -1;
            int idxNextZero = (int)outlen;
            for ( int i = 0; i < outlen; i++ ) {
                if ( outbuf[i] == 0 ) {
                    if ( idxFirstZero < 0 ) {
                        idxFirstZero = i;
                    } else {
                        idxNextZero = i;
                        break;
                    }
                }
            }
            
            [ret appendBytes:&outbuf[idxFirstZero+1] length:idxNextZero-idxFirstZero-1];
        }
    }
    
    free(outbuf);
    CFRelease(keyRef);
    return ret;
}

@end
