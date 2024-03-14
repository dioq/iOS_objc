//
//  DataTypeViewController.m
//  ObjectiveC
//
//  Created by Dio Brand on 2022/7/25.
//  Copyright © 2022 my. All rights reserved.
//

#import "DataTypeViewController.h"

@interface DataTypeViewController ()<UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UITextView *show;
@property(nonatomic,strong)NSData *tmpData;
@property(nonatomic,copy)NSString *tmpStr;

@end

@implementation DataTypeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.show.delegate = self;
}

- (IBAction)classType:(UIButton *)sender {
    /*
     isKindOfClass方法，用于判断是否为当前的class或class的子类.
     isMemberOfClass方法，是用于判断是否为当前的class，相当于更为严格的isKindOfClass方法.
     isSubclassOfClass是一个类方法，通常用于类之间判断是否存在继承关系.
     **/
    NSString *str = @"aaa";
    NSObject *obj = [NSObject new];
    if ([obj isMemberOfClass:[NSObject class]]) {
        NSLog(@"obj isMemberOfClass:[NSObject class]");
    }
    
    if ([str isKindOfClass:[NSString class]]) {
        NSLog(@"str isKindOfClass:[NSString class]");
    }
    
    if ([NSString isSubclassOfClass:[NSObject class]]) {
        NSLog(@"NSString isSubclassOfClass [NSObject class]");
    }
    
}

// Dictionary 转 NSData
- (IBAction)dict2JSONData:(UIButton *)sender {
    [self.show setText:@""];
    NSMutableDictionary *deviceInfo = [NSMutableDictionary dictionary];
    [deviceInfo setObject:@"TAC" forKey:@"carrierName"];
    [deviceInfo setObject:@"Xiaoming" forKey:@"name"];
    [deviceInfo setObject:@"15.3" forKey:@"systemVersion"];
    [deviceInfo setObject:@"88889ED5-AAAA-AAAA-8CC1-A12CEBCD9DDD" forKey:@"advertisingIdentifier"];
    [deviceInfo setObject:@"88889ED5-BBBB-BBBB-8CC1-A12CEBCD9DDD" forKey:@"identifierForVendor"];
    [deviceInfo setObject:@"Darwin" forKey:@"sysname"];
    [deviceInfo setObject:@"Xiaoming" forKey:@"nodename"];
    [deviceInfo setObject:@"25.4.0" forKey:@"release"];
    [deviceInfo setObject:@"Darwin Kernel Version 25.4.0: Mon Feb 21 21:26:14 PST 2022; root:xnu-8020.102.3~1/RELEASE_ARM64_T8020" forKey:@"version"];
    [deviceInfo setObject:@"iPhone23,1" forKey:@"machine"];
    [deviceInfo setValue:@"TestV" forKey:@"TestKey"];
    
    NSError *error;
    self.tmpData = [NSJSONSerialization dataWithJSONObject:deviceInfo options:NSJSONWritingPrettyPrinted error:&error];
    if (error) {
        NSLog(@"convert json error:\n%@",[error localizedFailureReason]);
    }
    [self.show setText:@"转成 JSON 了"];
}

- (IBAction)numberToData:(UIButton *)sender {
    NSUInteger index = 0x100;
    NSData *payload = [NSData dataWithBytes:&index length:sizeof(index)];
    NSLog(@"payload:%@",payload);
}

// NSData 转 NSString
- (IBAction)JSONData2string:(UIButton *)sender {
    [self.show setText:@""];
    self.tmpStr = [[NSString alloc] initWithData:self.tmpData encoding:NSUTF8StringEncoding];
    NSLog(@"json str:\n%@", self.tmpStr);
    [self.show setText:self.tmpStr];
}

// NSData 转 Dictionary
- (IBAction)JSONData2Dict:(UIButton *)sender {
    [self.show setText:@""];
    
    // 得先把 NSString 转成 NSData
    //    NSData *jsonData = [self.tmpStr dataUsingEncoding:NSUTF8StringEncoding];
    
    NSError *error;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:self.tmpData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&error];
    if(error) {
        NSLog(@"convert json error:\n%@",[error localizedFailureReason]);
        return;
    }
    
    NSLog(@"%@",dic);
    [self.show setText:@"打印出来"];
}

- (IBAction)Array2NSData:(UIButton *)sender {
    NSMutableDictionary *files_info01 = [NSMutableDictionary dictionary];
    [files_info01 setValue:@"/Documents/" forKey:@"Directory"];
    [files_info01 setValue:@"test01.txt" forKey:@"fileName"];
    NSMutableDictionary *files_info02 = [NSMutableDictionary dictionary];
    [files_info02 setValue:@"/Documents/" forKey:@"Directory"];
    [files_info02 setValue:@"test02.txt" forKey:@"fileName"];
    NSMutableDictionary *files_info03 = [NSMutableDictionary dictionary];
    [files_info03 setValue:@"/Documents/" forKey:@"Directory"];
    [files_info03 setValue:@"test03.txt" forKey:@"fileName"];
    NSMutableArray<NSMutableDictionary *> *files_info_arr = [NSMutableArray array];
    [files_info_arr addObject:files_info01];
    [files_info_arr addObject:files_info02];
    [files_info_arr addObject:files_info03];
    
    NSError *error;
    
    // Array 转 NSData
    NSData *tmpData = [NSJSONSerialization dataWithJSONObject:files_info_arr options:NSJSONWritingPrettyPrinted error:&error];
    if (error) {
        NSLog(@"convert json error:\n%@",[error localizedFailureReason]);
    }
    
    // NSData 转 Array
    NSArray *arr = [NSJSONSerialization JSONObjectWithData:tmpData
                                                   options:NSJSONReadingMutableContainers
                                                     error:&error];
    if(error) {
        NSLog(@"convert json error:\n%@",[error localizedFailureReason]);
        return;
    }
    NSLog(@"%@",arr);
}

- (IBAction)mutable2:(UIButton *)sender {
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@"AA",@"aa",@"BB",@"bb", nil];
    NSLog(@"%@",dic);
    /*
     NSArray类型的数组:arr
     [arr copy]------------------------------->NSArray类型 （浅拷贝）
     [arr mutableCopy]-------------------->NSMutableArray类型 （深拷贝）
     */
    NSMutableDictionary *dict = [dic mutableCopy];
    [dict setValue:@"CC" forKey:@"cc"];
    NSLog(@"%@",dict);
}

- (IBAction)mutable2dict:(UIButton *)sender {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:@"CC" forKey:@"cc"];
    [dict setValue:@"DD" forKey:@"dd"];
    [dict setValue:@"EE" forKey:@"d"];
    NSLog(@"%@",dict);
    /*
     NSMutableArray类型的数组:mArr
     [mArr copy]------------------------------->NSArray类型 （ 深拷贝）
     [mArr mutableCopy]-------------------->NSMutableArray类型 （深拷贝）
     */
    NSDictionary *dic = [dict copy];
    
    NSLog(@"%@",dic);
}

- (IBAction)mutableData_act:(UIButton *)sender {
    NSString *testStr = @"30819f300d06092a864886f70d010101050003818d0030818902818100b6869a92c25e7a05b7d6cdfeb9d9aea0643c151eea81164237ccf378cb095435dc222e508505bdcc3e2f0e741757a1a7d2a70766f3351f4212bbd4670130fbe5846cd09da45b1fa24b195f54f18ed756850c752157b3b4aa6a176a31467ea7edde783d9a9c7de74f2715ca3ef298b73461482f967ef1b8f1cf0d1ac2bf4957850203010001";
    NSString *test2Str = @"30818902818100b6869a92c25e7a05b7d6cdfeb9d9aea0643c151eea81164237ccf378cb095435dc222e508505bdcc3e2f0e741757a1a7d2a70766f3351f4212bbd4670130fbe5846cd09da45b1fa24b195f54f18ed756850c752157b3b4aa6a176a31467ea7edde783d9a9c7de74f2715ca3ef298b73461482f967ef1b8f1cf0d1ac2bf4957850203010001";
    
    NSData *data1 = [CryptoUtil hexDecode:testStr];
    NSMutableData *mutData = [data1 mutableCopy];
    NSLog(@"length:%lu", mutData.length);
    [mutData replaceBytesInRange:NSMakeRange(0, 22) withBytes:NULL length:0];
    NSLog(@"length:%lu", mutData.length);
    
    NSData *data2 = [mutData copy];
    NSString *hexStr = [CryptoUtil hexEncode:data2];
    if ([hexStr isEqual:test2Str]) {
        NSLog(@"true");
    }else {
        NSLog(@"false");
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]) {
        [self.view endEditing:YES];
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

@end
