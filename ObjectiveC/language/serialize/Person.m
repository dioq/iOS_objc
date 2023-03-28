//
//  Person.m
//  ObjectiveC
//
//  Created by hello on 2019/4/17.
//  Copyright © 2019 William. All rights reserved.
//

#import "Person.h"

@implementation Person

// 归档方法
-(void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeInteger:self.age forKey:@"age"];
    [aCoder encodeObject:self.gender forKey:@"gender"];
}
// 反归档方法
-(instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self != nil) {
        self.name = [aDecoder decodeObjectForKey:@"name"];
        self.age = [aDecoder decodeIntegerForKey:@"age"];
        self.gender = [aDecoder decodeObjectForKey:@"gender"];
    }
    return self;
}
//描述
-(NSString *)description {
    NSString *string = [NSString stringWithFormat:@"%@,%ld,%@",self.name,self.age,self.gender];
    return string;
}

- (nonnull id)copyWithZone:(nullable NSZone *)zone {
    return self;
}

// 支持NSSecureCoding
+(BOOL)supportsSecureCoding {
    return YES;
}

@end
