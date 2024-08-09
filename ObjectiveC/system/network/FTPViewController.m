//
//  FTPViewController.m
//  ObjectiveC
//
//  Created by zd on 22/7/2024.
//  Copyright © 2024 my. All rights reserved.
//

#import "FTPViewController.h"
#import "WJFtpRequestManager.h"
#import "WJTools.h"

@interface FTPViewController ()<WJFtpRequestManagerDelegate>
{
    NSString *docDir;
}

@property (nonatomic, strong)WJFtpRequestManager * manager;
@property (nonatomic, strong)NSString *local_path;

@end

@implementation FTPViewController

- (WJFtpRequestManager *)manager {
    if (_manager == nil) {
        _manager = [WJFtpRequestManager shareInstance];
        _manager.username = @"test";
        _manager.password = @"123456";
        _manager.serverIP = @"192.168.2.5";
        _manager.serverPort = 21;
        _manager.delegate = self;
    }
    return _manager;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"ftp 传输文件";
    docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES) firstObject];
    NSLog(@"docDir:\n%@",docDir);
    
    [self make_test_file];
}

-(void)make_test_file {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    self.local_path = [NSString stringWithFormat:@"%@/test.txt",docDir];
    NSData *data = [@"This is a test string." dataUsingEncoding:NSUTF8StringEncoding];
    // 创建文件时写入内容, 如果文件所在的 目录不存在 是无法写入数据的,需要先创建对应的目录
    BOOL suc = [fileManager createFileAtPath:self.local_path contents:data attributes:nil];
    if (suc) {
        NSLog(@"写入数据成功!");
    }else{
        NSLog(@"写入数据失败!");
        return;
    }
    NSLog(@"local_path1:%@",self.local_path);
}

- (IBAction)upload_btn_action:(id)sender {
    //    NSString *local_path = @"/var/mobile/Documents/test.txt";
    NSString *uuid = [[NSUUID UUID] UUIDString];
    NSString *remote_path =[NSString stringWithFormat:@"/upload_dir/%@.txt",uuid];
    [self.manager addUploadFileWithRelativePath:remote_path toLocalPath:self.local_path identifier:@""];
}

- (IBAction)down_btn_action:(UIButton *)sender {
    NSString *local_path =[NSString stringWithFormat:@"%@/%@.png",docDir,[[NSUUID UUID] UUIDString]];
    NSString *remote_path = @"/download_dir/server_img.png";
    [self.manager addDownloadFileWithRelativePath:remote_path toLocalPath:local_path identifier:@"" fileSize:0x10000000000];
}

#pragma mark - FYFtpRequestManagerDelegate
- (void)requestsManagerError:(NSString *)error identifier:(NSString *)identifier {
    WJLog(@"requestsManagerError = %@ identifier = %@", error, identifier);
}

-  (void)requestsManagerDidCompleteCreateDirectory:(NSString *)directory {
    WJLog(@"CreateDirectory = %@", directory);
}

- (void)requestsManagerDidCompleteListing:(NSArray *)listing {
    WJLog(@"requestsManagerDidCompleteListing = %@", listing);
}

- (void)requestsManagerDownloadDidCompleteLocalPath:(NSString *)localPath identifier:(NSString *)identifier {
    WJLog(@"DownloadDidComplete = %@ - %@", identifier, localPath);
    
}

- (void)requestsManagerUploadDidCompleteLocalPath:(NSString *)localPath identifier:(NSString *)identifier {
    WJLog(@"UploadDidCompleteLocalPat = %@", identifier);
}

- (void)requestsManagerProcess:(float)process identifier:(NSString *)identifier {
    WJLog(@"process = %.2f  - identifier = %@", process, identifier);
}

@end
