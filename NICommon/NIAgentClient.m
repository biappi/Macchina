//
//  NIAgentClient.m
//  Macchina
//
//  Created by Antonio "Willy" Malara on 16/08/12.
//  Copyright (c) 2012 Antonio "Willy" Malara. All rights reserved.
//

#import "NIAgentClient.h"
#import "NIMainHandlerClient.h"
#import "NIServer.h"
#import "NIControllerRequestClient.h"
#import "NIControllerNotificationServer.h"

@implementation NIAgentClient
{
    NIMainHandlerClient            * mainHandler;
    NIControllerRequestClient      * requestClient;
    NIControllerNotificationServer * notificationServer;
}

- (id)init;
{
    if ((self = [super init]) == nil)
        return nil;
    
    mainHandler = [[NIMainHandlerClient alloc] initWithName:@"NIHWMainHandler"];
    
    return self;
}

- (void)connect;
{
    NIDeviceConnectResponse * r = [mainHandler connectToControllerWithId:0x00000808
                                                                     boh:'NiMS'
                                                              clientRole:'prmy'
                                                              clientName:@"Testing 123"];
    
    NSLog(@" - %@", r);
    NSLog(@" ");
    
    if (r.success == NO)
        return;
    
    requestClient      = [[NIControllerRequestClient alloc]      initWithName:r.inPortName];
    notificationServer = [[NIControllerNotificationServer alloc] initWithName:r.outPortName];
    
    [notificationServer scheduleInRunLoop:[NSRunLoop currentRunLoop]];
    [requestClient setNotificationPortName:r.outPortName];
}

@end
