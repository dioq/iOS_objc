//
//  Modal1ViewController.m
//  ObjectiveC
//
//  Created by Geek on 2019/12/31.
//  Copyright © 2019 William. All rights reserved.
//

#import "Modal1ViewController.h"
#import "EndModalViewController.h"

@interface Modal1ViewController ()

@end

@implementation Modal1ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (IBAction)nextAction:(UIButton *)sender {
    EndModalViewController *vc = [[EndModalViewController alloc] initWithNibName:@"EndModalViewController" bundle:nil];
    vc.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:vc animated:YES completion:nil];
}

- (IBAction)backAction:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
