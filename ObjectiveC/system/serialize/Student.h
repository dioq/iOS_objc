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
@interface Student : NSObject<NSCopying,NSSecureCoding>

@property (nonatomic,copy) NSString *name;
@property (nonatomic,assign) NSInteger age;
@property (nonatomic,copy) NSString *gender;

- (NSString *)description;

@end

NS_ASSUME_NONNULL_END
