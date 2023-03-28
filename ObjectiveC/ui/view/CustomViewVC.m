//
//  CodeViewController.m
//  ObjectiveC
//
//  Created by lzd_free on 2019/2/27.
//  Copyright © 2019 William. All rights reserved.
//

#import "CustomViewVC.h"
#import "MyView.h"
#import "MyNibView.h"
#import "BookModel.h"

@interface CustomViewVC ()

@end

@implementation CustomViewVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"自定义View";
    
    BookModel *book = [[BookModel alloc] init];
    book.name = @"美人鱼";
    book.icon = @"1";
    
    MyView *myview = [[MyView alloc] initWithFrame:CGRectMake(10, 100, 120, 140)];
    myview.backgroundColor = [UIColor orangeColor];
    myview.book = book;
    [self.view addSubview:myview];
    
    
    NSArray *nibViews =  [[NSBundle mainBundle] loadNibNamed:@"MyNibView" owner:self options:nil];
    MyNibView *nibView = [nibViews objectAtIndex:0];
    nibView.frame = CGRectMake(ScreenWidth - 130, 100, 120, 140);
    nibView.backgroundColor = [UIColor yellowColor];
    nibView.book = book;
    [self.view addSubview:nibView];
}

@end
