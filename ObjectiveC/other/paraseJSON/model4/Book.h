//
//  Book.h
//  ObjectiveC
//
//  Created by hello on 2019/4/16.
//  Copyright © 2019 William. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Author.h"

NS_ASSUME_NONNULL_BEGIN

@interface Book : NSObject

@property(nonatomic, strong) NSString *name;
@property(nonatomic, assign) NSUInteger pages;
@property(nonatomic, strong)Author *author; //Book 包含 Author 属性

@end

NS_ASSUME_NONNULL_END
