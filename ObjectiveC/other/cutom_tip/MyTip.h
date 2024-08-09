//
//  MyTip.h
//  ObjectiveC
//
//  Created by zd on 17/7/2024.
//  Copyright © 2024 my. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MyTip : UIView

+ (instancetype)sharedManager;

-(void)show:(NSString * _Nonnull)msg duration:(float)duration;

@end

NS_ASSUME_NONNULL_END
