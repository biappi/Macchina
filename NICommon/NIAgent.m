//
//  NIAgent.m
//  Macchina
//
//  Created by Antonio "Willy" Malara on 15/08/12.
//  Copyright (c) 2012 Antonio "Willy" Malara. All rights reserved.
//

#import "NIAgent.h"
#import "NIMainHandlerServer.h"
#import "NIControllerRequestServer.h"
#import "NIProtocolMessages.h"

@implementation NIAgent

- (id) init;
{
    if ((self = [super init]) == nil)
        return nil;
    
    _mainHandlerServer = [[NIMainHandlerServer alloc] initWithName:@"NIHWMainHandler"];
    _controllerRequestServer = [[NIControllerRequestServer alloc] initWithName:@"NIHWMaschineController0001Request"];
    _controllerRequestServer.agent = self;
    
    _controllerRequestMidiServer = [[NIControllerRequestServer alloc] initWithName:@"NIHWMaschineController0001RequestMidi"];
    
    return self;
}

- (void)scheduleInRunLoop:(NSRunLoop *)runloop;
{
    [self.mainHandlerServer scheduleInRunLoop:runloop];
    [self.controllerRequestServer scheduleInRunLoop:runloop];
}

- (void)createNotificationClientWithName:(NSString *)name;
{
    _controllerNotificationClient = [[NIClient alloc] initWithName:name];
    
    [self performSelector:@selector(puppa) withObject:nil afterDelay:5];
}

- (void)puppa;
{
    [self.controllerNotificationClient sendMessage:[NIDeviceStateChangeMessage messageWithBool:YES]];
    [self.controllerNotificationClient sendMessage:[NISetFocusMessage messageWithBool:YES]];
}

@end
