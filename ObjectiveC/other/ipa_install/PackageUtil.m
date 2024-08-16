//
//  PackageUtil.m
//  Assistant
//
//  Created by zd on 22/12/2023.
//

#import "PackageUtil.h"
#include "local_server.h"

static NSString *ipa_name = @"WeChat.ipa";

@implementation PackageUtil

+ (instancetype)sharedManager {
    static PackageUtil *staticInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        staticInstance = [[super allocWithZone:NULL] init];
        [staticInstance initConfig];
    });
    return staticInstance;
}

-(void)initConfig {
    // 在子进程中启动服务器
    [self performSelectorInBackground:@selector(start_server) withObject:nil];
}

-(void)start_server {
    server_start();
    NSLog(@"log ---> %s server start",__FUNCTION__);
}

-(void)install {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES) firstObject];
    NSString *path = [NSString stringWithFormat:@"%@/%@",docDir,ipa_name];
    if (![fileManager fileExistsAtPath:path]) {
        NSLog(@"ipa包不存在!");
        return;
    }
    NSLog(@"log ---> %s:%d ipa path:\n%@",__FUNCTION__,__LINE__,path);
    
    init_property([path UTF8String], [ipa_name UTF8String]);
    
    //http://guest.hahago.net  download.hahago.net
    NSString *scheme = @"itms-services://?action=download-manifest&url=https://google.hahaya.top:9000/download/manifest.plist";
    NSURL *url = [NSURL URLWithString:scheme];
    UIApplication *application = [UIApplication sharedApplication];
    [application openURL:url options:@{} completionHandler:^(BOOL success) {
        if(success){
            NSLog(@"open %@",scheme);
        }else {
            NSLog(@"open fail");
        }
    }];
}

+(id)allocWithZone:(struct _NSZone *)zone{
    return [[self class] sharedManager];
}

-(id)copyWithZone:(struct _NSZone *)zone{
    return [[self class] sharedManager];
}

@end
