//
//  SetViewController.m
//  ObjectiveC
//
//  Created by Dio Brand on 2023/4/28.
//  Copyright © 2023 my. All rights reserved.
//

#import "SetViewController.h"

@interface SetViewController ()

@end

@implementation SetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"集合";
}

- (IBAction)set_show:(UIButton *)sender {
    //set集合的操作
    //便利初始化函数
    NSSet *set1 = [[NSSet alloc] initWithObjects:@"aa", @"bb", @"cc", @"dd", nil];
    //便利构造器
    NSSet *set2 = [NSSet setWithObjects:@"AA", @"BB", @"CC", nil];
    
    //获取集合中元素的个数
    unsigned long count = [set1 count];
    NSLog(@"set1里面的元素的个数为：%lu", count);
    
    //遍历集合：把set集合转换为数组然后进行遍历
    NSArray *setToArray = [set2 allObjects];
    array_display(setToArray);
    
    //随机获取Set中元素
    id element = [set1 anyObject];
    NSLog(@"随机获取其中的值%@", element);
    
    //比较两个Set是否相等
    if ([set1 isEqualToSet:set2] == NO) {
        NSLog(@"set1 != set2");
    }
    
    //查看一个元素是否在一个set中
    if ([set1 member:@"aa"]) {
        NSLog(@"aa 在set1中");
    }
}

- (IBAction)mutable_set:(UIButton *)sender {
    //set可变集合
    //便利初始化函数分配大小
    NSMutableSet *mutableSet1 = [[NSMutableSet alloc] initWithCapacity:3];
    NSMutableSet *mutableSet2 = [NSMutableSet setWithCapacity:3];
    NSMutableSet *mutableSet3 = [[NSMutableSet alloc] init];
    
    //添加元素
    [mutableSet1 addObject:@"aaa"];
    [mutableSet1 addObject:@"BBB"];
    [mutableSet1 addObject:@"bbb"];
    
    //删除元素
    [mutableSet1 removeObject:@"BBB"];
    
    //遍历Set
    NSArray *setArray = [mutableSet1 allObjects];
    array_display(setArray);
}

//封装遍历数组的函数
void array_display(id array)
{
    for (int i = 0 ; i < [array count]; i++) {
        id temp = [array objectAtIndex:i];
        NSLog(@"%@", temp);
    }
}

@end
