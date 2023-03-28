//
//  SpeechViewController.m
//  ObjectiveC
//
//  Created by hello on 2019/4/4.
//  Copyright © 2019 William. All rights reserved.
//

#import "SpeechViewController.h"
#import<AVFoundation/AVFoundation.h>

@interface SpeechViewController ()

@property (weak, nonatomic) IBOutlet UITextView *myTextView;

@end

@implementation SpeechViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (IBAction)toSpeech:(UIButton *)sender {
    AVSpeechSynthesizer * synthesizer = [[AVSpeechSynthesizer alloc] init];//语音合成器
    
    if ([self.myTextView.text isEqual: @""]) {
        return;
    }
    AVSpeechUtterance *utterance = [[AVSpeechUtterance alloc] initWithString:self.myTextView.text];//说话
    utterance.voice = [AVSpeechSynthesisVoice voiceWithLanguage:@"zh-CN"];//发音
    utterance.rate = 0.5f;//速率
    utterance.pitchMultiplier = 0.8f;//音调
    utterance.postUtteranceDelay = 0.1f;//延迟
    [synthesizer speakUtterance:utterance];//添加到语音合成器，不会等待，程序继续执行 此时语音开始合成
    
    NSString *text2 = [NSString stringWithFormat:@"再重复一次,%@", self.myTextView.text];
    AVSpeechUtterance *utterance2 = [[AVSpeechUtterance alloc] initWithString:text2];
    utterance2.voice = [AVSpeechSynthesisVoice voiceWithLanguage:@"zh-CN"];
    utterance2.rate = 0.5f;
    utterance2.pitchMultiplier = 0.8f;
    utterance2.postUtteranceDelay = 0.1f;
    [synthesizer speakUtterance:utterance2];//此时会等第一句结束后才会播放这句。程序不会阻塞。
}

- (IBAction)toWords:(UIButton *)sender {

}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.myTextView resignFirstResponder];
}

@end
