//
//  BadgeViewController.m
//  ObjectiveC
//
//  Created by zd on 11/12/2023.
//  Copyright © 2023 my. All rights reserved.
//

#import "BadgeViewController.h"

static int num = 1;

@interface BadgeViewController ()

@end

@implementation BadgeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIUserNotificationSettings  *setting = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge categories:nil];
    [[UIApplication  sharedApplication] registerUserNotificationSettings:setting];
}

- (IBAction)show1_action:(UIButton *)sender {
    [UIApplication sharedApplication].applicationIconBadgeNumber = num;
    
    // 一般在 app 进入后台时调用
    [[UIApplication  sharedApplication] registerForRemoteNotifications];
    //        [[UIApplication  sharedApplication] isRegisteredForRemoteNotifications];
}

- (IBAction)redpoint_add_action:(UIButton *)sender {
    num++;
}

- (IBAction)redpoint_minus_action:(UIButton *)sender {
    num--;
}

@end
