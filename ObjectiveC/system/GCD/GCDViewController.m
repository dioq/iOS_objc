//
//  GCDViewController.m
//  ObjectiveC
//
//  Created by hello on 2019/3/28.
//  Copyright © 2019 William. All rights reserved.
//

#import "GCDViewController.h"

@interface GCDViewController ()

@end

@implementation GCDViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (IBAction)delay:(UIButton *)sender {
    NSInteger time = 3;
    dispatch_queue_t mainQueue = dispatch_get_main_queue();
    //在主线程延迟执行
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, time * NSEC_PER_SEC), mainQueue, ^{
        NSLog(@"在主线程执行: 3秒后执行这个方法");
    });
    
    //在主线程中异步、立即执行,一般用在子线程中任务完成更新UI
    dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"回调主线程");
    });
    
    dispatch_queue_t globalQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0);
    //在子线程执行
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, time * NSEC_PER_SEC), globalQueue, ^{
        NSLog(@"在子线程执行: 3秒后执行这个方法");
    });
}

//异步
- (IBAction)asynchronousAction:(UIButton *)sender {
    // 异步 创建一个新线程执行任务,当前线程不被阻塞
    dispatch_queue_t queue = dispatch_queue_create("a different name", DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(queue, ^{
        [NSThread sleepForTimeInterval:6];
        NSLog(@"%d out:    %@",__LINE__, [NSThread currentThread]);
        NSLog(@"%d target is finished!",__LINE__);
    });
    NSLog(@"%d out:    %@",__LINE__, [NSThread currentThread]);
    NSLog(@"%d ==== go here!",__LINE__);
    
    // 常用全局并发队列实现异步
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        [NSThread sleepForTimeInterval:6];
        NSLog(@"%d out:    %@",__LINE__, [NSThread currentThread]);
        NSLog(@"%d target is finished!",__LINE__);
    });
    NSLog(@"%d out:    %@",__LINE__, [NSThread currentThread]);
    NSLog(@"%d ==== go here!",__LINE__);
}

//同步
- (IBAction)synchronousAction:(UIButton *)sender {
    // 同步 在当前线程中执行任务,线程会被阻塞
    dispatch_queue_t queue = dispatch_queue_create("a different name", DISPATCH_QUEUE_CONCURRENT);
    dispatch_sync(queue, ^{
        [NSThread sleepForTimeInterval:6];
        NSLog(@"out:    %@", [NSThread currentThread]);
        NSLog(@"target is finished!");
    });
    NSLog(@"out:    %@", [NSThread currentThread]);
    NSLog(@"the last line! ==== go here!");
}

//串行队列
- (IBAction)SerialAction:(UIButton *)sender {
    /*
     串行队列 使用1个线程执行队列中的任务
     **/
    //创建一个串行队列
    dispatch_queue_t queue = dispatch_queue_create("serial", NULL);
    dispatch_async(queue, ^{
        [NSThread sleepForTimeInterval:3];
        NSLog(@"%@ --> target1:串行队列",[NSThread currentThread]);
    });
    dispatch_async(queue, ^{
        [NSThread sleepForTimeInterval:6];
        NSLog(@"%@ --> target2:串行队列",[NSThread currentThread]);
    });
    dispatch_async(queue, ^{
        [NSThread sleepForTimeInterval:4];
        NSLog(@"%@ --> target3:串行队列",[NSThread currentThread]);
    });
    dispatch_async(queue, ^{
        [NSThread sleepForTimeInterval:2];
        NSLog(@"%@ --> target4:串行队列",[NSThread currentThread]);
    });
    NSLog(@"the last line! ==== go here!");
}

//并行队列
- (IBAction)ConcurrentAction:(UIButton *)sender {
    //创建一个并行队列  使用多个线程执行队列中的任务
    dispatch_queue_t queue = dispatch_queue_create("concurrent", DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(queue, ^{
        [NSThread sleepForTimeInterval:3];
        NSLog(@"%@ --> target1:并发队列",[NSThread currentThread]);
    });
    dispatch_async(queue, ^{
        [NSThread sleepForTimeInterval:6];
        NSLog(@"%@ --> target2:并发队列",[NSThread currentThread]);
    });
    dispatch_async(queue, ^{
        [NSThread sleepForTimeInterval:4];
        NSLog(@"%@ --> target3:并发队列",[NSThread currentThread]);
    });
    dispatch_async(queue, ^{
        [NSThread sleepForTimeInterval:2];
        NSLog(@"%@ --> target4:并发队列",[NSThread currentThread]);
    });
    NSLog(@"the last line! ==== go here!");
}

- (IBAction)notify2Action:(UIButton *)sender {
    //创建一个并发队列
    //    dispatch_queue_t queue = dispatch_queue_create("a different name", DISPATCH_QUEUE_CONCURRENT);
    //创建一个队列组
    dispatch_group_t group = dispatch_group_create();
    //获取全局并发队列
    dispatch_queue_t global_queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0);
    
    //任务1
    //    dispatch_group_async(group, queue, ^{
    dispatch_group_enter(group);
    dispatch_async(global_queue, ^{
        [NSThread sleepForTimeInterval:10];
        NSLog(@"target1 is finished!");
        dispatch_group_leave(group);
    });
    //    });
    //任务2
    dispatch_group_enter(group);
    //    dispatch_group_async(group, queue, ^{
    dispatch_async(global_queue, ^{
        [NSThread sleepForTimeInterval:6];
        NSLog(@"target2 is finished!");
        dispatch_group_leave(group);
    });
    //    });
    //任务3
    //    dispatch_group_async(group, queue, ^{
    dispatch_async(global_queue, ^{
        dispatch_group_enter(group);
        [NSThread sleepForTimeInterval:3];
        NSLog(@"target3 is finished!");
        dispatch_group_leave(group);
    });
    //    });
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        NSLog(@"done");
    });
    /*
     dispatch_group_wait 返回0表示: 不超时所有任务完成
     其他表示: 已经超时任务还在进行
     **/
    //    long result = dispatch_group_wait(group, DISPATCH_TIME_FOREVER); //表示永久等待下去
    long result = dispatch_group_wait(group, dispatch_time(DISPATCH_TIME_NOW, 15 * NSEC_PER_SEC));
    if (result==0) {
        NSLog(@"all tasks has finished");
    }else{
        NSLog(@"Overtime, not all tasks completed");
    }
    NSLog(@"the last line! ==== go here!");
}

- (IBAction)notifyAction:(UIButton *)sender {
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0);
    dispatch_group_t group = dispatch_group_create();
    dispatch_group_async(group, queue, ^{
        [NSThread sleepForTimeInterval:8];
        NSLog(@"blk0");
    });
    dispatch_group_async(group, queue, ^{
        [NSThread sleepForTimeInterval:6];
        NSLog(@"blk1");
    });
    dispatch_group_async(group, queue, ^{
        [NSThread sleepForTimeInterval:3];
        NSLog(@"blk2");
    });
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        NSLog(@"done");
    });
    /*
     dispatch_group_wait 返回0表示: 不超时所有任务完成
     其他表示: 已经超时任务还在进行
     **/
    //    long result = dispatch_group_wait(group, DISPATCH_TIME_FOREVER); //表示永久等待下去
    long result = dispatch_group_wait(group, dispatch_time(DISPATCH_TIME_NOW, 5 * NSEC_PER_SEC));
    if (result == 0) {
        NSLog(@"all tasks has finished");
    }else{
        NSLog(@"Overtime, not all tasks completed");
    }
    NSLog(@"the last line! ==== go here!");
}

@end
