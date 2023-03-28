//
//  AVPlayerViewController.m
//  ObjectiveC
//
//  Created by hello on 2019/3/19.
//  Copyright © 2019 William. All rights reserved.
//

#import "AVPlayerViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface AVPlayerViewController ()<AVAudioPlayerDelegate>

@property(nonatomic, strong)AVAudioPlayer *player;

@end

@implementation AVPlayerViewController

- (AVAudioPlayer *)player{
    if (!_player) {
        // 1. 创建播放器对象
        // 虽然传递的参数是NSURL地址, 但是只支持播放本地文件, 远程音乐文件路径不支持
        NSURL *url = [[NSBundle mainBundle]URLForResource:@"back02.mp3" withExtension:nil];
        _player = [[AVAudioPlayer alloc]initWithContentsOfURL:url error:nil];
        
        //允许调整速率,此设置必须在prepareplay 之前
        _player.enableRate = YES;
        _player.delegate = self;
        _player.numberOfLoops = MAXBSIZE;//循环播放次数
        [_player prepareToPlay];
    }
    return _player;
}

- (void)viewDidLoad {
    [super viewDidLoad];

}

- (IBAction)startPlay:(UIButton *)sender {
    [self.player play];
}

- (IBAction)pause:(UIButton *)sender {
    [self.player pause];
}

- (IBAction)stop:(UIButton *)sender {
    [self.player stop];
    //为保证下次start时,从头播放.self.currentTime需要设置为0,因为系统不会重置.
    self.player.currentTime = 0;
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    //flag 表示是否播放有错误
    if (flag) {
        NSLog(@"play completed successfully");
    }
}

@end
