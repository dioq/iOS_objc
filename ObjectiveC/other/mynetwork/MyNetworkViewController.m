//
//  MyNetworkViewController.m
//  ObjectiveC
//
//  Created by Dio Brand on 2022/8/8.
//  Copyright © 2022 my. All rights reserved.
//

#import "MyNetworkViewController.h"
#import "NetworkManager.h"

@interface MyNetworkViewController ()<UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UITextView *show;

@end

@implementation MyNetworkViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.show.delegate = self;
}

- (IBAction)get:(UIButton *)sender {
    [self.show setText:@""];
    NSString *urlStr = @"http://jobs8.cn:8090/get";
    [[NetworkManager sharedManager] getUrl:urlStr success:^(id  _Nonnull response) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.show setText:response];
        });
    } failure:^(NSError * _Nonnull error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.show setText:[error localizedDescription]];
        });
    }];
}

- (IBAction)download:(UIButton *)sender {
    [self.show setText:@""];
    NSString *urlStr = @"https://jobs8.cn:8091/cmdr.plist";
//    NSString *urlStr = @"itms-services://?action=download-manifest&url=https://jobs8.cn:8091/cmdr.plist";
    [[NetworkManager sharedManager] getUrl:urlStr success:^(id  _Nonnull response) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.show setText:response];
        });
    } failure:^(NSError * _Nonnull error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.show setText:[error localizedDescription]];
        });
    }];
}

- (IBAction)post:(UIButton *)sender {
    [self.show setText:@""];
    NSString *urlStr = @"http://jobs8.cn:8090/post";
    NSMutableDictionary<NSString *,NSObject *> *param = [NSMutableDictionary dictionary];
    [param setValue:@"Dio Brand" forKey:@"name"];
    [param setValue:@18 forKey:@"age"];
    [[NetworkManager sharedManager] postUrl:urlStr paramJson:param success:^(id  _Nonnull response) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.show setText:response];
        });
    } failure:^(NSError * _Nonnull error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.show setText:[error localizedDescription]];
        });
    }];
}

- (IBAction)formdataAct:(UIButton *)sender {
    [self.show setText:@""];
    NSString *urlStr = @"http://jobs8.cn:8090/postform";
    NSString *parameter = [NSString stringWithFormat:@"name=%@&area=%@&age=%d&action=%@", @"dio", @"guiyang",18,@"testaction"];
    NSData *paramData = [parameter dataUsingEncoding:NSUTF8StringEncoding];
    [[NetworkManager sharedManager] postUrl:urlStr parameters:paramData success:^(id _Nonnull response) {
        NSString *result = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.show setText:result];
        });
    } failure:^(NSError * _Nonnull error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.show setText:[error localizedDescription]];
        });
    }];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]) {
        [self.view endEditing:YES];
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

@end
