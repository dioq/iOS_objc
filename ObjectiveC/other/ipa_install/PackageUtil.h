//
//  PackageUtil.h
//  Assistant
//
//  Created by zd on 22/12/2023.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface PackageUtil : NSObject

+ (instancetype)sharedManager;
-(void)install;

@end

NS_ASSUME_NONNULL_END
