//
//  BrowerViewController.m
//  ObjectiveC
//
//  Created by hello on 2019/7/9.
//  Copyright © 2019 William. All rights reserved.
//

#import "BrowerViewController.h"

@interface BrowerViewController ()

@end

@implementation BrowerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (IBAction)jumpAction:(UIButton *)sender {
    NSURL *url = [NSURL URLWithString:@"https://www.google.com"];
    BOOL whether = [[UIApplication sharedApplication] canOpenURL:url];
    if (whether == NO) {
        NSLog(@"浏览器不可跳转");
        return;
    }
    if (@available(iOS 10.0, *)) {
        NSDictionary *options = [NSDictionary dictionary];
//        NSDictionary *options = @{UIApplicationOpenURLOptionUniversalLinksOnly : @YES};
        /*
         有人会好奇，options这个字典是做什么用的呢？为什么传空呢？UIApplication 的头文件中列了一个可用在 options字典中的key: UIApplicationOpenURLOptionUniversalLinksOnly:并且默认布尔值是NO，使用时需要设置为YES才生效。然而UIApplicationOpenURLOptionUniversalLinksOnly并不是跳转到Safari浏览器，而是只能打开应用里配置好的有效通用URL。简而言之：我设置一个微信的URL，但是微信压根没有配置这个URL或者禁止访问这个URL再或者我手机上没有微信App，则回调都会返回失败，也并不会跳转到外部浏览器。
         **/
        [[UIApplication sharedApplication] openURL:url options:options completionHandler:^(BOOL success) {
            if (success == YES) {
                NSLog(@"跳转成功");
            }else{
                NSLog(@"跳转失败");
            }
        }];
    }else{
        [[UIApplication sharedApplication] openURL:url];
    }
}

@end
