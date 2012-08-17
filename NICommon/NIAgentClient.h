//
//  NIAgentClient.h
//  Macchina
//
//  Created by Antonio "Willy" Malara on 16/08/12.
//  Copyright (c) 2012 Antonio "Willy" Malara. All rights reserved.
//

#import "NIMainHandlerClient.h"
#import "NIControllerRequestClient.h"
#import "NIControllerNotificationServer.h"

@interface NIAgentClient : NSObject

@property (readonly) NIMainHandlerClient            * mainHandler;
@property (readonly) NIControllerRequestClient      * requestClient;
@property (readonly) NIControllerNotificationServer * notificationServer;

- (void)connect;
- (void)sendTestImage;

@end
