//
//  AppDelegate.m
//  ObjectiveC
//
//  Created by William on 2018/10/22.
//  Copyright © 2018年 William. All rights reserved.
//

#import "AppDelegate.h"
#import "MyTabBarController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


//告诉代理启动基本完成程序准备开始运行
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    if (@available(iOS 13,*)) {
        return YES;
    } else {
        self.window = [[UIWindow alloc]initWithFrame:[[UIScreen mainScreen] bounds]];
        self.window.backgroundColor = [UIColor whiteColor];
        [self.window makeKeyAndVisible];
        MyTabBarController *tabBarCtrl = [[MyTabBarController alloc] init];
        self.window.rootViewController = tabBarCtrl;
        return YES;
    }
}

//app间跳转
-(BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
    // 此处url的值就是APP_1 openURL的url
    NSString *paraStr = url.absoluteString;
    NSLog(@"%@", paraStr);
    return YES;
}


//告诉代理进程启动但还没进入状态保存
-(BOOL)application:(UIApplication*)application willFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    return YES;
}

//当应用程序将要进入非活动状态执行，在此期间，应用程序不接收消息或事件，比如来电话了
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}

//当应用程序进入活动状态执行，这个刚好跟上面那个方法相反
- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

//当程序被推送到后台的时候调用。所以要设置后台继续运行，则在这个函数里面设置即可
- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

//当程序从后台将要重新回到前台时候调用，这个刚好跟上面的那个方法相反。
- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}

//当程序将要退出时被调用，通常是用来保存数据和一些退出前的清理工作。
- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
