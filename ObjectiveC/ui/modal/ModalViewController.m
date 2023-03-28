//
//  ModalViewController.m
//  ObjectiveC
//
//  Created by hello on 2019/11/16.
//  Copyright © 2019 William. All rights reserved.
//

#import "ModalViewController.h"
#import "Modal1ViewController.h"

@interface ModalViewController ()

@end

@implementation ModalViewController

- (void)viewDidLoad {
    [super viewDidLoad];

}

- (IBAction)jump1Action:(UIButton *)sender {
    Modal1ViewController *vc = [[Modal1ViewController alloc] initWithNibName:@"Modal1ViewController" bundle:nil];
    vc.modalPresentationStyle = UIModalTransitionStyleCoverVertical;
    [self presentViewController:vc animated:YES completion:^{
        NSLog(@"跳转已执行");
    }];
}

@end
