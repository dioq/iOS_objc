//
//  CheckAppViewController.m
//  ObjectiveC
//
//  Created by zd on 22/12/2023.
//  Copyright © 2023 my. All rights reserved.
//

#import "CheckAppViewController.h"

@interface CheckAppViewController ()

@end

@implementation CheckAppViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (IBAction)check_app_act:(UIButton *)sender {
    NSString *urlStr = @"weixin://";
    //    NSString *urlStr = @"weixinapp://";
    NSURL *url = [NSURL URLWithString:urlStr];
    UIApplication *application = [UIApplication sharedApplication];
    if([application canOpenURL:url]){ // 无论是否安装 都返回 YES
        NSLog(@"安装了");
        NSDictionary *dict = [NSDictionary dictionary];
        [application  openURL:url options:dict completionHandler:^(BOOL success) {
            if(success) {
                NSLog(@"跳转成功");
            }else {
                NSLog(@"跳转失败");
            }
        }];
    }else {
        NSLog(@"未安装");
    }
}

- (IBAction)check_bid_act:(UIButton *)sender {
    BOOL baiduMap = [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"baidumap://"]];
    if(baiduMap) {
        NSLog(@"yes");
    }else {
        NSLog(@"no");
    }
}

@end
