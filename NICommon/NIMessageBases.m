//
//  NIMessageBases.m
//  Macchina
//
//  Created by Antonio "Willy" Malara on 17/08/12.
//  Copyright (c) 2012 Antonio "Willy" Malara. All rights reserved.
//

#import "NIMessageBases.h"

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

@implementation NIPlainMessage

+ (NIMessage *)messageFromData:(NSData *)data;
{
    return [[self class] new];
}

- (NSData *)dataRepresentation;
{
    uint32_t data = self.messageId;
    return [NSData dataWithBytes:&data length:sizeof(data)];
}

@end

@implementation NINumberValueMessage

+ (NINumberValueMessage *)messageWithValue:(uint32_t)s;
{
    NINumberValueMessage * m = [[self class] new];
    m.value = s;
    return m;
}

+ (NINumberValueMessage *)messageWithBool:(BOOL)s;
{
    NINumberValueMessage * m = [[self class] new];
    m.isTrue = s;
    return m;
}

+ (NINumberValueMessage *)messageFromData:(NSData *)data;
{
    NINumberValueMessage * m = [[self class] new];
    m.value = *(uint32_t *)(data.bytes + 8);
    return m;
}

- (BOOL)isTrue;
{
     return self.value == 'true';
}

- (void)setIsTrue:(BOOL)isTrue;
{
    self.value = isTrue ? 'true' : 0;
}

- (NSData *)dataRepresentation;
{
    uint32_t message[] = {
        self.messageId,
        self.value ? 'true' : 0,
    };
    
    return [NSData dataWithBytes:&message length:sizeof(message)];
}

- (NSString *)description;
{
    return [NSString stringWithFormat:@"%@ - value: %08x - isTrue: %@",
            [super description],
            self.value,
            self.isTrue ? @"YES" : @"NO"];
}

@end
