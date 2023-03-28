//
//  NibCollectionViewCell.h
//  ObjectiveC
//
//  Created by lzd_free on 2019/2/27.
//  Copyright © 2019 William. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class PersonModel;
@interface NibCollectionViewCell : UICollectionViewCell

@property(nonatomic, strong)PersonModel *person;

@end

NS_ASSUME_NONNULL_END
