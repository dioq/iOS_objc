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
    NSString *urlStr = @"http://127.0.0.1:8090/get";
    [[NetworkManager sharedManager] getUrl:urlStr success:^(id  _Nonnull response) {
        [self showTip:response];
    } failure:^(NSError * _Nonnull error) {
        [self showTip:[error localizedDescription]];
    }];
}

- (IBAction)post:(UIButton *)sender {
    [self.show setText:@""];
    NSString *urlStr = @"http://127.0.0.1:8090/post";
    NSMutableDictionary<NSString *,NSObject *> *param = [NSMutableDictionary dictionary];
    [param setValue:@"Dio Brand" forKey:@"name"];
    [param setValue:@18 forKey:@"age"];
    [[NetworkManager sharedManager] postUrl:urlStr paramDict:[param copy] success:^(id  _Nonnull response) {
        [self showTip:response];
    } failure:^(NSError * _Nonnull error) {
        [self showTip:[error localizedDescription]];
    }];
}

- (IBAction)submit_action:(UIButton *)sender {
    NSString *urlStr = @"http://127.0.0.1:8090/form";
    
    NSMutableDictionary *textMutDict = [NSMutableDictionary dictionary];
    [textMutDict setValue:@"Dio" forKey:@"name"];
    [textMutDict setValue:@"Beijing" forKey:@"address"];
    [textMutDict setValue:@"18" forKey:@"age"];
    
    NSMutableDictionary *fileMutDict = [NSMutableDictionary dictionary];
    NSData *dt1 = [@"11111,this is a test" dataUsingEncoding:NSUTF8StringEncoding];
    NSData *dt2 = [@"22222,this is a test" dataUsingEncoding:NSUTF8StringEncoding];
    NSData *dt3 = [@"33333,this is a test" dataUsingEncoding:NSUTF8StringEncoding];
    [fileMutDict setValue:dt1 forKey:@"file1"];
    [fileMutDict setValue:dt2 forKey:@"file2"];
    [fileMutDict setValue:dt3 forKey:@"file2"];
    
    [[NetworkManager sharedManager] submitUrl:urlStr textDict:[textMutDict copy] fileDict:[fileMutDict copy] success:^(id _Nonnull response) {
        [self showTip:response];
    } failure:^(NSError * _Nonnull error) {
        [self showTip:[error localizedDescription]];
    }];
}

-(void)showTip:(NSString * _Nonnull)tip {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.show setText:tip];
    });
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
