
//
//  PhoneModel.m
//  ObjectiveC
//
//  Created by hello on 2019/4/16.
//  Copyright © 2019 William. All rights reserved.
//

#import "PhoneModel.h"

@implementation PhoneModel

-(PhoneModel *)initWithDict:(NSDictionary *)dict{
//    self.name = [dict objectForKey:@"name"];
//    self.number = [dict objectForKey:@"number"];
    /* 下面这行代码和上面这些代码功能等价, 是一次性给所有属性赋值 */
    [self setValuesForKeysWithDictionary:dict];
    
    return self;
}

//防崩
-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}

@end
