//
//  SerializeViewController.m
//  ObjectiveC
//
//  Created by hello on 2019/4/17.
//  Copyright © 2019 William. All rights reserved.
//

#import "SerializeViewController.h"
#import "Student.h"

@interface SerializeViewController ()

@property(nonatomic,strong)NSData *serializeData;
@property(nonatomic,strong)NSData *serializeNSArrayData;
@property(nonatomic,strong)NSData *serializeNSObjectData;

@end

@implementation SerializeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"序列化";
}

- (IBAction)serializeString:(UIButton *)sender {
    NSString *str = @"d9ac70dac380a8b6d87840a1d2b2b94f";
    NSError *error;
    self.serializeData = [NSKeyedArchiver archivedDataWithRootObject:str requiringSecureCoding:YES error:&error];
    if (error) {
        NSLog(@"%@",[error localizedFailureReason]);
        return;
    }
    NSLog(@"字符串序列化完成");
}

- (IBAction)deserializeString:(UIButton *)sender {
    NSError *error;
    NSString *str = [NSKeyedUnarchiver unarchivedObjectOfClass:[NSString class] fromData:self.serializeData error:&error];
    if (error) {
        NSLog(@"%@",[error localizedFailureReason]);
        return;
    }
    NSLog(@"字符串反序列化:%@",str);
}

- (IBAction)serialize1:(UIButton *)sender {
    NSArray *array = [NSArray arrayWithObjects:@1,@2,@3, nil];
    NSError *error;
    self.serializeNSArrayData = [NSKeyedArchiver archivedDataWithRootObject:array requiringSecureCoding:YES error:&error];
    if (error) {
        NSLog(@"%@",[error localizedFailureReason]);
        return;
    }
    NSLog(@"NSArray 已经序列化完成!");
}

- (IBAction)deserialize:(UIButton *)sender {
    NSError *error;
    NSMutableSet *set = [NSMutableSet set]; // 待解析的数据中存在的OC数据类型
    [set addObject:[NSArray class]];
    [set addObject:[NSNumber class]];
    
    NSArray *arr = [NSKeyedUnarchiver unarchivedObjectOfClasses:[set copy] fromData:self.serializeNSArrayData error:&error];
    if (error) {
        NSLog(@"%@",[error localizedFailureReason]);
        return;
    }
    NSLog(@"NSArray 反序列化:\n%@", arr);
}

- (IBAction)serialize2:(UIButton *)sender {
    NSError *error;
    Student *person = [[Student alloc]init];
    person.name = @"BigBaby";
    person.age = 16;
    person.gender = @"男";
    
    self.serializeNSObjectData = [NSKeyedArchiver archivedDataWithRootObject:person requiringSecureCoding:YES error:&error];
    if (error) {
        NSLog(@"%@",[error localizedFailureReason]);
        return;
    }
    NSLog(@"Person 对象 已经序列化完成!");
}

- (IBAction)deserialize2:(UIButton *)sender {
    NSError *error;
    
    NSMutableSet *set = [NSMutableSet set]; // 待解析的数据中存在的OC数据类型
    [set addObject:[Student class]];
    [set addObject:[NSString class]];
    Student *person = [NSKeyedUnarchiver unarchivedObjectOfClasses:[set copy] fromData:self.serializeNSObjectData error:&error];
    if (error) {
        NSLog(@"%@",[error localizedFailureReason]);
        return;
    }
    NSLog(@"person 反序列化:\n%@", person.description);
}

@end
