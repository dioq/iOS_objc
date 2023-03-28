#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonCryptor.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    CryptorNoPadding = 0,    // 无填充
    CryptorPKCS7Padding = 1, // PKCS_7 | 每个字节填充字节序列的长度。 ***此填充模式使用系统方法。***
    CryptorZeroPadding = 2,  // 0x00 填充 | 每个字节填充 0x00
    CryptorANSIX923,         // 最后一个字节填充字节序列的长度，其余字节填充0x00。
    CryptorISO10126          // 最后一个字节填充字节序列的长度，其余字节填充随机数据。
}AESPadding;

typedef enum {
    KeySizeAES128          = 16,
    KeySizeAES192          = 24,
    KeySizeAES256          = 32,
}AESKeySize;

typedef enum {
    ModeECB        = 1,
    ModeCBC        = 2,
    ModeCFB        = 3,
    ModeOFB        = 7,
}AESMode;

@interface AES : NSObject

+ (NSString *)AESEncrypt:(NSString *)originalStr
                    mode:(AESMode)mode
                     key:(NSString *)key
                 keySize:(AESKeySize)keySize
                      iv:(NSString * _Nullable )iv
                 padding:(AESPadding)padding;

+ (NSString *)AESDecrypt:(NSString *)originalStr
                    mode:(AESMode)mode
                     key:(NSString *)key
                 keySize:(AESKeySize)keySize
                      iv:(NSString * _Nullable )iv
                 padding:(AESPadding)padding;

// crypto base
+ (NSData *)AESWithData:(NSData *)originalData
              operation:(CCOperation)operation
                   mode:(CCMode)mode
                    key:(NSString *)key
                keySize:(AESKeySize)keySize
                     iv:(NSString *)iv
                padding:(AESPadding)padding;

@end

NS_ASSUME_NONNULL_END
