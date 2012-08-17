//
//  NIMessage.m
//  Macchina
//
//  Created by Antonio "Willy" Malara on 15/08/12.
//  Copyright (c) 2012 Antonio "Willy" Malara. All rights reserved.
//

#import "NIMessage.h"
#import "NIMessageBases.h"

typedef struct {
    uint32_t   messageId;
    __unsafe_unretained NSString * className;
} MessageIdToString;

Class    ClassForMessageID(uint32_t messageId);
uint32_t MessageIDForClass(Class aClass);

MessageIdToString MessageIdToStringTable[] = {
    { 0x02536756, @"NIGetServiceVersionMessage"   },
    { 0x02444300, @"NIDeviceConnectMessage"       },
    { 0x02404300, @"NISetAsciiStringMessage"      },
    { 0x02446724, @"NIGetDeviceEnabledMessage"    },
    { 0x02444e00, @"NIDeviceStateChangeMessage"   },
    { 0x02446743, @"NIGetDeviceAvailableMessage"  },
    { 0x02434e00, @"NISetFocusMessage"            },
    { 0x02446744, @"NIGetDriverVersionMessage"    },
    { 0x02436746, @"NIGetFirmwareVersionMessage"  },
    { 0x02436753, @"NIGetSerialNumberMessage"     },
    { 0x02646749, @"NIGetDisplayInvertedMessage"  },
    { 0x02646743, @"NIGetDisplayContrastMessage"  },
    { 0x02646742, @"NIGetDisplayBacklightMessage" },
    { 0x02566766, @"NIGetFloatPropertyMessage"    },
    { 0x02647344, @"NIDisplayDrawMessage"         },
    { 0x02654e00, @"NIWheelsChangedMessage"       },
    { 0x02504e00, @"NIPadsChangedMessage"         },
};

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
