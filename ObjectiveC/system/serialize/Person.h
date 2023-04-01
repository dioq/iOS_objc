//
//  Person.h
//  ObjectiveC
//
//  Created by hello on 2019/4/17.
//  Copyright © 2019 William. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

// 给自定义类归档，首先要遵守NSCoding协议。
@interface Person : NSObject<NSCopying,NSSecureCoding>

@property (nonatomic,strong) NSString *name;
@property (nonatomic,assign) NSInteger age;
@property (nonatomic,strong) NSString *gender;

- (NSString *)description;

@end

NS_ASSUME_NONNULL_END
