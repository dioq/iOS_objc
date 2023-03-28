//
//  MyNibView.h
//  ObjectiveC
//
//  Created by lzd_free on 2019/2/27.
//  Copyright © 2019 William. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class BookModel;
@interface MyNibView : UIView

// 只放一个数据属性用来赋值，内部布局，放到.m 中自己管，不暴露给外界
@property (nonatomic, strong) BookModel *book;

@end

NS_ASSUME_NONNULL_END
