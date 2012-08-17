//
//  NIProtocolMessages.m
//  Macchina
//
//  Created by Antonio "Willy" Malara on 17/08/12.
//  Copyright (c) 2012 Antonio "Willy" Malara. All rights reserved.
//

#import "NIProtocolMessages.h"

@implementation NIDeviceStateChangeMessage  @end
@implementation NIGetDeviceEnabledMessage   @end
@implementation NIGetServiceVersionMessage  @end
@implementation NIGetDeviceAvailableMessage @end

@implementation NIDeviceConnectMessage

+ (NIMessage *)messageFromData:(NSData *)data;
{
    NIDeviceConnectMessage * m = [NIDeviceConnectMessage new];
    const void * bytes = data.bytes;
    
    m.controllerId = *(uint32_t *)(bytes + 0x04);
    m.boh          = *(uint32_t *)(bytes + 0x08);
    m.clientRole   = *(uint32_t *)(bytes + 0x0c);
    
    {
        uint32_t   nameLenght = *(uint32_t *)(bytes + 0x10);
        uint16_t * wideString =  (uint16_t *)(bytes + 0x14);
        
        char name[nameLenght];
        memset(&name, 0, nameLenght);
        
        for (int i = 0; i < nameLenght; i++)
            name[i] = wideString[i];
        
        m.clientName = [NSString stringWithCString:name encoding:NSUTF8StringEncoding];
    }
    
    return m;
}

- (NSData *)dataRepresentation;
{
    NSData * clientNameData = [self.clientName dataUsingEncoding:NSASCIIStringEncoding
                                            allowLossyConversion:YES];
    size_t   clientNameLen  = (clientNameData.length + 1) * 2;
    size_t   messageDataLen = 0x20 + clientNameLen;
    
    uint8_t msgData[messageDataLen];
    *((uint32_t *)(msgData + 0x00)) = self.messageId;
    *((uint32_t *)(msgData + 0x04)) = self.controllerId;
    *((uint32_t *)(msgData + 0x08)) = self.boh;
    *((uint32_t *)(msgData + 0x0c)) = self.clientRole;
    
    uint16_t * msgClientName = ((uint16_t *)(msgData + 0x20));
    uint8_t  * clientName    = (uint8_t *)clientNameData.bytes;
    
    for (int i = 0; i < clientNameData.length; i++)
        msgClientName[i] = clientName[i];
    
    msgClientName[clientNameData.length] = 0;
    
    return [NSData dataWithBytes:msgData length:messageDataLen];
}

- (NSString *)description;
{
    return [NSString stringWithFormat:@"%@ - id: %08x boh: %08x, role: %08x, name: %@",
            [super description],
            self.controllerId,
            self.boh,
            self.clientRole,
            self.clientName];
}

@end

@implementation NISetAsciiStringMessage

+ (NIMessage *)messageFromData:(NSData *)data;
{
    NISetAsciiStringMessage * m = [NISetAsciiStringMessage new];
    const void * bytes = data.bytes;
    
    m.boh1   = *(uint32_t *)(bytes + 0x04);
    m.boh2   = *(uint32_t *)(bytes + 0x08);
    
    m.string = [NSString stringWithCString:(char *)(bytes + 0x10) encoding:NSUTF8StringEncoding];
    
    return m;
}

- (NSData *)dataRepresentation;
{
    NSData * stringData = [self.string dataUsingEncoding:NSASCIIStringEncoding
                                    allowLossyConversion:YES];
    
    size_t   messageDataLen = 0x10 + stringData.length + 1;
    
    uint8_t msgData[messageDataLen];
    *((uint32_t *)(msgData + 0x00)) = self.messageId;
    *((uint32_t *)(msgData + 0x04)) = self.boh1;
    *((uint32_t *)(msgData + 0x08)) = self.boh2;
    *((uint32_t *)(msgData + 0x0c)) = (uint32_t)(stringData.length + 1);
    memcpy(msgData + 0x10, stringData.bytes, stringData.length);
    msgData[stringData.length + 0x10] = 0;
    
    return [NSData dataWithBytes:msgData length:messageDataLen];
}

- (NSString *)description;
{
    return [NSString stringWithFormat:@"%@ - boh1: %08x, boh2: %08x, string: %@",
            [super description],
            self.boh1,
            self.boh2,
            self.string];
}

@end
