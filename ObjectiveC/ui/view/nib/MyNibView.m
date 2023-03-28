//
//  MyNibView.m
//  ObjectiveC
//
//  Created by lzd_free on 2019/2/27.
//  Copyright © 2019 William. All rights reserved.
//

#import "MyNibView.h"
#import "BookModel.h" //模型

@interface MyNibView()

@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *label;

@end

@implementation MyNibView

//重写initWithFrame构造方法
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

// 调用模型的set方法，给书的子控件赋值，
- (void)setBook:(BookModel *)book {
    _book = book;
    self.icon.image = [UIImage imageNamed:book.icon];
    self.label.text = book.name;
}

@end
