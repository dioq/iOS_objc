//
//  DataModel.m
//  ObjectiveC
//
//  Created by hello on 2019/4/16.
//  Copyright © 2019 William. All rights reserved.
//

#import "DataModel.h"

@implementation DataModel

-(DataModel *)initWithDict:(NSDictionary *)dict{
//    self.name = [dict objectForKey:@"name"];
//    self.age = [[dict objectForKey:@"age"] integerValue];
    /* 下面这行代码和上面这些代码功能等价, 是一次性给所有属性赋值 */
    [self setValuesForKeysWithDictionary:dict];
    
    self.phones = [NSMutableArray array];
    NSArray *arary = [dict objectForKey:@"phones"];
    for (NSDictionary *dict2 in arary) {
        PhoneModel *phone = [[PhoneModel alloc] initWithDict:dict2];
        [self.phones addObject:phone];
    }
    return self;
}

//防崩
-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}

@end
