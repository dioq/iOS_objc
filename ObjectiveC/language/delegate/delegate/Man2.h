//
//  Man2.h
//  ObjectiveC
//
//  Created by hello on 2019/4/16.
//  Copyright © 2019 William. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Eat2.h"

NS_ASSUME_NONNULL_BEGIN

@interface Man2 : NSObject

@property(nonatomic, weak) id<Eat2> myDelegate;

@end

NS_ASSUME_NONNULL_END
