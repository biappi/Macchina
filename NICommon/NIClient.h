//
//  NIClient.h
//  Macchina
//
//  Created by Antonio "Willy" Malara on 16/08/12.
//  Copyright (c) 2012 Antonio "Willy" Malara. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NIMessage.h"

@interface NIClient : NSObject

@property (readonly) NSString * name;

- (id)initWithName:(NSString *)name;
- (NSData *)sendMessage:(NIMessage *)message;

@end
