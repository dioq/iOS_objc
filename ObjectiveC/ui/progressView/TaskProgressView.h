//
//  TaskProgressView.h
//  ObjectiveC
//
//  Created by zd on 1/3/2026.
//  Copyright © 2026 my. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TaskProgressView : UIView

@property (nonatomic, strong) UIProgressView *progressView;
@property (nonatomic, strong) UILabel *statusLabel;

- (void)updateTotal:(NSInteger)total completed:(NSInteger)completed;

@end

NS_ASSUME_NONNULL_END
