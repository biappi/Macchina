//
//  NIMessageBases.h
//  Macchina
//
//  Created by Antonio "Willy" Malara on 17/08/12.
//  Copyright (c) 2012 Antonio "Willy" Malara. All rights reserved.
//

#import "NIMessage.h"

@interface NIUnknownMessage : NIMessage
@end

@interface NIPlainMessage : NIMessage
@end

@interface NINumberValueMessage : NIMessage

@property uint32_t value;
@property BOOL     isTrue;

+ (NINumberValueMessage *)messageWithBool:(BOOL)s;
+ (NINumberValueMessage *)messageWithValue:(uint32_t)s;

@end
