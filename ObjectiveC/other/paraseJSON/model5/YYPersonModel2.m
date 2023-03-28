//
//  YYPersonModel2.m
//  ObjectiveC
//
//  Created by hello on 2019/4/16.
//  Copyright © 2019 William. All rights reserved.
//

#import "YYPersonModel2.h"

@implementation YYPersonModel2

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
             @"personId":@"id",
             @"sex":@"sexDic.sex" // 声明sex字段在sexDic下的sex
             };
}

// 声明自定义类参数类型
+ (NSDictionary *)modelContainerPropertyGenericClass {
    // value使用[YYEatModel class]或YYEatModel.class或@"YYEatModel"没有区别
    return @{@"eats" : [YYEatModel class]};
}

@end
