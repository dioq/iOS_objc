//
//  MyFontViewController.m
//  ObjectiveC
//
//  Created by hello on 2019/9/6.
//  Copyright © 2019 William. All rights reserved.
//

#import "MyFontViewController.h"

@interface MyFontViewController ()

@end

@implementation MyFontViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    /*
     系统字体有81种,如果自己添加N种新字体, 总共就会有81+N种字体
     **/
    NSArray<NSString *> *familyNames = [UIFont familyNames];
    for (int i = 0; i < familyNames.count; i++) {
        NSString *fontfamilyname = [familyNames objectAtIndex:i];
        NSLog(@"fontfamilyname:'%@'",fontfamilyname);
        for(NSString *fontName in [UIFont fontNamesForFamilyName: fontfamilyname]) {
            NSLog(@"font:'%@'",fontName);
        }
        NSLog(@"-------------------- %d done ---------------------",i);
    }
    
    UIFont *myfont = [UIFont fontWithName:@"MyanmarSangamMN-Bold" size:20];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(30, 100, 300, 60)];
    label.backgroundColor = [UIColor greenColor];
    label.text = @"字体测试 这是一段文字";
    label.font = myfont;
    [self.view addSubview:label];
}

@end
