//
//  DelegateView.m
//  ObjectiveC
//
//  Created by hello on 2019/4/16.
//  Copyright © 2019 William. All rights reserved.
//

#import "DelegateView.h"

@implementation DelegateView

- (IBAction)test:(UIButton *)sender {
    if (self.myDelegate != nil) {
        [self.myDelegate touch:@"William"];
    }
    if (self.myDelegate2 != nil) {
        [self.myDelegate2 testMethod:@"Dio"];
    }
}

@end
