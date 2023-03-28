//
//  TestModel.m
//  ObjectiveC
//
//  Created by hello on 2019/4/16.
//  Copyright © 2019 William. All rights reserved.
//

#import "TestModel.h"

@implementation TestModel

-(TestModel *)initWithDict:(NSDictionary *)dict{
//    self.code = [[dict objectForKey:@"code"] integerValue];
//    self.msg = [dict objectForKey:@"msg"];
    /* 下面这行代码和上面这些代码功能等价, 是一次性给所有属性赋值 */
    [self setValuesForKeysWithDictionary:dict];
    
    //给模型赋值
    NSDictionary *contentDict = [dict objectForKey:@"content"];
    ContentModel *contentModel = [[ContentModel alloc] initWithDict:contentDict];
    self.content = contentModel;
    
    //为模型数组赋值
    self.data = [NSMutableArray array];
    NSArray *array = [dict objectForKey:@"data"];
    for (NSDictionary *dict2 in array) {
        DataModel *dtModel = [[DataModel alloc] initWithDict:dict2];
        [self.data addObject:dtModel];
    }
    return self;
}

//防崩 setValuesForKeysWithDictionary找不到json中value在属性中所对应的值时,走这个方法
-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}

@end
