//
//  ColorViewController.m
//  ObjectiveC
//
//  Created by hello on 2019/3/3.
//  Copyright © 2019 William. All rights reserved.
//

#import "ColorViewController.h"
#import <HRColorPickerView.h>
#import <HRColorMapView.h>
#import <HRBrightnessSlider.h>

@interface ColorViewController ()

@property(nonatomic, strong)HRColorPickerView *colorPickerView;
@property(nonatomic, strong)UIColor *color;

@end

@implementation ColorViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.colorPickerView = [[HRColorPickerView alloc] initWithFrame:CGRectMake(10, Common.getTopHeight + 10, ScreenWidth - 20, ScreenHeight - Common.getTopHeight - 20)];
    self.colorPickerView.color = self.color;
    [self.colorPickerView addTarget:self
                             action:@selector(action:)
                   forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:self.colorPickerView];
    
    HRColorMapView *colorMapView = [[HRColorMapView alloc] init];
    colorMapView.saturationUpperLimit = @1;
    colorMapView.tileSize = @1;
    [self.colorPickerView addSubview:colorMapView];
    self.colorPickerView.colorMapView = colorMapView;
    
    HRBrightnessSlider *slider = [[HRBrightnessSlider alloc] init];
    slider.brightnessLowerLimit = @0;
    [self.colorPickerView addSubview:slider];
    self.colorPickerView.brightnessSlider = slider;
}

-(void)action:(HRColorPickerView *)sender {
    self.color = sender.backgroundColor;
    NSLog(@"%@", self.color);
}


@end
