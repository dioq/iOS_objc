//
//  ButtonViewController.m
//  ObjectiveC
//
//  Created by Dio Brand on 2022/6/24.
//  Copyright © 2022 my. All rights reserved.
//

#import "ButtonViewController.h"

@interface ButtonViewController ()

@property (weak, nonatomic) IBOutlet UIButton *btn1;

@property(nonatomic,assign) BOOL isSelected;

@end

@implementation ButtonViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemOrganize target:self action:@selector(refresh)];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    
    [self.btn1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.btn1 setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
    [self.btn1 addTarget:self action:@selector(action1:) forControlEvents:UIControlEventTouchUpInside];
}

-(void)refresh {
    NSLog(@"导航栏上的按钮被点了");
}

-(void)action1:(UIButton *)sender {
    if  (sender.backgroundColor != UIColor.redColor) {
        sender.backgroundColor = UIColor.redColor;
    }else {
        sender.backgroundColor = UIColor.greenColor;
    }
    NSLog(@"%s ----> go here", __FUNCTION__);
}

@end
