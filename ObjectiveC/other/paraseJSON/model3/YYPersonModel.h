//
//  YYPersonModel.h
//  ObjectiveC
//
//  Created by hello on 2019/4/16.
//  Copyright © 2019 William. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YYPersonModel : NSObject

@property (assign, nonatomic) long userid;
@property (copy,   nonatomic) NSString *des;
@property (copy,   nonatomic) NSString *name;
@property (assign, nonatomic) int age;
@property (copy,   nonatomic) NSString *sex;

@end

NS_ASSUME_NONNULL_END
