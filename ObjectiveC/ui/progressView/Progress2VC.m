//
//  Progress2VC.m
//  ObjectiveC
//
//  Created by zd on 1/3/2026.
//  Copyright © 2026 my. All rights reserved.
//

#import "Progress2VC.h"
#import "TaskProgressView.h"

static int num = 0;

@interface Progress2VC ()
{
    TaskProgressView *progress;
}

@end

@implementation Progress2VC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.title = @"自定义进度条";
}

- (IBAction)add:(UIButton *)sender {
    num++;
    [progress updateTotal:120 completed:num];
}

- (IBAction)sub:(UIButton *)sender {
    num--;
    [progress updateTotal:120 completed:num];
}

- (IBAction)show_act:(UIButton *)sender {
    progress = [[TaskProgressView alloc] initWithFrame:CGRectMake(20, 400, self.view.bounds.size.width-40, 20)];
    [self.view addSubview:progress];
    progress.backgroundColor = [UIColor redColor];
}

@end
