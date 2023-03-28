//
//  MMKVViewController.m
//  ObjectiveC
//
//  Created by Dio Brand on 2022/9/29.
//  Copyright © 2022 my. All rights reserved.
//

#import "MMKVViewController.h"
#import <MMKV/MMKV.h>

@interface MMKVViewController ()

@end

@implementation MMKVViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (IBAction)test01:(UIButton *)sender {
    [MMKV initializeMMKV:nil];
    
    MMKV *mmkv = [MMKV defaultMMKV];
    
    [mmkv setBool:YES forKey:@"bool"];
    BOOL bValue = [mmkv getBoolForKey:@"bool"];
    if (bValue) {
        NSLog(@"bool 保存成功");
    }else {
        NSLog(@"bool 保存失败");
    }
    
    [mmkv setInt32:-1024 forKey:@"int32"];
    int32_t iValue = [mmkv getInt32ForKey:@"int32"];
    NSLog(@"iValue:%d", iValue);
    
    [mmkv setString:@"hello, mmkv" forKey:@"string"];
    NSString *str = [mmkv getStringForKey:@"string"];
    NSLog(@"str:%@",str);
}

@end
