//
//  ObjectiveCTests.m
//  ObjectiveCTests
//
//  Created by zd on 30/10/2025.
//  Copyright © 2025 my. All rights reserved.
//

#import <XCTest/XCTest.h>
#include <time.h>

@interface ObjectiveCTests : XCTestCase

@end

@implementation ObjectiveCTests

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

-(void)test4 {
    NSTimeInterval time = [[NSProcessInfo processInfo] systemUptime];
    srand((unsigned int)clock());
    NSTimeInterval last_start_time = time + rand() % 10000000;
    NSLog(@"%d ---> %f",__LINE__,last_start_time);
    NSString *str = [NSString stringWithFormat:@"%f",last_start_time];
    NSLog(@"%d ---> %@",__LINE__,str);
    
    NSData *dt = [str dataUsingEncoding:NSUTF8StringEncoding];
    NSString *str2 = [[NSString alloc] initWithData:dt encoding:NSUTF8StringEncoding];
    NSLog(@"%d ---> %@",__LINE__,str2);
    
    NSTimeInterval last_start_time2 = [str2 doubleValue];
    NSLog(@"%d ---> %f",__LINE__,last_start_time2);
}

-(void)test3{
    // 使用 CPU 时钟作为种子
    srand((unsigned int)clock());
    
    for (int i = 0; i < 100; i++)
    {
        int random_num = rand() % 10000;
        printf("%d: %d\n", __LINE__, random_num);
    }
}

-(void)test2 {
    srand((unsigned int)clock());
    for (int i =0; i < 100; i++) {
        long num = rand() % 1000000;
        printf("%ld\n",num);
    }
}

- (void)testExample {
    for (int i =0; i < 200; i++) {
        NSString *uuidStr = [[NSUUID UUID] UUIDString];
        //        NSLog(@"%d uuid:%@",i, uuidStr);
        printf("%s\n",[uuidStr UTF8String]);
    }
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
