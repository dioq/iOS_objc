//
//  FilesystemViewController.m
//  ObjectiveC
//
//  Created by Dio Brand on 2022/9/15.
//  Copyright © 2022 my. All rights reserved.
//

#import "FilesystemViewController.h"

@interface FilesystemViewController ()

@property (weak, nonatomic) IBOutlet UILabel *show;

@end

@implementation FilesystemViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (IBAction)createAction:(UIButton *)sender {
    //获取Document文件
    NSString * docsdir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString * rarFilePath = [docsdir stringByAppendingPathComponent:@"Announcement"];//将需要创建的串拼接到后面
    NSString * dataFilePath = [docsdir stringByAppendingPathComponent:@"AnnouncementData"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDir = NO;
    BOOL dataIsDir = NO;
    // fileExistsAtPath 判断一个文件或目录是否有效，isDirectory判断是否一个目录
    BOOL existed = [fileManager fileExistsAtPath:rarFilePath isDirectory:&isDir];
    BOOL dataExisted = [fileManager fileExistsAtPath:dataFilePath isDirectory:&dataIsDir];
    if ( !(isDir == YES && existed == YES) ) {//如果文件夹不存在
        [fileManager createDirectoryAtPath:rarFilePath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    if (!(dataIsDir == YES && dataExisted == YES) ) {
        [fileManager createDirectoryAtPath:dataFilePath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    [self.show setText:@"创建目录成功"];
}

- (IBAction)deleteDir:(UIButton *)sender {
    //获取Document文件
    NSString * docsdir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString * rarFilePath = [docsdir stringByAppendingPathComponent:@"Announcement"];//将需要创建的串拼接到后面
    NSString * dataFilePath = [docsdir stringByAppendingPathComponent:@"AnnouncementData"];
    
    if ([self deletePath: rarFilePath]) {
        [self.show setText:@"删除目录成功"];
    }
    
    if ([self deletePath:dataFilePath]) {
        [self.show setText:@"删除目录成功"];
    }
}

- (IBAction)clearSandbox:(UIButton *)sender {
    NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *libDir = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *tmpDir = NSTemporaryDirectory();
    [self clearDir:docDir];
    [self clearDir:libDir];
    [self clearDir:tmpDir];
}

-(void)clearDir:(NSString *)path {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    // 获取目录下的所有内容(文件和目录)
    NSError *error;
    NSArray *contents = [fileManager contentsOfDirectoryAtPath:path error:&error];
    if(error) {
        NSLog(@"%@",[error localizedDescription]);
        return;
    }
    for (int i = 0; i < contents.count; i++) {
        NSString *filename = [contents objectAtIndex:i];
//        NSLog(@"%@", filename);
        BOOL suc = [fileManager removeItemAtPath:[path stringByAppendingPathComponent:filename] error:NULL];
        if (suc) {
            NSLog(@"%@ 删除成功", filename);
        }else {
            NSLog(@"%@ 删除失败", filename);
        }
    }
}

-(BOOL)deletePath:(NSString*)pFold {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    return [fileManager removeItemAtPath:pFold error:nil];
}

@end
