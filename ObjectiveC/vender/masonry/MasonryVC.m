//
//  MasonryVC.m
//  ObjC_SDK
//
//  Created by William on 2018/9/29.
//  Copyright © 2018年 William. All rights reserved.
//

#import "MasonryVC.h"
#import <Masonry.h>

@interface MasonryVC ()
{
    UILabel *label1;
    UILabel *label2;
    UILabel *label3;
    UILabel *label4;
    UIView *backView;
    UIButton *btn;
    UIView *myView;
}

@end

@implementation MasonryVC

/**
 Masonry 基础 API
 mas_makeConstraints    添加约束
 mas_remakeConstraints  使用新添加的约束，同时会删除原有的约束
 mas_updateConstraints  使用新添加的约束，但不删除原有的约束
 */

- (void)viewDidLoad {
    [super viewDidLoad];
    label1 = [UILabel new];
    label2 = [UILabel new];
    label3 = [UILabel new];
    label4 = [UILabel new];
    
    //初始化label，并设置它的一些参数
    NSArray *arrayLabel = @[label1,label2,label3,label4];
    NSArray *arrayText = @[@"科目一",@"科目二",@"科目三",@"科目四"];
    for (int i = 0; i<4; i++) {
        UILabel *label = arrayLabel[i];
        label.backgroundColor = [UIColor colorWithRed:arc4random()%255/255.0 green:arc4random()%255/255.0 blue:arc4random()%255/255.0 alpha:1.0];
        label.text = arrayText[i];
        label.layer.cornerRadius = 10;
        label.clipsToBounds = YES;
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor whiteColor];
        [self.view addSubview:label];
    }
    
    //初始化uiview
    backView = [UIView new];
    backView.clipsToBounds = YES;
    backView.layer.cornerRadius = 50;
    backView.layer.masksToBounds = YES;
    backView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:backView];
    //初始化button
    btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"汽车类型" forState:UIControlStateNormal];
    btn.backgroundColor = [UIColor redColor];
    btn.layer.cornerRadius = 40;
    [backView addSubview:btn];
    //初始化myView
    myView = [UIView new];
    myView.backgroundColor = [UIColor yellowColor];
    [self.view addSubview:myView];
    
    [self creatContrains];
}

-(void)creatContrains{
    [label1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@80);//距顶部距离
        make.left.equalTo(self.view.mas_left).offset(50);//向左偏移50
        make.height.equalTo(@70);//设置它的高度
    }];

    [label2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.height.equalTo(self->label1);//设置label2的顶部，底部和高度和label1一样，这样设置，简洁明了，很方便吧
        make.left.equalTo(self->label1.mas_right).offset(40);//相对于label1的右间距，偏移40
        make.right.equalTo(self.view.mas_right).offset(-50);//设置它的右侧偏移量为50，注意为－号哦。
        make.width.equalTo(self->label1.mas_width);//设置与label1等宽，这里设置的是相对约束，根据不同屏幕的大小，改变label1和label2的宽度。
    }];
    
    [label3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.width.height.equalTo(self->label1);//设置它的左右，宽高和label1一样
        make.top.equalTo(self->label1.mas_bottom).offset(40);//设置label3顶部距label1底部距离
    }];
    
    [label4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self->label3);//设置它的高低和label3一样的约束
        make.left.right.equalTo(self->label2);//设置它的左右和label2一样
    }];
    
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);//设置x轴中心对成位置为self.view的x周中心对称
        make.top.equalTo(@125);//顶部距离设置
        make.size.mas_equalTo(CGSizeMake(100, 100));//设置它的size
    }];;
    
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self->backView);//设置它的x轴，y轴的中心对成位置为backView
        make.size.mas_equalTo(CGSizeMake(80, 80));//设置它的size
    }];
    
    [myView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self->label3.mas_bottom).offset(20);//设置顶部距label3底部距20
        make.centerX.equalTo(self->backView);
        make.width.equalTo(self->label3.mas_width).multipliedBy(1);//宽是label3宽的两倍
        make.height.equalTo(self->label3.mas_height).dividedBy(1);//高是label3高的二分之一
    }];
    
    [self performSelector:@selector(updateView:) withObject:myView afterDelay:2];
}

-(void)updateView: (UIView *)view2{
    [view2 mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self->label3.mas_bottom).offset(120);//设置顶部距label3底部距30
        make.centerX.equalTo(self->backView).offset(30);
        make.width.equalTo(self->backView.mas_width).multipliedBy(2);
        make.height.equalTo(self->label3.mas_height).dividedBy(3);
    }];
}



//方法传参数是这样调用的
-(void) setKids: (NSString *)myOldestKidName secondKid: (NSString *) mySecondOldestKidName thirdKid: (NSString *) myThirdOldestKidName{

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
