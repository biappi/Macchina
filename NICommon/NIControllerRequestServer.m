//
//  NIControllerRequestServer.m
//  Macchina
//
//  Created by Antonio "Willy" Malara on 16/08/12.
//  Copyright (c) 2012 Antonio "Willy" Malara. All rights reserved.
//

#import "NIControllerRequestServer.h"
#import "NIProtocolMessages.h"
#import "NIAgent.h"

@implementation NIControllerRequestServer

- (NSData *)handleNISetAsciiStringMessage:(NISetAsciiStringMessage *)message;
{
    [self.agent createNotificationClientWithName:message.string];
    
    uint32_t theTrue = 'true';
    return [NSData dataWithBytes:&theTrue length:sizeof(theTrue)];
}

- (NSData *)handleNIGetDeviceAvailableMessage:(NIGetDeviceAvailableMessage *)message;
{
    uint32_t theTrue = 'true';
    return [NSData dataWithBytes:&theTrue length:sizeof(theTrue)];
}

@end
