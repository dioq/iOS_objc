//
//  ReceiveNotificationMsg.m
//  ObjectiveC
//
//  Created by Dio Brand on 2023/2/28.
//  Copyright © 2023 my. All rights reserved.
//

#import "ReceiveNotificationMsg.h"

@implementation ReceiveNotificationMsg

-(void)addNotificationObserver {
    /*
     参数解释：
     1、observer 观察者（不能为nil，通知中心会弱引用，ARC是iOS9之前是unsafe_unretained，iOS9及以后是weak，MRC是assign，所以这也是MRC不移除会crash，ARC不移除不会crash的原因，建议都要严格移除。）
     2、aSelector 收到消息后要执行的方法
     3、aName 消息通知的名字（如果name设置为nil，则表示接收所有消息）
     4、anObject 消息发送者（表示接收哪个发送者的通知，如果为nil，接收所有发送者的通知）
     
     注意：
     1、每次调用addObserver时，都会在通知中心重新注册一次，即使是同一对象监听同一个消息，而不是去覆盖原来的监听。这样，当通知中心转发某一消息时，如果同一对象多次注册了这个通知的观察者，则会收到多个通知。
     */
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveMsg:) name:self.aName object:self.anObject];
}

-(void)receiveMsg:(NSNotification *)noti {
    NSDictionary *info = [noti userInfo];
    NSString *v1 = [info objectForKey:@"k1"];
    NSString *v2 = [info objectForKey:@"k2"];
    NSLog(@"接收到通知");
    NSLog(@"k1 = %@, k2 = %@",v1,v2);
}

-(void)dealloc {
    // 移除self的全部通知
    //    [[NSNotificationCenter defaultCenter] removeObserver:self];
    // 移除 self 特定通知
    [[NSNotificationCenter defaultCenter] removeObserver:self name:self.aName object:self.anObject];
}

@end
