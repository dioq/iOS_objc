//
//  PlistViewController.m
//  ObjectiveC
//
//  Created by zd on 19/6/2023.
//  Copyright © 2023 my. All rights reserved.
//

#import "PlistViewController.h"

@interface PlistViewController ()
{
    NSString *docDir;
}
@end

@implementation PlistViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationController.title = @"plist文件";
    
    // 获取Documents目录路径
    docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES) firstObject];
    NSLog(@"docDir:\n%@",docDir);
}

- (IBAction)TestDictonary:(UIButton *)sender {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"dictonary" ofType:@"plist"];
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:path];
    NSLog(@"%@",dict);
    NSDictionary *wx_dict = [dict objectForKey:@"com.tencent.xin"];
    NSString *version = [wx_dict objectForKey:@"version"];
    NSLog(@"version:%@",version);
}

- (IBAction)TestArray:(UIButton *)sender {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"array" ofType:@"plist"];
    NSArray *array = [NSArray arrayWithContentsOfFile:path];
    NSLog(@"%@",array);
}

- (IBAction)save_action:(UIButton *)sender {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Info" ofType:@"plist"];
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:path];
    NSLog(@"%@",dict);
    
    
    NSError *error;
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:dict requiringSecureCoding:YES error:&error];
    if (error) {
        NSLog(@"%@",[error localizedFailureReason]);
        return;
    }
    
    NSString *filePath = [NSString stringWithFormat:@"%@/Info.plist",docDir];
    BOOL suc = [[NSFileManager defaultManager] createFileAtPath:filePath contents:data attributes:nil];
    if (suc) {
        NSLog(@"写入数据成功!");
    }else{
        NSLog(@"写入数据失败!");
    }
}

@end
