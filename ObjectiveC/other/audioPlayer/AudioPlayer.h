//
//  AudioPlayer.h
//  ObjectiveC
//
//  Created by hello on 2019/4/5.
//  Copyright © 2019 William. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AudioPlayer : NSObject

+ (instancetype)sharedManager;
-(void)play:(NSURL *)url;
-(void)play;
-(void)plause;
-(void)stop;

@end

NS_ASSUME_NONNULL_END
