//
//  PasteboardViewController.m
//  ObjectiveC
//
//  Created by zd on 19/6/2023.
//  Copyright © 2023 my. All rights reserved.
//

#import "PasteboardViewController.h"

/*
 + (UIPasteboard *)generalPasteboard;
 系统级别的剪切板在整个设备中共享，而且会持久化，即应用程序被删掉，其向系统级的剪切板中写入的数据依然存在
 
 + (nullable UIPasteboard *)pasteboardWithName:(NSString *)pasteboardName create:(BOOL)create;
 自定义的剪切板用pasteboardName进行标识，只能在同一个开发者账号签名的App 中共享数据。
 举个例子：比如你开发了多款应用，用户全部下载了，在A应用中用户拷贝了一些数据（为了数据安全，不用系统级别的Pasteboard），在打开B应用时就会自动识别，提高用户体验。
 
 + (UIPasteboard *)pasteboardWithUniqueName;
 第3个方法创建的剪切板等价为使用第2个方法创建的剪切板，只是其名称字符串为nil
 
 
 //剪切板内容发生变化时发送的通知
 UIKIT_EXTERN NSString *const UIPasteboardChangedNotification;
 //剪切板数据类型键值增加时发送的通知
 UIKIT_EXTERN NSString *const UIPasteboardChangedTypesAddedKey;
 //剪切板数据类型键值移除时发送的通知
 UIKIT_EXTERN NSString *const UIPasteboardChangedTypesRemovedKey;
 //剪切板被删除时发送的通知
 UIKIT_EXTERN NSString *const UIPasteboardRemovedNotification;
 //使用举例
 //当剪切板被删除时，监听通知，可处理相应事件；
 [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(menuControllerWillHide) name:UIPasteboardRemovedNotification object:nil];
 **/

@interface PasteboardViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *imgv;

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
    UIPasteboard *pasteboard = [UIPasteboard pasteboardWithName:@"pbid1" create:YES];
    [pasteboard setString:@"This is seconf test string for pasteboard ..."];
}

- (IBAction)read_custom:(UIButton *)sender {
    UIPasteboard *pasteboard = [UIPasteboard pasteboardWithName:@"pbid1" create:YES];
    NSString *str = [pasteboard string];
    NSLog(@"%@",str);
}

- (IBAction)many_save_act:(UIButton *)sender {
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    
    NSMutableArray<NSDictionary *> *mutArr = [[NSMutableArray alloc] init];
    
    NSMutableDictionary<NSString *, NSData *> *mutDict = [[NSMutableDictionary alloc] init];
    for (int i = 0; i < 5; i++) {
        NSString *key = [NSString stringWithFormat:@"key%d",i];
        NSString *value = [NSString stringWithFormat:@"This is a test string for value.%d",i];
        NSData *dt = [value dataUsingEncoding:NSUTF8StringEncoding];
        [mutDict setObject:dt forKey:key];
    }
    
    [mutArr addObject:[mutDict copy]];
    [mutArr addObject:[mutDict copy]];
    
    pasteboard.items = [mutArr copy];
    
    NSLog(@"many save on pasteboard");
}

- (IBAction)many_read_act:(UIButton *)sender {
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    
    NSLog(@"numberOfItems:%lu",pasteboard.numberOfItems);
    NSLog(@"items.count:%lu",pasteboard.items.count);
    if(pasteboard.numberOfItems == 0) {
        return;
    }
    
    //    NSMutableIndexSet *mutSet = [[NSMutableIndexSet alloc] init];
    //    for (int i = 0; i < pasteboard.numberOfItems; i++) {
    //        [mutSet addIndex:i];
    //    }
    //    NSArray *item = [pasteboard pasteboardTypesForItemSet:mutSet];
    //    NSLog(@"%@",item);
    
    NSLog(@"%@",pasteboard.items);
}

- (IBAction)file_save_act:(UIButton *)sender {
    UIImage *img = [UIImage imageNamed:@"music_on"];
    NSData *data = UIImagePNGRepresentation(img);
    
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    [pasteboard setData:data forPasteboardType:@"test.png"];
}

- (IBAction)file_get_act:(UIButton *)sender {
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    
    NSData *data = [pasteboard dataForPasteboardType:@"test.png"];
    
    UIImage *img = [UIImage imageWithData:data];
    [self.imgv setImage:img];
}

- (IBAction)monitor_act:(UIButton *)sender {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handle_monitor) name:UIPasteboardChangedNotification object:nil];
    NSLog(@"monitor 开始");
}

-(void)handle_monitor {
    NSLog(@"剪切板内容发生变化 .....");
}

@end
