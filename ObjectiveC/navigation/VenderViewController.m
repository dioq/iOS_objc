//
//  SDKViewController.m
//  ObjectiveC
//
//  Created by William on 2018/10/22.
//  Copyright © 2018年 William. All rights reserved.
//

#import "VenderViewController.h"
#import "HUDViewController.h"
#import "MasonryVC.h"
#import "SDViewController.h"
#import "MyShareViewController.h"
#import "AFNetworkingVC.h"
#import "HQFlowViewVC.h"
#import "MenuListViewController.h"
#import "ColorViewController.h"
#import "Color2ViewController.h"
#import "ToastViewController.h"
#import "LottieViewController.h"
#import "DLSlideViewVC.h"
#import "MJRefreshViewController.h"
#import "CheckboxViewController.h"
#import "MMKVViewController.h"

@interface VenderViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property (nonatomic,strong) NSMutableArray *dataArray;

@end

@implementation VenderViewController

-(void)loadData{//添加controller
    self.dataArray = [NSMutableArray array];
    
    MMKVViewController *mmkvVC = [MMKVViewController new];
    mmkvVC.title = @"MMKV";
    [self.dataArray addObject:mmkvVC];
    
    CheckboxViewController *checkboxVC = [CheckboxViewController new];
    checkboxVC.title = @"Checkbox";
    [self.dataArray addObject:checkboxVC];
    
    MJRefreshViewController *mjVC = [MJRefreshViewController new];
    mjVC.title = @"MJRefresh";
    [self.dataArray addObject:mjVC];
    
    DLSlideViewVC *dlsVC = [DLSlideViewVC new];
    dlsVC.title = @"DLSlideView";
    [self.dataArray addObject:dlsVC];
    
    LottieViewController *lottieVC = [LottieViewController new];
    lottieVC.title = @"lottie";
    [self.dataArray addObject:lottieVC];
    
    ToastViewController *toastVC = [ToastViewController new];
    toastVC.title= @"toast";
    [self.dataArray addObject:toastVC];
    
    Color2ViewController *color2VC = [Color2ViewController new];
    color2VC.title = @"颜色选取2";
    [self.dataArray addObject:color2VC];
    
    ColorViewController *colorVC = [ColorViewController new];
    colorVC.title = @"颜色选取";
    [self.dataArray addObject:colorVC];
    
    MenuListViewController *menulistVC = [MenuListViewController new];
    menulistVC.title = @"展开选项列表";
    [self.dataArray addObject:menulistVC];
    
    HQFlowViewVC *hqflowVC = [HQFlowViewVC new];
    hqflowVC.title = @"3D轮播图";
    [self.dataArray addObject:hqflowVC];
    
    AFNetworkingVC *afVC = [AFNetworkingVC new];
    afVC.title = @"AFNetworking";
    [self.dataArray addObject:afVC];
    
    MyShareViewController *shareVC = [MyShareViewController new];
    shareVC.title = @"share";
    [self.dataArray addObject:shareVC];
    
    SDViewController *sdVC = [SDViewController new];
    sdVC.title = @"SDAutoLayout使用事例";
    [self.dataArray addObject:sdVC];
    
    MasonryVC *masVC = [MasonryVC new];
    masVC.title = @"Masonry使用事例";
    [self.dataArray addObject:masVC];
    
    HUDViewController *hudVC = [[HUDViewController alloc] init];
    hudVC.title = [NSString stringWithFormat:@"MBProgressHUD"];
    [self.dataArray addObject:hudVC];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"SDK";
    [self loadData];

    if (@available(iOS 11.0, *)) {//判断系统版本
        self.myTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
