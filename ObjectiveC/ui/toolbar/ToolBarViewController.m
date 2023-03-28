//
//  ToolBarViewController.m
//  ObjectiveC
//
//  Created by Dio Brand on 2023/2/17.
//  Copyright © 2023 my. All rights reserved.
//

#import "ToolBarViewController.h"

@interface ToolBarViewController ()

@end

@implementation ToolBarViewController

// 隐藏toolbar
- (BOOL)prefersStatusBarHidden {
    return YES;
}

// toolbar 模式
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

// 隐藏 navigationBar
-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
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
