//
//  CategoryViewController.m
//  ObjectiveC
//
//  Created by Dio Brand on 2023/2/25.
//  Copyright © 2023 my. All rights reserved.
//

#import "CategoryViewController.h"
#import "NSString+blank.h"

@interface CategoryViewController ()

@end

@implementation CategoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (IBAction)stringCategory01:(UIButton *)sender {
    NSString *testStr1 = @"";
    NSString *testStr2 = nil;
    
    if(!(testStr1 || testStr2)) {
        NSLog(@"testStr1 testStr2 应该都不为空");
    }else{
        NSLog(@"这种判断存在问题");
    }
    
    BOOL suc1 = [[NSString alloc] isBlankString:testStr1];
    if(suc1) {
        NSLog(@"testStr1 为空");
    }else {
        NSLog(@"testStr1 不为空");
    }
    
    BOOL suc2 = [[NSString alloc] isBlankString:testStr2];
    if(suc2) {
        NSLog(@"testStr2 为空");
    }else {
        NSLog(@"testStr2 不为空");
    }
}

@end
