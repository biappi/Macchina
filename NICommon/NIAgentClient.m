//
//  NIAgentClient.m
//  Macchina
//
//  Created by Antonio "Willy" Malara on 16/08/12.
//  Copyright (c) 2012 Antonio "Willy" Malara. All rights reserved.
//

#import "NIAgentClient.h"
#import "NIImageConversions.h"

@implementation NIAgentClient

- (id)init;
{
    if ((self = [super init]) == nil)
        return nil;
    
    _mainHandler = [[NIMainHandlerClient alloc] initWithName:@"NIHWMainHandler"];
    
    return self;
}

- (void)connect;
{
    NIDeviceConnectResponse * r = [self.mainHandler connectToControllerWithId:0x00000808
                                                                          boh:'NiMS'
                                                                   clientRole:'prmy'
                                                                   clientName:@"Testing 123"];
    
    NSLog(@" - %@", r);
    NSLog(@" ");
    
    if (r.success == NO)
        return;
    
    _requestClient      = [[NIControllerRequestClient alloc]      initWithName:r.inPortName];
    _notificationServer = [[NIControllerNotificationServer alloc] initWithName:r.outPortName];
    _notificationServer.agentClient = self;
    
    [_notificationServer scheduleInRunLoop:[NSRunLoop currentRunLoop]];
    [_requestClient setNotificationPortName:r.outPortName];
}

- (void)sendTestImage;
{
    NIDisplayDrawMessage * m = TestImageDataMessage();
    [_requestClient sendMessage:m];
    m.displayNumber = 1;
    [_requestClient sendMessage:m];
}

@end
