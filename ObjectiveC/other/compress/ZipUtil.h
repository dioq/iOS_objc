//
//  ZipUtil.h
//  ObjectiveC
//
//  Created by zd on 16/1/2024.
//  Copyright © 2024 my. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZipUtil : NSObject

//压缩
- (NSData *)gzipDeflate:(NSData*)data;
//解压缩
- (NSData *)gzipInflate:(NSData*)data;

@end

NS_ASSUME_NONNULL_END
