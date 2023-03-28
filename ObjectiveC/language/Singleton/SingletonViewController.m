//
//  SingletonViewController.m
//  ObjectiveC
//
//  Created by Dio Brand on 2022/10/2.
//  Copyright © 2022 my. All rights reserved.
//

#import "SingletonViewController.h"
#import "MyManager.h"

@interface SingletonViewController ()

@end

@implementation SingletonViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"单例";
}

- (IBAction)showAct:(UIButton *)sender {
    //在控制台看到输出结果为同一个对象
    MyManager *obj1 = [MyManager sharedManager];
    NSLog(@"obj1 = %@",obj1);
    
    MyManager *obj2 = [MyManager sharedManager];
    NSLog(@"obj2 = %@",obj2);
    
    MyManager *obj3 = [MyManager sharedManager];
    NSLog(@"obj3 = %@",obj3);
    
    MyManager *obj4 = [[MyManager alloc] init];
    NSLog(@"obj4 = %@",obj4);
    
    MyManager *obj5 = [[MyManager alloc] init];
    NSLog(@"obj5 = %@",obj5);
}

@end
