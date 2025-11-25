//
//  NSUserDefaultsVC.m
//  ObjectiveC
//
//  Created by Dio Brand on 2022/8/3.
//  Copyright © 2022 my. All rights reserved.
//

#import "NSUserDefaultsVC.h"

@interface NSUserDefaultsVC ()
{
    NSUserDefaults *defaults;
}
@end

@implementation NSUserDefaultsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // 1. 创建NSUserDefaults单例
    defaults = [NSUserDefaults standardUserDefaults];
}

- (IBAction)study:(UIButton *)sender {
    // 2. 数据写入:
    // 通过 key 值 来存入 和 读取数据
    [defaults setInteger:23 forKey:@"myInteger"];
    // 注意：对相同的Key赋值约等于一次覆盖，要保证每一个Key的唯一性
    
    // 3. 将数据 立即存入到 磁盘:
    [defaults synchronize];
    
    // 4. 通过key值 按照写入对应类型 读取数据 有返回值
    NSInteger myInteger = [defaults integerForKey:@"myInteger"];
    NSLog(@"myInteger:%ld",myInteger);
}

- (IBAction)test1:(UIButton *)sender {
    // NSUserDefaults 数据存放在沙盒,路径如下
    NSString *bundleID = [[[NSBundle mainBundle] infoDictionary] valueForKey:@"CFBundleIdentifier"];
    NSString *path = [NSString stringWithFormat:@"%@/Library/Preferences/%@.plist",NSHomeDirectory(),bundleID];
    NSLog(@"path:%@", path);
    
    NSString *value = @"test value";
    NSString *key = @"test key";
    [defaults setObject:value forKey:key];
}

- (IBAction)test2:(UIButton *)sender {
    NSMutableDictionary *mutDict = [NSMutableDictionary new];
    [mutDict setValue:@"value1" forKey:@"key1"];
    [mutDict setValue:@"value2" forKey:@"key2"];
    
    [defaults setObject:[mutDict copy] forKey:@"dkey"];
    
    NSDictionary *dict = [defaults objectForKey:@"dkey"];
    NSLog(@"%@",[dict valueForKey:@"key1"]);
}

@end
