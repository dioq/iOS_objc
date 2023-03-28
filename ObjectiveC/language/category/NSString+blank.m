//
//  NSString+blank.m
//  ObjectiveC
//
//  Created by Dio Brand on 2023/2/25.
//  Copyright © 2023 my. All rights reserved.
//

#import "NSString+blank.h"

@implementation NSString (blank)

- (BOOL)isBlankString:(NSString *)aStr {
    if (!aStr) {
        return YES;
    }
    if ([aStr isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if (!aStr.length) {
        return YES;
    }
    NSCharacterSet *set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    NSString *trimmedStr = [aStr stringByTrimmingCharactersInSet:set];
    if (!trimmedStr.length) {
        return YES;
    }
    return NO;
}

@end
