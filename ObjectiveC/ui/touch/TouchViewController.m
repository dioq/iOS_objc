//
//  TouchViewController.m
//  ObjectiveC
//
//  Created by Dio Brand on 2022/8/19.
//  Copyright © 2022 my. All rights reserved.
//

#import "TouchViewController.h"

@interface TouchViewController ()

@property(nonatomic,assign)float startX;
@property(nonatomic,assign)BOOL bMove;

@end

@implementation TouchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    NSLog(@"%f, %f",[UIScreen mainScreen].bounds.size.width,[UIScreen mainScreen].bounds.size.height);
}

//滑动开始事件
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    //    NSLog(@"开始了");
    UITouch *touch = [touches anyObject];
    CGPoint pointone = [touch locationInView:self.view];//获得初始的接触点
    //以字符的形式输出触摸点
    _startX  = pointone.x;
    NSLog(@"触摸点的坐标：%f",_startX);
}
//滑动移动事件
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    //    NSLog(@"移动啦");
    UITouch *touch = [touches anyObject];
    //imgViewTop是滑动后最后接触的View
    CGPoint pointtwo = [touch locationInView:self.view];  //获得滑动后最后接触屏幕的点
    NSLog(@"移动点的坐标：%f,%f",pointtwo.x,_startX);
    int position = (pointtwo.x-_startX);
    NSLog(@"position is %d",position);
    if(fabs(pointtwo.x-_startX)>100) {  //判断两点间的距离
        NSLog(@"移动了");
        _bMove = YES;
    }
}

//滑动结束处理事件
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint pointtwo = [touch locationInView:self.view];  //获得滑动后最后接触屏幕的点
    if((fabs(pointtwo.x-_startX)>50)&&(_bMove)) {
        //判断点的位置关系 左滑动
        if(pointtwo.x-_startX>0) {   //左向右滑动业务处理
            NSLog(@"左向右移动");
        }
        //判断点的位置关系 右滑动
        else
        {  //右向左滑动业务处理
            NSLog(@"右移动");
            //             [self goToNext];
        }
    }
}

@end
