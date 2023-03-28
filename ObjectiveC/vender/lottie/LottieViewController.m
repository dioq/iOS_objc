//
//  LottieViewController.m
//  ObjectiveC
//
//  Created by hello on 2019/4/7.
//  Copyright © 2019 William. All rights reserved.
//

#import "LottieViewController.h"
#import <Lottie/Lottie.h>

@interface LottieViewController ()

@property(nonatomic, strong) LOTAnimationView *animation;

@end

@implementation LottieViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (IBAction)start2:(UIButton *)sender {
    self.animation = [LOTAnimationView animationNamed:@"water-loading"];
    self.animation.frame = CGRectMake(10, 70, ScreenWidth - 20, ScreenWidth - 20);
    self.animation.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.view addSubview: self.animation];
    [self.animation playWithCompletion:^(BOOL animationFinished) {
        NSLog(@"animation has finished!  ==  %d", animationFinished);
        [self.animation removeFromSuperview];
    }];
}

- (IBAction)start3:(UIButton *)sender {
    // 获取文件路径
    //    NSString *path = [[NSBundle mainBundle] pathForResource:@"water-loading" ofType:@"json"];
    // 将文件数据化
    //    NSData *data = [[NSData alloc] initWithContentsOfFile:path];
    // 对数据进行JSON格式化并返回字典形式
    //    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    //NSData 转NSString
    //    NSString *str  = [[NSString alloc] initWithBytes:data.bytes length:data.length encoding:NSUTF8StringEncoding];
    
    //或者你可以用代码通过NSURL来加载，这种情况一般是将动画效果保存在服务器，动态加载。
    NSURL *url = [NSURL URLWithString:@""];
    self.animation = [[LOTAnimationView alloc] initWithContentsOfURL:url];
    self.animation.frame = CGRectMake(10, 70, ScreenWidth - 20, ScreenWidth - 20);
    self.animation.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.view addSubview: self.animation];
    [self.animation playWithCompletion:^(BOOL animationFinished) {
        NSLog(@"animation has finished!  ==  %d", animationFinished);
    }];
}

@end
