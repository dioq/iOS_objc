//
//  InstallViewController.m
//  ObjectiveC
//
//  Created by zd on 9/12/2023.
//  Copyright © 2023 my. All rights reserved.
//

#import "InstallViewController.h"

@interface InstallViewController ()

@end

@implementation InstallViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (IBAction)online_install:(UIButton *)sender {
    NSString *scheme = @"itms-services://?action=download-manifest&url=https://jobs8.cn:9000/download/install.plist";
    NSURL *url = [NSURL URLWithString:scheme];
    UIApplication *application = [UIApplication sharedApplication];
    [application openURL:url options:@{} completionHandler:^(BOOL success) {
        if(success){
            NSLog(@"open %@",scheme);
        }else {
            NSLog(@"open fail");
        }
    }];
}

@end
