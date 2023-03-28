//
//  EncryptionViewController.m
//  ObjectiveC
//
//  Created by Geek on 2019/12/12.
//  Copyright © 2019 William. All rights reserved.
//

#import "CryptoViewController.h"
#import "CryptoUtil.h"
#import "RSA.h"
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
     生成公钥和私钥的网站:http://web.chacuo.net/netrsakeypair
     **/
    self.publickKey = @"MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQC2hpqSwl56BbfWzf652a6gZDwVHuqBFkI3zPN4ywlUNdwiLlCFBb3MPi8OdBdXoafSpwdm8zUfQhK71GcBMPvlhGzQnaRbH6JLGV9U8Y7XVoUMdSFXs7SqahdqMUZ+p+3eeD2anH3nTycVyj7ymLc0YUgvln7xuPHPDRrCv0lXhQIDAQAB";
    self.privateKey = @"MIICdgIBADANBgkqhkiG9w0BAQEFAASCAmAwggJcAgEAAoGBALaGmpLCXnoFt9bN/rnZrqBkPBUe6oEWQjfM83jLCVQ13CIuUIUFvcw+Lw50F1ehp9KnB2bzNR9CErvUZwEw++WEbNCdpFsfoksZX1TxjtdWhQx1IVeztKpqF2oxRn6n7d54PZqcfedPJxXKPvKYtzRhSC+WfvG48c8NGsK/SVeFAgMBAAECgYBAuPRAzCmCLVrmEX+c2WLBvylK9/6BrannbYZ8M8roEH0xpaipssJ9lSNMhb/tNAZ1fQLz75PLtLs93XB1DLCVNbsnikuqufCb58cBsMZ3F19YEjixzkq1uWXvR54OazchRAcEO717caVypwSbo08ybYp3d0NjXMChnOT5pvKB4QJBAOdWge8wAken16ivHdpzU/RJ01SJJcGIVV+Xn7/257sQMinUeMSrt+s/lHnd3+ajz25xZKEYx/kLhG97ZBDj+hkCQQDJ+/REu2OFwGBg2S2sjF+M8krmnr0AKzVYze46N2MXlz4iRxFmHgzPSgSCTPkB3b/dwXGcb42FB8PUYF0QD85NAkEAl0/b+Qjb1OaRhoHT8viQJy7KjXaPPYDg5n+UO8lRVOeJCBczTuBKkhKqGPPo6UCoAsMkYMKGufywiQKaNvoGsQJAIUneAynjCBshhzSj22kzIjaYc5O70HhOjXk7Busz8KJjgiC2VF8le1BWl+b5rv4N7g1AnSihaUhTVQAgtlH0jQJALOHAJe5jlWkBRy7YmYgw98wzDPeHenK3RY5H3jXlrtMGDjCPEiHknRiCjZJjW0I/wJ8vPs7Jlz2CrpYqpIJdFw==";
}

- (IBAction)RSAcrypto:(UIButton *)sender {
    NSString *plaintext = @"Hello Dio Brand";
    NSString *result = [RSA encryptString:plaintext publicKey:self.publickKey];
    NSLog(@"Encrypted with public key: %@", result);
    NSString *decWithPrivKey = [RSA decryptString:result privateKey:self.privateKey];
    NSLog(@"Decrypted with private key: %@", decWithPrivKey);
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
