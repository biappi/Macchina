//
//  NIMainHandlerServer.m
//  Macchina
//
//  Created by Antonio "Willy" Malara on 16/08/12.
//  Copyright (c) 2012 Antonio "Willy" Malara. All rights reserved.
//

#import "NIMainHandlerServer.h"
#import "NIProtocolMessages.h"

@implementation NIMainHandlerServer

- (NSData *)handleNIGetServiceVersionMessage:(NIGetServiceVersionMessage *)message;
{
    uint32_t version = 0x00010400;
    return [NSData dataWithBytes:&version length:sizeof(version)];
}

- (NSData *)handleNIDeviceConnectMessage:(NIDeviceConnectMessage *)message;
{
    if (message.controllerId != 0x00000808)
    {
        uint32_t fail = 'fail';
        NSLog(@" is not a maschine, failing");
        return [NSData dataWithBytes:&fail length:sizeof(fail)];
    }
    
    char        * inPortName  = "NIHWMaschineController0001Request";
    uint32_t      inPortLen   = (uint32_t)strlen(inPortName);
    
    char        * outPortName = "NIHWMaschineController0001Notification";
    uint32_t      outPortLen  = (uint32_t)strlen(outPortName);
    
    uint32_t      replyLen    = 0x0c + inPortLen + outPortLen + 2;
    
    uint8_t reply[replyLen];
    memset(reply, 0, replyLen);
    
    *((uint32_t *)(reply + 0x00)) = 'true';
    *((uint32_t *)(reply + 0x04)) = inPortLen + 1;
    *((uint32_t *)(reply + 0x08 + inPortLen + 1)) = outPortLen + 1;
    
    memcpy(reply + 0x08,                 inPortName,  inPortLen);
    memcpy(reply + 0x0c + inPortLen + 1, outPortName, outPortLen);
    
    return [NSData dataWithBytes:reply length:replyLen];
}

- (NSData *)handleNIGetDeviceEnabledMessage:(NIGetDeviceEnabledMessage *)message;
{
    uint32_t theTrue = 'true';
    return [NSData dataWithBytes:&theTrue length:sizeof(theTrue)];
}

@end
