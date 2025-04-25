//
//  CompressViewController.m
//  ObjectiveC
//
//  Created by zd on 26/6/2023.
//  Copyright © 2023 my. All rights reserved.
//

#import "CompressViewController.h"
#import "ZipUtil.h"
#import <SSZipArchive.h>

@interface CompressViewController ()
{
    NSString *homeDir;
    NSString *docDir;
    NSString *libDir;
    NSString *cachesDir;
    NSString *tmpDir;
    NSString *appPath;
}

@property(nonatomic,strong)NSData *tmpData;

@end

@implementation CompressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"数据的压缩和解压";
    
    // 获取沙盒根目录路径
    homeDir = NSHomeDirectory();
    NSLog(@"homeDir:\n%@",homeDir);
    
    // 获取Documents目录路径
    docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES) firstObject];
    NSLog(@"docDir:\n%@",docDir);
    
    //获取Library的目录路径
    libDir = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory,NSUserDomainMask,YES) firstObject];
    NSLog(@"libDir:\n%@",libDir);
    
    // 获取cache目录路径
    cachesDir = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask,YES) firstObject];
    NSLog(@"cachesDir:\n%@",cachesDir);
    
    // 获取tmp目录路径
    tmpDir = NSTemporaryDirectory();
    NSLog(@"tmpDir:\n%@",tmpDir);
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

- (IBAction)compress_file_action:(UIButton *)sender {
    // 目标路径
    NSString *dst_path = [NSString stringWithFormat:@"%@/test.zip",docDir];
    // 源路径，待压缩的文件
    NSString *f1 = [NSString stringWithFormat:@"%@/t1.txt",docDir];
    NSString *f2 = [NSString stringWithFormat:@"%@/t2.txt",docDir];
    NSArray *src_paths = @[f1,f2];
    
    NSLog(@"dst_path:%@",dst_path);
    NSLog(@"src_paths:%@",src_paths);
    BOOL result = [SSZipArchive createZipFileAtPath:dst_path
                                   withFilesAtPaths:src_paths];
    NSLog(@"%d",result);
}

- (IBAction)decopress_file_action:(UIButton *)sender {
    // 源路径，待解压缩的文件
    NSString *src_path = [NSString stringWithFormat:@"%@/test.zip",docDir];
    // 目标路径
    NSString *dst_path = [NSString stringWithFormat:@"%@/test",docDir];
    
    BOOL result = [SSZipArchive unzipFileAtPath:src_path
                                  toDestination:dst_path];
    NSLog(@"%d",result);
}

- (IBAction)compress_dir_action:(UIButton *)sender {
    // 目标路径
    NSString *dst_path = [NSString stringWithFormat:@"%@/test.zip",libDir];
    
    // 源路径，待压缩的文件夹
    NSString *src_path = [NSString stringWithFormat:@"%@/test",libDir];
    
    BOOL result = [SSZipArchive createZipFileAtPath:dst_path
                            withContentsOfDirectory:src_path];
    NSLog(@"%d",result);
}

- (IBAction)decopress_dir_action:(UIButton *)sender {
    // 源路径，待解压缩的文件
    NSString *src_path = [NSString stringWithFormat:@"%@/test.zip",libDir];
    // 目标路径
    NSString *dst_path = [NSString stringWithFormat:@"%@/test",tmpDir];
    
    BOOL result = [SSZipArchive unzipFileAtPath:src_path
                                  toDestination:dst_path];
    NSLog(@"%d",result);
}

- (IBAction)decopress_selected_file_act:(UIButton *)sender {
    NSString *src_path = [NSString stringWithFormat:@"%@/test.zip",docDir];
    NSString *dst_dir_path = [NSString stringWithFormat:@"%@/dst",docDir];
}

@end
