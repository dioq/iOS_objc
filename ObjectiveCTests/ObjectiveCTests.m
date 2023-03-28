//
//  ObjectiveCTests.m
//  ObjectiveCTests
//
//  Created by Dio Brand on 2023/3/16.
//  Copyright © 2023 my. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "CryptoUtil.h"

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
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    NSData *dataFromHexString = [CryptoUtil hexDecode:@"5308f5a2a893cd444946cab7aec4ab2eb4821aeb"];
    NSString *stringFromBase64Data = [dataFromHexString base64EncodedStringWithOptions:0];
    NSData *data = [[NSData alloc] initWithBase64EncodedString:stringFromBase64Data options:0];
    NSLog(@"\n\nstringFromBase64Data:\n%@\n\n", stringFromBase64Data);
    NSLog(@"data:%@",data);
}

-(void)test001 {
    UIView *v = [UIView new];
    v.backgroundColor = [UIColor orangeColor];
}

-(void)test02 {
    NSString *hexStr = @"6c6f67";
    NSData *data = [CryptoUtil hexDecode:hexStr];
    NSString *value = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"=========================\n%@",value);
}

-(void)test03 {
    NSString *path = @"/var/mobile/Containers/Data/Application/AF53C4B6-E80C-4B7A-9CCF-82DEDF2595CC/Library/WechatPrivate/text.txt";
    NSArray<NSString *> *strArr = [path componentsSeparatedByString:@"/"];
    NSString *dirPath = [path stringByReplacingOccurrencesOfString:[strArr lastObject] withString:@""];
    NSLog(@"path:%@\ndirPath:%@",path,dirPath);
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
