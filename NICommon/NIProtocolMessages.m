//
//  NIProtocolMessages.m
//  Macchina
//
//  Created by Antonio "Willy" Malara on 17/08/12.
//  Copyright (c) 2012 Antonio "Willy" Malara. All rights reserved.
//

#import "NIProtocolMessages.h"

@implementation NIDeviceStateChangeMessage   @end
@implementation NIGetDeviceEnabledMessage    @end
@implementation NIGetServiceVersionMessage   @end
@implementation NIGetDeviceAvailableMessage  @end
@implementation NISetFocusMessage            @end
@implementation NIGetDriverVersionMessage    @end
@implementation NIGetFirmwareVersionMessage  @end
@implementation NIGetSerialNumberMessage     @end
@implementation NIGetDisplayInvertedMessage  @end
@implementation NIGetDisplayContrastMessage  @end
@implementation NIGetDisplayBacklightMessage @end
@implementation NIGetFloatPropertyMessage    @end

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

@implementation NIDisplayDrawMessage : NIMessage

- (NSData *)dataRepresentation;
{
    struct packet {
        uint32_t msgid;
        uint32_t dispn;
        uint16_t y;
        uint16_t x;
        uint16_t h;
        uint16_t w;
        uint32_t size;
    };
    
    struct packet p;
    p.msgid = self.messageId;
    p.dispn = self.displayNumber | 0x10000000;
    p.x = self.originX;
    p.y = self.originY;
    p.w = self.sizeWidth;
    p.h = self.sizeHeight;
    p.size = (uint32_t)self.st7529EncodedImage.length;
    
    NSMutableData * data = [NSMutableData dataWithBytes:&p length:sizeof(struct packet)];
    [data appendData:self.st7529EncodedImage];
    
    return data;
}

- (NSString *)description;
{
    return [NSString stringWithFormat:@"%@ - display: %d, rect: {%d, %d, %d, %d}",
            [super description],
            self.displayNumber,
            self.originX,
            self.originY,
            self.sizeWidth,
            self.sizeHeight];
}

@end

@implementation NIWheelsChangedEvent

- (NSString *)description;
{
    return [NSString stringWithFormat:@"{%d, %f}", self.wheelId, self.delta];
}

@end

@implementation NIWheelsChangedMessage

+ (NIMessage *)messageFromData:(NSData *)data;
{
    NIWheelsChangedMessage * m = [[self class] new];
    const void * bytes = data.bytes;
    
    m.boh1   = *(uint32_t *)(bytes + 0x04);
    m.boh2   = *(uint32_t *)(bytes + 0x08);
    
    uint32_t   numberOfEvents = *(uint32_t *)(bytes + 0x0c);
    uint32_t * eventsList     =  (uint32_t *)(bytes + 0x10);
    
    NSMutableArray * events = [NSMutableArray arrayWithCapacity:numberOfEvents];
    
    for (int i = 0; i < numberOfEvents; i++)
    {
        NIWheelsChangedEvent * e = [NIWheelsChangedEvent new];
        e.wheelId = eventsList[i * 2];
        e.delta   = ((float *)eventsList)[i * 2 + 1];
        [events addObject:e];
    }
    
    m.events = events;
    
    return m;
}

- (NSString *)description;
{
    NSMutableArray * descs = [NSMutableArray arrayWithCapacity:self.events.count];
    for (NIWheelsChangedEvent * e in self.events)
        [descs addObject:[e description]];
    
    return [NSString stringWithFormat:@"%@ - boh1: %08x, boh2: %08x, [%@]",
            [super description],
            self.boh1,
            self.boh2,
            [descs componentsJoinedByString:@", "]];
}

@end
