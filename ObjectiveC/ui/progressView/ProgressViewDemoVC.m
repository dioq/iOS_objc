//
//  ProgressViewDemoVC.m
//  ObjectiveC
//
//  Created by zd on 24/9/2024.
//  Copyright © 2024 my. All rights reserved.
//

#import "ProgressViewDemoVC.h"

static double num = 0;

@interface ProgressViewDemoVC ()

@property(nonatomic, strong)UIProgressView *progressView;

@end

@implementation ProgressViewDemoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(10, 200, [[UIScreen mainScreen] bounds].size.width - 20, 0)];
    self.progressView.tintColor = [UIColor greenColor];     // 进度条颜色
    self.progressView.backgroundColor = [UIColor redColor]; // 进度条背景色
    //设置进度条的高度，下面这句代码表示进度条的宽度变为原来的1倍，高度变为原来的1.5倍.
    self.progressView.transform = CGAffineTransformMakeScale(1.0f, 1.5f);
    [self.view addSubview:self.progressView];
    [self.progressView setProgress:0.5 animated:YES];
}

- (IBAction)add_btn_act:(UIButton *)sender {
    num = num + 10;
    double rate = num / 100;
    [self.progressView setProgress:rate animated:YES];
}

- (IBAction)minus_btn_act:(UIButton *)sender {
    num = num - 10;
    double rate = num / 100;
    [self.progressView setProgress:rate animated:YES];
}

@end
