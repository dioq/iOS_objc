//
//  DocumentPickerVC.m
//  ObjectiveC
//
//  Created by zd on 9/8/2024.
//  Copyright © 2024 my. All rights reserved.
//

#import "DocumentPickerVC.h"

@interface DocumentPickerVC ()<UIDocumentPickerDelegate, UIDocumentInteractionControllerDelegate>
{
    NSString *docDir;
}
@property(nonatomic, strong)NSFileManager *fileManager;
@property(nonatomic, strong)NSArray *documentTypes;

@end

@implementation DocumentPickerVC

/*
 Document 共享权限
 UIFileSharingEnabled                           YES
 LSSupportsOpeningDocumentsInPlace              YES
 **/

/*
 documentPickerMode
 
 UIDocumentPickerModeImport：用户选择一个外部文档，文档选择器拷贝该文档到应用沙盒，不会修改源文档。
 UIDocumentPickerModeOpen：打开一个外部文档，用户可以修改该文档。
 UIDocumentPickerModeExportToService：文档选择器拷贝文档到一个外部路径，不会修改源文档。
 UIDocumentPickerModeMoveToService：拷贝文档到外部路径，同时可以修改该拷贝。
 **/

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _fileManager = [NSFileManager defaultManager];
    // 获取Documents目录路径
    docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES) firstObject];
    NSLog(@"docDir:\n%@",docDir);
    
    
    self.documentTypes = @[@"public.item",@"public.content"];
}

- (IBAction)import_btn_act:(UIButton *)sender {
    // 自动导入到 NSTemporaryDirectory() 目录下
    UIDocumentPickerViewController *documentPickerViewController = [[UIDocumentPickerViewController alloc] initWithDocumentTypes:self.documentTypes inMode:UIDocumentPickerModeImport];
    documentPickerViewController.delegate = self;
    [self presentViewController:documentPickerViewController animated:YES completion:nil];
}

- (IBAction)open_btn_act:(UIButton *)sender {
    UIDocumentPickerViewController *documentPickerViewController = [[UIDocumentPickerViewController alloc] initWithDocumentTypes:self.documentTypes inMode:UIDocumentPickerModeOpen];
    documentPickerViewController.delegate = self;
    [self presentViewController:documentPickerViewController animated:YES completion:nil];
}

- (IBAction)ExportToService_btn_act:(UIButton *)sender { // 未实现
    NSLog(@"%s",__FUNCTION__);
    //    UIDocumentPickerViewController *documentPickerViewController = [[UIDocumentPickerViewController alloc] initWithDocumentTypes:self.documentTypes inMode:UIDocumentPickerModeExportToService];
    //    documentPickerViewController.delegate = self;
    //    [self presentViewController:documentPickerViewController animated:YES completion:nil];
}

- (IBAction)MoveToService_btn_act:(UIButton *)sender { // 未实现
    NSLog(@"%s",__FUNCTION__);
    //    UIDocumentPickerViewController *documentPickerViewController = [[UIDocumentPickerViewController alloc] initWithDocumentTypes:self.documentTypes inMode:UIDocumentPickerModeMoveToService];
    //    documentPickerViewController.delegate = self;
    //    [self presentViewController:documentPickerViewController animated:YES completion:nil];
}

//-(void)documentInteractionController:(UIDocumentInteractionController *)controller didEndSendingToApplication:(NSString *)application {
//    NSLog(@"%s application:%@",__FUNCTION__,application);
//}

-(void)documentPicker:(UIDocumentPickerViewController *)controller didPickDocumentsAtURLs:(NSArray<NSURL *> *)urls {
    NSLog(@"%s",__FUNCTION__);
    NSError *error;
    for (NSURL *url in urls) {
        NSLog(@"%d: url:%@",__LINE__,url);
        if (controller.documentPickerMode == UIDocumentPickerModeOpen) {
            //在此已获取到文件，可对文件进行需求上的操作
            BOOL fileUrlAuthozied = [url startAccessingSecurityScopedResource];
            if (fileUrlAuthozied) {
                //通过文件协调工具来得到新的文件地址，以此得到文件保护功能
                NSFileCoordinator *fileCoordinator = [[NSFileCoordinator alloc] init];
                [fileCoordinator coordinateReadingItemAtURL:url options:0 error:&error byAccessor:^(NSURL *newURL) {
                    NSLog(@"%d: url:%@",__LINE__,newURL);
                    //读取文件
                    NSString *fileName = [newURL lastPathComponent];
                    fileName = [fileName stringByRemovingPercentEncoding];
                    NSLog(@"fileName:%@",fileName);
                    NSData *data = [NSData dataWithContentsOfURL:newURL];
                    NSLog(@"data length : %lu", data.length);
                    [self write:fileName data:data];
                }];
                [url stopAccessingSecurityScopedResource];
            }
        }
    }
}

-(void)write:(NSString *)fileName data:(NSData *)data {
    NSString *filePath = [docDir stringByAppendingPathComponent:fileName];
    NSLog(@"filePath:%@",filePath);
    // 创建文件时写入内容
    BOOL suc = [_fileManager createFileAtPath:filePath contents:data attributes:nil];
    if (suc) {
        NSLog(@"写入数据成功!");
    }else{
        NSLog(@"写入数据失败!");
    }
}

@end
