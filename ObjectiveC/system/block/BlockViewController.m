//
//  BlockViewController.m
//  ObjectiveC
//
//  Created by hello on 2019/11/2.
//  Copyright © 2019 William. All rights reserved.
//

//参考文章:https://juejin.im/entry/588075132f301e00697f18e0

#import "BlockViewController.h"
#import "DownloadManager.h"

// 1. 给  Calculate 类型 sum变量 赋值「下定义」
typedef int (^Calculate)(int, int); // Calculate就是类型名

@interface BlockViewController ()

@property(nonatomic, copy) void (^someBlock)(int);

// 2. 作为对象的属性声明，copy 后 block 会转移到堆中和对象一起
//@property (nonatomic, copy) Calculate sum;    // 使用   typedef
@property (nonatomic, copy) int (^sum)(int, int); // 不使用 typedef

@end

@implementation BlockViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //    [self study1];
    //    [self study2];
    //    [self study3];
    //    [self study4];
    //    [self study5];
    //    [self study6];
    //    [self study7];
    //    [self study8];
    //    [self study9];
    //    [self study10];
    [self study11];
}

//block回调
-(void)study11 {
    NSString *url = @"http://jobs8.cn:8081/getdata";
    NSDictionary *para = @{@"a":@"A"};
    //下载类
    DownloadManager *downloadManager = [[DownloadManager alloc] init];
    /*
    [downloadManager downloadWithURL: url parameters:para handler:^(NSData *receiveData, NSError *error) {
        if (error) {
            NSLog(@"下载失败：%@",error);
        }else {
            NSLog(@"下载成功，%@",receiveData);
        }
    }];
    **/
    
    //另一种写法,将block声明、实现和方法调用分开来写,这样写便于理解
    void (^handler)(NSData * receiveData, NSError * error);//block的声明
    handler = ^(NSData * receiveData, NSError * error){//block的实现
        if (error) {
            NSLog(@"下载失败：%@",error);
        }else {
            NSLog(@"下载成功，%@",receiveData);
            NSString *json_str = [[NSString alloc]initWithData:receiveData encoding:NSUTF8StringEncoding];
            NSLog(@"下载成功，%@", json_str);
        }
    };
    /*
     //也可以用 typedef 定义的 DownloadHandler
     DownloadHandler handler = ^(NSData * receiveData, NSError * error){
         if (error) {
             NSLog(@"下载失败：%@",error);
         }else {
             NSLog(@"下载成功，%@",receiveData);
         }
     };
     **/
    
    [downloadManager downloadWithURL:url parameters:para handler:handler];
}

//block作为方法的参数
-(void)study10 {
    // 调用
    CGFloat result1 = [self testTimeConsume:^{
        // 放入 block 中的代码
        NSLog(@"传递无参数的block");
    }];
    NSLog(@"result1 = %f", result1);
    
    // 调用
    /*
     CGFloat result2 = [self testTimeConsume2:^(NSString *name) {
     // 放入 block 中的代码，可以使用参数 name
     // 参数 name 是实现代码中传入的，在调用时只能使用，不能传值
     NSLog(@"传递有参数的block, 参数 name = %@", name);
     }];
     */
    //下面的写法 是将block的声明和实现 与 调用方法独立开来
    void (^myBlock) (NSString *name);//block声明
    myBlock  = ^(NSString *name){//block实现
        // 放入 block 中的代码，可以使用参数 name
        // 参数 name 是实现代码中传入的，在调用时只能使用，不能传值
        NSLog(@"传递有参数的block, 参数 name = %@", name);
    };
    CGFloat result2 = [self testTimeConsume2:myBlock];
    NSLog(@"result2 = %f", result2);
}
// -------------------------- 无参数的Block ---------------------------
- (CGFloat)testTimeConsume:(void(^)(void))middleBlock {
    // 执行前记录下当前的时间
    CFTimeInterval startTime = CACurrentMediaTime();
    middleBlock();
    // 执行后记录下当前的时间
    CFTimeInterval endTime = CACurrentMediaTime();
    return endTime - startTime;
}
// ------------------------- 有参数的Block ---------------------------
- (CGFloat)testTimeConsume2:(void(^)(NSString * name))middleBlock {
    // 执行前记录下当前的时间
    CFTimeInterval startTime = CACurrentMediaTime();
    NSString *name = @"William";
    middleBlock(name);//这里调用 study10 中声明的block, 这里调用后 study10 中的block才执行
    // 执行后记录下当前的时间
    CFTimeInterval endTime = CACurrentMediaTime();
    return endTime - startTime;
}


//2、Block作为属性（Xcode 快捷键：typedefBlock）
-(void)study9 {
    Calculate sum1 = ^(int a,int b){
        return a+b;
    };
    int a = sum1(10,20); // 调用 sum变量
    NSLog(@"a = %d", a);
    
    // 声明，类外
    self.sum = ^(int a,int b){
        return a+b;
    };
    // 调用，类内
    int b = self.sum(10,20);
    NSLog(@"b = %d", b);
}

//1、Block作为变量（Xcode快捷键：inlineBlock）
-(void)study8 {
    int (^sum) (int, int); // 定义一个 Block 变量 sum
    // 给 Block 变量赋值
    // 一般 返回值省略：sum = ^(int a,int b)…
    sum = ^int (int a,int b){
        return a+b;
    }; // 赋值语句最后有 分号
    int a = sum(10,20); // 调用 Block 变量
    NSLog(@"a = %d", a);
}

//防止 Block 循环引用
-(void)study7 {
    /*
     Block 循环引用的情况：
     某个类将 block 作为自己的属性变量，然后该类在 block 的方法体里面又使用了该类本身
     **/
    //    self.someBlock = ^(int a){
    //        [self test];
    //    };
    
    //（1）ARC 下：使用 __weak
    __weak typeof(self) weakSelf = self;
    self.someBlock = ^(int a){
        [weakSelf test:a];
    };
    self.someBlock(10);
    
    //（2）MRC 下：使用 __block  (注:现在主流都是ARC,这种情况很少会出现)
    __block typeof(self) blockSelf = self;
    self.someBlock = ^(int a){
        [blockSelf test:a];
    };
    self.someBlock(20);
}
-(void)test:(int)num {
    NSLog(@"Just a test! num = %d", num);
}

//截获自动变量（局部变量）值
-(void)study6 {
    typedef void (^MyBlock)(void);
    /*
     （1）默认情况
     对于 block 外的变量引用，block 默认是将其复制到其数据结构中来实现访问的。也就是说block的自动变量截获只针对block内部使用的自动变量, 不使用则不截获, 因为截获的自动变量会存储于block的结构体内部, 会导致block体积变大。特别要注意的是默认情况下block只能访问不能修改局部变量的值。
     **/
    int age = 10;
    MyBlock myBlock = ^{
        NSLog(@"age = %d", age);
    };
    age = 20;
    myBlock();
    
    /*
     （2） __block 修饰的外部变量
     对于用 __block 修饰的外部变量引用，block 是复制其引用地址来实现访问的。block可以修改__block 修饰的外部变量的值。
     **/
    __block int number = 60;
    MyBlock myBlock2 = ^{
        NSLog(@"number = %d", number);
    };
    number = 99;
    myBlock2();
}

//5、实际开发中常用typedef 定义Block
-(void)study5 {
    typedef int (^MyBlock)(int , int);
    MyBlock myBlockFive;
    myBlockFive = ^int (int a, int b){
        return a * b;
    };
    int result = myBlockFive(88,99);
    NSLog(@"result = %d", result);
}

//4、无参数有返回值(很少用到)
-(void)study4 {
    int (^MyBlockFour)(void) = ^int {
        return 99;
    };
    int result = MyBlockFour();
    NSLog(@"result = %d", result);
}

//3、有参数有返回值
-(void)study3 {
    int (^MyBlockThree)(int,int) = ^int(int a,int b){
        return a + b;
    };
    int result = MyBlockThree(12,56);
    NSLog(@"result = %d", result);
}

//2、有参数无返回值
-(void)study2 {
    //2，有参数，无返回值，声明和定义
    void(^MyBlockTwo)(int a) = ^(int a){
        NSLog(@"有参数，无返回值 a = %d",a);
    };
    MyBlockTwo(100);
}

//1、无参数无返回值
-(void)study1 {
    //1，无参数，无返回值，声明和定义
    void(^MyBlockOne)(void) = ^(void){
        NSLog(@"无参数，无返回值");
    };
    MyBlockOne();//block的调用
}

@end
