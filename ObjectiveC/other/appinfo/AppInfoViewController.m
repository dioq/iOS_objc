//
//  AppInfoViewController.m
//  ObjectiveC
//
//  Created by zd on 9/6/2025.
//  Copyright © 2025 my. All rights reserved.
//

#import "AppInfoViewController.h"

@interface AppInfoViewController ()

@end

@implementation AppInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"App 信息";
}

- (IBAction)show_act:(UIButton *)sender {
    NSDictionary *infoDictionary =[[NSBundle mainBundle] infoDictionary];
    NSString *bundleID = [infoDictionary valueForKey:@"CFBundleIdentifier"]; //bundle identifier
    NSLog(@"Bundle Identifier:%@",bundleID);
}

@end
