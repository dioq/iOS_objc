//
//  DelegateViewController.m
//  ObjectiveC
//
//  Created by hello on 2019/4/16.
//  Copyright © 2019 William. All rights reserved.
//

#import "DelegateViewController.h"
#import "Eat.h"
#import "Man.h"
#import "Dog.h"
#import "Fish.h"
#import "DelegateView.h"
#import "TestDelegate2.h"
#import "Man2.h"
#import "Dog2.h"

@interface DelegateViewController ()<TestDelegate, TestDelegate2>

@end

@implementation DelegateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self study1];
    [self study2];
//    [self study3];
}

-(void)study3{
    DelegateView *delView = [[[NSBundle mainBundle] loadNibNamed:@"DelegateView" owner:self options:nil] lastObject];
    delView.frame = CGRectMake(10, 70, ScreenWidth - 20, 150);
    [self.view addSubview:delView];
    delView.myDelegate = self;
    delView.myDelegate2 = self;
}

-(void)touch:(NSString *)str{
    NSLog(@"touch: %@",str);
}

-(void)testMethod:(NSString *)str{
    NSLog(@"touch: %@",str);
}

-(void)study2{
    Man2 *man = [Man2 new];
    Dog2 *dog = [Dog2 new];
    man.myDelegate = dog;         // 设置代理
    
    if ([man.myDelegate respondsToSelector:@selector(watch)]) {
        [man.myDelegate watch];   // 通知代理方看门
    }
}

-(void)study1{
    Man *man = [Man new];
    Dog *dog = [Dog new];
    Fish *fish = [Fish new];
    
    [man eat];
    [man watch];
    [man drink];
    [dog eat];
    [fish eat];
}

@end
