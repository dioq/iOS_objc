//
//  MessageViewController.m
//  ObjectiveC
//
//  Created by hello on 2019/4/4.
//  Copyright © 2019 William. All rights reserved.
//

#import "JumpAppViewController.h"
#import <MessageUI/MessageUI.h>
#import <StoreKit/StoreKit.h>

@interface JumpAppViewController ()<MFMailComposeViewControllerDelegate,MFMessageComposeViewControllerDelegate>

@end

@implementation JumpAppViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}


- (IBAction)otherApp:(UIButton *)sender {
    NSString *urlStr = @"weixin://";
    NSURL *url = [NSURL URLWithString:urlStr];
    UIApplication *application = [UIApplication sharedApplication];
    if([application canOpenURL:url]){
        NSDictionary *dict = [NSDictionary dictionary];
        [[UIApplication sharedApplication] openURL:url options:dict completionHandler:^(BOOL success) {
            NSLog(@"跳转 %d", success);
        }];
    }else {
        NSLog(@"没安装对应的App: %@", urlStr);
    }
}

//跳转到AppStore所在App的页面
- (IBAction)store:(UIButton *)sender {
    NSString *appid = @"925021570";
    NSString *str = [NSString stringWithFormat:@"http://itunes.apple.com/us/app/id%@",appid];
    NSURL *url = [NSURL URLWithString:str];
    if (@available(iOS 10.0, *)) {
        NSDictionary *dict = [NSDictionary dictionary];
        [[UIApplication sharedApplication] openURL:url options:dict completionHandler:nil];
    }
}

//仅支持iOS10.3+（需要做校验）且每个APP内每年最多弹出3次评分Alert
- (IBAction)evaluatePage:(UIButton *)sender {
    if([SKStoreReviewController respondsToSelector:@selector(requestReview)]){ // 在App内弹框评价
        //防止键盘遮挡
        [[UIApplication sharedApplication].keyWindow endEditing:YES];
        [SKStoreReviewController requestReview];//调用弹框
    } else { // 到AppStore里去评价
        //不论iOS 版本均可使用APP内部打开网页形式，跳转到App Store 直接编辑评论
        NSString *appid = @"925021570";
        NSString *str =[NSString stringWithFormat:@"https://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=%@&pageNumber=0&sortOrdering=2&type=Purple+Software&mt=8", appid];
        NSURL *url = [NSURL URLWithString:str];
        if ([[UIApplication sharedApplication] canOpenURL: url]) {//判断当前环境是否可以打开此url
            if ([[[UIDevice currentDevice] systemVersion]intValue] >= 10) {
                NSDictionary *dict = [NSDictionary dictionary];
                [[UIApplication sharedApplication] openURL:url options:dict completionHandler:nil];
            }
        }
    }
}

//iOS 11之后可以直接跳转到评分编辑页面
- (IBAction)evaluatePage2:(UIButton *)sender {
    NSString *appid = @"925021570";
    NSString *str = [[NSString alloc] init];;
    
    if ([[[UIDevice currentDevice] systemVersion]intValue] >= 11) {  //直接跳转到评分编辑页面
        str = [NSString stringWithFormat:@"https://itunes.apple.com/us/app/twitter/id%@?mt=8&action=write-review",appid];
    }else { //以普通方式去AppStore评价
        str = [NSString stringWithFormat:@"https://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=%@&pageNumber=0&sortOrdering=2&type=Purple+Software&mt=8",appid];
    }
    
    NSURL *url = [NSURL URLWithString:str];
    if ([[UIApplication sharedApplication] canOpenURL: url]) {//判断当前环境是否可以打开此url
        if ([[[UIDevice currentDevice] systemVersion]intValue] >= 10) {
            NSDictionary *dict = [NSDictionary dictionary];
            [[UIApplication sharedApplication] openURL:url options:dict completionHandler:nil];
        }
    }
}

- (IBAction)mail:(UIButton *)sender {
    if ([MFMailComposeViewController canSendMail]) { // 用户已设置邮件账户
        [self sendEmailAction]; // 调用发送邮件的代码
    }else{
        NSLog(@"用户未设置邮箱账户");
    }
}

- (IBAction)mesage:(UIButton *)sender {
    //发送短信
    if ([MFMessageComposeViewController canSendText]) {
        [self sendMessageAction];
    }else{
        NSLog(@"用户不能发送短信");
    }
}


#pragma mark -发送邮件
- (void)sendEmailAction {
    // 邮件服务器
    MFMailComposeViewController *mailCompose = [[MFMailComposeViewController alloc] init];
    // 设置邮件代理
    [mailCompose setMailComposeDelegate:self];
    
    // 设置邮件主题
    [mailCompose setSubject:@"我是邮件主题"];
    
    // 设置收件人
    [mailCompose setToRecipients:@[@"william17162018@gmail.com"]];
    // 设置抄送人
    [mailCompose setCcRecipients:@[@"xuanqikru1171@163.com"]];
    // 设置密抄送
    [mailCompose setBccRecipients:@[@"yeminx97309@163.com"]];
    
    /**
     *  设置邮件的正文内容
     */
    NSString *emailContent = @"我是邮件内容";
    // 是否为HTML格式
    [mailCompose setMessageBody:emailContent isHTML:NO];
    // 如使用HTML格式，则为以下代码
    //    [mailCompose setMessageBody:@"<html><body><p>Hello</p><p>World！</p></body></html>" isHTML:YES];
    
    /**
     *  添加附件
     */
    UIImage *image = [UIImage imageNamed:@"1"];
    NSData *imageData = UIImagePNGRepresentation(image);
    [mailCompose addAttachmentData:imageData mimeType:@"png" fileName:@"photo.png"];
    
    //    NSString *file = [[NSBundle mainBundle] pathForResource:@"test" ofType:@"pdf"];
    //    NSData *pdf = [NSData dataWithContentsOfFile:file];
    //    [mailCompose addAttachmentData:pdf mimeType:@"" fileName:@"pdf文件"];
    
    // 弹出邮件发送视图
    [self presentViewController:mailCompose animated:YES completion:nil];
}

#pragma mark - 实现 MFMailComposeViewControllerDelegate
- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error{
    
    switch (result) {
        case MFMailComposeResultCancelled:
            NSLog(@"取消发送");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"发送失败");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"保存草稿文件");
            break;
        case MFMailComposeResultSent:
            NSLog(@"发送成功");
            break;
        default:
            break;
    }
    // 关闭邮件发送视图
    [self dismissViewControllerAnimated:YES completion:nil];
}


//  调用系统API发送短信
- (void)sendMessageAction{
    MFMessageComposeViewController *messageVC = [[MFMessageComposeViewController alloc] init];
    // 设置短信代理
    messageVC.messageComposeDelegate = self;
    // 发送给谁
    messageVC.recipients = @[@"18701235678"];
    // 发送的内容
    messageVC.body = @"hello world";
    // 弹出发送短信的视图
    [self presentViewController:messageVC animated:YES completion:nil];
}

#pragma mark - 实现 MFMessageComposeViewControllerDelegate
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result{
    
    switch (result) {
        case MessageComposeResultCancelled:
            NSLog(@"取消发送");
            break;
        case MessageComposeResultFailed:
            NSLog(@"发送失败");
            break;
        case MessageComposeResultSent:
            NSLog(@"发送成功");
            break;
        default:
            break;
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
