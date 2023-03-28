//
//  AudioPlayerVC.m
//  ObjectiveC
//
//  Created by hello on 2019/4/5.
//  Copyright © 2019 William. All rights reserved.
//

#import "AudioPlayerVC.h"
#import "AudioPlayer.h"

@interface AudioPlayerVC ()

@end

@implementation AudioPlayerVC

//播放
- (IBAction)goPlay:(UIButton *)sender {
    [[AudioPlayer sharedManager] play];
}
//停止
- (IBAction)goStop:(UIButton *)sender {
    [[AudioPlayer sharedManager] stop];
}
//暂停
- (IBAction)goPlause:(UIButton *)sender {
    [[AudioPlayer sharedManager] plause];
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (IBAction)play:(UIButton *)sender {
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"shot.wav" withExtension:nil];
    [[AudioPlayer sharedManager] play:url];
    
//    dispatch_queue_t queue = dispatch_get_main_queue();
//    dispatch_async(queue, ^{
//        NSLog(@"target is finished!");
//    });
}

- (IBAction)play2:(UIButton *)sender {
    NSString *urlStr = [[NSBundle mainBundle] pathForResource:@"bg_maze" ofType:@"mp3"];
    NSURL *url = [NSURL URLWithString:urlStr];
    [[AudioPlayer sharedManager] play:url];
}

@end
