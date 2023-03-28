//
//  HUDViewController.m
//  ObjC_SDK
//
//  Created by William on 2018/9/10.
//  Copyright © 2018年 William. All rights reserved.
//

#import "HUDViewController.h"
#import <MBProgressHUD.h>

@interface HUDViewController ()
{
    MBProgressHUD *hud;
}

@end

@implementation HUDViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (IBAction)show:(UIButton *)sender {
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    hud.activityIndicatorColor = UIColor.white
//    [[UIActivityIndicatorView appearanceWhenContainedInInstancesOfClasses:[UISplitViewController class], nil];
    [UIActivityIndicatorView appearanceWhenContainedInInstancesOfClasses:[NSArray arrayWithObjects:[MBProgressHUD class], nil]].color = [UIColor redColor];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.label.text = @"Loading";
    
    int64_t delayInSeconds = 2.0; // 延迟的时间
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self->hud hideAnimated:YES];
        [self->hud removeFromSuperview];
    });
}

- (IBAction)show2:(UIButton *)sender {
    MBProgressHUD *hud2 = [[MBProgressHUD alloc]init];
    hud2.mode = MBProgressHUDModeIndeterminate;
    hud2.label.text = @"Loading";
    [UIActivityIndicatorView appearanceWhenContainedInInstancesOfClasses:[NSArray arrayWithObjects:[MBProgressHUD class], nil]].color = [UIColor redColor];
    [self.view addSubview:hud2];
    [hud2 showAnimated:YES];
    int64_t delayInSeconds = 3.0; // 延迟的时间
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [hud2 hideAnimated:YES];
        [hud2 removeFromSuperview];
    });
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
