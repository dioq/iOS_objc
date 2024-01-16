//
//  CompressViewController.m
//  ObjectiveC
//
//  Created by zd on 26/6/2023.
//  Copyright © 2023 my. All rights reserved.
//

#import "CompressViewController.h"
#import "ZipUtil.h"

@interface CompressViewController ()

@property(nonatomic,strong)NSData *tmpData;

@end

@implementation CompressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"数据的压缩和解压";
}

- (IBAction)compress_data:(UIButton *)sender {
    NSString *testStr = @"This is just a test string.This is just a test string.This is just a test string.This is just a test string.";
    NSData *testData = [testStr dataUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"before compress length:%lu", testData.length);
    self.tmpData =  [[ZipUtil new] gzipDeflate:testData];
    NSLog(@"after  compress length:%lu", self.tmpData.length);
}

- (IBAction)DeCompress_data:(UIButton *)sender {
    NSData *after_unzip_data = [[ZipUtil new] gzipInflate:self.tmpData];
    NSLog(@"after  unzip length:%lu", after_unzip_data.length);
    NSString *origin_str = [[NSString alloc] initWithData:after_unzip_data encoding:NSUTF8StringEncoding];
    NSLog(@"origin_str:%@",origin_str);
}

@end
