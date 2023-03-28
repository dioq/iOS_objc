//
//  ToastViewController.m
//  ObjectiveC
//
//  Created by hello on 2019/3/25.
//  Copyright © 2019 William. All rights reserved.
//

#import "ToastViewController.h"
#import "CBToast.h"

@interface ToastViewController ()

@end

@implementation ToastViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CGFloat main_width = [UIScreen mainScreen].bounds.size.width;
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(30, 90, main_width-30*2, 40);
    btn.tag = 1;
    btn.backgroundColor = [UIColor orangeColor];
    btn.titleLabel.font = [UIFont systemFontOfSize:14];
    [btn setTitle:@"正在加载中" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(showToastAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn1.frame = CGRectMake(30, CGRectGetMaxY(btn.frame)+15, main_width-30*2, 40);
    btn1.tag = 2;
    btn1.backgroundColor = [UIColor orangeColor];
    btn1.titleLabel.font = [UIFont systemFontOfSize:15];
    [btn1 setTitle:@"请你核对信息之后，再从新下一个单子，然后查看一下订单号码和订单金额是否符合规定，然后就可以测试这个名字很长的啦" forState:UIControlStateNormal];
    [btn1 addTarget:self action:@selector(showToastAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn1];
    
    UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn2.frame = CGRectMake(30, CGRectGetMaxY(btn1.frame)+15, main_width-30*2, 40);
    btn2.tag = 3;
    btn2.selected = YES;
    btn2.backgroundColor = [UIColor orangeColor];
    btn2.titleLabel.font = [UIFont systemFontOfSize:15];
    [btn2 setTitle:@"菊花旋转" forState:UIControlStateNormal];
    [btn2 addTarget:self action:@selector(showToastAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn2];
    
    
    UIButton *btn3 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn3.frame = CGRectMake(30, CGRectGetMaxY(btn2.frame)+15, main_width-30*2, 40);
    btn3.tag = 4;
    btn3.selected = YES;
    btn3.backgroundColor = [UIColor orangeColor];
    btn3.titleLabel.font = [UIFont systemFontOfSize:14];
    [btn3 setTitle:@"菊花带消息的正在加载中" forState:UIControlStateNormal];
    [btn3 addTarget:self action:@selector(showToastAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn3];
}

- (void)showToastAction:(UIButton *)buton{
    switch (buton.tag) {
        case 1:
        {
            [CBToast showToastAction:buton.currentTitle];
        }
            break;
        case 2:
        {
            //根据top，bottom，center来显示位置。 时间3.0s
            [CBToast showToast:buton.currentTitle location:@"bottom" showTime:3.0];
        }
            break;
        case 3:
        {
            if (buton.selected) {
                [CBToast showToastAction];
            }else{
                [CBToast hiddenToastAction];
            }
            buton.selected = !buton.selected;
        }
            break;
        case 4:
        {
            if (buton.selected) {
                [CBToast showIndicatorToastAction:buton.currentTitle];
            }else{
                [CBToast hiddenIndicatorToastAction];
            }
            buton.selected = !buton.selected;
        }
            break;
        default:
            break;
    }
}

@end
