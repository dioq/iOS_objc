//
//  ReceiveNotificationMsg.h
//  ObjectiveC
//
//  Created by Dio Brand on 2023/2/28.
//  Copyright © 2023 my. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NotificationVC.h"

NS_ASSUME_NONNULL_BEGIN

@interface ReceiveNotificationMsg : NSObject

@property(nonatomic,copy)NSString *aName;
@property(nonatomic,weak)NotificationVC *anObject;

-(void)addNotificationObserver;

@end

NS_ASSUME_NONNULL_END
