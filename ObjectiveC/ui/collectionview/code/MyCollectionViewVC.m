//
//  MyCollectionViewVC.m
//  ObjectiveC
//
//  Created by lzd_free on 2019/2/27.
//  Copyright © 2019 William. All rights reserved.
//

#import "MyCollectionViewVC.h"
#import "MyCollectionViewCell.h"

@interface MyCollectionViewVC ()<UICollectionViewDelegate, UICollectionViewDataSource>

@property(nonatomic, strong)UICollectionView *myCollectionView;
@property(nonatomic, strong)NSMutableArray *dataArray;

@end

@implementation MyCollectionViewVC

static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"code collectionview";
    
    self.dataArray = [NSMutableArray array];
    for (int i = 0; i < 10; i++) {
        NSString *value = [NSString stringWithFormat:@"第%d个cell",i];
        [self.dataArray addObject:value];
    }
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    // 定义大小
    layout.itemSize = CGSizeMake(100, 100);
    // 设置最小行间距
    layout.minimumLineSpacing = 10;
    // 设置垂直间距
    layout.minimumInteritemSpacing = 10;
    // 设置滚动方向（默认垂直滚动）
    //    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    // 设置边缘的间距，默认是{0，0，0，0}
    layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    
    self.myCollectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    [self.myCollectionView registerClass:MyCollectionViewCell.class forCellWithReuseIdentifier:reuseIdentifier];
    self.myCollectionView.backgroundColor = [UIColor greenColor];
    [self.view addSubview:self.myCollectionView];
    self.myCollectionView.delegate = self;
    self.myCollectionView.dataSource = self;
}


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 3;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    MyCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"点击的是section:%ld\trow:%ld", indexPath.section, indexPath.row);
}

@end
