//
//  SandboxViewController.m
//  ObjectiveC
//
//  Created by Dio on 2022/6/15.
//  Copyright © 2022 my. All rights reserved.
//

#import "SandboxViewController.h"

@interface SandboxViewController ()
{
    NSString *homeDir;
    NSString *docDir;
    NSString *libDir;
    NSString *cachesDir;
    NSString *tmpDir;
    NSString *bundlePath;
}

@property(nonatomic, strong)NSFileManager *fileManager;
@property(nonatomic, copy)NSString *filePath;

@end

@implementation SandboxViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _fileManager = [NSFileManager defaultManager];
    
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
    
    // 获取应用程序程序包中资源文件路径的方法：
    bundlePath = [[NSBundle mainBundle] bundlePath];
    NSLog(@"bundlePath:\n%@",bundlePath);
    NSString *resourcePath = [[NSBundle mainBundle] resourcePath];
    NSLog(@"resourcePath:\n%@",resourcePath);
    NSString *execuPath = [[NSBundle mainBundle] executablePath];
    NSLog(@"execuPath:\n%@",execuPath);
}

- (IBAction)write:(UIButton *)sender {
    NSError *error;
    NSString *testStr = @"This is a test string.";
    
    NSString *newDirPath = [NSString stringWithFormat:@"%@/testDir",libDir];
    // 如果文件所在的 目录不存在 是无法写入数据的,需要先创建对应的目录
    if (![_fileManager fileExistsAtPath:newDirPath]) {
        [_fileManager createDirectoryAtPath:newDirPath withIntermediateDirectories:YES attributes:nil error:&error];
        if (error) {
            NSLog(@"%@",[error localizedFailureReason]);
            return;
        }
    }
    
    // 要写入的文件名字 和 绝对路径
    _filePath = [NSString stringWithFormat:@"%@/test.txt",newDirPath];
    
    [testStr writeToFile:_filePath atomically:YES encoding:NSUTF8StringEncoding error:&error];
    if (error) {
        NSLog(@"%@",[error localizedFailureReason]);
        return;
    }
    NSLog(@"写入数据成功!");
}

- (IBAction)createAndwrite:(UIButton *)sender {
    _filePath = [NSString stringWithFormat:@"%@/test.txt",docDir];
    NSLog(@"filePath:%@",_filePath);
    NSString *testStr = [[NSUUID UUID] UUIDString];
    NSData *data = [testStr dataUsingEncoding:NSUTF8StringEncoding];
    // 创建文件时写入内容, 如果文件所在的 目录不存在 是无法写入数据的,需要先创建对应的目录
    
    BOOL suc = [_fileManager createFileAtPath:_filePath contents:data attributes:nil];
    if (suc) {
        NSLog(@"写入数据成功!");
    }else{
        NSLog(@"写入数据失败!");
    }
}

- (IBAction)readSandbox:(UIButton *)sender {
    if (![_fileManager fileExistsAtPath:_filePath]) {
        NSLog(@"文件不存在!");
        return;
    }
    // 读取 sandbox 里的内容
    NSData *data = [_fileManager contentsAtPath:_filePath];
    NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"%@",str);
}

@end
