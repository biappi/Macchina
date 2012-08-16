//
//  NIAgent.h
//  Macchina
//
//  Created by Antonio "Willy" Malara on 15/08/12.
//  Copyright (c) 2012 Antonio "Willy" Malara. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NIMainHandlerServer.h"
#import "NIControllerRequestServer.h"
#import "NIClient.h"

@interface NIAgent : NSObject

@property (readonly) NIMainHandlerServer       * mainHandlerServer;
@property (readonly) NIControllerRequestServer * controllerRequestServer;
@property (readonly) NIClient                  * controllerNotificationClient;
@property (readonly) NIServer                  * controllerRequestMidiServer;

- (void)scheduleInRunLoop:(NSRunLoop *)runloop;
- (void)createNotificationClientWithName:(NSString *)name;

@end
