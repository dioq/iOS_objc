//
//  MJRefreshViewController.m
//  ObjectiveC
//
//  Created by hello on 2019/9/18.
//  Copyright © 2019 William. All rights reserved.
//

#import "MJRefreshViewController.h"
#import <MJRefresh.h>

@interface MJRefreshViewController ()<UITableViewDelegate, UITableViewDataSource>
{
    NSString *identifier;
}
@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property (nonatomic, strong)NSMutableArray *dataArray;

@end

@implementation MJRefreshViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"MJRefresh";
    
    self.dataArray = [NSMutableArray arrayWithObjects:@"我是谁",@"我从哪里来",@"我要到哪里去", nil];
    
    identifier = @"cellid";
    self.myTableView.delegate = self;
    self.myTableView.dataSource = self;
    [self.myTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:identifier];
    
    
    //    self.myTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refresTop)];//用方法回调
    self.myTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self.dataArray insertObject:@"顶------部刷新添加数据" atIndex:0];
        [self.myTableView.mj_header endRefreshing];
        [self.myTableView reloadData];
    }];//用Block回调
    
    //    self.myTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(refresBottom)];//用方法回调
    self.myTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [self.dataArray addObject:@"底=======部刷新添加数据"];
        [self.myTableView.mj_footer endRefreshing];
        [self.myTableView reloadData];
    }];//用Block回调
    
}

-(void)refresTop{
    [self.dataArray insertObject:@"顶------部刷新添加数据" atIndex:0];
    [self.myTableView.mj_header endRefreshing];
    [self.myTableView reloadData];
}

-(void)refresBottom{
    [self.dataArray addObject:@"底=======部刷新添加数据"];
    [self.myTableView.mj_footer endRefreshing];
    [self.myTableView reloadData];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    cell.textLabel.text = [self.dataArray objectAtIndex:indexPath.row];
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

@end
