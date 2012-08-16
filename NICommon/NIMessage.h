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

@interface NIUnknownMessage : NIMessage
@end

@interface NIGetServiceVersionMessage : NIMessage
@end
    
@interface NIDeviceConnectMessage : NIMessage
@property uint32_t   controllerId;
@property uint32_t   boh;
@property uint32_t   clientRole;
@property NSString * clientName;
@end

@interface NISetAsciiStringMessage : NIMessage
@property uint32_t   boh1;
@property uint32_t   boh2;
@property NSString * string;
@end

@interface NIGetDeviceEnabledMessage  : NIMessage
@property uint32_t   boh;
@end

@interface NIDeviceStateChangeMessage  : NIMessage
@property BOOL deviceState;
+ (NIDeviceStateChangeMessage *)messageWithDeviceState:(BOOL)s;
@end
