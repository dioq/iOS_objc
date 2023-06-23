//
//  PasteboardViewController.m
//  ObjectiveC
//
//  Created by zd on 19/6/2023.
//  Copyright © 2023 my. All rights reserved.
//

#import "PasteboardViewController.h"

/*
 + (UIPasteboard *)generalPasteboard;系统级别的剪切板在整个设备中共享，而且会持久化，即应用程序被删掉，其向系统级的剪切板中写入的数据依然在。
 + (nullable UIPasteboard *)pasteboardWithName:(NSString *)pasteboardName create:(BOOL)create;自定义的剪切板通过一个特定的名称字符串进行创建，它在应用程序内或者同一开发者开发(必须Bundle Identifier 例com.maoshaoqian.** 星号前部一样)的其他应用程序中可以进行数据共享。举个例子：比如你开发了多款应用，用户全部下载了，在A应用中用户拷贝了一些数据（为了数据安全，不用系统级别的Pasteboard），在打开B应用时就会自动识别，提高用户体验。
 + (UIPasteboard *)pasteboardWithUniqueName;第3个方法创建的剪切板等价为使用第2个方法创建的剪切板，只是其名称字符串为nil，它通常用于当前应用内部。（当然也可以跨应用使用，但必须Bundle Identifier 例com.maoshaoqian.** 星号前部一样）
 **/
@interface PasteboardViewController ()

@end

@implementation PasteboardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (IBAction)write:(UIButton *)sender {
    [[UIPasteboard generalPasteboard] setString:@"This is a test string for pasteboard ..."];
}

- (IBAction)read:(UIButton *)sender {
    NSString *str = [[UIPasteboard generalPasteboard] string];
    NSLog(@"%@",str);
}

- (IBAction)write_custom:(UIButton *)sender {
    //获取一个自定义的剪切板 name参数为此剪切板的名称 create参数用于设置当这个剪切板不存在时 是否进行创建
    UIPasteboard *pasteboard = [UIPasteboard pasteboardWithName:@"myself" create:YES];
    [pasteboard setString:@"This is seconf test string for pasteboard ..."];
}

- (IBAction)read_custom:(UIButton *)sender {
    UIPasteboard *pasteboard = [UIPasteboard pasteboardWithName:@"myself" create:YES];
    NSString *str = [pasteboard string];
    NSLog(@"%@",str);
}

@end
