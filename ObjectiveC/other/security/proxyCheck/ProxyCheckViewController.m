//
//  ProxyCheckViewController.m
//  ObjectiveC
//
//  Created by Dio Brand on 2022/11/12.
//  Copyright © 2022 my. All rights reserved.
//

#import "ProxyCheckViewController.h"

@interface ProxyCheckViewController ()

@property (weak, nonatomic) IBOutlet UILabel *show;

@end

@implementation ProxyCheckViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"抓包代理检测";
}

- (IBAction)proxyCheck:(UIButton *)sender {
    NSString *tip;
    if([self checkProxySetting]) {
        tip = @"检测到抓包";
    }else{
        tip = @"没有抓包代理";
    }
    [self.show setText:tip];
}

// 判断是否设置了代理
- (BOOL)checkProxySetting {
    // 获取当前系统代理配置
    NSDictionary *proxySettings = (__bridge NSDictionary *)(CFNetworkCopySystemProxySettings());
    // 获取代理的信息 - url一般都填baidu
    NSURL *url = [NSURL URLWithString:@"https://www.baidu.com"];
    NSArray *proxies = (__bridge NSArray *)(CFNetworkCopyProxiesForURL((__bridge CFURLRef)(url), (__bridge CFDictionaryRef)(proxySettings)));
    
    if (proxies.count > 0) {
        NSString *proxyType = [proxies.firstObject objectForKey:(NSString *)kCFProxyTypeKey];
        if (![proxyType isEqualToString:(__bridge NSString *)kCFProxyTypeNone]) {
            for (int i = 0; i < proxies.count; i++) {
                NSDictionary *settings = proxies[i];
                if (i == 0) {
                    NSLog(@"---------------代理配置---------------");
                }
                NSLog(@"host: %@", [settings objectForKey:(NSString *)kCFProxyHostNameKey]);
                NSLog(@"port: %@", [settings objectForKey:(NSString *)kCFProxyPortNumberKey]);
                NSLog(@"type: %@", [settings objectForKey:(NSString *)kCFProxyTypeKey]);
                if (i == proxies.count - 1) {
                    NSLog(@"-------------------------------------");
                }
                else {
                    NSLog(@"---------------------------");
                }
            }
            return YES;
        }
    }
    return NO;
}

@end
