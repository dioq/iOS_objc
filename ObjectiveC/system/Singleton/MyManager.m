//
//  MyManager.m
//  ObjectiveC
//
//  Created by hello on 2018/12/2.
//  Copyright © 2018 William. All rights reserved.
//

#import "MyManager.h"

@interface MyManager()
//单例中可以定义一些属性
@property(nonatomic,copy)NSString *somepro;

@end

@implementation MyManager

+ (instancetype)sharedManager {
    static MyManager *staticInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        staticInstance = [[super allocWithZone:NULL] init];
        staticInstance.somepro = [staticInstance getSomepro];
    });
    return staticInstance;
}

+(id)allocWithZone:(struct _NSZone *)zone{
    return [[self class] sharedManager];
}

-(id)copyWithZone:(struct _NSZone *)zone{
    return [[self class] sharedManager];
}

-(NSString *)getSomepro {
    return @"单例中可以定义一些属性";
}

@end
