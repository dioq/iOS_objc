//
//  ContentModel.m
//  ObjectiveC
//
//  Created by hello on 2019/4/16.
//  Copyright © 2019 William. All rights reserved.
//

#import "ContentModel.h"

@implementation ContentModel

-(ContentModel *)initWithDict:(NSDictionary *)dict{
    [self setValuesForKeysWithDictionary:dict];
    
    return self;
}

//防崩 setValuesForKeysWithDictionary找不到json中value在属性中所对应的值时,走这个方法
-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}

@end
