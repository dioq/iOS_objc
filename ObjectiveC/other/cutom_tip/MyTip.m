//
//  MyTip.m
//  ObjectiveC
//
//  Created by zd on 17/7/2024.
//  Copyright © 2024 my. All rights reserved.
//

#import "MyTip.h"

@implementation MyTip

+ (instancetype)sharedManager {
    static MyTip *staticInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        staticInstance = [[super allocWithZone:NULL] init];
    });
    return staticInstance;
}

+(id)allocWithZone:(struct _NSZone *)zone{
    return [[self class] sharedManager];
}

-(id)copyWithZone:(struct _NSZone *)zone{
    return [[self class] sharedManager];
}

-(void)show:(NSString *)msg duration:(float)duration {
    __block UILabel *tip;
    dispatch_async(dispatch_get_main_queue(), ^{
        tip = [[UILabel alloc] init];
        UIWindow *window =  [[[UIApplication sharedApplication] windows] objectAtIndex:0];
        [window addSubview:tip];
        
        tip.text = msg;
        tip.numberOfLines = 0x0;
//        tip.preferredMaxLayoutWidth = 200;
        [tip sizeToFit];
        tip.frame = CGRectMake(0, 0, window.frame.size.width - 60, 100);
        tip.center = window.center;
        tip.layer.cornerRadius = 10;
        tip.alpha = 0.5;
    });
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, duration * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [tip removeFromSuperview];
    });
}

@end
