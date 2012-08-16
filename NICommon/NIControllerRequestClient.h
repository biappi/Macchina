//
//  NIControllerRequestClient.h
//  Macchina
//
//  Created by Antonio "Willy" Malara on 16/08/12.
//  Copyright (c) 2012 Antonio "Willy" Malara. All rights reserved.
//

#import "NIClient.h"

@interface NIControllerRequestClient : NIClient

- (uint32_t)setNotificationPortName:(NSString *)name;

@end
