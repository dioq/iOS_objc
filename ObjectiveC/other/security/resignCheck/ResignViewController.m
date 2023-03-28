//
//  ResignViewController.m
//  ObjectiveC
//
//  Created by Dio Brand on 2022/7/16.
//  Copyright © 2022 my. All rights reserved.
//

#import "ResignViewController.h"

@interface ResignViewController ()

@property (weak, nonatomic) IBOutlet UILabel *show;
@property(nonatomic,strong)NSArray *teamIDArr;

@end

@implementation ResignViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.teamIDArr = @[@"38D3676P2T",@"DZ4RUFAG9F",@"AF7H266475",@"5YBWG2X244"];
}

- (IBAction)check:(UIButton *)sender {
    [self.show setText:@""];
    NSString *tip;
    int status = [self check];
    if (status == 0) {
        tip = @"苹果商店的正版app. 因为没有在 ipa 包里找到重签名的描述文件";
    }else if (status == 1) {
        tip = @"自己的团队(teamID)签名的应用. 在 ipa 包里找到重签名的描述文件,但描述文件的 teamID 是自己的";
    }else if(status == 2) {
        tip = @"被重签名的 ipa, 在 ipa 包里找到重签名的描述文件,而且描述文件的 teamID 不是自己的";
    }
    [self.show setText:tip];
}

- (int)check {
    int status = 0;
    //取出embedded.mobileprovision这个描述文件的内容进行判断
    NSString *mobileProvisionPath = [[NSBundle mainBundle] pathForResource:@"embedded" ofType:@"mobileprovision"];
    NSData *rawData = [NSData dataWithContentsOfFile:mobileProvisionPath];
    if (rawData != nil) {
        NSString *rawDataString = [[NSString alloc] initWithData:rawData encoding:NSASCIIStringEncoding];
        NSRange plistStartRange = [rawDataString rangeOfString:@"<plist"];
        NSRange plistEndRange = [rawDataString rangeOfString:@"</plist>"];
        if (plistStartRange.location != NSNotFound && plistEndRange.location != NSNotFound) {
            NSString *tempPlistString = [rawDataString substringWithRange:NSMakeRange(plistStartRange.location, NSMaxRange(plistEndRange))];
            NSData *tempPlistData = [tempPlistString dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *plistDic =  [NSPropertyListSerialization propertyListWithData:tempPlistData options:NSPropertyListImmutable format:nil error:nil];
            
            NSArray *applicationIdentifierPrefix = [plistDic valueForKey:@"ApplicationIdentifierPrefix" ];
            NSDictionary *entitlementsDic = [plistDic valueForKey:@"Entitlements"];
            NSString *mobileBundleID = [entitlementsDic valueForKey:@"application-identifier"];
            if (applicationIdentifierPrefix.count > 0 && mobileBundleID != nil) {
//                NSLog(@"mobileBundleID:%@",mobileBundleID);
                mobileBundleID = [mobileBundleID substringToIndex:10];
                if([self.teamIDArr containsObject:mobileBundleID]) {
                    status = 1; // 自己的团队teamID
                }else {
                    status = 2; // 其他团团队 teamID
                }
            }
        }
    }
    return status;
}

- (IBAction)checkSignerid:(UIButton *)sender {
    [self.show setText:@""];
    NSString *teamID = [self getTeamID];
    if([self.teamIDArr containsObject:teamID]) {
        [self.show setText:@"TeamID 间允许的值"];
    }else {
        [self.show setText:@"TeamID 被修改过"];
    }
}

/*
 原理是:往 Keychain 存取数据时要通过 teamID 作为标识的前缀,通过存取一个条数据获取 teamID,如果被重签名过这个值会发生变化。这种方式是不可被串改的
 **/
// 获取 开发者账号的 TeamID
-(NSString *)getTeamID{
    NSDictionary *query = [NSDictionary dictionaryWithObjectsAndKeys:
                           (__bridge id)kSecClassGenericPassword, (__bridge id)kSecClass,
                           @"bundleSeedID", (__bridge id)kSecAttrAccount,
                           @"", (__bridge id)kSecAttrService,
                           (__bridge id)kCFBooleanTrue, (__bridge id)kSecReturnAttributes,
                           (__bridge id)kSecMatchLimitOne,(__bridge id)kSecMatchLimit,
                           nil];
    CFDictionaryRef result = nil;
    OSStatus status = SecItemCopyMatching((CFDictionaryRef)query, (CFTypeRef *)&result);
    if (status == errSecItemNotFound) { // 如果还没有 bundleSeedID 这条数据,就往Keychain里添加
        NSMutableDictionary *insertDict = [NSMutableDictionary dictionaryWithDictionary:query];
        [insertDict removeObjectForKey:(__bridge id)kSecMatchLimit];// 删除 table 这一项
        status = SecItemAdd((CFDictionaryRef)insertDict, (CFTypeRef *)&result);// 添加或查询后 result 都会保存添加后 Keychain 里 bundleSeedID 这条数据的信息
    }
    if (status != errSecSuccess) {
        return nil;
    }
    NSString *accessGroup = [(__bridge NSDictionary *)result objectForKey:(__bridge id)kSecAttrAccessGroup]; // 返回信息里的 agrp 对应数据的前一剖分就是 TeamID
    NSArray *components = [accessGroup componentsSeparatedByString:@"."];
    NSString *teamID = [[components objectEnumerator] nextObject];
    CFRelease(result);
    return teamID;
}

@end
