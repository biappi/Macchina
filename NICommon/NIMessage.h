//
//  NIMessage.h
//  Macchina
//
//  Created by Antonio "Willy" Malara on 15/08/12.
//  Copyright (c) 2012 Antonio "Willy" Malara. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NIMessage : NSObject

@property (readonly) uint32_t messageId;

+ (NIMessage *)messageFromData:(NSData *)data;

- (NSData *)dataRepresentation;

@end

