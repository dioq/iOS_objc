//
//  VideoViewController.m
//  ObjectiveC
//
//  Created by hello on 2018/11/23.
//  Copyright © 2018 William. All rights reserved.
//

#import "MyVideoViewController.h"
#import <AVFoundation/AVFoundation.h> //需要导入框架

@interface MyVideoViewController ()

@end

@implementation MyVideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self test];
}

// 播放mp4
- (void)test {
    //1.从mainBundle获取test.mp4的具体路径
    NSString *path = [[NSBundle mainBundle] pathForResource:@"test" ofType:@"mp4"];
    NSLog(@"%@", path);
    //2.文件的url
    NSURL *url = [NSURL fileURLWithPath:path];
    
    //3.根据url创建播放器(player本身不能显示视频)
    AVPlayer *player = [AVPlayer playerWithURL:url];
    
    //4.根据播放器创建一个视图播放的图层
    AVPlayerLayer *layer = [AVPlayerLayer playerLayerWithPlayer:player];
    //5.设置图层的大小
    layer.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    
    //6.添加到控制器的view的图层上面
    [self.view.layer addSublayer:layer];
    
    //7.开始播放
    [player play];
}

@end
