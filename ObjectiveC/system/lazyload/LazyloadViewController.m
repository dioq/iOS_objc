//
//  LazyloadViewController.m
//  ObjC_stu
//
//  Created by William on 2018/9/29.
//  Copyright © 2018年 William. All rights reserved.
//

#import "LazyloadViewController.h"

@interface LazyloadViewController ()

@property(strong, nonatomic) UIView *myView;
@property(nonatomic, strong) UILabel *titleLable;

@end

/**
 lazyloading 是重写getter方法, 当调用对象的getter方法时会被触发
 */
@implementation LazyloadViewController

-(UIView *)myView {
    if (!_myView) {
        self.myView = [[UIView alloc]initWithFrame:CGRectMake(80, 170, 200, 200)];
        self.myView.backgroundColor = [UIColor redColor];
    }
    return _myView;
}

-(UILabel *)titleLable{
    if (!_titleLable) {
        self.titleLable = [[UILabel alloc]initWithFrame:CGRectMake(10, 70, 200, 90)];
        self.titleLable.textAlignment = NSTextAlignmentCenter;
        self.titleLable.backgroundColor = [UIColor orangeColor];
        [self.titleLable setText:@"aaa"];
    }
    return _titleLable;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.myView];
    [self.view addSubview:self.titleLable];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
