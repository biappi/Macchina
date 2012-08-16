//
//  NIResponse.m
//  Macchina
//
//  Created by Antonio "Willy" Malara on 16/08/12.
//  Copyright (c) 2012 Antonio "Willy" Malara. All rights reserved.
//

#import "NIResponse.h"

@interface NIResponse ()
- (void)parseData:(NSData *)data;
@end

@implementation NIResponse
{
    NSData * data;
}

+ (id)responseWithData:(NSData *)data;
{
    NIResponse * zelf = [[[self class] alloc] initWithData:data];
    return zelf;
}

- (id)initWithData:(NSData *)theData;
{
    if ((self = [super init]) == nil)
        return nil;
    
    [self parseData:theData];
    
    return self;
}

- (void)parseData:(NSData *)theData;
{
    data = theData;
}

- (NSData *)dataRepresentation;
{
    return data;
}

@end

@implementation NISingleInt32Response

- (void)parseData:(NSData *)theData;
{
    self.response =  *((uint32_t *)(theData.bytes));
}

- (NSData *)dataRepresentation;
{
    return [NSData dataWithBytes:&_response length:sizeof(_response)];
}

- (NSString *)description;
{
    return [NSString stringWithFormat:@"%@ - %08x", [super description], self.response];
}

@end

@implementation  NIDeviceConnectResponse

- (void)parseData:(NSData *)data;
{
    uint8_t * response = (uint8_t *)data.bytes;
    self.success = (*((uint32_t *)(response)) == 'true');
    
    if (!self.success)
        return;
    
    uint32_t   inPortLen   = *((uint32_t *)(response + 0x04));
    uint32_t   outPortLen  = *((uint32_t *)(response + 0x08 + inPortLen));
    
    NSData   * inPortData  = [NSData dataWithBytes:response + 0x08             length:inPortLen  - 1];
    NSData   * outPortData = [NSData dataWithBytes:response + 0x0c + inPortLen length:outPortLen - 1];
    
    self.inPortName  = [[NSString alloc] initWithData:inPortData  encoding:NSUTF8StringEncoding];
    self.outPortName = [[NSString alloc] initWithData:outPortData encoding:NSUTF8StringEncoding];
}

- (NSData *)dataRepresentation;
{
    NSData      * inPortNameData  = [self.inPortName dataUsingEncoding:NSUTF8StringEncoding];
    uint32_t      inPortLen       = (uint32_t)inPortNameData.length;
    
    NSData      * outPortNameData = [self.outPortName dataUsingEncoding:NSUTF8StringEncoding];
    uint32_t      outPortLen      = (uint32_t)outPortNameData.length;
    
    uint32_t      replyLen        = 0x0c + inPortLen + outPortLen + 2;
    
    uint8_t reply[replyLen];
    memset(reply, 0, replyLen);
    
    *((uint32_t *)(reply + 0x00)) = 'true';
    *((uint32_t *)(reply + 0x04)) = inPortLen + 1;
    *((uint32_t *)(reply + 0x08 + inPortLen + 1)) = outPortLen + 1;
    
    memcpy(reply + 0x08,                 inPortNameData.bytes,  inPortLen);
    memcpy(reply + 0x0c + inPortLen + 1, outPortNameData.bytes, outPortLen);
    
    return [NSData dataWithBytes:reply length:replyLen];
}

- (NSString *)description;
{
    return [NSString stringWithFormat:@"%@ - success: %d - inPortName: %@ - outPortName: %@",
                [super description],
                self.success,
                self.inPortName,
                self.outPortName];
}

@end
