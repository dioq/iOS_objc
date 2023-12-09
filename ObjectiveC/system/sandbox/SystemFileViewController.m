//
//  SystemFileViewController.m
//  ObjectiveC
//
//  Created by Dio Brand on 2022/9/16.
//  Copyright © 2022 my. All rights reserved.
//

#import "SystemFileViewController.h"

@interface SystemFileViewController ()<UIDocumentPickerDelegate, UIDocumentInteractionControllerDelegate>
{
    NSString *docDir;
}
@property(nonatomic, strong)NSFileManager *fileManager;

@end

@implementation SystemFileViewController

- (void)viewDidLoad {
    _fileManager = [NSFileManager defaultManager];
    // 获取Documents目录路径
    docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES) firstObject];
//    NSLog(@"docDir:\n%@",docDir);
}

- (IBAction)selectAction:(UIButton *)sender {
    [self presentDocumentCloud];
}

//打开文件APP
- (void)presentDocumentCloud {
    NSArray *documentTypes = @[@"public.content", @"public.text", @"public.source-code ", @"public.image", @"public.audiovisual-content", @"com.adobe.pdf", @"com.apple.keynote.key", @"com.microsoft.word.doc", @"com.microsoft.excel.xls", @"com.microsoft.powerpoint.ppt"];
    
    UIDocumentPickerViewController *documentPickerViewController = [[UIDocumentPickerViewController alloc] initWithDocumentTypes:documentTypes inMode:UIDocumentPickerModeOpen];
    documentPickerViewController.delegate = self;
    [self presentViewController:documentPickerViewController animated:YES completion:nil];
}

-(void)documentInteractionController:(UIDocumentInteractionController *)controller didEndSendingToApplication:(NSString *)application {
    NSLog(@"%d",__LINE__);
}

-(void)documentPicker:(UIDocumentPickerViewController *)controller didPickDocumentsAtURLs:(NSArray<NSURL *> *)urls {
    NSLog(@"%d",__LINE__);
    for (NSURL *url in urls) {
        NSLog(@"url1:%@",url);
        //在此已获取到文件，可对文件进行需求上的操作
        
        BOOL fileUrlAuthozied = [url startAccessingSecurityScopedResource];
        if (fileUrlAuthozied) {
            //通过文件协调工具来得到新的文件地址，以此得到文件保护功能
            NSFileCoordinator *fileCoordinator = [[NSFileCoordinator alloc] init];
            NSError *error;
            
            [fileCoordinator coordinateReadingItemAtURL:url options:0 error:&error byAccessor:^(NSURL *newURL) {
                //读取文件
                NSString *fileName = [newURL lastPathComponent];
                NSLog(@"1 fileName:%@",fileName);
                fileName = [fileName stringByRemovingPercentEncoding];
                NSLog(@"2 fileName:%@",fileName);
                NSData * data = [NSData dataWithContentsOfURL:newURL];
                NSLog(@"data length : %lu", data.length);
                [self saveFile:fileName data:data];
            }];
            [url stopAccessingSecurityScopedResource];
        }
    }
}

-(void)saveFile:(NSString *)fileName data:(NSData *)data {
//    NSData *data2 = [@"aaaaa" dataUsingEncoding:NSUTF8StringEncoding];
    NSString *filePath = [docDir stringByAppendingPathComponent:fileName];

    // 创建文件时写入内容
    BOOL suc = [_fileManager createFileAtPath:filePath contents:data attributes:nil];
    if (suc) {
        NSLog(@"写入数据成功!");
    }else{
        NSLog(@"写入数据失败!");
    }
}

- (IBAction)testAction:(UIButton *)sender {
    
}

@end
