//
//  SDViewController.m
//  ObjC_SDK
//
//  Created by William on 2018/9/29.
//  Copyright © 2018年 William. All rights reserved.
//

#import "SDViewController.h"
#import <SDAutoLayout.h>

@interface SDViewController ()

@end

@implementation SDViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIView *view0 = [UIView new];
    view0.backgroundColor = [UIColor redColor];
    UIView *view1 = [UIView new];
    view1.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:view0];
    [self.view addSubview:view1];
    
    view0.sd_layout
    .leftSpaceToView(self.view, 10)
    .topSpaceToView(self.view, 80)
    .heightIs(100)
    .widthRatioToView(self.view, 0.4);
    
    view1.sd_layout
    .leftSpaceToView(view0, 10)
    .topEqualToView(view0)
    .heightRatioToView(view0, 1)
    .rightSpaceToView(self.view, 10);
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
