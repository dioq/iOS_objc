//
//  EndModalViewController.m
//  ObjectiveC
//
//  Created by hello on 2019/11/16.
//  Copyright © 2019 William. All rights reserved.
//

#import "EndModalViewController.h"

@interface EndModalViewController ()

@end

@implementation EndModalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (IBAction)backAction:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        NSLog(@"回跳已执行");
    }];
}

- (IBAction)backFirstAction:(UIButton *)sender {
    [self dismissModalStack];
}

- (void)dismissModalStack {
    UIViewController *vc = self.presentingViewController;
    while (vc.presentingViewController) {
        vc = vc.presentingViewController;
    }
    [vc dismissViewControllerAnimated:YES completion:NULL];
}

@end
