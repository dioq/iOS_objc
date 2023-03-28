//
//  HandleCellVC.m
//  ObjectiveC
//
//  Created by Dio Brand on 2023/3/17.
//  Copyright © 2023 my. All rights reserved.
//

#import "HandleCellVC.h"


@interface HandleCellVC ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property(nonatomic,strong)NSMutableArray *dataArray;

@end

@implementation HandleCellVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"操作cell";
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:self action:@selector(rightTopBtn:)];
    self.navigationItem.rightBarButtonItem = barButtonItem;
    
    self.dataArray = [NSMutableArray arrayWithObjects:@"a",@"b",@"c",@"d",@"e",@"f",@"g",@"h",@"i",@"j",@"k",@"l",@"m",@"n", nil];
    
    self.myTableView.delegate = self;
    self.myTableView.dataSource = self;
    //在初始化tableview的时候就去register一个自顶的cell, 这种写法在cellForRowAtIndexPath部分就不用去判断这个cell是否非空
    //使用dequeueReuseableCellWithIdentifier:forIndexPath:必须注册，但返回的cell可省略空值判断的步骤。
    [self.myTableView registerClass:[UITableViewCell classForCoder] forCellReuseIdentifier:CELLID];
}

-(void)rightTopBtn:(UIBarButtonItem *)barButtonItem {
    BOOL isOr = _myTableView.isEditing;
    [self.myTableView setEditing:!isOr animated:YES];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //使用dequeueReuseableCellWithIdentifier:forIndexPath:必须注册，但返回的cell可省略空值判断的步骤。
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELLID forIndexPath:indexPath];
    cell.textLabel.text = self.dataArray[indexPath.row];
    return cell;
}

//返回编辑类型，滑动删除
-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 3) {//row等于3的cell不能删
        return UITableViewCellEditingStyleNone;
    }
    return UITableViewCellEditingStyleDelete;
}

//在这里修改删除按钮的文字
-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"点击删除";
}

//点击删除按钮的响应方法，在这里处理删除的逻辑
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if(editingStyle == UITableViewCellEditingStyleDelete) {
        [self.dataArray removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

@end
