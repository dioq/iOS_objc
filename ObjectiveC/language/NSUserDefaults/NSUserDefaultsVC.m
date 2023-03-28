//
//  NSUserDefaultsVC.m
//  ObjectiveC
//
//  Created by Dio Brand on 2022/8/3.
//  Copyright © 2022 my. All rights reserved.
//

#import "NSUserDefaultsVC.h"

@interface NSUserDefaultsVC ()

@end

@implementation NSUserDefaultsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (IBAction)study:(UIButton *)sender {
    // 1. 创建NSUserDefaults单例:
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
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

- (IBAction)write:(UIButton *)sender {
    // NSUserDefaults 数据存放在沙盒 Library/Preferences/ 目录下，一个以你包名命名的.plist文件。
    NSString *value = @"test value";
    NSString *key = @"test key";
    [[NSUserDefaults standardUserDefaults] setObject:value forKey:key];
    NSString *path = NSHomeDirectory();
    NSLog(@"path : %@", path);
}

- (IBAction)read:(UIButton *)sender {
    
}

@end
