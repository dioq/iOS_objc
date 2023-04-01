//
//  KVOViewController.m
//  ObjectiveC
//
//  Created by hello on 2019/10/11.
//  Copyright © 2019 William. All rights reserved.
//

#import "KVOViewController.h"
#import "Person2.h"

@interface KVOViewController ()

@property(nonatomic, strong)Person2 *person;

@end

@implementation KVOViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //导航栏右按钮
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"改变值" style:UIBarButtonItemStylePlain target:self action:@selector(changeValue)];
    
    self.person = [[Person2 alloc] init];
    self.person.name = @"最初的名字";
    
    /*
     options: 有4个值，分别是：
     
     　　NSKeyValueObservingOptionOld 把更改之前的值提供给处理方法
     
     　　NSKeyValueObservingOptionNew 把更改之后的值提供给处理方法
     
     　　NSKeyValueObservingOptionInitial 把初始化的值提供给处理方法，一旦注册，立马就会调用一次。通常它会带有新值，而不会带有旧值。
     
     　　NSKeyValueObservingOptionPrior 分2次调用。在值改变之前和值改变之后。
     */
    [self.person addObserver:self forKeyPath:@"name" options:NSKeyValueObservingOptionNew context:nil];
}

#pragma mark - kvo的回调方法(系统提供的回调方法)
//keyPath:属性名称
//object:被观察的对象
//change:变化前后的值都存储在change字典中
//context:注册观察者的时候,context传递过来的值
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    id oldName = [change objectForKey:NSKeyValueChangeOldKey];
    NSLog(@"oldName----------%@",oldName);
    id newName = [change objectForKey:NSKeyValueChangeNewKey];
    NSLog(@"newName-----------%@",newName);
}

-(void)changeValue{
    static int i = 0;
    self.person.name = [NSString stringWithFormat:@"第 %i 个值", i];
    i++;
}

//界面销毁时 移除观察者
- (void)dealloc {
    [self.person removeObserver:self forKeyPath:@"name"];
    self.person = nil;
}

@end
