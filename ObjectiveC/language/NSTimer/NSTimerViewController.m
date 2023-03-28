//
//  NSTimerViewController.m
//  ObjectiveC
//
//  Created by Dio Brand on 2023/2/14.
//  Copyright © 2023 my. All rights reserved.
//

#import "NSTimerViewController.h"

@interface NSTimerViewController ()

@property (weak, nonatomic) IBOutlet UILabel *show;
@property (strong, nonatomic) NSTimer *timer;
@property(nonatomic,assign)int num;

@end

@implementation NSTimerViewController

-(NSTimer *)timer {
    if (!_timer)  {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(subtractTime) userInfo:nil repeats:YES];
    }
    return _timer;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (IBAction)startAction:(UIButton *)sender {
    //    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(subtractTime) userInfo:nil repeats:YES];
    // 启动定时器
    [self.timer fire];
}

- (IBAction)pauseAction:(UIButton *)sender {
    // 停止定时器
    [self.timer invalidate];
    self.timer = nil;
}

-(void)subtractTime {
    NSString *show_text = [NSString stringWithFormat:@"循环运行 第 %d 次", _num++];
    [self.show setText:show_text];
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
