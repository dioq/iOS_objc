//
//  AlertViewController.m
//  ObjectiveC
//
//  Created by Dio Brand on 2022/9/24.
//  Copyright © 2022 my. All rights reserved.
//

#import "AlertViewController.h"

@interface AlertViewController ()

@end

@implementation AlertViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (IBAction)withTF:(UIButton *)sender {
    //创建一个弹框
    UIAlertController *addAlertVC = [UIAlertController alertControllerWithTitle:@"添加" message:@"添加设备唯一标识" preferredStyle:UIAlertControllerStyleAlert];
    
    __block NSString *key;
    __block NSString *value;
    //创建两个textFiled输入框
    [addAlertVC addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.tag = 100;
        textField.placeholder = @"key";
        textField.text = @"udid";
        textField.userInteractionEnabled = NO;
    }];
    [addAlertVC addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.tag = 101;
        textField.placeholder = @"value";
        //            textField.secureTextEntry = YES;
    }];
    
    //创建取消事件(按钮)
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    //添加 取消事件 到 弹窗界面
    [addAlertVC addAction:cancelAction];
    
    
    //创建 确认按钮(事件) 并添加到弹窗界面
    UIAlertAction *confirmAction =[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        UITextField *keyTF = [addAlertVC.view viewWithTag:100];
        key = keyTF.text;
        UITextField *valueTF = [addAlertVC.view viewWithTag:101];
        value = valueTF.text;
        NSLog(@"%@ : %@", key,value);
    }];
    //添加确定按钮
    [addAlertVC addAction:confirmAction];
    
    //模态显示一个弹框  注意: UIAlterController只能通过模态形式进行弹出,不能使用push
    [self.navigationController presentViewController:addAlertVC animated:YES completion:nil];
}

- (IBAction)withoutself:(UIButton *)sender {
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
//    [window.rootViewController.view layoutSubviews];
}

@end
