//
//  StringViewController.m
//  ObjectiveC
//
//  Created by Dio Brand on 2022/8/6.
//  Copyright © 2022 my. All rights reserved.
//

#import "StringViewController.h"

@interface StringViewController ()

@end

static NSString *global_str;
@implementation StringViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (IBAction)stringtype:(UIButton *)sender {
    NSString *str1 = @"1234567890";
    NSLog(@"%@",str1);
    NSLog(@"%d:%@",__LINE__,[str1 class]);
    //str1: __NSCFConstantString
    
    NSString *str2 = [NSString stringWithString:@"1234567890"];
    NSLog(@"%@",str2);
    NSLog(@"%d:%@",__LINE__,[str2 class]);
    //str2: __NSCFConstantString
    
    NSString *str3 = [NSString stringWithFormat:@"1234567890"];
    NSLog(@"%@",str3);
    NSLog(@"%d:%@",__LINE__,[str3 class]);
    //str3: __NSCFString
    
    NSString *str4 = [NSString stringWithString:str3];
    NSLog(@"%@",str4);
    NSLog(@"%d:%@",__LINE__,[str4 class]);
    
    //    global_str = str4;
    //    NSLog(@"%@",global_str);
    //    NSLog(@"%d:%@",__LINE__,[global_str class]);
    
}

- (IBAction)match0:(UIButton *)sender {
    NSString *testStr = @"https://jobs8.cn";
    if ([testStr hasPrefix:@"https"]) {
        NSLog(@"前缀匹配到了");
    }
    if ([testStr hasSuffix:@".cn"]) {
        NSLog(@"后缀匹配到了");
    }
}

- (IBAction)subString:(UIButton *)sender {
    //字符串截取
    NSString *str1=@"Hello world";
    //从索引为2的位置开始截取直到最后（包括第二个字符）
    NSLog(@"{2,}: %@",[str1 substringFromIndex:2]);//打印结果为:llo world
    //从索引为0开始截取到索引为2的位置,但是不包括索引2所对应的字符
    NSLog(@"{0,2}: %@",[str1 substringToIndex:2]);//打印结果为:He
    //从指定索引的位置(location)向后截取,截取长度为length
    NSRange range={2,3};//截取位置从索引2开始 截取3位长度的字符 包括索引为2对应的字符
    NSLog(@"{2,3}: %@",[str1 substringWithRange:range]);//打印结果:llo

    //字符串替换
    NSString *str2=@"abc";
    NSString *str3=@"def";
    NSLog(@"%@",[str2 stringByReplacingOccurrencesOfString:str2 withString:str3]);//打印结果:def
}

- (IBAction)indexOfString:(UIButton *)sender {
    NSString *testStr = @"/var/mobile/Containers/Data/Application/AF53C4B6-E80C-4B7A-9CCF-82DEDF2595CC/Library/WechatPrivate/text.txt";
    NSRange range = [testStr rangeOfString:@"/"];
    NSLog(@"%lu-%lu", range.location,range.length);
}

- (IBAction)splitString:(UIButton *)sender {
    NSString *str1 = @"1=2=3=4";
    NSArray *arry = [str1 componentsSeparatedByString:@"="];
    NSLog(@"%@",arry);
}

- (IBAction)MutableStringAction:(UIButton *)sender {
    NSMutableString *str = [[NSMutableString alloc]init];
    [str appendString:@"dsfafkjfdsfkdfsdlkfj,"];
    NSLog(@"%@",str);
    NSLog(@"%d:%@",__LINE__,[str class]);
    
    // 删除指定范围字符
    NSMutableString *testStr = [NSMutableString string];
    [testStr appendString:@"/var/mobile/Containers/Data/Application/AF53C4B6-E80C-4B7A-9CCF-82DEDF2595CC/Library/WechatPrivate/text.txt"];
    [testStr deleteCharactersInRange:NSMakeRange(0, 76)];
    NSLog(@"%@",testStr);
    NSLog(@"%d:%@",__LINE__,[testStr class]);
    
    // 字符串替换
    NSMutableString *str3 = [[NSMutableString alloc] init];
    [str3 appendString:@"AAAAAAAA-AAAA-AAAA-AAAA-AAAAAAAABBBB"];
    NSString *tmp = [str3 stringByReplacingOccurrencesOfString:@"-" withString:@""];
    NSLog(@"str3:%@",tmp);
}

- (IBAction)conver:(UIButton *)sender {
    NSMutableString *mutbalStr = [[NSMutableString alloc] init];
    [mutbalStr appendString:@"This is a test mutable string."];
    [mutbalStr appendFormat:@"\ttest v:%d",100];
    /*
     NSMutableString是NSString的子类，所以NSMutableString的实例可以给NSString的变量赋值，这样会导致NSMutableString实例改变了内容，NSString的变量也改变的情况，这在某些情况下是错的，这个时候应该使用 copy关键字来将 NSMutableString 的实例字符串拷贝一份到 NSString实例里面
     */
    NSString *str = [mutbalStr copy];
    NSLog(@"str:\n%@",str);
    
    // NSString to NSMutableString
    NSString *string = @"A string.";
    NSMutableString *mutableString = [string mutableCopy];
    NSLog(@"*mutableString:\n%@", mutableString);
}

- (IBAction)ctype:(UIButton *)sender {
    // NSString转换char
    NSString * str1 = @"Test";
    const char * c1 = [str1 UTF8String];
    printf("%s\n",c1);
    
    
    NSString * str2 = @"Test2";
    const char *p = [str2 UTF8String];
    char b[0x100] = {0};
    memcpy(b, p, 0x100);
    printf("%s\n",b);
    
    // char转换NSString
    const char * c3 = "test3";
    NSString *str3 = [NSString stringWithUTF8String:c3];
    NSLog(@"%@",str3);
}

@end
