//
//  MyShareViewController.m
//  ObjectiveC
//
//  Created by hello on 2018/11/26.
//  Copyright © 2018 William. All rights reserved.
//

#import "MyShareViewController.h"

@interface MyShareViewController ()

@property(nonatomic, strong)NSArray *SharePic;

@end

@implementation MyShareViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    NSString *text = @"this is a text.";
    UIImage *img = [UIImage imageNamed:@"1"];
    NSURL *urlToShare = [NSURL URLWithString:@"http://www.google.com"];
    self.SharePic = [NSArray arrayWithObjects:text,img, urlToShare, nil];
}

- (IBAction)shareAction:(UIButton *)sender {
    NSArray * items =  self.SharePic;    //分享图片 数组
    UIActivityViewController * activityCtl = [[UIActivityViewController alloc]initWithActivityItems:items applicationActivities:nil];
    //去除一些不需要的图标选项
    activityCtl.excludedActivityTypes = @[UIActivityTypePostToTwitter];
    [self presentViewController:activityCtl animated:YES completion:nil];
}

/*
 // UIActivityType
 // 发布到Facebook
 UIActivityTypePostToFacebook     NS_AVAILABLE_IOS(6_0);
 // 发布到Twitter
 UIActivityTypePostToTwitter      NS_AVAILABLE_IOS(6_0);
 // 发布到新浪微博
 UIActivityTypePostToWeibo        NS_AVAILABLE_IOS(6_0);
 // 信息
 UIActivityTypeMessage            NS_AVAILABLE_IOS(6_0);
 // 邮件
 UIActivityTypeMail               NS_AVAILABLE_IOS(6_0);
 // 打印
 UIActivityTypePrint              NS_AVAILABLE_IOS(6_0);
 // 复制到剪切板
 UIActivityTypeCopyToPasteboard   NS_AVAILABLE_IOS(6_0);
 // 指定给联系人
 UIActivityTypeAssignToContact    NS_AVAILABLE_IOS(6_0);
 // 保存至本地相册(记得修改info.plist的隐私权限)
 UIActivityTypeSaveToCameraRoll   NS_AVAILABLE_IOS(6_0);
 // 添加到阅读列表(Safari)
 UIActivityTypeAddToReadingList   NS_AVAILABLE_IOS(7_0);
 // 发布到Flickr(图片分享网站)
 UIActivityTypePostToFlickr       NS_AVAILABLE_IOS(7_0);
 // 发布到Vimeo(视频分享网站)
 UIActivityTypePostToVimeo        NS_AVAILABLE_IOS(7_0);
 // 发布到腾讯微博
 UIActivityTypePostToTencentWeibo NS_AVAILABLE_IOS(7_0);
 // AirDrop
 UIActivityTypeAirDrop            NS_AVAILABLE_IOS(7_0);
 // 在iBooks内打开
 UIActivityTypeOpenInIBooks       NS_AVAILABLE_IOS(9_0);
 */

@end
