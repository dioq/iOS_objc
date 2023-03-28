//
//  MyAlertUtil.m
//  ObjectiveC
//
//  Created by Dio Brand on 2023/3/23.
//  Copyright © 2023 my. All rights reserved.
//

#import "MyAlertUtil.h"
#import <UIKit/UIKit.h>

@interface MyAlertUtil()

@property(nonatomic,strong)UIView *cover;

@end

@implementation MyAlertUtil

+ (instancetype)sharedManager {
    static MyAlertUtil *staticInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        staticInstance = [[super allocWithZone:NULL] init];
        //        staticInstance.somepro = [staticInstance getSomepro];
    });
    return staticInstance;
}

+(id)allocWithZone:(struct _NSZone *)zone{
    return [[self class] sharedManager];
}

-(id)copyWithZone:(struct _NSZone *)zone{
    return [[self class] sharedManager];
}

-(UIView *)cover {
    if (!_cover) {
        self.cover = [[UIView alloc] init];
        self.cover.backgroundColor =  [UIColor colorWithRed:0.84 green:0.74 blue:0.84 alpha:0.5];
        self.cover.frame = CGRectMake(0, 0, 150, 150);
        UIWindow *window =  [[[UIApplication sharedApplication] windows] objectAtIndex:0];
        self.cover.center = window.center;
        // 修改父控件为圆角
        self.cover.layer.cornerRadius = 10;
    }
    return _cover;
}

-(void)showTip:(NSString *)tip {
    [self disappear];
    dispatch_async(dispatch_get_main_queue(), ^{
        UIWindow *window =  [[[UIApplication sharedApplication] windows] objectAtIndex:0];
        [window addSubview:self.cover];
        
        // 2.创建菊花
        // 菊花有默认的尺寸
        // 注意: 虽然有默认的尺寸, 但是要想显示必须让菊花转起来
        UIActivityIndicatorView *activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleLarge];
        activity.center = CGPointMake(self.cover.frame.size.width * 0.5, 50);
        [self.cover addSubview:activity];
        [activity startAnimating];
        
        // 3.创建UILabel
        UILabel *label = [[UILabel alloc] init];
        //    label.backgroundColor = [UIColor purpleColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = tip;
        label.frame = CGRectMake(0, self.cover.frame.size.height - 80, self.cover.frame.size.width, 80);
        [self.cover addSubview:label];
    });
}

-(void)disappear {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.cover.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];// 删除所有子视图
        [self.cover removeFromSuperview];
    });
}

-(void)showTip:(NSString *)tip duration:(float)duration {
    [self disappear];
    [self showTip:tip];
    //在主线程延迟执行
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, duration * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [self disappear];
    });
}

@end
