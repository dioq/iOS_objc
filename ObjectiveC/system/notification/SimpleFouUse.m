//
//  SimpleFouUse.m
//  ObjectiveC
//
//  Created by Dio Brand on 2023/2/28.
//  Copyright © 2023 my. All rights reserved.
//

#import "SimpleFouUse.h"

@implementation SimpleFouUse

-(void)addNotificationObserver {
    NSString *aName = @"justforuse";
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveMsg:) name:aName object:nil];
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
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
