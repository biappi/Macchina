//
//  NIMainHandlerClient.h
//  Macchina
//
//  Created by Antonio "Willy" Malara on 16/08/12.
//  Copyright (c) 2012 Antonio "Willy" Malara. All rights reserved.
//

#import "NIClient.h"
#import "NIResponse.h"

@interface NIMainHandlerClient : NIClient

- (uint32_t)getServiceVersion;
- (NIDeviceConnectResponse *)connectToControllerWithId:(uint32_t)controllerId
                                                   boh:(uint32_t)boh
                                            clientRole:(uint32_t)clientRole
                                            clientName:(NSString *)clientName;

@end
