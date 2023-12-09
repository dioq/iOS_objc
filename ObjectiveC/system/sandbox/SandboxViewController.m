//
//  SandboxViewController.m
//  ObjectiveC
//
//  Created by Dio on 2022/6/15.
//  Copyright © 2022 my. All rights reserved.
//

#import "SandboxViewController.h"

@interface SandboxViewController ()<UITextFieldDelegate>
{
    NSString *homeDir;
    NSString *docDir;
    NSString *libDir;
    NSString *cachesDir;
    NSString *tmpDir;
    NSString *appPath;
}

@property (weak, nonatomic) IBOutlet UITextField *inputTF;
@property (weak, nonatomic) IBOutlet UILabel *show;
@property(weak, nonatomic) IBOutlet UIImageView *showimage;

@property(nonatomic, strong)NSFileManager *fileManager;
@property(nonatomic,copy)NSString *filePath;

@end

@implementation SandboxViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.inputTF.delegate = self;
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
    NSString *bundlePath = [[NSBundle mainBundle] bundlePath];
    NSLog(@"bundlePath:\n%@",bundlePath);
    NSString *resourcePath = [[NSBundle mainBundle] resourcePath];
    NSLog(@"resourcePath:\n%@",resourcePath);
    NSString *execuPath = [[NSBundle mainBundle] executablePath];
    NSLog(@"execuPath:\n%@",execuPath);
}

- (IBAction)write:(UIButton *)sender {
    if (self.inputTF.text == nil || [self.inputTF.text isEqual:@""]) {
        [self.show setText:@"测试文字不能为空"];
        return;
    }
    NSString *testStr = self.inputTF.text;
    
    NSString *newDirName = @"WechatPrivate";
    NSString *newDirPath = [NSString stringWithFormat:@"%@/%@",libDir, newDirName];
    //     如果文件所在的 目录不存在 是无法写入数据的,需要先创建对应的目录
    if (![_fileManager fileExistsAtPath:newDirPath]) {
        NSError *error;
        [_fileManager createDirectoryAtPath:newDirPath withIntermediateDirectories:YES attributes:nil error:&error];
        if (error) {
            NSLog(@"%@",error);
            return;
        }
    }
    
    // 要写入的文件名字 和 绝对路径
    NSString *fileName = @"test.txt";
    _filePath = [NSString stringWithFormat:@"%@/%@",newDirPath,fileName];
    
    NSError *error;
    [testStr writeToFile:_filePath atomically:YES encoding:NSUTF8StringEncoding error:&error];
    if (error) {
        NSLog(@"%@",error);
        [_show setText:[error localizedFailureReason]];
    }
    [_show setText:@"数据写入成功"];
}

- (IBAction)createAndwrite:(UIButton *)sender {
    NSString *fileName = @"test.txt";
    NSString *newDirName = @"WechatPrivate";
    NSString *newDirPath = [NSString stringWithFormat:@"%@/%@",libDir, newDirName];
    NSString *filePath = [NSString stringWithFormat:@"%@/%@",newDirPath,fileName];
    NSString *testStr = [[NSUUID UUID] UUIDString];
    NSData *data = [testStr dataUsingEncoding:NSUTF8StringEncoding];
    // 创建文件时写入内容, 如果文件所在的 目录不存在 是无法写入数据的,需要先创建对应的目录
    BOOL suc = [_fileManager createFileAtPath:filePath contents:data attributes:nil];
    if (suc) {
        [self.show setText:@"写入数据成功!"];
    }else{
        [self.show setText:@"写入数据失败!"];
    }
}

- (IBAction)readSandbox:(UIButton *)sender {
    if (![_fileManager fileExistsAtPath:_filePath]) {
        [_show setText:@"文件不存在!"];
        return;
    }
    // 读取 sandbox 里的内容
    NSData *getData = [_fileManager contentsAtPath:_filePath];
    //    NSLog(@"getData size %lu", getData.length);
    NSString *getText = [[NSString alloc] initWithData:getData encoding:NSUTF8StringEncoding];
    //    NSLog(@"%@\n content:\n%@",_filePath,getText);
    NSString *result = [NSString stringWithFormat:@"%@\n%@",_filePath,getText];
    [_show setText:result];
}

- (IBAction)getdata:(UIButton *)sender {
    NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"myimage" ofType:@"jpg"];
    NSLog(@"imagePath:\n%@", imagePath);
    UIImage *appleImage = [[UIImage alloc] initWithContentsOfFile:imagePath];
    
    [self.showimage setImage:appleImage];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];// 放弃第一响应者
    return YES;
}

@end
