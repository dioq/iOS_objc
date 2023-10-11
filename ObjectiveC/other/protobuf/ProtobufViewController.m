//
//  ProtobufViewController.m
//  ObjectiveC
//
//  Created by zd on 11/10/2023.
//  Copyright © 2023 my. All rights reserved.
//

#import "ProtobufViewController.h"
#import "Person.pbobjc.h"
#import "CryptoUtil.h"

@interface ProtobufViewController ()

@property(nonatomic,strong)NSData *pdata;

@end

@implementation ProtobufViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (IBAction)serialize_action:(UIButton *)sender {
    Person *per = [Person new];
    per.name = @"Dio";
    per.age = 0x20;
    per.email = @"zhendong2011@live.cn";
    
    // 序列化
    self.pdata = [per data];
    NSLog(@"Person 序列化完成");
    NSString *hex = [CryptoUtil hexEncode:self.pdata];
    NSLog(@"%@", hex);
}

- (IBAction)deserialize_action:(UIButton *)sender {
    // 反序列化
    Person *p = [Person parseFromData:self.pdata error:nil];
    NSLog(@"Person 反序列化完成");
    NSLog(@"person:%@",p);
}

@end
