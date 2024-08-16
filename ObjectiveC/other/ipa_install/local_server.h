//
//  local_server.h
//  ObjectiveC
//
//  Created by zd on 14/8/2024.
//  Copyright © 2024 my. All rights reserved.
//

#ifndef local_server_h
#define local_server_h

#include <stdio.h>
#import <Foundation/Foundation.h>

int init_property(const char *path,const char *name);
int server_start(void);

#endif /* local_server_h */
