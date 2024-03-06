//
//  ObjectiveCTests.m
//  ObjectiveCTests
//
//  Created by zd on 24/6/2023.
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
    [UIView alloc];
}

-(void)testDataLength {
    NSString *str = @"a";
    NSData *dt = [str dataUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"length:%lu",dt.length);
}

-(void)testSha256 {
    NSString *plaintext = @"MIIDdjCCAl4CCQDpeD5eFazlfjANBgkqhkiG9w0BAQsFADB7MQswCQYDVQQGEwJDTjELMAkGA1UECAwCU0QxCzAJBgNVBAcMAkpOMQ0wCwYDVQQKDARRRFpZMREwDwYDVQQLDAhqb2JzOC5jbjELMAkGA1UEAwwCQ0ExIzAhBgkqhkiG9w0BCQEWFHpoZW5kb25nMjAxMUBsaXZlLmNuMB4XDTIyMTEyMjE4MzQwOFoXDTMyMTExOTE4MzQwOFowfzELMAkGA1UEBhMCQ04xCzAJBgNVBAgMAlNEMQswCQYDVQQHDAJKTjENMAsGA1UECgwEUURaWTERMA8GA1UECwwIam9iczguY24xDzANBgNVBAMMBlNFUlZFUjEjMCEGCSqGSIb3DQEJARYUemhlbmRvbmcyMDExQGxpdmUuY24wggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQCwYqk7CzCVBRw2QLO0WTu0R+D06o47BjlLviNSj7K/Q06CUKmuGBBHlQ+9Til+aCBae0px1iFVSVDl803zNMmN+5OVwPRSdtbMQUznVbyjVCVFPzkGlKgL7T/jm7kpDXoafu1S3Q4hoK+TlJEXNTvy8xHA+JY87LFE227U/I+8Jn2ZZPEmY8TcHsO3zbC3+wrB3V/jiodPjJXifm3qGB/PSnPRNXF1/MzuNzAUWYo2/Ye2ORLspjuCz2YMFB+KQRqK3fnicbsRDyss3AK9a+Qj2VYM9ZE+Da8vAvOD9J6r3FXB+9Z5mIWY081jwFz0V/Maz8QnsTLpJ9SYIdZuBa7HAgMBAAEwDQYJKoZIhvcNAQELBQADggEBAIi30qCI60WmdZL2NYyIxnvqVMJPTLn+jh4blrgVizCwp2S0FDbs2OByjfja4GnWnbK/Cdz0zSzcQAJSvpVouPFh8H+kDXD7JfSc+9VGwJ8jbCz/oOYMGYC7KjqEYj6ovkTD26wzCDfcbYj80cE8i2MxgTP6H78uSwcYJojND2ygkUZjE1tnSPMBs+xzV2VHSCYYozvn0McIoBo4Psnf3yYFVFDpRYFYUgM+A9O+3iXzTBCGwzie6+WgqsJrNrzNfcXM6b9m6NOMmaUGHo05Cq+RMd70OK70jOwct7vWUudRtwUk3mvnyrL6DW9xIl0VL704ZUFMWCLG/HNNRsbUPV0=";
    NSString *ciphext = [CryptoUtil sha256:plaintext];
    NSLog(@"=======%@\n",ciphext);
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
