//
//  TestModel.h
//  ObjectiveC
//
//  Created by hello on 2019/4/16.
//  Copyright © 2019 William. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DataModel.h"
#import "ContentModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface TestModel : NSObject

@property(nonatomic, assign)NSInteger code;
@property(nonatomic, copy)NSString *msg;
@property(nonatomic, strong)ContentModel *content;
@property(nonatomic, strong)NSMutableArray<DataModel *> *data;

-(TestModel *)initWithDict:(NSDictionary *)dict;

@end

NS_ASSUME_NONNULL_END
