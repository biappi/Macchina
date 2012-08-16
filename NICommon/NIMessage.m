//
//  NIMessage.m
//  Macchina
//
//  Created by Antonio "Willy" Malara on 15/08/12.
//  Copyright (c) 2012 Antonio "Willy" Malara. All rights reserved.
//

#import "NIMessage.h"

typedef struct {
                        uint32_t   messageId;
    __unsafe_unretained NSString * className;
} MessageIdToString;

MessageIdToString MessageIdToStringTable[] = {
    { 0x02536756, @"NIGetServiceVersionMessage" },
    { 0x02444300, @"NIDeviceConnectMessage"     },
    { 0x02404300, @"NISetAsciiStringMessage"    },
    { 0x02446724, @"NIGetDeviceEnabledMessage"  },
    { 0x02444e00, @"NIDeviceStateChangeMessage" },
};

Class    ClassForMessageID(uint32_t messageId);
uint32_t MessageIDForClass(Class aClass);

@implementation NIMessage

+ (NIMessage *)messageFromData:(NSData *)data;
{
    if (data.length < 4)
        return nil;
    
    uint32_t messageId = *((uint32_t *)data.bytes);
    NIMessage * m = [ClassForMessageID(messageId) messageFromData:data];
    
    return m;
}

- (uint32_t)messageId;
{
    return MessageIDForClass([self class]);
}

- (NSData *)dataRepresentation;
{
    NSAssert(false, @"Specialize %s for %@", __PRETTY_FUNCTION__, [self className]);
    return nil;
}

- (NSString *)description;
{
    return [NSString stringWithFormat:@"%@ %08x", [super description], self.messageId];
}

@end

@implementation NIUnknownMessage
{
    NSData * data;
}

+ (NIMessage * )messageFromData:(NSData *)data;
{
    NIUnknownMessage *zelf = [NIUnknownMessage new];
    zelf->data = data;
    return zelf;
}

- (uint32_t)messageId;
{
    return *((uint32_t *)data.bytes);
}

- (NSData *)dataRepresentation;
{
    return data;
}

- (NSString *)description;
{
    return [NSString stringWithFormat:@"%@ - %@", [super description], data];
}

@end

@implementation NIGetServiceVersionMessage

+ (NIMessage *)messageFromData:(NSData *)data;
{
    return [NIGetServiceVersionMessage new];
}

- (NSData *)dataRepresentation;
{
    uint32_t data = self.messageId;
    return [NSData dataWithBytes:&data length:sizeof(data)];
}

@end

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

@implementation NIGetDeviceEnabledMessage

+ (NIMessage *)messageFromData:(NSData *)data;
{
    NIGetDeviceEnabledMessage * m = [NIGetDeviceEnabledMessage new];
    m.boh = *(uint32_t *)(data.bytes + 8);
    return m;
}

- (NSData *)dataRepresentation;
{
    uint32_t message[] = {
        self.messageId,
        self.boh,
    };
    
    return [NSData dataWithBytes:&message length:sizeof(message)];
}

- (NSString *)description;
{
    return [NSString stringWithFormat:@"%@ - boh: %08x",
                [super description],
                self.boh];
}

@end

@implementation NIDeviceStateChangeMessage

+ (NIDeviceStateChangeMessage *)messageWithDeviceState:(BOOL)s;
{
    NIDeviceStateChangeMessage * m = [NIDeviceStateChangeMessage new];
    m.deviceState = s;
    return m;
}

+ (NIMessage *)messageFromData:(NSData *)data;
{
    NIDeviceStateChangeMessage * m = [NIDeviceStateChangeMessage new];
    m.deviceState = *(uint32_t *)(data.bytes + 8) == 'true';
    return m;
}

- (NSData *)dataRepresentation;
{
    uint32_t message[] = {
        self.messageId,
        self.deviceState ? 'true' : 0,
    };
    
    return [NSData dataWithBytes:&message length:sizeof(message)];
}

- (NSString *)description;
{
    return [NSString stringWithFormat:@"%@ - deviceState: %08x",
            [super description],
            self.deviceState];
}

@end

Class ClassForMessageID(uint32_t messageId)
{
    for (int i = 0;
         i < sizeof(MessageIdToStringTable) / sizeof(MessageIdToString);
         i++)
    {
        if (messageId == MessageIdToStringTable[i].messageId)
            return NSClassFromString(MessageIdToStringTable[i].className);
    }
    
    return [NIUnknownMessage class];
}

uint32_t MessageIDForClass(Class aClass)
{
    NSString *className = NSStringFromClass(aClass);
    
    for (int i = 0;
         i < sizeof(MessageIdToStringTable) / sizeof(MessageIdToString);
         i++)
    {
        if ([MessageIdToStringTable[i].className isEqualToString:className])
            return MessageIdToStringTable[i].messageId;
    }
    
    return 0;
}
