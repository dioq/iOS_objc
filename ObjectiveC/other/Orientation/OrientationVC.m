//
//  OrientationVC.m
//  ObjectiveC
//
//  Created by hello on 2019/3/31.
//  Copyright © 2019 William. All rights reserved.
//

#import "OrientationVC.h"

@interface OrientationVC ()

@end

@implementation OrientationVC

- (void)viewDidLoad {
    [super viewDidLoad];
 
    /**
     *  开始生成 设备旋转 通知
     */
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    /**
     *  添加 设备旋转 通知
     *
     *  当监听到 UIDeviceOrientationDidChangeNotification 通知时，调用handleDeviceOrientationDidChange:方法
     *  @param handleDeviceOrientationDidChange: handleDeviceOrientationDidChange: description
     *
     *  @return return value description
     */
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleDeviceOrientationDidChange:)
                                                 name:UIDeviceOrientationDidChangeNotification
                                               object:nil
     ];
}

-(void)dealloc{
    /**
     *  销毁 设备旋转 通知
     *
     *  @return return value description
     */
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIDeviceOrientationDidChangeNotification
                                                  object:nil
     ];

    /**
     *  结束 设备旋转通知
     *
     *  @return return value description
     */
    [[UIDevice currentDevice]endGeneratingDeviceOrientationNotifications];

}

- (void)handleDeviceOrientationDidChange:(UIInterfaceOrientation)interfaceOrientation {
    //1.获取 当前设备 实例
    UIDevice *device = [UIDevice currentDevice] ;
    /**
     *  2.取得当前Device的方向，Device的方向类型为Integer
     *
     *  必须调用beginGeneratingDeviceOrientationNotifications方法后，此orientation属性才有效，否则一直是0。orientation用于判断设备的朝向，与应用UI方向无关
     *
     *  @param device.orientation
     *
     */
    switch (device.orientation) {
        case UIDeviceOrientationFaceUp:
            NSLog(@"屏幕朝上平躺");
            break;
        case UIDeviceOrientationFaceDown:
            NSLog(@"屏幕朝下平躺");
            break;
            //系統無法判斷目前Device的方向，有可能是斜置
        case UIDeviceOrientationUnknown:
            NSLog(@"未知方向");
            break;
        case UIDeviceOrientationLandscapeLeft:
            NSLog(@"屏幕向左横置");
            break;
        case UIDeviceOrientationLandscapeRight:
            NSLog(@"屏幕向右橫置");
            break;
        case UIDeviceOrientationPortrait:
            NSLog(@"屏幕直立");
            break;
        case UIDeviceOrientationPortraitUpsideDown:
            NSLog(@"屏幕直立，上下顛倒");
            break;
        default:
            NSLog(@"无法辨识");
            break;
    }
}

- (IBAction)showAction:(UIButton *)sender {
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    NSLog(@"orientation:%ld", (long)orientation);
    if (orientation == UIInterfaceOrientationPortrait || orientation == UIInterfaceOrientationPortraitUpsideDown) {
        NSLog(@"UIInterfaceOrientationPortrait || orientation == UIInterfaceOrientationPortraitUpsideDown");
    }else {
        NSLog(@"UIInterfaceOrientationPortrait");
    }
}

@end
