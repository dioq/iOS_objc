//
//  MyView.m
//  ObjectiveC
//
//  Created by lzd_free on 2019/2/27.
//  Copyright © 2019 William. All rights reserved.
//

#import "MyView.h"
#import "BookModel.h"//模型

@interface MyView()
// 两个内部子控件在内部包装起来，不给外界看到
@property (nonatomic, weak) UIImageView *icon;
@property (nonatomic, weak) UILabel *label;

@end

@implementation MyView

// 1.重写initWithFrame:方法，创建子控件并添加到自己上面
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        // 1. 创建书图标
        UIImageView *icon = [UIImageView new];
        self.icon = icon;
        [self addSubview:self.icon];
        
        // 2.书名
        UILabel *bookName = [UILabel new];
        bookName.textAlignment = NSTextAlignmentCenter;
        self.label = bookName;
        [self addSubview:self.label];
        
    }
    return self;
}

// 2.重写layoutSubviews，给自己内部子控件设置frame
- (void)layoutSubviews {
    [super layoutSubviews];
    CGSize size = self.frame.size;
    self.icon.frame = CGRectMake(0, 0, size.width , size.height * 0.7);
    self.label.frame = CGRectMake(0, size.height * 0.7, size.width, size.height *(1 - 0.7));
}

// 3.调用模型的set方法，给书的子控件赋值，
- (void)setBook:(BookModel *)book {
    _book = book;
    self.icon.image = [UIImage imageNamed:book.icon];
    self.label.text = book.name;
}

@end
