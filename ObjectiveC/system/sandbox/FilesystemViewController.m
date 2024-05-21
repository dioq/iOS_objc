//
//  FilesystemViewController.m
//  ObjectiveC
//
//  Created by Dio Brand on 2022/9/15.
//  Copyright © 2022 my. All rights reserved.
//

#import "FilesystemViewController.h"

@interface FilesystemViewController ()
{
    NSString *docDir;
    NSString *libDir;
    NSString *cachesDir;
    NSString *tmpDir;
}

@property (weak, nonatomic) IBOutlet UILabel *show;

@end

@implementation FilesystemViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
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
    
    if ([self deleteFile: rarFilePath]) {
        [self.show setText:@"删除目录成功"];
    }
    
    if ([self deleteFile:dataFilePath]) {
        [self.show setText:@"删除目录成功"];
    }
}

- (IBAction)clearSandbox:(UIButton *)sender {
    NSString *lib_cache_path = [NSString stringWithFormat:@"%@/Caches",libDir];
    NSString *lib_preferences_path = [NSString stringWithFormat:@"%@/Preferences",libDir];
    
    [self emptyDir:docDir];
    [self emptyDir:libDir];
    [self emptyDir:lib_cache_path];
    [self emptyDir:lib_preferences_path];
    [self emptyDir:cachesDir];
    [self emptyDir:tmpDir];
}
-(void)emptyDir:(NSString *)path {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    // 获取目录下的所有内容(文件和目录)
    NSError *error;
    NSArray *contents = [fileManager contentsOfDirectoryAtPath:path error:&error];
    if(error) {
        NSLog(@"%@:%@",path,[error localizedFailureReason]);
        return;
    }
    for (int i = 0; i < contents.count; i++) {
        NSString *filename = [contents objectAtIndex:i];
        NSString *current_path = [path stringByAppendingPathComponent:filename];
        [self deleteFile:current_path];
    }
}
-(BOOL)deleteFile:(NSString *)path {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    BOOL suc = [fileManager removeItemAtPath:path error:&error];
    if(error) {
        NSLog(@"%@",[error localizedFailureReason]);
    }
    return suc;
}

- (IBAction)file_copy_act:(UIButton *)sender {
    NSString *path1 = @"/tmp/test.txt";
    NSString *path2 = [NSString stringWithFormat:@"%@/test.txt",cachesDir];
    [self copySourcePath:path1 TargetPath:path2];
    
    NSString *path3 = @"/tmp/dir2";
    NSString *path4 = [NSString stringWithFormat:@"%@/dir2",cachesDir];
    [self copySourcePath:path3 TargetPath:path4];
}

-(BOOL)copySourcePath:(NSString *)sourcePath TargetPath:(NSString *)targetPath {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    BOOL suc = [fileManager copyItemAtPath:sourcePath toPath:targetPath error:&error];
    if(error) {
        NSLog(@"%@",[error localizedFailureReason]);
    }
    return suc;
}

@end
