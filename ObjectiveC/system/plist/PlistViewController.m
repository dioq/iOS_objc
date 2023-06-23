//
//  PlistViewController.m
//  ObjectiveC
//
//  Created by zd on 19/6/2023.
//  Copyright © 2023 my. All rights reserved.
//

#import "PlistViewController.h"

@interface PlistViewController ()

@end

@implementation PlistViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationController.title = @"plist文件";
    
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


@end
