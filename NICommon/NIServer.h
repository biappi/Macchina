//
//  NIServer.h
//  Macchina
//
//  Created by Antonio "Willy" Malara on 16/08/12.
//  Copyright (c) 2012 Antonio "Willy" Malara. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NIServer : NSObject

@property (readonly) NSString * name;

- (id)initWithName:(NSString *)name;
- (void)scheduleInRunLoop:(NSRunLoop *)runloop;

@end
