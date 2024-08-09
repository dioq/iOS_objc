//
//  DeviceIDViewController.m
//  ObjectiveC
//
//  Created by Dio Brand on 2022/6/28.
//  Copyright © 2022 my. All rights reserved.
//

#import "DeviceIDViewController.h"
#import <AdSupport/AdSupport.h>
#import <AppTrackingTransparency/ATTrackingManager.h>
#import <Security/Security.h>
#import "SimulateIDFA.h"
#import "CryptoUtil.h"

@interface DeviceIDViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *uuidTF;
@property (weak, nonatomic) IBOutlet UITextView *show;

@end

@implementation DeviceIDViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.uuidTF.delegate = self;
}

- (IBAction)getuuid:(UIButton *)sender {
    [self.show setText:@""];
    NSUUID *uuid = [[NSUUID alloc] initWithUUIDString:self.uuidTF.text];
    NSString *uuidStr = [uuid UUIDString];
    NSLog(@"uuid:%@", uuidStr);
    [self.show setText:uuidStr];
}

- (IBAction)randomUUID:(UIButton *)sender {
    [self.show setText:@""];
    NSUUID *uuid = [NSUUID UUID];
    NSString *uuidStr = [uuid UUIDString];
    NSLog(@"random uuid:%@", uuidStr);
    [self.show setText:uuidStr];
}

// IDFV 供应商标识
- (IBAction)getIDFV:(UIButton *)sender {
    /*
     IDFV是通过BundleID的DNS反串的前两部分进行匹配，如果相同，返回的值就相同。
     例如：com.company.hello和com.company.word这两个bundleID就是同一个Vender生成的IDFV就是相同的,
     如果用户把所有此Vender的app都卸载，再次获取IDFV就会和之前的不同，会被重置。
     获取方式:[[[UIDevice currentDevice] identifierForVendor] UUIDString]
     试用：iOS6+
     注意：无法保证唯一标识
     */
    [self.show setText:@""];
    NSString *idfv = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    NSLog(@"IDFV:\n%@",idfv);
    [self.show setText:idfv];
}

// IDFA 广告标识
- (IBAction)getIDFA:(UIButton *)sender {
    [self.show setText:@""];
    /*
     该标识是用来进行广告标记，进行推送广告。
     用户可以在设置->隐私->广告，进行重置此ID的值，获取直接关闭，关闭之后获取的值是000000000xxxxx
     获取：[[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString]
     试用：iOS6+
     注意：该值在用户没有对系统设置进行修改的时候是惟一的，但是用户可以进行手动操作关闭或者重置
     */
    if (@available(iOS 14, *)) {
        // iOS14及以上版本需要先请求权限
        [ATTrackingManager requestTrackingAuthorizationWithCompletionHandler:^(ATTrackingManagerAuthorizationStatus status) {
            // 获取到权限后，依然使用老方法获取idfa
            if (status == ATTrackingManagerAuthorizationStatusAuthorized) {
                NSString *idfa = [[ASIdentifierManager sharedManager].advertisingIdentifier UUIDString];
                NSLog(@"IDFA:\n%@",idfa);
                //                [self.show setText:idfa];
            } else {
                NSString *tip = @"请在设置-隐私-跟踪中允许App请求跟踪";
                NSLog(@"%@",tip);
                //                [self.show setText:tip];
            }
        }];
    } else {
        // iOS14以下版本依然使用老方法
        // 判断在设置-隐私里用户是否打开了广告跟踪
        if ([[ASIdentifierManager sharedManager] isAdvertisingTrackingEnabled]) {
            NSString *idfa = [[ASIdentifierManager sharedManager].advertisingIdentifier UUIDString];
            NSLog(@"IDFA:\n%@",idfa);
            [self.show setText:idfa];
        } else {
            NSString *tip = @"请在设置-隐私-跟踪中允许App请求跟踪";
            NSLog(@"%@",tip);
            [self.show setText:tip];
        }
    }
}

- (IBAction)SimulateIDFA:(UIButton *)sender {
    [self.show setText:@""];
    NSString *simulateIDFA = [SimulateIDFA createSimulateIDFA];
    NSLog(@"simulateIDFA:\n%@", simulateIDFA);
    [self.show setText:simulateIDFA];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

@end
