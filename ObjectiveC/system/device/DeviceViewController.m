//
//  DeviceViewController.m
//  ObjectiveC
//
//  Created by hello on 2019/4/25.
//  Copyright © 2019 William. All rights reserved.
//

#import "DeviceViewController.h"
#import <sys/utsname.h>

/*
 iPhone机型相关信息
 https://www.theiphonewiki.com/wiki/Models
 **/
@interface DeviceViewController ()

@end

@implementation DeviceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //手机系统
    NSString *osType = [[UIDevice currentDevice] systemName];
    NSLog(@"手机系统:%@", osType);
    if (@available(iOS 10, *)) {
        NSLog(@"系统版本大于等于10");
    }
    //手机系统版本
    NSString *osVersion = [[UIDevice currentDevice] systemVersion];
    NSLog(@"手机系统版本:%@", osVersion);
    //手机类型
    NSString* phoneModel = [self iplatform];//方法在下面
    NSLog(@"手机类型:%@", phoneModel);
    //电池电量
    CGFloat batteryLevel = [[UIDevice currentDevice] batteryLevel];
    NSLog(@"电池电量:%f", batteryLevel);
}

- (NSString *)iplatform {
    struct utsname systemInfo;
    uname(&systemInfo);
    
    NSString *platform = [NSString stringWithCString:systemInfo.machine encoding:NSASCIIStringEncoding];
    
    if([platform  isEqualToString:@"iPhone1,1"])  return @"iPhone 2G";
    
    if([platform  isEqualToString:@"iPhone1,2"])  return @"iPhone 3G";
    
    if([platform  isEqualToString:@"iPhone2,1"])  return @"iPhone 3GS";
    
    if([platform  isEqualToString:@"iPhone3,1"])  return @"iPhone 4";
    
    if([platform  isEqualToString:@"iPhone3,2"])  return @"iPhone 4";
    
    if([platform  isEqualToString:@"iPhone3,3"])  return @"iPhone 4";
    
    if([platform  isEqualToString:@"iPhone4,1"])  return @"iPhone 4S";
    
    if([platform  isEqualToString:@"iPhone5,1"])  return @"iPhone 5";
    
    if([platform  isEqualToString:@"iPhone5,2"])  return @"iPhone 5";
    
    if([platform  isEqualToString:@"iPhone5,3"])  return @"iPhone 5c";
    
    if([platform  isEqualToString:@"iPhone5,4"])  return @"iPhone 5c";
    
    if([platform  isEqualToString:@"iPhone6,1"])  return @"iPhone 5s";
    
    if([platform  isEqualToString:@"iPhone6,2"])  return @"iPhone 5s";
    
    if([platform  isEqualToString:@"iPhone7,1"])  return @"iPhone 6 Plus";
    
    if([platform  isEqualToString:@"iPhone7,2"])  return @"iPhone 6";
    
    if([platform  isEqualToString:@"iPhone8,1"])  return @"iPhone 6s";
    
    if([platform  isEqualToString:@"iPhone8,2"])  return @"iPhone 6s Plus";
    
    if([platform  isEqualToString:@"iPhone8,4"])  return @"iPhone SE";
    
    if([platform  isEqualToString:@"iPhone9,1"])  return @"iPhone 7";
    
    if([platform  isEqualToString:@"iPhone9,2"])  return @"iPhone 7 Plus";
    
    if([platform  isEqualToString:@"iPhone10,1"]) return @"iPhone 8";
    
    if([platform  isEqualToString:@"iPhone10,4"]) return @"iPhone 8";
    
    if([platform  isEqualToString:@"iPhone10,2"]) return @"iPhone 8 Plus";
    
    if([platform  isEqualToString:@"iPhone10,5"]) return @"iPhone 8 Plus";
    
    if([platform  isEqualToString:@"iPhone10,3"]) return @"iPhone X";
    
    if([platform  isEqualToString:@"iPhone10,6"]) return @"iPhone X";
    
    if([platform  isEqualToString:@"iPhone11,8"]) return @"iPhone XR";
    
    if([platform  isEqualToString:@"iPhone11,2"]) return @"iPhone XS";
    
    if([platform  isEqualToString:@"iPhone11,4"]) return @"iPhone XS Max";
    
    if([platform  isEqualToString:@"iPhone11,6"]) return @"iPhone XS Max";
    
    if ([platform isEqualToString:@"iPod1,1"])   return @"iPod Touch 1G";
    
    if ([platform isEqualToString:@"iPod2,1"])   return @"iPod Touch 2G";
    
    if ([platform isEqualToString:@"iPod3,1"])   return @"iPod Touch 3G";
    
    if ([platform isEqualToString:@"iPod4,1"])   return @"iPod Touch 4G";
    
    if ([platform isEqualToString:@"iPod5,1"])   return @"iPod Touch 5G";
    
    if ([platform isEqualToString:@"iPad1,1"])   return @"iPad 1G";
    
    if ([platform isEqualToString:@"iPad2,1"])   return @"iPad 2";
    
    if ([platform isEqualToString:@"iPad2,2"])   return @"iPad 2";
    
    if ([platform isEqualToString:@"iPad2,3"])   return @"iPad 2";
    
    if ([platform isEqualToString:@"iPad2,4"])   return @"iPad 2";
    
    if ([platform isEqualToString:@"iPad2,5"])   return @"iPad Mini 1G";
    
    if ([platform isEqualToString:@"iPad2,6"])   return @"iPad Mini 1G";
    
    if ([platform isEqualToString:@"iPad2,7"])   return @"iPad Mini 1G";
    
    if ([platform isEqualToString:@"iPad3,1"])   return @"iPad 3";
    
    if ([platform isEqualToString:@"iPad3,2"])   return @"iPad 3";
    
    if ([platform isEqualToString:@"iPad3,3"])   return @"iPad 3";
    
    if ([platform isEqualToString:@"iPad3,4"])   return @"iPad 4";
    
    if ([platform isEqualToString:@"iPad3,5"])   return @"iPad 4";
    
    if ([platform isEqualToString:@"iPad3,6"])   return @"iPad 4";
    
    if ([platform isEqualToString:@"iPad4,1"])   return @"iPad Air";
    
    if ([platform isEqualToString:@"iPad4,2"])   return @"iPad Air";
    
    if ([platform isEqualToString:@"iPad4,3"])   return @"iPad Air";
    
    if ([platform isEqualToString:@"iPad4,4"])   return @"iPad Mini 2G";
    
    if ([platform isEqualToString:@"iPad4,5"])   return @"iPad Mini 2G";
    
    if ([platform isEqualToString:@"iPad4,6"])   return @"iPad Mini 2G";
    
    if ([platform isEqualToString:@"i386"])      return @"iPhone Simulator";
    
    if ([platform isEqualToString:@"x86_64"])    return @"iPhone Simulator";
    
    return platform;
}

@end
