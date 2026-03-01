//
//  TaskProgressView.m
//  ObjectiveC
//
//  Created by zd on 1/3/2026.
//  Copyright © 2026 my. All rights reserved.
//

#import "TaskProgressView.h"

@implementation TaskProgressView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    float progress_height = 10;
    // 进度条
    self.progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
    self.progressView.frame = CGRectMake(0, 0, self.bounds.size.width, progress_height);
    self.progressView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self.progressView.progressTintColor = [UIColor systemBlueColor];
    self.progressView.trackTintColor = [UIColor systemGray5Color];
    [self addSubview:self.progressView];
    
    float label_height = 10;
    // 文字
    self.statusLabel = [[UILabel alloc] init];
    self.statusLabel.textAlignment = NSTextAlignmentCenter;
    self.statusLabel.font = [UIFont systemFontOfSize:12];
    self.statusLabel.textColor = [UIColor darkGrayColor];
    self.statusLabel.frame = CGRectMake(0, progress_height, self.bounds.size.width, label_height);
    //    self.statusLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [self addSubview:self.statusLabel];
}

- (void)updateTotal:(NSInteger)total completed:(NSInteger)completed {
    if (total <= 0) {
        self.progressView.progress = 0;
        self.statusLabel.text = @"0 / 0 (0%)";
        return;
    }
    
    float progress = (float)completed / total;
    [self.progressView setProgress:progress animated:YES];
    
    NSString *text = [NSString stringWithFormat:@"%zd / %zd (%.0f%%)", completed, total, progress * 100];
    self.statusLabel.text = text;
}

// 可选：方便直接用 initWithFrame 后调用
+ (instancetype)progressViewWithFrame:(CGRect)frame {
    return [[self alloc] initWithFrame:frame];
}

@end
