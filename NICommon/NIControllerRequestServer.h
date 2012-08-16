//
//  NIControllerRequestServer.h
//  Macchina
//
//  Created by Antonio "Willy" Malara on 16/08/12.
//  Copyright (c) 2012 Antonio "Willy" Malara. All rights reserved.
//

#import "NIServer.h"

@class NIAgent;

@interface NIControllerRequestServer : NIServer
@property __weak NIAgent * agent;
@end
