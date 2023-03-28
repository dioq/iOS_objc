//
//  ItemListViewController.m
//  ObjectiveC
//
//  Created by hello on 2019/3/1.
//  Copyright © 2019 William. All rights reserved.
//

#import "MenuListViewController.h"
#import "YCMenuView.h"

@interface MenuListViewController ()

@property(nonatomic,strong)NSArray*arr;

@end

@implementation MenuListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"展开选项列表";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"菜单" style:UIBarButtonItemStylePlain target:self action:@selector(rightTopBtn:)];
    
    UIImage *image = [UIImage imageNamed:@"ic_filter_category_0"];
    YCMenuAction *action = [YCMenuAction actionWithTitle:@"首页" image:image handler:^(YCMenuAction *action) {
        NSLog(@"点击了%@",action.title);
    }];
    YCMenuAction *action1 = [YCMenuAction actionWithTitle:@"个人" image:image handler:^(YCMenuAction *action) {
        NSLog(@"点击了%@",action.title);
    }];
    YCMenuAction *action2 = [YCMenuAction actionWithTitle:@"最新" image:image handler:^(YCMenuAction *action) {
        NSLog(@"点击了%@",action.title);
    }];
    YCMenuAction *action3 = [YCMenuAction actionWithTitle:@"搜索页" image:image handler:^(YCMenuAction *action) {
        NSLog(@"点击了%@",action.title);
    }];
    YCMenuAction *action4 = [YCMenuAction actionWithTitle:@"新闻页" image:image handler:^(YCMenuAction *action) {
        NSLog(@"点击了%@",action.title);
    }];
    
    self.arr = @[action,action1,action2,action3,action4,action,action1,action2];
}

-(void)rightTopBtn:(UIBarButtonItem *)sender {
    YCMenuView *view = [YCMenuView menuWithActions:self.arr width:140 relyonView:sender];
    view.maxDisplayCount = 10;
    [view show];
}

- (IBAction)showlist1:(UIButton *)sender {
    YCMenuView *view = [YCMenuView menuWithActions:self.arr width:140 relyonView:sender];
    view.maxDisplayCount = 10;
    [view show];
}

- (IBAction)showlist2:(UIButton *)sender {
    YCMenuView *view = [YCMenuView menuWithActions:self.arr width:140 relyonView:sender];
    view.maxDisplayCount = 10;
    [view show];
}

- (IBAction)showlist3:(UIButton *)sender {
    YCMenuView *view = [YCMenuView menuWithActions:self.arr width:140 relyonView:sender];
    view.maxDisplayCount = 10;
    [view show];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UITouch *touch = touches.anyObject;
    CGPoint P = [touch locationInView:self.view];
    
    // 创建
    YCMenuView *view = [YCMenuView menuWithActions:self.arr width:140 atPoint:P];
    
    // 自定义设置
    //    view.menuColor = [UIColor whiteColor];
    //    view.separatorColor = [UIColor whiteColor];
    view.maxDisplayCount = 20;
    //    view.offset = 0;
    //    view.textColor = [UIColor whiteColor];
    //    view.textFont = [UIFont boldSystemFontOfSize:18];
    view.menuCellHeight = 60;
    //    view.dismissOnselected = YES;
    //    view.dismissOnTouchOutside = YES;
    
    // 显示
    [view show];
}

@end
