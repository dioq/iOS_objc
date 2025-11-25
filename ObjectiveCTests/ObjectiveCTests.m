//
//  ObjectiveCTests.m
//  ObjectiveCTests
//
//  Created by zd on 30/10/2025.
//  Copyright © 2025 my. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface ObjectiveCTests : XCTestCase

@end

@implementation ObjectiveCTests

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testExample {
    NSArray<NSString *> *systemVersionsArr = [NSArray arrayWithObjects:@"16.0",@"16.0.1",@"16.0.2",@"16.0.3",@"16.1",@"16.1.1",@"16.1.2",@"16.2",@"16.3",@"16.3.1",@"16.4",@"16.4.1",@"16.5",@"16.5.1",@"16.6",@"16.6.1",@"16.7",@"16.7.1",@"16.7.2",@"16.7.3",@"16.7.4",@"16.7.5",@"16.7.6",@"16.7.7",@"17.0",@"17.0.1",@"17.0.2",@"17.0.3",@"17.1",@"17.1.1",@"17.1.2",@"17.2",@"17.2.1",@"17.3",@"17.3.1",@"17.4",@"17.4.1",@"17.5",@"17.5.1",nil];
    for (int i =0; i < 100; i++) {
        long index = random() % systemVersionsArr.count;
        NSString *systemVersion = systemVersionsArr[index];
        NSLog(@"systemVersion:%@",systemVersion);
    }
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
