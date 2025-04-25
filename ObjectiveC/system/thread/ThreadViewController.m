//
//  ThreadViewController.m
//  ObjectiveC
//
//  Created by zd on 21/12/2023.
//  Copyright © 2023 my. All rights reserved.
//

#import "ThreadViewController.h"

@interface ThreadViewController ()

@end

@implementation ThreadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (IBAction)thread_sleep_act:(UIButton *)sender {
    NSTimeInterval interval = [[NSDate date] timeIntervalSince1970];
    NSLog(@"time1:%f",interval); //时间戳
    
    [NSThread sleepForTimeInterval:3];
    
    NSTimeInterval interval2 = [[NSDate date] timeIntervalSince1970];
    NSLog(@"time2:%f",interval2); //时间戳
}

- (IBAction)thread_creat_act:(UIButton *)sender {
    NSString *msg = @"thread_creat_act";
    NSThread *thread = [[NSThread currentThread] initWithTarget:self selector:@selector(newThread1:) object:msg];
    NSLog(@"%d:%@",__LINE__, [NSThread currentThread]);
    if ([NSThread isMainThread]) {
        NSLog(@"%d: main thread",__LINE__);
    }
    [thread start];
}

- (IBAction)thread_create_sys_act:(UIButton *)sender {
    NSString *msg = @"thread_create_sys_act";
    [self performSelectorInBackground:@selector(newThread1:) withObject:msg];
    NSLog(@"%d:%@",__LINE__, [NSThread currentThread]);
    if ([NSThread isMainThread]) {
        NSLog(@"%d: main thread",__LINE__);
    }
}

- (IBAction)back_main_thread_act:(UIButton *)sender {
    // 开辟子线程
    [self performSelectorInBackground:@selector(childThread) withObject:nil];
    NSLog(@"%d:%@",__LINE__, [NSThread currentThread]);
    if ([NSThread isMainThread]) {
        NSLog(@"%d: main thread",__LINE__);
    }
}

- (IBAction)OperationQueue_btn_action:(UIButton *)sender {
    /**
     NSInvocationOperation : 创建操作 ---> 创建队列 ---> 操作加入队列
     */
    //1:创建操作
    NSInvocationOperation *op = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(handleInvocation:) object:@"123"];
    //2:创建队列
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    //3:操作加入队列 --- 操作会在新的线程中
    [queue addOperation:op];
}

- (void)handleInvocation:(NSObject *)param{
    NSLog(@"%d --- %@ : %@",__LINE__,[NSThread currentThread], param);
}

-(void)newThread1:(NSString *)msg {
    NSLog(@"%d:%@ msg:%@",__LINE__, [NSThread currentThread],msg);
    [NSThread sleepForTimeInterval:5];
    if ([NSThread isMainThread]) {
        NSLog(@"%d: main thread",__LINE__);
    }
}

-(void)childThread {
    NSLog(@"%d:%@",__LINE__, [NSThread currentThread]);
    if ([NSThread isMainThread]) {
        NSLog(@"%d: main thread",__LINE__);
    }else {
        // 返回主线程
        [self performSelectorOnMainThread:@selector(mainThread) withObject:nil waitUntilDone:YES];
    }
}

-(void)mainThread {
    NSLog(@"%d:%@",__LINE__, [NSThread currentThread]);
    if ([NSThread isMainThread]) {
        NSLog(@"%d: main thread",__LINE__);
    }
}

@end
