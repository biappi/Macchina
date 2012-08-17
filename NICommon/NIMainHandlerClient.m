//
//  NIMainHandlerClient.m
//  Macchina
//
//  Created by Antonio "Willy" Malara on 16/08/12.
//  Copyright (c) 2012 Antonio "Willy" Malara. All rights reserved.
//

#import "NIMainHandlerClient.h"
#import "NIProtocolMessages.h"

@implementation NIMainHandlerClient

- (uint32_t)getServiceVersion;
{
    NSData * data = [self sendMessage:[NIGetServiceVersionMessage new]];
    NISingleInt32Response * r = [NISingleInt32Response responseWithData:data];
    return r.response;
}

- (NIDeviceConnectResponse *)connectToControllerWithId:(uint32_t)controllerId
                                                   boh:(uint32_t)boh
                                            clientRole:(uint32_t)clientRole
                                            clientName:(NSString *)clientName;
{
    NIDeviceConnectMessage * msg = [NIDeviceConnectMessage new];
    msg.controllerId = controllerId;
    msg.boh = boh;
    msg.clientRole = clientRole;
    msg.clientName = clientName;
    
    NSData * data = [self sendMessage:msg];
    return [NIDeviceConnectResponse responseWithData:data];
}

@end
