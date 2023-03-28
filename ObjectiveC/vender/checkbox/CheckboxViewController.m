//
//  CheckboxViewController.m
//  ObjectiveC
//
//  Created by Dio Brand on 2022/9/18.
//  Copyright © 2022 my. All rights reserved.
//

#import "CheckboxViewController.h"
#import "CheckBox.h"

@interface CheckboxViewController ()<CheckBoxDelegate>

@property(nonatomic,strong)CheckBox *box;

@end

@implementation CheckboxViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.box=[[CheckBox alloc]initWithItemTitleArray:@[@"Keychain",@"沙盒",@"设备信息",@"44",@"55"] columns:5];
    [self.view addSubview:self.box];
    self.box.isMulti = YES; // 复选
    [self.box setFrame:CGRectMake(10, 160, 360,45)];
    [self.box setTextColor:[UIColor redColor]];
    [self.box setTextFont:[UIFont systemFontOfSize:10]];
    [self.box setNormalImage:[UIImage imageNamed:@"icon_check_n"]];
    [self.box setSelectedImage:[UIImage imageNamed:@"icon_check_s"]];
    self.box.delegate = self;
}

- (void)checkBoxItemdidSelected:(UIButton *)item atIndex:(NSUInteger)index checkBox:(CheckBox *)checkbox {
    NSLog(@"%d ----> atIndex: %lu",__LINE__, index);
}

- (IBAction)selectedItems:(UIButton *)sender {
    NSArray *items = [self.box getSelectedItemIndexs];
    for (NSObject *item in items) {
        NSLog(@"%@",item);
    }
}

@end
