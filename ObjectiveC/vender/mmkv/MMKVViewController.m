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
{
    NSString *docDir;
    MMKV *mmkv;
}

@end

@implementation MMKVViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES) firstObject];
    
    //    NSString *rootDir = [NSString stringWithFormat:@"%@/MMappedKV",docDir];
    //    [MMKV initializeMMKV:rootDir]; 指定储存目录
    [MMKV initializeMMKV:nil];
}

- (IBAction)create_btn_action:(UIButton *)sender {
    // 创建自定义的实例
    mmkv = [MMKV mmkvWithID:@"test"];
    
    // set 布尔值
    [mmkv setBool:YES forKey:@"bool"];
    // get 布尔值
    BOOL bl = [mmkv getBoolForKey:@"bool"];
    NSLog(@"%d: %d",__LINE__,bl);
    
    // set值 32位整形
    [mmkv setInt32:-1024 forKey:@"int32"];
    // get值 32位整形
    int num = [mmkv getInt32ForKey:@"int32"];
    NSLog(@"%d: %d",__LINE__,num);
    
    // set值 32位无符号整形
    [mmkv setUInt32:32 forKey:@"uint32"];
    // get值 32位无符号整形
    num = [mmkv getUInt32ForKey:@"uint32"];
    NSLog(@"%d: %d",__LINE__,num);
    
    // set值 64位整形
    [mmkv setInt64:64 forKey:@"int64"];
    // get值 64位整形
    long num2 = [mmkv getInt64ForKey:@"int64"];
    NSLog(@"%d: %ld",__LINE__,num2);
    
    // set值 64位无符号整形
    [mmkv setUInt64:64 forKey:@"uint64"];
    // get值 64位无符号整形
    unsigned long num3 = [mmkv getInt64ForKey:@"uint64"];
    NSLog(@"%d: %lu",__LINE__,num3);
    
    // set值 字符串
    [mmkv setString:@"hello, mmkv" forKey:@"string"];
    // get值 字符串
    NSString *str =[mmkv getStringForKey:@"string"];
    NSLog(@"%d: %@",__LINE__,str);
    
    // set值 float
    [mmkv setFloat:30.0 forKey:@"float"];
    // get值 float
    float num4 = [mmkv getFloatForKey:@"float"];
    NSLog(@"%d: %f",__LINE__,num4);
    
    // set值 double
    [mmkv setDouble:3.14 forKey:@"double"];
    // get值 double
    double num5 = [mmkv getDoubleForKey:@"double"];
    NSLog(@"%d: %f",__LINE__,num5);
    
    // set值 object
    NSString *str2 = [NSString stringWithFormat:@"This is a test string. num:%d",num];
    [mmkv setObject:str2 forKey:@"object"];
    // get值 object
    NSObject *objc = [mmkv getObjectOfClass:NSString.class forKey:@"object"];
    NSLog(@"%d: %@",__LINE__,objc);
    
    // set值 date
    [mmkv setDate:[NSDate date] forKey:@"date"];
    // get值 date
    NSDate *date = [mmkv getDateForKey:@"date"];
    NSLog(@"%d: %@",__LINE__,date);
}

- (IBAction)delete_btn_action:(UIButton *)sender {
    mmkv = [MMKV mmkvWithID:@"test"];
    // 删除单个
    [mmkv removeValueForKey:@"date"];
    
    // 删除多个
    [mmkv removeValuesForKeys:@[@"double", @"float"]];
    
    // 删除缓存，不删除磁盘文件
    [mmkv clearMemoryCache];
    
    // 删除所有键值，删除磁盘文件
    [mmkv close];
}

- (IBAction)show_btn_action:(UIButton *)sender {
    mmkv = [MMKV mmkvWithID:@"test"];
    // 获取总数
    unsigned long size = mmkv.totalSize;
    NSLog(@"size:%lu\n",size);
    
    // 是否存在key
    BOOL exist = [mmkv containsKey:@"string"];
    if (exist) {
        NSLog(@"string exist");
    }else {
        NSLog(@"string not exist");
    }
    
    // 获取所有keys
    NSArray *keys = [mmkv allKeys];
    for (NSString *key in keys) {
        NSLog(@"key name:%@",key);
    }
}

- (IBAction)test01:(UIButton *)sender {
    // 创建默认实例
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
