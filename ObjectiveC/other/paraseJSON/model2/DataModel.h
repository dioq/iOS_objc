//
//  DataModel.h
//  ObjectiveC
//
//  Created by hello on 2019/4/16.
//  Copyright © 2019 William. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PhoneModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface DataModel : NSObject

@property(nonatomic, copy)NSString *name;
@property(nonatomic, assign)NSInteger age;
@property(nonatomic, strong)NSMutableArray<PhoneModel *> *phones;

-(DataModel *)initWithDict:(NSDictionary *)dict;

@end

NS_ASSUME_NONNULL_END
