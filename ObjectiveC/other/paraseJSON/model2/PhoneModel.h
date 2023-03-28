//
//  PhoneModel.h
//  ObjectiveC
//
//  Created by hello on 2019/4/16.
//  Copyright © 2019 William. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface PhoneModel : NSObject

@property(nonatomic, copy)NSString *name;
@property(nonatomic, copy)NSString *number;

-(PhoneModel *)initWithDict:(NSDictionary *)dict;

@end

NS_ASSUME_NONNULL_END
