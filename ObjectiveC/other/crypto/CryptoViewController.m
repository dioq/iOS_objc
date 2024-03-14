//
//  EncryptionViewController.m
//  ObjectiveC
//
//  Created by Geek on 2019/12/12.
//  Copyright © 2019 William. All rights reserved.
//

#import "CryptoViewController.h"
#import "CryptoUtil.h"
#import "RSAUtil.h"
#import "AES.h"
#import "AES256Util.h"

@interface CryptoViewController ()

@property(nonatomic, copy)NSString *publickKey;//公钥
@property(nonatomic, copy)NSString *privateKey;//私钥
@property(nonatomic, strong)NSData *cipherData;

@end

@implementation CryptoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    /*
     openssl 生成公钥和私钥
     openssl genrsa -out private_key.pem 1024
     openssl rsa -in private_key.pem -pubout -out public_key.pem
     **/
    self.publickKey = @"MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDaCXgeHqPXkv8qCpWFxpHteDn8j0GExQMHowbMzCbdhfysuFkl1DdbsTGT3QPOenlro5D7pn5onZ2doE/5nyMIyPBQ2Dhq/RSsQQQDofTBvA37PaT3rGa4e1Nn1fp5wcBh8RDwT7h2iYg6ndRe02A1bCxDW93OPGaWokSHs+0OUQIDAQAB";
    self.privateKey = @"MIICdwIBADANBgkqhkiG9w0BAQEFAASCAmEwggJdAgEAAoGBANoJeB4eo9eS/yoKlYXGke14OfyPQYTFAwejBszMJt2F/Ky4WSXUN1uxMZPdA856eWujkPumfmidnZ2gT/mfIwjI8FDYOGr9FKxBBAOh9MG8Dfs9pPesZrh7U2fV+nnBwGHxEPBPuHaJiDqd1F7TYDVsLENb3c48ZpaiRIez7Q5RAgMBAAECgYBHRP0ca0uG9aeuaFNDrQqaIshhg7oY2gUJhAJ/AuRZWKilFIUfVmTZ9euMt5u87E+wHYEQoPWE4LBai8JYh+n9JDJNdNokqLzVT7WStKbPuNETWYYa2WLf0vsU0LZUe2Wkvdl4UbgjfO2Br6Zvooqz1ot7XLlwrwrqSb1nullDIQJBAP+oQKxN3dh+2MjinsG6G2SaToc4IRcI5+lK4tOVJrH81qhRGWGIUVn25/UDCzROAdEn2o7lrlvgXDEgMKRb3q0CQQDaVE3w4uiyIYx6UZjC9OEYCKtd84/R1qRbH2UavKSpZVN1UlMgwaNYPBX2OwABUpv9HRmRR5nulSyYfHG8pNa1AkEA5jgVRRQ5miNgBEZOwBVfZZCu9oVNBvk2HZcZ+35sggs1Ig0l1fZzi5gT+UbsaAV3DWneHqAmCwZW/sYGB3vTYQJBAMbJkbmtcH+YCkbo+nUv768pXZaKiD1f+H+7Qxwn/Kj7yBR/Y47koCxbcQejyqppo/u/PiNIFUDk9BjW3dwMHi0CQGYGZILNBkKfJQwHK7ARFYhCFT5hzVUgTcE9RsMzFOToEyA9nNq4WgpHwA+QT7jnSQfqhMmXF+wleZfzfsQ4Gn0=";
}

// RSA 公钥加密 私钥解密 (反过来数学理论上可行,但实际上会降低加密的安全等级)
- (IBAction)RSAcrypto:(UIButton *)sender {
    NSString *plaintext = @"This is a test string for RSA encrypt.";
    
    NSData *cipher_data = [RSAUtil encryptData:[plaintext dataUsingEncoding:NSUTF8StringEncoding] publicKey:[CryptoUtil base64Decode:self.publickKey]];
    NSString *hexStr = [CryptoUtil hexEncode:cipher_data];
    NSLog(@"cipher:\n%@", hexStr);
    
    NSData *plaint_data = [RSAUtil decryptData:cipher_data privateKey:[CryptoUtil base64Decode:self.privateKey]];
    //    NSLog(@"plaint_data.length:%lu", plaint_data.length);
    NSString *plaintext2 = [[NSString alloc] initWithData:plaint_data encoding:NSUTF8StringEncoding];
    NSLog(@"plaintext:\n%@", plaintext2);
}

- (IBAction)aes256origin:(UIButton *)sender {
    const char *plaintext = "user=test2&pwd=123456&code=quis&ip=127.0.0.1";
    printf("plaintext hex:\n");
    for (int i = 0; i < strlen(plaintext); i++) {
        printf("%.2x", plaintext[i]);
    }
    printf("\n");
    
    const size_t keyLength = kCCKeySizeAES256;
    const char key[keyLength] = "by78elrbovb3rncvk9kkwx0byxb70rlo";
    const void *iv  = "ixJ7U9asz9GgGfk7";
    
    // 缓冲区大小
    size_t dataOutAvailable = (strlen(plaintext) / 0x10) * 0x10 + ((strlen(plaintext) % 0x10) ? 1 : 0);
    unsigned char *result1 = (unsigned char *)malloc(dataOutAvailable);
    memset(result1, 0, dataOutAvailable);
    size_t result1_len = 0;
    
    CCCryptorRef cryptorRef;
    CCCryptorCreate(kCCEncrypt, kCCAlgorithmAES, kCCOptionPKCS7Padding, key, keyLength, iv, &cryptorRef);
    CCCryptorUpdate(cryptorRef, plaintext, strlen(plaintext), result1, dataOutAvailable, &result1_len);
    printf("result_len1 = %lx\n", result1_len);
    for (int i = 0; i < result1_len; i++) {
        printf("%.2x", result1[i]);
    }
    
    unsigned char *result2 = (unsigned char *)malloc(0x10);
    memset(result2, 0, 0x10);
    size_t result2_len = 0;
    // 处理填充 也就是最后16个字节
    CCCryptorFinal(cryptorRef, result2, 0x10, &result2_len);
    printf("\nresult2_len = %lx\n", result2_len);
    for (int i = 0; i < result2_len; i++) {
        printf("%.2x", result2[i]);
    }
    printf("\n");
    
    unsigned long result_len = result1_len + result2_len;
    unsigned char *result = (unsigned char *)malloc(result_len);
    memcpy(result, result1, result1_len);
    memcpy(result + result1_len, result2, result2_len);
    printf("最终结果:\n");
    for (int i = 0; i < result_len; i++) {
        printf("%.2x", result[i]);
    }
    printf("\n===================== 解密 ======================\n");
    decrypt(result, result_len);
}

void decrypt(unsigned char *cipher,size_t len) {
    const size_t keyLength = kCCKeySizeAES256;
    const char key[keyLength] = "by78elrbovb3rncvk9kkwx0byxb70rlo";
    const void *iv  = "ixJ7U9asz9GgGfk7";
    
    size_t dataOutAvailable = len;
    unsigned char *result1 = (unsigned char *)malloc(dataOutAvailable);
    memset(result1, 0, dataOutAvailable);
    size_t result1_len = 0;
    
    CCCryptorRef cryptorRef;
    CCCryptorCreate(kCCDecrypt, kCCAlgorithmAES, kCCOptionPKCS7Padding, key, keyLength, iv, &cryptorRef);
    CCCryptorUpdate(cryptorRef, cipher, len, result1, dataOutAvailable, &result1_len);
    printf("result1_len = %lx\n", result1_len);
    for (int i = 0; i < result1_len; i++) {
        printf("%.2x", result1[i]);
    }
    unsigned char *result2 = (unsigned char *)malloc(0x10);
    memset(result2, 0, 0x10);
    size_t result2_len = 0;
    // 处理填充 也就是最后16个字节
    CCCryptorFinal(cryptorRef, result2, 0x10, &result2_len);
    printf("\nresult2_len = %lx\n", result2_len);
    for (int i = 0; i < result2_len; i++) {
        printf("%.2x", result2[i]);
    }
    printf("\n");
    
    unsigned long result_len = result1_len + result2_len;
    unsigned char *result = (unsigned char *)malloc(result_len);
    memcpy(result, result1, result1_len);
    memcpy(result + result1_len, result2, result2_len);
    printf("最终结果:\n");
    for (int i = 0; i < result_len; i++) {
        printf("%.2x", result[i]);
    }
    printf("\n");
    printf("in string:\n%s\n", result);
}

// 加密后返回 base64
- (IBAction)AEScrypto:(UIButton *)sender {
    NSString *plainText = @"user=test2&pwd=123456&code=quis&ip=127.0.0.1";
    NSString *key = @"by78elrbovb3rncvk9kkwx0byxb70rlo";
    NSString *iv = @"ixJ7U9asz9GgGfk7";
    
    NSString *enStr = [AES AESEncrypt:plainText mode:kCCModeCBC key:key keySize:KeySizeAES256 iv:iv padding:CryptorPKCS7Padding];
    NSString *deStr = [AES AESDecrypt:enStr mode:kCCModeCBC key:key keySize:KeySizeAES256 iv:iv padding:CryptorPKCS7Padding];
    
    NSLog(@"\n加密前：%@\n加密后：%@\n解密后：%@\n",plainText,enStr,deStr);
}

// 加密后返回 NSData
- (IBAction)AEScrypto2:(UIButton *)sender {
    NSString *plainText = @"user=test2&pwd=123456&code=quis&ip=127.0.0.1";
    NSString *key = @"by78elrbovb3rncvk9kkwx0byxb70rlo";
    NSString *iv = @"ixJ7U9asz9GgGfk7";
    
    NSData *plainData = [plainText dataUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"待加密二进制数:\n%@", [CryptoUtil hexEncode:plainData]);
    NSData *cipherData = [AES AESWithData:plainData operation:kCCEncrypt mode:kCCModeCBC key:key keySize:KeySizeAES256 iv:iv padding:CryptorPKCS7Padding];
    self.cipherData = cipherData;
    NSString *cipher_hex = [CryptoUtil hexEncode:cipherData];
    NSLog(@"加密后:\n%@", cipher_hex);
    
    //    NSData *plainData2 = [AES AESWithData:cipherData operation:kCCDecrypt mode:kCCModeCBC key:key keySize:KeySizeAES256 iv:iv padding:CryptorPKCS7Padding];
    //    NSString *plainText2 = [[NSString alloc] initWithData:plainData2 encoding:NSUTF8StringEncoding];
    //    NSLog(@"解密后的明文:\n%@",plainText2);
}

- (IBAction)AESdecrypto:(UIButton *)sender {
    NSString *key = @"by78elrbovb3rncvk9kkwx0byxb70rlo";
    NSString *iv = @"ixJ7U9asz9GgGfk7";
    
    NSData *plainData2 = [AES AESWithData:self.cipherData operation:kCCDecrypt mode:kCCModeCBC key:key keySize:KeySizeAES256 iv:iv padding:CryptorPKCS7Padding];
    NSLog(@"解密后:");
    NSLog(@"\n%@",[CryptoUtil hexEncode:plainData2]);
    NSString *plainText2 = [[NSString alloc] initWithData:plainData2 encoding:NSUTF8StringEncoding];
    NSLog(@"\n%@",plainText2);
}

- (IBAction)AES2crypto:(UIButton *)sender {
    NSString *key = @"by78elrbovb3rncvk9kkwx0byxb70rlo";
    NSString *iv = @"ixJ7U9asz9GgGfk7";
    NSData *keyData = [key dataUsingEncoding:NSUTF8StringEncoding];
    
    NSString *plainText = @"user=test2&pwd=123456&code=quis&ip=127.0.0.1";
    
    NSData *plainData = [plainText dataUsingEncoding:NSUTF8StringEncoding];
    NSData *cipherData = [AES256Util AEC256EncryptWithPlainText:plainData withKey:keyData iv:iv];
    NSString *cipherTextStr = [cipherData base64EncodedStringWithOptions:0];
    NSLog(@"加密后的密文:%@",cipherTextStr);
    
    NSData *plainData2 = [AES256Util AES256DecryptWithCipherData:cipherData withKey:keyData iv:iv];
    NSString *plainText2 = [[NSString alloc] initWithData:plainData2 encoding:NSUTF8StringEncoding];
    NSLog(@"解密后的明文:%@",plainText2);
}

- (IBAction)MD5encryption:(UIButton *)sender {
    NSString *plaintext = @"Hello Dio Brand";
    NSString *result = [CryptoUtil md5:plaintext];
    NSLog(@"MD5: %@", result);
}

- (IBAction)SHA256encrypt:(UIButton *)sender {
    NSString *plaintext = @"Hello Dio Brand";
    NSString *result = [CryptoUtil sha256:plaintext];
    NSLog(@"SHA256: %@", result);
}

- (IBAction)base64crypto:(UIButton *)sender {
    NSString *plainText = @"user=test1&pwd=111333&code=kxgi&ip=127.0.0.1";
    NSData *data = [plainText dataUsingEncoding:NSUTF8StringEncoding];
    NSUInteger option = NSDataBase64EncodingEndLineWithLineFeed;
    NSString *cipherText = [data base64EncodedStringWithOptions:option];
    NSLog(@"cipherText:\n%@",cipherText);
    
    NSData *data2 = [[NSData alloc]initWithBase64EncodedString:cipherText options:option];
    //2.把二进制数据在转换为字符串
    NSString *plainText2 = [[NSString alloc]initWithData:data2 encoding:NSUTF8StringEncoding];
    NSLog(@"plainText2:\n%@",plainText2);
}

- (IBAction)hexStringAct:(UIButton *)sender {
    NSString *hexStr = @"12432154679809ABCDADCB12432154679809ABCDADCB";
    NSLog(@"hexStr length:%lu",hexStr.length);
    NSData *hexData = [CryptoUtil hexDecode:hexStr];
    NSLog(@"hexData length:%lu", [hexData length]);
    
    NSString *hexStr2 = [CryptoUtil hexEncode:hexData];
    NSLog(@"hexStr2 length:%lu",hexStr2.length);
    NSLog(@"hexStr2:\n%@",hexStr2);
}

@end
