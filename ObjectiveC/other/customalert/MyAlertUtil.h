//
//  MyAlertUtil.h
//  ObjectiveC
//
//  Created by Dio Brand on 2023/3/23.
//  Copyright © 2023 my. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MyAlertUtil : NSObject

+ (instancetype)sharedManager;

-(void)showTip:(NSString * _Nonnull)tip;
-(void)disappear;
-(void)showTip:(NSString * _Nonnull)tip duration:(float)duration;

@end

NS_ASSUME_NONNULL_END
