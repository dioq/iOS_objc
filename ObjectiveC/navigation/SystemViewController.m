//
//  StudyViewController.m
//  ObjectiveC
//
//  Created by William on 2018/10/22.
//  Copyright © 2018年 William. All rights reserved.
//

#import "SystemViewController.h"
#import "LazyloadViewController.h"
#import "SingletonViewController.h"
#import "GCDViewController.h"
#import "ThreadViewController.h"
#import "DelegateViewController.h"
#import "DeviceViewController.h"
#import "NSURLSessionVC.h"
#import "PolymorphismViewController.h"
#import "KVOViewController.h"
#import "BlockViewController.h"
#import "SerializeViewController.h"
#import "HTTPS1WayViewController.h"
#import "HTTPSPing01ViewController.h"
#import "HTTPSPing02ViewController.h"
#import "HTTPS2WayViewController.h"
#import "DataTypeViewController.h"
#import "NSUserDefaultsVC.h"
#import "StringViewController.h"
#import "TimeViewController.h"
#import "NSTimerViewController.h"
#import "CategoryViewController.h"
#import "NotificationVC.h"
#import "CFObjectViewController.h"
#import "AVPlayerViewController.h"
#import "SetViewController.h"
#import "PlistViewController.h"
#import "PasteboardViewController.h"
#import "SandboxViewController.h"
#import "SystemFileViewController.h"
#import "FilesystemViewController.h"

@interface SystemViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property (nonatomic,strong) NSMutableArray *dataArray;

@end

@implementation SystemViewController

-(void)loadData{//添加controller
    self.dataArray = [NSMutableArray array];
    
    SandboxViewController *sandboxVC = [SandboxViewController new];
    sandboxVC.title = @"Sandbox";
    [self.dataArray addObject:sandboxVC];
    
    SystemFileViewController *fileVC = [SystemFileViewController new];
    fileVC.title = @"系统File";
    [self.dataArray addObject:fileVC];
    
    FilesystemViewController *filesysVC = [FilesystemViewController new];
    filesysVC.title = @"文件操作";
    [self.dataArray addObject:filesysVC];
    
    PasteboardViewController *pasteboardVC = [PasteboardViewController new];
    pasteboardVC.title = @"Pasteboard";
    [self.dataArray addObject:pasteboardVC];
    
    PlistViewController *plistVC = [PlistViewController new];
    plistVC.title = @"处理 plist 配置文件";
    [self.dataArray addObject:plistVC];
    
    AVPlayerViewController *playerVC = [AVPlayerViewController new];
    playerVC.title = @"音频播放";
    [self.dataArray addObject:playerVC];
    
    CFObjectViewController *cfVC = [CFObjectViewController new];
    cfVC.title = @"Core Foundation 数据类型";
    [self.dataArray addObject:cfVC];
    
    SetViewController *setVC = [SetViewController new];
    setVC.title = @"集合";
    [self.dataArray addObject:setVC];
    
    DataTypeViewController *dataTypeVC = [DataTypeViewController new];
    dataTypeVC.title = @"objc Foundation 数据类型";
    [self.dataArray addObject:dataTypeVC];
    
    NotificationVC *notiVC = [NotificationVC new];
    notiVC.title = @"Notification 通知";
    [self.dataArray addObject:notiVC];
    
    CategoryViewController *categoryVC = [CategoryViewController new];
    categoryVC.title = @"Category 类别";
    [self.dataArray addObject:categoryVC];
    
    NSTimerViewController *timerVC = [NSTimerViewController new];
    timerVC.title = @"NSTimer 使用";
    [self.dataArray addObject:timerVC];
    
    TimeViewController *timeVC = [TimeViewController new];
    timeVC.title = @"Time时间";
    [self.dataArray addObject:timeVC];
    
    StringViewController *strVC = [StringViewController new];
    strVC.title = @"String";
    [self.dataArray addObject:strVC];
    
    NSUserDefaultsVC *udVC = [NSUserDefaultsVC new];
    udVC.title = @"NSUserDefaults";
    [self.dataArray addObject:udVC];
    
    HTTPS1WayViewController *https1VC = [HTTPS1WayViewController new];
    https1VC.title = @"Https 单向验证";
    [self.dataArray addObject:https1VC];
    
    HTTPSPing01ViewController *httpsPing01VC = [HTTPSPing01ViewController new];
    httpsPing01VC.title = @"Https 证书绑定 SSL ping 实现方式1";
    [self.dataArray addObject:httpsPing01VC];
    
    HTTPSPing02ViewController *httpsPing02VC = [HTTPSPing02ViewController new];
    httpsPing02VC.title = @"Https 证书绑定 SSL ping 实现方式2";
    [self.dataArray addObject:httpsPing02VC];
    
    HTTPS2WayViewController *https2VC = [HTTPS2WayViewController new];
    https2VC.title = @"Https 双向验证";
    [self.dataArray addObject:https2VC];
    
    NSURLSessionVC *networkVC = [NSURLSessionVC new];
    networkVC.title = @"原生网络请求";
    [self.dataArray addObject:networkVC];
    
    SerializeViewController *serializeVC = [SerializeViewController new];
    serializeVC.title = @"Archiver 序列化";
    [self.dataArray addObject:serializeVC];
    
    BlockViewController *blockVC = [[BlockViewController alloc] init];
    blockVC.title = @"Block";
    [self.dataArray addObject:blockVC];
    
    KVOViewController *kvoVC = [KVOViewController new];
    kvoVC.title = @"KVO";
    [self.dataArray addObject: kvoVC];
    
    PolymorphismViewController *polyVC = [PolymorphismViewController new];
    polyVC.title = @"多态";
    [self.dataArray addObject:polyVC];
    
    DeviceViewController *devVC = [DeviceViewController new];
    devVC.title = @"设备信息";
    [self.dataArray addObject:devVC];
    
    DelegateViewController *delegateVC = [DelegateViewController new];
    delegateVC.title = @"delegate";
    [self.dataArray addObject:delegateVC];
    
    ThreadViewController *threadVC = [ThreadViewController new];
    threadVC.title = @"thread 线程";
    [self.dataArray addObject:threadVC];
    
    GCDViewController *GCDVC = [GCDViewController new];
    GCDVC.title = @"GCD";
    [self.dataArray addObject:GCDVC];
    
    SingletonViewController *singletonVC = [SingletonViewController new];
    singletonVC.title = @"单例";
    [self.dataArray addObject:singletonVC];
    
    LazyloadViewController *lazy = [LazyloadViewController new];
    lazy.title = @"lazyload";
    [self.dataArray addObject:lazy];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"language";
    [self loadData];
    
    self.myTableView.delegate = self;
    self.myTableView.dataSource = self;
    [self.myTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:CELLID];
}

//Sections数量
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
//Row数量
- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELLID];
    if(cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CELLID];
    }
    UIViewController *anyVC = _dataArray[indexPath.row];
    cell.textLabel.text = anyVC.title;
    return cell;
}
//点击cell事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UIViewController *anyVC = _dataArray[indexPath.row];
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:anyVC animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}

@end
