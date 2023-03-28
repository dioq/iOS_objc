//
//  SliderViewController.m
//  ObjectiveC
//
//  Created by Dio Brand on 2022/8/19.
//  Copyright © 2022 my. All rights reserved.
//

#import "SliderViewController.h"

@interface SliderViewController ()

@end

@implementation SliderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //初始化方法
    UISlider *slider = [[UISlider alloc] initWithFrame:CGRectMake(30, 100, 300, 30)];
    [self.view addSubview:slider];
    
    //指定附加到滑块断点的值,最小值表示滑块的前端,最大值表示滑块的尾端
    slider.maximumValue = 100;
    slider.minimumValue = 0;
    
    //设置滑块的初始值,该值必须位于最大值和最小值之间
    slider.value = 50;
    //设置滑块滑动到最小值时的图像，如果空白，则不显示图像
    slider.minimumValueImage = [UIImage imageNamed:@"tab_mine_50"];
    //设置滑块滑动到最大值时的图像，如果空白，则不显示图像
    slider.maximumValueImage = [UIImage imageNamed:@"tab_team_50"];
    //设置最小值前端滑杆的颜色
    slider.minimumTrackTintColor = [UIColor yellowColor];
//    设置最大值右端的滑杆的颜色
    slider.maximumTrackTintColor = [UIColor greenColor];
    //设置滑块拇指的颜色
//    slider.thumbTintColor = [UIColor redColor];
    //注意这个属性：如果你没有设置滑块的图片，那个这个属性将只会改变已划过一段线条的颜色，不会改变滑块的颜色，如果你设置了滑块的图片，又设置了这个属性，那么滑块的图片将不显示，滑块的颜色会改变（IOS7）
    
    //设置滑块值的更改是否是连续事件,该值默认为YES
    [slider setContinuous:NO];
    //设置滑块划过部分的线条图案，要让该属性生效，不能设置minimumTrackTintColor属性
//    [slider setMinimumTrackImage:[UIImage imageNamed:@"mainImage_cn"] forState:(UIControlStateNormal)];
    //设置滑块未划过部分的线条图案，要让该属性生效，不能设置maximumTrackTintColor属性
//    [slider setMaximumTrackImage:[UIImage imageNamed:@"mainImage_tr"] forState:(UIControlStateNormal)];
    //设置滑块的图片,要使该属性生效，则不能设置ThumbImage属性
    [slider setThumbImage:[UIImage imageNamed:@"tab_home_50"] forState:(UIControlStateNormal)];
    //添加触发事件
    [slider addTarget:self action:@selector(sliderValurChanged:) forControlEvents:(UIControlEventValueChanged)];
}

// 获取滑块数值
- (void)sliderValurChanged:(UISlider*)sender {
    NSLog(@"%f",sender.value);
}

@end
