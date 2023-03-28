//
//  AudioPlayer.m
//  ObjectiveC
//
//  Created by hello on 2019/4/5.
//  Copyright © 2019 William. All rights reserved.
//

#import "AudioPlayer.h"
#import <AVFoundation/AVFoundation.h>

static AudioPlayer *staticInstance = nil;

@interface AudioPlayer()<AVAudioPlayerDelegate>

@property(nonatomic, strong)AVAudioPlayer *player;

@end

@implementation AudioPlayer

+ (instancetype)sharedManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        staticInstance = [[self alloc] init];
    });
    return staticInstance;
}

-(void)play:(NSURL *)url {
    _player = [[AVAudioPlayer alloc]initWithContentsOfURL:url error:nil];
    //允许调整速率,此设置必须在prepareplay 之前
    _player.enableRate = YES;
    _player.delegate = self;
    _player.numberOfLoops = 0;//循环播放次数
    [_player prepareToPlay];
    [_player play];
}

//播放
-(void)play {
    [_player play];
}
//暂停
-(void)plause {
    [_player pause];
}
//停止
-(void)stop {
    [_player stop];
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    //flag 表示是否播放有错误
    if (flag) {
        NSLog(@"play completed successfully");
    }
}

@end
