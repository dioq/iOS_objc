//
//  PasteboardViewController.m
//  ObjectiveC
//
//  Created by Dio Brand on 2023/4/24.
//  Copyright © 2023 my. All rights reserved.
//

#import "PasteboardViewController.h"

@interface PasteboardViewController ()

@end

@implementation PasteboardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[UIPasteboard generalPasteboard] setString:@""];
}


@end
