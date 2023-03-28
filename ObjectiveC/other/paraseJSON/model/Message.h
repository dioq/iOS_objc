//
//  Message.h
//  ObjectiveC
//
//  Created by hello on 2019/4/16.
//  Copyright © 2019 William. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Message : NSObject

@property(nonatomic,copy)NSString * sender;
@property(nonatomic,copy)NSString * receiver;
@property(nonatomic,copy)NSString * content;
@property(nonatomic,copy)NSString * data;

@end

NS_ASSUME_NONNULL_END
