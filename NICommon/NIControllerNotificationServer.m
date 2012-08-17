//
//  NIControllerNotificationServer.m
//  Macchina
//
//  Created by Antonio "Willy" Malara on 16/08/12.
//  Copyright (c) 2012 Antonio "Willy" Malara. All rights reserved.
//

#import "NIControllerNotificationServer.h"
#import "NIProtocolMessages.h"
#import "NIAgentClient.h"

@implementation NIControllerNotificationServer

- (NSData *)handleNIDeviceStateChangeMessage:(NIDeviceStateChangeMessage *)stateChange;
{
    return nil;
}

- (NSData *)handleNISetFocusMessage:(NISetFocusMessage *)setFocus;
{
    [self.agentClient sendTestImage];
    return nil;
}

@end
