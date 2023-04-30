//
//  SerializeViewController.m
//  ObjectiveC
//
//  Created by hello on 2019/4/17.
//  Copyright © 2019 William. All rights reserved.
//

#import "SerializeViewController.h"
#import "Person.h"

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
        NSLog(@"%@",error);
        return;
    }
    NSLog(@"字符串序列化完成");
}

- (IBAction)deserializeString:(UIButton *)sender {
    NSError *error;
    NSString *str = [NSKeyedUnarchiver unarchivedObjectOfClass:[NSString class] fromData:self.serializeData error:&error];
    if (error) {
        NSLog(@"%@",error);
        return;
    }
    NSLog(@"字符串反序列化:%@",str);
}

- (IBAction)serialize1:(UIButton *)sender {
    NSArray *array = [NSArray arrayWithObjects:@1,@2,@3, nil];
    NSError *error;
    self.serializeNSArrayData = [NSKeyedArchiver archivedDataWithRootObject:array requiringSecureCoding:YES error:&error];
    if (error) {
        NSLog(@"%@",error);
        return;
    }
    NSLog(@"NSArray 已经序列化完成!");
}
- (IBAction)deserialize:(UIButton *)sender {
    NSError *error;
    NSArray *arr = [NSKeyedUnarchiver unarchivedObjectOfClass:[NSArray class] fromData:self.serializeNSArrayData error:&error];
    if (error) {
        NSLog(@"%@",error);
        return;
    }
    NSLog(@"NSArray 反序列化:\n%@", arr);
}

- (IBAction)serialize2:(UIButton *)sender {
    Person *person = [[Person alloc]init];
    person.name = @"BigBaby";
    person.age = 16;
    person.gender = @"男";
    
    NSError *error;
    self.serializeNSObjectData = [NSKeyedArchiver archivedDataWithRootObject:person requiringSecureCoding:YES error:&error];
    if (error) {
        NSLog(@"%@",error);
        return;
    }
    NSLog(@"Person 对象 已经序列化完成!");
}

- (IBAction)deserialize2:(UIButton *)sender {
    NSError *error;
    Person *person = [NSKeyedUnarchiver unarchivedObjectOfClass:[Person class] fromData:self.serializeNSObjectData error:&error];
    if (error) {
        NSLog(@"%@",error);
        return;
    }
    NSLog(@"person 反序列化:\n%@", person.description);
}

- (IBAction)oldMethod:(UIButton *)sender {
    NSError *error;
    NSObject *obj = [NSKeyedUnarchiver unarchiveObjectWithData:self.serializeData];
    if (error) {
        NSLog(@"%@",error);
        return;
    }
    NSLog(@"字符串反序列化:%@",obj);
}

@end
