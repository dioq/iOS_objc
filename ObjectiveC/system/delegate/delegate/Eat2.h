//
//  Eat2.h
//  ObjectiveC
//
//  Created by hello on 2019/4/16.
//  Copyright © 2019 William. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol Eat2 <NSObject>

@required   //必须实现
-(void)eat;

@optional   //可选实现
-(void)watch;

@end

NS_ASSUME_NONNULL_END
