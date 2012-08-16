//
//  NIControllerNotificationServer.m
//  Macchina
//
//  Created by Antonio "Willy" Malara on 16/08/12.
//  Copyright (c) 2012 Antonio "Willy" Malara. All rights reserved.
//

#import "NIControllerNotificationServer.h"
#import "NIMessage.h"

@implementation NIControllerNotificationServer

- (NSData *)handleNIDeviceStateChangeMessage:(NIDeviceStateChangeMessage *)stateChange;
{
    NSLog(@" - DEVICE IS NOW %@", stateChange.deviceState ? @"on" : @"off");
    return nil;
}

@end
