//
//  NIControllerRequestClient.m
//  Macchina
//
//  Created by Antonio "Willy" Malara on 16/08/12.
//  Copyright (c) 2012 Antonio "Willy" Malara. All rights reserved.
//

#import "NIControllerRequestClient.h"
#import "NIResponse.h"
#import "NIProtocolMessages.h"

@implementation NIControllerRequestClient

- (uint32_t)setNotificationPortName:(NSString *)name;
{
    NSData                  * responseData;
    NISetAsciiStringMessage * setNotificationPort;
    NISingleInt32Response   * response;
    
    setNotificationPort = [NISetAsciiStringMessage new];
    setNotificationPort.boh1 = 0xabababab;
    setNotificationPort.boh2 = 0xcdcdcdcd;
    setNotificationPort.string = name;
    
    responseData = [self sendMessage:setNotificationPort];
    response     = [NISingleInt32Response responseWithData:responseData];
    
    return response.response;
}

@end
