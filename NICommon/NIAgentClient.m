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
{
    NILedState * ledState;
    int          curLed;
}

- (id)init;
{
    if ((self = [super init]) == nil)
        return nil;
    
    _mainHandler = [[NIMainHandlerClient alloc] initWithName:@"NIHWMainHandler"];
    ledState = [NILedState new];
    
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
    [self.requestClient sendMessage:m];
    m.displayNumber = 1;
    [self.requestClient sendMessage:m];
    [self ledtest];
}

- (void)ledtest;
{
    [ledState setLed:curLed - 1 intensity:0x00];
    [ledState setLed:curLed     intensity:0x3f];
    
    curLed = (curLed + 1) % 57;
    
    NISetLedStateMessage * m = [NISetLedStateMessage new];
    m.state = ledState;
    
    [self.requestClient sendMessage:m];
    
    [self performSelector:@selector(ledtest) withObject:nil afterDelay:0.5];
}

@end
