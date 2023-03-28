//
//  Eat.h
//  ObjectiveC
//
//  Created by hello on 2019/4/16.
//  Copyright © 2019 William. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Drink.h"

NS_ASSUME_NONNULL_BEGIN

@protocol Eat <NSObject, Drink>//协议遵守其他协议

@required   //必须实现
-(void)eat;

@optional   //可选实现
-(void)watch;

@end

NS_ASSUME_NONNULL_END
