//
//  ParseViewController.m
//  ObjectiveC
//
//  Created by hello on 2019/4/16.
//  Copyright © 2019 William. All rights reserved.
//

#import "ParseViewController.h"
#import "Message.h"
#import "model2/TestModel.h"
#import "model2/ContentModel.h"
#import "model2/DataModel.h"
#import "model2/PhoneModel.h"
#import "model3/YYPersonModel.h"
#import <YYModel.h>
#import "model4/Book.h"
#import "model4/Author.h"
#import "model5/YYPersonModel2.h"
#import "model5/YYEatModel.h"

/*
 json在线解析
 https://www.json.cn
 json在线转model
 http://modelend.com
 */
@interface ParseViewController ()

@property(nonatomic,strong)NSMutableArray * dataArray;

@end

@implementation ParseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (IBAction)parse5:(UIButton *)sender {
//    NSDictionary *dic = @{
//                          @"id":@"123",
//                          @"name":@"张三",
//                          @"age":@(12),
//                          @"languages":@[
//                                  @"汉语",@"英语",@"法语"
//                                  ],
//                          @"job":@{
//                                  @"work":@"iOS开发",
//                                  @"eveDay":@"10小时",
//                                  @"site":@"软件园"
//                                  },
//                          @"eats":@[
//                                  @{@"food":@"西瓜",@"date":@"8点"},
//                                  @{@"food":@"烤鸭",@"date":@"14点"},
//                                  @{@"food":@"西餐",@"date":@"20点"}
//                                  ]
//                          };
    NSString * filepath = [[NSBundle mainBundle]pathForResource:@"test3" ofType:@"json"];
    NSData * fileData = [NSData dataWithContentsOfFile:filepath];
    NSString *jsonStr = [[NSString alloc] initWithData:fileData encoding:NSUTF8StringEncoding];
    YYPersonModel2 *model = [YYPersonModel2 yy_modelWithJSON: jsonStr];
    NSLog(@"id:%@, name:%@, age:%d", model.personId, model.name, model.age);
    NSArray *languages = model.languages;
    NSLog(@"languages: %@", languages);
    NSDictionary *job = model.job;
    NSLog(@"job: %@", job);
    NSArray<YYEatModel *> *eatsArr = model.eats;
    for (YYEatModel *eat in eatsArr) {
        NSLog(@"food:%@, date:%@", eat.food, eat.date);
    }
}

- (IBAction)parse4:(UIButton *)sender {
    NSString * filepath = [[NSBundle mainBundle]pathForResource:@"test2" ofType:@"json"];
    NSData * fileData = [NSData dataWithContentsOfFile:filepath];
    NSString *jsonStr = [[NSString alloc] initWithData:fileData encoding:NSUTF8StringEncoding];
    
    Book *book = [Book yy_modelWithJSON:jsonStr];
    NSLog(@"name:%@ ,pages:%ld", book.name, book.pages);
    Author *author = book.author;
    NSLog(@"name:%@, birthday:%@", author.name, author.birthday);
}

- (IBAction)parse3:(UIButton *)sender {
    NSDictionary *dic = @{@"id":@"11",@"description":@"test",@"name":@"张三", @"age":@(12), @"sex":@"男"};
    // 将数据转模型
    YYPersonModel *model = [YYPersonModel yy_modelWithJSON:dic];
    NSLog(@"id:%ld,description:%@,name:%@, age:%d, sex:%@", model.userid ,model.des ,model.name, model.age, model.sex);
}

- (IBAction)parse2:(UIButton *)sender {
    NSString *filepath = [[NSBundle mainBundle]pathForResource:@"test" ofType:@"json"];
    //2.转化为数据   创建data对象接收数据
    NSData *fileData = [NSData dataWithContentsOfFile:filepath];
    //3.使用系统提供JSON类  将需要解析的文件传入
    NSDictionary *tempDict = [NSJSONSerialization JSONObjectWithData:fileData options:NSJSONReadingAllowFragments error:nil];
    NSLog(@"\n%@", tempDict);
    TestModel *model = [[TestModel alloc] initWithDict:tempDict];
    ContentModel *content = model.content;
    NSLog(@"content:\nname:%@, number:%@, address:%@",content.name ,content.number, content.address);
    NSArray<DataModel *> *data = model.data;
    for (DataModel *dtModel in data) {
        NSLog(@"============ one is start ==============");
        NSLog(@"name:%@, age:%ld", dtModel.name, dtModel.age);
        NSArray<PhoneModel *> *phones = dtModel.phones;
        NSLog(@"phones:\n");
        for (PhoneModel *phModel in phones) {
            NSLog(@"name:%@, number:%@", phModel.name, phModel.number);
        }
        NSLog(@"============ one is over ==============");
    }
}

- (IBAction)JsonSystem:(UIButton *)sender {
    //1.获取文件路径
    NSString * filepath = [[NSBundle mainBundle]pathForResource:@"message" ofType:@"json"];
    //2.转化为数据   创建data对象接收数据
    NSData * fileData = [NSData dataWithContentsOfFile:filepath];
    //3.使用系统提供JSON类  将需要解析的文件传入，由于外层是数组，所以最后解析的数据，应该由数组接收
    NSArray * tempArray = [NSJSONSerialization JSONObjectWithData:fileData options:NSJSONReadingAllowFragments error:nil];
    NSLog(@"\n%@",tempArray);
    //更新数据  初始化数组:
    self.dataArray = [NSMutableArray array];
    //3.1 遍历JSON获取到的数据
    for (NSDictionary * dic in tempArray) {
        NSLog(@"\n%@",dic[@"content"]);
        //3.2创建模型对象
        Message * message = [Message new];
        [message setValuesForKeysWithDictionary:dic];
        //3.3将模型数据放入数组内部
        [self.dataArray addObject:message];
    }
    //测试打印
    //    [self.dataArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
    //        NSLog(@"============   1111   =============");
    //        NSLog(@"%@   %@   %@   %@",[obj receiver],[obj content],[obj data],[obj sender]);
    //        NSLog(@"============   2222   =============");
    //    }];
    for (Message *msg in self.dataArray) {
        NSLog(@"============   1111   =============");
        NSLog(@"%@ %@ %@ %@",msg.sender, msg.receiver, msg.content, msg.data);
        NSLog(@"============   2222   =============");
    }
}

@end
