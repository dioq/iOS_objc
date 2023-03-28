//
//  YYPersonModel2.h
//  ObjectiveC
//
//  Created by hello on 2019/4/16.
//  Copyright © 2019 William. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YYEatModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface YYPersonModel2 : NSObject

@property (strong, nonatomic) NSNumber *personId;
@property (copy,   nonatomic) NSString *name;
@property (assign, nonatomic) int age;
@property (copy,   nonatomic) NSString *sex;
@property (strong, nonatomic) NSArray *languages;
@property (strong, nonatomic) NSDictionary *job;
@property (strong, nonatomic) NSArray <YYEatModel *> *eats;

@end

NS_ASSUME_NONNULL_END
