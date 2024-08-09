//
//  MyAlertViewController.m
//  ObjectiveC
//
//  Created by Dio Brand on 2023/3/23.
//  Copyright © 2023 my. All rights reserved.
//

#import "MyAlertViewController.h"
#import "MyAlertUtil.h"
#import "MyTip.h"

@interface MyAlertViewController ()

@end

@implementation MyAlertViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (IBAction)showAlertAct:(UIButton *)sender {
    [self useCustomHUD];
}

- (void)useCustomHUD
{
    // 1.创建父控件
    UIView *cover = [[UIView alloc] init];
    cover.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    cover.frame = CGRectMake(0, 0, 150, 150);
    cover.center = self.view.center;
    
    // 修改父控件为圆角
    cover.layer.cornerRadius = 10;
    [self.view addSubview:cover];
    
    // 2.创建菊花
    // 菊花有默认的尺寸
    // 注意: 虽然有默认的尺寸, 但是要想显示必须让菊花转起来
    UIActivityIndicatorView *activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleLarge];
    activity.center = CGPointMake(cover.frame.size.width * 0.5, 50);
    [activity startAnimating];
    
    [cover addSubview:activity];
    // 3.创建UILabel
    UILabel *label = [[UILabel alloc] init];
    //    label.backgroundColor = [UIColor purpleColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = @"正在拼命加载中...";
    label.frame = CGRectMake(0, cover.frame.size.height - 80, cover.frame.size.width, 80);
    [cover addSubview:label];
}

- (IBAction)show:(UIButton *)sender {
    [[MyAlertUtil sharedManager] showTip:@"正在上传 ..."];
}

- (IBAction)done:(UIButton *)sender {
    [[MyAlertUtil sharedManager] disappear];
}

- (IBAction)disapper_after_time_action:(UIButton *)sender {
    [[MyAlertUtil sharedManager] disappearAfter:5];
}

- (IBAction)showSometime:(UIButton *)sender {
    [[MyAlertUtil sharedManager] showTip:@"显示一会" duration:5];
}

- (IBAction)show_message_tip_act:(UIButton *)sender {
    NSString *tip = @"In conclusion, navigating Palera1n Rootful mode is a seamless experience, particularly beneficial for addressing tweaks without rootless support updates and meeting specific iCloud Bypass requirements. However, for everyday read and write access to the complete file system is not needed. The landscape of tweaks is rapidly evolving, with most being developed for rootless environments, indicating a significant shift in the future of jailbreaking.";
//    tip = @"In conclusion, navigating Palera1n Rootful mode";
    [[MyTip sharedManager] show:tip duration:2];
}

@end
