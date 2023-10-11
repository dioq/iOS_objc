//
//  OtherViewController.m
//  ObjectiveC
//
//  Created by hello on 2019/3/17.
//  Copyright © 2019 William. All rights reserved.
//

#import "OtherViewController.h"
#import "ClearCacheViewController.h"
#import "JudgeNetworkingVC.h"
#import "LocalizableViewController.h"
#import "OrientationVC.h"
#import "SpeechViewController.h"
#import "JumpAppViewController.h"
#import "ParseViewController.h"
#import "ChangeIconViewController.h"
#import "CryptoViewController.h"
#import "SandboxViewController.h"
#import "SystemFileViewController.h"
#import "FilesystemViewController.h"
#import "DeviceIDViewController.h"
#import "MyNetworkViewController.h"
#import "ContactsViewController.h"
#import "ScreenshotViewController.h"
#import "RegularViewController.h"
#import "MyAlertViewController.h"
#import "CompressViewController.h"
#import "ProtobufViewController.h"

@interface OtherViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property (nonatomic,strong) NSMutableArray *dataArray;

@end

@implementation OtherViewController

-(void)loadData{//添加controller
    self.dataArray = [NSMutableArray array];
    
    ProtobufViewController *protobufVC = [ProtobufViewController new];
    protobufVC.title = @"Protobuf 数据序列化";
    [self.dataArray addObject:protobufVC];
    
    CompressViewController *compressVC = [CompressViewController new];
    compressVC.title = @"数据的压缩和解压";
    [self.dataArray addObject:compressVC];
    
    MyAlertViewController *alertVC = [MyAlertViewController new];
    alertVC.title = @"自定义提示框";
    [self.dataArray addObject:alertVC];
    
    RegularViewController *regularVC = [RegularViewController new];
    regularVC.title = @"正则表达式";
    [self.dataArray addObject:regularVC];
    
    ScreenshotViewController *screenshotVC = [ScreenshotViewController new];
    screenshotVC.title = @"截图";
    [self.dataArray addObject:screenshotVC];
    
    ContactsViewController *contactsVC = [ContactsViewController new];
    contactsVC.title = @"通讯录";
    [self.dataArray addObject:contactsVC];
    
    MyNetworkViewController *myNet = [MyNetworkViewController new];
    myNet.title = @"自己封装的网络工具";
    [self.dataArray addObject:myNet];
    
    DeviceIDViewController *deviceUUID = [DeviceIDViewController new];
    deviceUUID.title = @"设备唯一标识符";
    [self.dataArray addObject:deviceUUID];
    
    SandboxViewController *sandboxVC = [SandboxViewController new];
    sandboxVC.title = @"Sandbox";
    [self.dataArray addObject:sandboxVC];
    
    SystemFileViewController *fileVC = [SystemFileViewController new];
    fileVC.title = @"系统File";
    [self.dataArray addObject:fileVC];
    
    FilesystemViewController *filesysVC = [FilesystemViewController new];
    filesysVC.title = @"文件操作";
    [self.dataArray addObject:filesysVC];
    
    CryptoViewController *encryptionVC = [CryptoViewController new];
    encryptionVC.title = @"加密与解密";
    [self.dataArray addObject:encryptionVC];
    
    ChangeIconViewController *changeIconVC = [[ChangeIconViewController alloc] init];
    changeIconVC.title = @"更改App icon";
    [self.dataArray addObject:changeIconVC];
    
    ParseViewController *parseVC = [ParseViewController new];
    parseVC.title = @"解析JSON";
    [self.dataArray addObject:parseVC];
    
    JumpAppViewController *messageVC = [JumpAppViewController new];
    messageVC.title = @"App间跳转";
    [self.dataArray addObject:messageVC];
    
    SpeechViewController *speechVC = [SpeechViewController new];
    speechVC.title = @"语音处理";
    [self.dataArray addObject:speechVC];
    
    OrientationVC *orientationVC = [OrientationVC new];
    orientationVC.title = @"屏幕方向变化";
    [self.dataArray addObject:orientationVC];
    
    LocalizableViewController *localizableVC= [LocalizableViewController new];
    localizableVC.title = @"本地化";
    [self.dataArray addObject:localizableVC];
    
    JudgeNetworkingVC *judgeVC = [JudgeNetworkingVC new];
    judgeVC.title = @"网络判断";
    [self.dataArray addObject:judgeVC];
    
    ClearCacheViewController *clearCacheVC = [ClearCacheViewController new];
    clearCacheVC.title = @"清理缓存";
    [self.dataArray addObject:clearCacheVC];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"Other";
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
