//
//  DelegateView.h
//  ObjectiveC
//
//  Created by hello on 2019/4/16.
//  Copyright © 2019 William. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TestDelegate2.h"

NS_ASSUME_NONNULL_BEGIN

@protocol TestDelegate <NSObject>

-(void)touch:(NSString *)str;

@end

@interface DelegateView : UIView

@property(nonatomic, weak)id<TestDelegate> myDelegate;
@property(nonatomic, weak)id<TestDelegate2> myDelegate2;

@end

NS_ASSUME_NONNULL_END
