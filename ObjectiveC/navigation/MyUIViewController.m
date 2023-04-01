//
//  MyUIViewController.m
//  ObjectiveC
//
//  Created by William on 2018/10/22.
//  Copyright © 2018年 William. All rights reserved.
//

#import "MyUIViewController.h"
#import "WKWebViewVC.h"
#import "WKWebViewDelegateVC.h"
#import "WebViewJSCode.h"
#import "WebViewJSCode2.h"
#import "MyVideoViewController.h"
#import "MyCollectionViewVC.h"
#import "NibCollectionViewVC.h"
#import "CustomViewVC.h"
#import "PhotoViewController.h"
#import "BrowerViewController.h"
#import "MyFontViewController.h"
#import "ModalViewController.h"
#import "LabelViewController.h"
#import "ButtonViewController.h"
#import "SliderViewController.h"
#import "TouchViewController.h"
#import "AlertViewController.h"
#import "ToolBarViewController.h"
#import "HandleCellVC.h"
#import "WindowViewController.h"

@interface MyUIViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property (nonatomic,strong) NSMutableArray *dataArray;

@end

@implementation MyUIViewController

-(void)loadData{//添加controller
    self.dataArray = [NSMutableArray array];
    
    WindowViewController *windowVC = [WindowViewController new];
    windowVC.title = @"window 研究";
    [self.dataArray addObject:windowVC];
    
    HandleCellVC *tbvc = [HandleCellVC new];
    tbvc.title = @"操作cell";
    [self.dataArray addObject:tbvc];
    
    ToolBarViewController *toolBarVC = [ToolBarViewController new];
    toolBarVC.title = @"状态栏";
    [self.dataArray addObject:toolBarVC];
    
    AlertViewController *alertVC = [AlertViewController new];
    alertVC.title = @"Alert";
    [self.dataArray addObject:alertVC];
    
    TouchViewController *touchVC = [TouchViewController new];
    touchVC.title = @"View touch 捕抓轨迹";
    [self.dataArray addObject:touchVC];
    
    SliderViewController *sliderVC = [SliderViewController new];
    sliderVC.title = @"UISlider";
    [self.dataArray addObject:sliderVC];
    
    ButtonViewController *btnVC = [ButtonViewController new];
    btnVC.title = @"UIButton";
    [self.dataArray addObject:btnVC];
    
    LabelViewController *labelVC = [LabelViewController new];
    labelVC.title = @"UILabel";
    [self.dataArray addObject:labelVC];
    
    ModalViewController *modalVC = [ModalViewController new];
    modalVC.title = @"模态跳转";
    [self.dataArray addObject:modalVC];
    
    MyFontViewController *fontVC = [MyFontViewController new];
    fontVC.title = @"自定义字体";
    [self.dataArray addObject:fontVC];
    
    BrowerViewController *browerVC = [BrowerViewController new];
    browerVC.title = @"跳转到浏览器";
    [self.dataArray addObject:browerVC];
    
    PhotoViewController *photoVC = [PhotoViewController new];
    photoVC.title = @"Photo";
    [self.dataArray addObject:photoVC];
    
    CustomViewVC *codeViewVC = [CustomViewVC new];
    codeViewVC.title = @"自定义View";
    [self.dataArray addObject:codeViewVC];
    
    NibCollectionViewVC *nibCollVC = [NibCollectionViewVC new];
    nibCollVC.title = @"nib CollectionView";
    [self.dataArray addObject:nibCollVC];
    
    MyCollectionViewVC *collectionVC = [MyCollectionViewVC new];
    collectionVC.title = @"代码CollectionView";
    [self.dataArray addObject:collectionVC];
    
    MyVideoViewController *videoVC = [MyVideoViewController new];
    videoVC.title = @"Video";
    [self.dataArray addObject:videoVC];
    
    WebViewJSCode2 *jscodeVC2 = [WebViewJSCode2 new];
    jscodeVC2.title = @"webview js往 app 传不同的参数";
    [self.dataArray addObject:jscodeVC2];
    
    WebViewJSCode *jscodeVC = [WebViewJSCode new];
    jscodeVC.title = @"webview 中与 js 交互";
    [self.dataArray addObject:jscodeVC];
    
    WKWebViewDelegateVC *wk2 = [WKWebViewDelegateVC new];
    wk2.title = @"WKWebView delegate";
    [self.dataArray addObject:wk2];
    
    WKWebViewVC *wk = [WKWebViewVC new];
    wk.title = @"WKWebView load";
    [self.dataArray addObject:wk];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"UI";
    [self loadData];
    self.myTableView.delegate = self;
    self.myTableView.dataSource = self;
    [self.myTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cellID"];
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellID"];
    if(cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellID"];
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


@end
