//
//  NIControllerNotificationServer.h
//  Macchina
//
//  Created by Antonio "Willy" Malara on 16/08/12.
//  Copyright (c) 2012 Antonio "Willy" Malara. All rights reserved.
//

#import "NIServer.h"

@class NIAgentClient;

@interface NIControllerNotificationServer : NIServer
@property __weak NIAgentClient * agentClient;
@end
