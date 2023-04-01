//
//  PolymorphismViewController.m
//  ObjectiveC
//
//  Created by hello on 2019/9/17.
//  Copyright © 2019 William. All rights reserved.
//

#import "PolymorphismViewController.h"
#import "CHChina.h"

#import "Osier.h"
#import "PineTree.h"

/*
 oc中的指针类型变量有两个：一个是编译时类型，一个是运行时类型，编译时类型由声明该变量时使用的类型决定，运行时类型由实际赋给该变量的对象决定。如果编译时类型和运行时类型不一致，就有可能出现多态。
 **/

@interface PolymorphismViewController ()

@end

@implementation PolymorphismViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"多态";
//    [self study1];
    [self study2];
}

//理解二
-(void)study2{
    //父类的指针指向子类的对象
    Tree *t1 = [[Osier alloc] init];
    [t1 grow];
    Tree *t2 = [[PineTree alloc] init];
    [t2 grow];
}

//理解一
-(void)study1{
    //    下面编译时类型和运行时类型完全一样，因此不存在多态
    CHPerson *person = [[CHPerson alloc]init];
    [person eat];
    
    //    下面编译时类型和运行时类型完全一样，因此不存在多态
    CHChina *china = [[CHChina alloc]init];
    [china eat];
    
    //    下面编译时类型和运行时类型不一样，因此发生多态
    CHPerson *perch = [[CHChina alloc]init];
    //    调用从父类继承的play方法
    [perch play];
    //    调用子类重写eat方法
    [perch eat];
    
    //    因为perch的编译时类型是CHPerson，但CHPerson没有playgame方法，所以编译时会报错
    //    [perch playgame];
    //    但可以将任何类型的指针变量赋值给id类型的变量
    id allperch = perch;//下面会解释为何这样做？
    [allperch playgame];
}

@end
