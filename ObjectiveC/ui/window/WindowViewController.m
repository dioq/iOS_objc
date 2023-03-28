//
//  WindowViewController.m
//  ObjectiveC
//
//  Created by Dio Brand on 2023/3/18.
//  Copyright © 2023 my. All rights reserved.
//

#import "WindowViewController.h"

@interface WindowViewController ()

@end

@implementation WindowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"获取window";
}

- (IBAction)currentWindow:(UIButton *)sender {
    //创建一个弹框
    UIAlertController *addAlertVC = [UIAlertController alertControllerWithTitle:@"控制台" message:@"苹果推的控制界面" preferredStyle:UIAlertControllerStyleAlert];
    
    //    __block NSString *target_account;
    //    __block NSString *content;
    //创建两个textFiled输入框
    [addAlertVC addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.tag = 100;
        textField.placeholder = @"目标号码 ...";
        textField.userInteractionEnabled = NO;
    }];
    [addAlertVC addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.tag = 101;
        textField.placeholder = @"发送的内容";
        
    }];
    
    // 发送
    UIAlertAction *sendAction =[UIAlertAction actionWithTitle:@"发送" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        
    }];
    //添加确定按钮
    [addAlertVC addAction:sendAction];
    
    
    // 清空
    UIAlertAction *cleanAction =[UIAlertAction actionWithTitle:@"清空" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        
    }];
    [addAlertVC addAction:cleanAction];
    
    UIWindow *window =  [[[UIApplication sharedApplication] windows] objectAtIndex:0];
    [window.rootViewController presentViewController:addAlertVC animated:YES completion:nil];
}

@end
