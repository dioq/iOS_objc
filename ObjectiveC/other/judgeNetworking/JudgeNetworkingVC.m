//
//  judgeNetworkingVC.m
//  ObjectiveC
//
//  Created by hello on 2019/3/25.
//  Copyright © 2019 William. All rights reserved.
//

#import "JudgeNetworkingVC.h"
#import <AFNetworking.h>
#import "Reachability.h"
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTelephony/CTCarrier.h>
#import <SystemConfiguration/SystemConfiguration.h>
#import <netinet/in.h>

@interface JudgeNetworkingVC ()

@property (nonatomic, strong) Reachability *reachability;

@end

@implementation JudgeNetworkingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (IBAction)judeWhichNet:(UIButton *)sender {
    CTTelephonyNetworkInfo *info = [[CTTelephonyNetworkInfo alloc] init];
    CTCarrier *carrier = [info subscriberCellularProvider];
    //当前手机所属运营商名称
    NSString *mobile;
    //先判断有没有SIM卡，如果没有则不获取本机运营商
    if (!carrier.isoCountryCode) {
        mobile = @"无运营商";
    }else{
        mobile = [carrier carrierName];
    }
    NSLog(@"%@", mobile);
}

//SCNetworkReachabilityRef   注:Reachability就是封土装的SCNetworkReachabilityRef
/*
 使用SCNetworkReachabilityRef需要导入下面两个库
 #import <SystemConfiguration/SystemConfiguration.h>
 #import <netinet/in.h>
 **/
- (IBAction)SCNetwork:(UIButton *)sender {
    BOOL isConnection = [self isConnectionAvailable];
    if (isConnection) {
        NSLog(@"网络正常连接");
    }else{
        NSLog(@"网络不可用");
    }
}
- (BOOL)isConnectionAvailable {
    //创建零地址，0.0.0.0的地址表示查询本机的网络连接状态
    struct sockaddr_in zeroAddress;
    bzero(&zeroAddress, sizeof(zeroAddress));
    zeroAddress.sin_len = sizeof(zeroAddress);
    zeroAddress.sin_family = AF_INET;
    
    // Recover reachability flags
    SCNetworkReachabilityRef defaultRouteReachability = SCNetworkReachabilityCreateWithAddress(NULL, (struct sockaddr *)&zeroAddress);
    SCNetworkReachabilityFlags flags;
    //获得连接的标志
    BOOL didRetrieveFlags = SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags);
    CFRelease(defaultRouteReachability);
    //如果不能获取连接标志，则不能连接网络，直接返回
    if (!didRetrieveFlags) {
        NSLog(@"Error. Could not recover network reachability flags");
        return NO;
    }
    //根据获得的连接标志进行判断
    BOOL isReachable = ((flags & kSCNetworkFlagsReachable) != 0);
    BOOL needsConnection = ((flags & kSCNetworkFlagsConnectionRequired) != 0);
    return (isReachable && !needsConnection) ? YES : NO;
}

//当用户为手机流量时，判断具体网络类型
- (IBAction)sysAPI:(UIButton *)sender {
    CTTelephonyNetworkInfo *info = [CTTelephonyNetworkInfo new];
    NSString *networkType = @"";
    if ([info respondsToSelector:@selector(currentRadioAccessTechnology)]) {
        NSString *currentStatus = info.currentRadioAccessTechnology;
        NSArray *network2G = @[CTRadioAccessTechnologyGPRS, CTRadioAccessTechnologyEdge, CTRadioAccessTechnologyCDMA1x];
        NSArray *network3G = @[CTRadioAccessTechnologyWCDMA, CTRadioAccessTechnologyHSDPA, CTRadioAccessTechnologyHSUPA, CTRadioAccessTechnologyCDMAEVDORev0, CTRadioAccessTechnologyCDMAEVDORevA, CTRadioAccessTechnologyCDMAEVDORevB, CTRadioAccessTechnologyeHRPD];
        NSArray *network4G = @[CTRadioAccessTechnologyLTE];
        
        if ([network2G containsObject:currentStatus]) {
            networkType = @"2G";
        }else if ([network3G containsObject:currentStatus]) {
            networkType = @"3G";
        }else if ([network4G containsObject:currentStatus]){
            networkType = @"4G";
        }else {
            networkType = @"未知网络";
        }
    }
    NSLog(@"%@", networkType);
}

//启动网络监视
- (IBAction)reachability:(UIButton *)sender {
    // 监听通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
    //初始化监听控件
    self.reachability = [Reachability reachabilityForInternetConnection];
    // 开始监听
    [self.reachability startNotifier];
    NetworkStatus netStatus = [self.reachability currentReachabilityStatus];
    NSLog(@"刚打开网络监听时,网络状态未变化,打印一下网络状态:");
    switch (netStatus) {
        case NotReachable:
            NSLog(@"first----------网络有问题");
            break;
        case ReachableViaWWAN:
            NSLog(@"first----------蜂窝网络");
            break;
        case ReachableViaWiFi:
            NSLog(@"first----------连接wifi");
            break;
        default:
            break;
    }
}

/*!
 * Called by Reachability whenever status changes.
 */
- (void) reachabilityChanged:(NSNotification *)note {
    Reachability* curReach = [note object];
    NSParameterAssert([curReach isKindOfClass:[Reachability class]]);
    
    // 自己获取网络
    NetworkStatus netStatus = [curReach currentReachabilityStatus];
    switch (netStatus) {
        case NotReachable:
            NSLog(@"changed----------网络有问题");
            break;
        case ReachableViaWWAN:
            NSLog(@"changed----------蜂窝网络");
            break;
        case ReachableViaWiFi:
            NSLog(@"changed----------连接wifi");
            break;
        default:
            NSLog(@"不明原因");
            break;
    }
}
//controller销毁时移出通知
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kReachabilityChangedNotification object:nil];
}


- (IBAction)judgeAF:(UIButton *)sender {
    //1.创建网络监听管理者
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    //2.监听网络状态的改变
    /*
     AFNetworkReachabilityStatusUnknown             = 未知
     AFNetworkReachabilityStatusNotReachable        = 没有网络
     AFNetworkReachabilityStatusReachableViaWWAN    = 3G/4G
     AFNetworkReachabilityStatusReachableViaWiFi    = WIFI
     */
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        // 当网络状态发生改变的时候调用这个block
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:
                NSLog(@"未知");
                break;
            case AFNetworkReachabilityStatusNotReachable:
                NSLog(@"没有网络");
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
                NSLog(@"3G/4G");
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
                NSLog(@"WIFI");
                break;
            default:
                break;
        }
    }];
    
    //3.开始监听
    [manager startMonitoring];
    BOOL isConnecting = [manager isReachable];
    if (isConnecting) {
        NSLog(@"网络通畅");
    }else{
        NSLog(@"网络不通畅");
    }
    NSLog(@"the last line! ==== go here!");
}

@end
