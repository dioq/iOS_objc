//
//  YYPersonModel.m
//  ObjectiveC
//
//  Created by hello on 2019/4/16.
//  Copyright © 2019 William. All rights reserved.
//

#import "YYPersonModel.h"

@implementation YYPersonModel

//处理系统关键字
+ (NSDictionary<NSString *, id> *)modelCustomPropertyMapper
{
    return @{@"userid":@"id",
             @"des":@"description"
             };
}

@end
