#import <Foundation/Foundation.h>

@interface RSAUtil : NSObject

+(NSData *)encryptData:(NSData *)data publicKey:(NSData *)key;
+(NSData *)decryptData:(NSData *)data privateKey:(NSData *)key;

@end
