//
//  DLSlideViewVC.h
//  ObjectiveC
//
//  Created by hello on 2019/4/15.
//  Copyright © 2019 William. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DLTabedSlideView.h"

NS_ASSUME_NONNULL_BEGIN

@interface DLSlideViewVC : UIViewController
    
    @property (weak, nonatomic) IBOutlet DLTabedSlideView *tabedSlideView;
    
@end

NS_ASSUME_NONNULL_END
