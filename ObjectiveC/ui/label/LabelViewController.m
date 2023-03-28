//
//  LabelViewController.m
//  ObjectiveC
//
//  Created by Geek on 2019/12/23.
//  Copyright © 2019 William. All rights reserved.
//

#import "LabelViewController.h"

@interface LabelViewController ()

@end

@implementation LabelViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    /*
     NSForegroundColorAttributeName  字体颜色
     NSFontAttributeName  字体大小
     NSUnderlineColorAttributeName 下划线颜色
     NSUnderlineStyleAttributeName   下划线style
     NSUnderlineStyleSingle    单线
     NSUnderlineStyleDouble  双线
     
     NSStrikethroughColorAttributeName   中间线颜色
     NSStrikethroughStyleAttributeName   中间线style
     */
    NSString *textString = @"这个是用来演示的文字";
    
    //字符串字体大小、颜色全部统一样式
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(10, 100, ScreenWidth - 20, 50)];
    label1.backgroundColor = [UIColor cyanColor];
    [self.view addSubview:label1];
    NSMutableAttributedString *str1 = [[NSMutableAttributedString alloc] initWithString:textString attributes:@{NSForegroundColorAttributeName:[UIColor redColor], NSFontAttributeName:[UIFont systemFontOfSize:30]}];
    label1.attributedText = str1;
    
    //字体大小、颜色不统一,只改变一种
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(10, 100 + 60, ScreenWidth - 20, 50)];
    label2.backgroundColor = [UIColor cyanColor];
    [self.view addSubview:label2];
    NSMutableAttributedString *str2 = [[NSMutableAttributedString alloc] initWithString:textString];
    [str2 addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0, 3)];
    [str2 addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:35] range:NSMakeRange(3, [textString length] - 3)];
    label2.attributedText = str2;
    
    //字体大小、颜色不统一，全部改变
    UILabel *label3 = [[UILabel alloc] initWithFrame:CGRectMake(10, 100 + 120, ScreenWidth - 20, 50)];
    label3.backgroundColor = [UIColor cyanColor];
    [self.view addSubview:label3];
    NSMutableAttributedString *str3 = [[NSMutableAttributedString alloc] initWithString:textString];
    [str3 addAttributes:@{NSForegroundColorAttributeName:[UIColor redColor], NSFontAttributeName:[UIFont systemFontOfSize:28]} range:NSMakeRange(0, 3)];
    [str3 addAttributes:@{NSForegroundColorAttributeName:[UIColor orangeColor], NSFontAttributeName:[UIFont systemFontOfSize:33]} range:NSMakeRange(3, 7)];
    label3.attributedText = str3;
    
    //在label3的基础上添加下划线
    UILabel *label4 = [[UILabel alloc] initWithFrame:CGRectMake(10, 100 + 180, ScreenWidth - 20, 50)];
    label4.backgroundColor = [UIColor cyanColor];
    [self.view addSubview:label4];
    NSMutableAttributedString *str4 = [[NSMutableAttributedString alloc] initWithString:textString];
    [str4 addAttributes:@{NSForegroundColorAttributeName:[UIColor redColor], NSFontAttributeName:[UIFont systemFontOfSize:28],  NSUnderlineColorAttributeName:[UIColor blackColor], NSUnderlineStyleAttributeName:@(NSUnderlineStyleSingle)} range:NSMakeRange(0, 3)];
    [str4 addAttributes:@{NSForegroundColorAttributeName:[UIColor orangeColor], NSFontAttributeName:[UIFont systemFontOfSize:33], NSUnderlineColorAttributeName:[UIColor redColor], NSUnderlineStyleAttributeName:@(NSUnderlineStyleDouble)} range:NSMakeRange(3, 7)];
    label4.attributedText = str4;
    
    //在label3的基础上,在文字中间添加横线
    UILabel *label5 = [[UILabel alloc] initWithFrame:CGRectMake(10, 100 + 240, ScreenWidth - 20, 50)];
    label5.backgroundColor = [UIColor cyanColor];
    [self.view addSubview:label5];
    NSMutableAttributedString *str5 = [[NSMutableAttributedString alloc] initWithString:textString];
    [str5 addAttributes:@{NSForegroundColorAttributeName:[UIColor redColor], NSFontAttributeName:[UIFont systemFontOfSize:28], NSStrikethroughColorAttributeName:[UIColor blueColor], NSStrikethroughStyleAttributeName:@(NSUnderlineStyleSingle)} range:NSMakeRange(0, 3)];
    [str5 addAttributes:@{NSForegroundColorAttributeName:[UIColor orangeColor], NSFontAttributeName:[UIFont systemFontOfSize:33], NSStrikethroughColorAttributeName:[UIColor purpleColor], NSStrikethroughStyleAttributeName:@(NSUnderlineStyleDouble)} range:NSMakeRange(3, 7)];
    label5.attributedText = str5;
    
    //在label3的基础上,添加图片
    UILabel *label6 = [[UILabel alloc] initWithFrame:CGRectMake(10, 100 + 300, ScreenWidth - 20, 50)];
    label6.backgroundColor = [UIColor cyanColor];
    [self.view addSubview:label6];
    NSMutableAttributedString *str6 = [[NSMutableAttributedString alloc] initWithString:textString];
    [str6 addAttributes:@{NSForegroundColorAttributeName:[UIColor redColor], NSFontAttributeName:[UIFont systemFontOfSize:28]} range:NSMakeRange(0, 3)];
    [str6 addAttributes:@{NSForegroundColorAttributeName:[UIColor orangeColor], NSFontAttributeName:[UIFont systemFontOfSize:33]} range:NSMakeRange(3, 7)];
    label6.attributedText = str6;
    NSTextAttachment *attach = [[NSTextAttachment alloc] init];
    attach.image = [UIImage imageNamed:@"ic_1"];
    attach.bounds = CGRectMake(0, -5, 32, 32);
    NSAttributedString *string6 = [NSAttributedString attributedStringWithAttachment:attach];
    [str6 appendAttributedString:string6];
    label6.attributedText = str6;
}

@end
