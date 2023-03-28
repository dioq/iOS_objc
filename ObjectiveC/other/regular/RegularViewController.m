//
//  RegularViewController.m
//  ObjectiveC
//
//  Created by Dio Brand on 2023/2/15.
//  Copyright © 2023 my. All rights reserved.
//

#import "RegularViewController.h"

@interface RegularViewController ()

@end

@implementation RegularViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (IBAction)match01:(UIButton *)sender {
    // 例如在字符串中筛选出以Window开头的所有子串.
    NSError *error = nil;
    NSRegularExpression *reg = [NSRegularExpression regularExpressionWithPattern:@"\\bWindows[0-9a-zA-Z]+" options:(NSRegularExpressionAllowCommentsAndWhitespace) error:&error];
    
    NSString *content = @"历史上比较受欢迎的电脑操作系统版本有: WindowsXp, WindowsNT, Windows98, Windows95等";
    if (!error) {
        NSArray<NSTextCheckingResult *> * result = [reg matchesInString:content options:(NSMatchingReportCompletion) range:(NSRange){0, content.length}];
        
        for (NSTextCheckingResult *ele in result) {
            NSLog(@"element == %@\n", [content substringWithRange:ele.range]);
        }
    }
}

- (IBAction)matchFileName:(UIButton *)sender {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", @"wxid.*.rcr"];
    NSArray <NSString *> * mobiles = @[
        @"wxid.wirworoio.rcr",
        @"wxid.i8913jfa.rcr",
        @"wxid.1312930.rcr",
        @"wxid.9319301.rcr",
        @"wxid.i8913jfa.txt",
        @"wxid.1312930.data",
        @"wxid.9319301.dt"
    ];
    
    for (NSString *mobile in mobiles) {
        BOOL match = [predicate evaluateWithObject:mobile];
        NSLog(@"字符串%@,%@", mobile, match ? @"合法" : @"不合法");
    }
}

- (IBAction)match02:(UIButton *)sender {
    /*
     手机号: ^1[3-9]\\d{9}$
     身份证号: ^[0-9]{15}$)|([0-9]{17}([0-9]|X)$
     中文姓名: ^[\u4E00-\u9FA5]{2,}
     网址链接: ^(http|https|ftp)\://([a-zA-Z0-9\.\-]+(\:[a-zA-Z0-9\.&%\$\-]+)*@)?((25[0-5]|2[0-4][0-9]|[0-1]{1}[0-9]{2}|[1-9]{1}[0-9]{1}|[1-9])\.(25[0-5]|2[0-4][0-9]|[0-1]{1}[0-9]{2}|[1-9]{1}[0-9]{1}|[1-9]|0)\.(25[0-5]|2[0-4][0-9]|[0-1]{1}[0-9]{2}|[1-9]{1}[0-9]{1}|[1-9]|0)\.(25[0-5]|2[0-4][0-9]|[0-1]{1}[0-9]{2}|[1-9]{1}[0-9]{1}|[0-9])|([a-zA-Z0-9\-]+\.)*[a-zA-Z0-9\-]+\.[a-zA-Z]{2,4})(\:[0-9]+)?(/[^/][a-zA-Z0-9\.\,\?\'\\/\+&%\$#\=~_\-@]*)*$
     */
    // 判断手机号是否合法
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", @"^1[3-9]\\d{9}$"];
    NSArray <NSString *> * mobiles = @[
        @"17826830415",
        @"12826830415",
        @"27826830415",
        @"1782683041"
    ];
    
    for (NSString *mobile in mobiles) {
        BOOL match = [predicate evaluateWithObject:mobile];
        NSLog(@"手机号码[%@]%@", mobile, match ? @"合法" : @"不合法");
    }
}

- (IBAction)mathc03:(UIButton *)sender {
    /*
     .    匹配任意单个字符除了换行符
     *    匹配>=0个重复的在*号之前的字符.
     +    匹配>=1个重复的+号前的字符.
     **/
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", @".+"];
    NSString *appFileName = @"Caches";
    NSLog(@"%@",appFileName);
    BOOL match = [predicate evaluateWithObject:appFileName];
    if(match) {
        NSLog(@"is right file");
    }else{
        NSLog(@"not is right file");
    }
}

- (IBAction)match04:(UIButton *)sender {
    // 不加任何正则表符号时,就是判断字符串是否相等
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", @"Caches"];
    NSString *appFileName = @"Caches";
    NSLog(@"%@",appFileName);
    BOOL match = [predicate evaluateWithObject:appFileName];
    if(match) {
        NSLog(@"is right file");
    }else{
        NSLog(@"not is right file");
    }
}

@end
