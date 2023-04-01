//
//  NotificationVC.m
//  ObjectiveC
//
//  Created by Dio Brand on 2023/2/28.
//  Copyright © 2023 my. All rights reserved.
//

#import "NotificationVC.h"
#import "ReceiveNotificationMsg.h"
#import "SimpleFouUse.h"

@interface NotificationVC ()

@property(nonatomic,strong)ReceiveNotificationMsg *recMsg;
@property(nonatomic,strong)SimpleFouUse *forUse;

@end

@implementation NotificationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.recMsg = [ReceiveNotificationMsg new];
    self.recMsg.aName = @"num001";
    self.recMsg.anObject = self;
    [self.recMsg addNotificationObserver];
    
    self.forUse = [SimpleFouUse new];
    [self.forUse addNotificationObserver];
}

- (IBAction)sendMsg:(UIButton *)sender {
    /*
     参数解析
     1、aName 消息通知的名字、
     2、anObject 消息发送者、
     3、aUserInfo 传递的数据
     */
    NSMutableDictionary *aUserInfo = [NSMutableDictionary dictionary];
    [aUserInfo setObject:@"深入学习" forKey:@"k1"];
    [aUserInfo setObject:@"研究每一个参数的作用" forKey:@"k2"];
    // 推送消息
    [[NSNotificationCenter defaultCenter] postNotificationName:self.recMsg.aName object:self userInfo:aUserInfo];
}

- (IBAction)forUse:(UIButton *)sender {
    NSString *aName = @"justforuse";
    NSMutableDictionary *aUserInfo = [NSMutableDictionary dictionary];
    [aUserInfo setObject:@"简单使用" forKey:@"k1"];
    [aUserInfo setObject:@"没有复杂的参数" forKey:@"k2"];
    // 推送消息
    [[NSNotificationCenter defaultCenter] postNotificationName:aName object:self userInfo:aUserInfo];
}

@end
