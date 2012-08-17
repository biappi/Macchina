//
//  NIProtocolMessages.h
//  Macchina
//
//  Created by Antonio "Willy" Malara on 17/08/12.
//  Copyright (c) 2012 Antonio "Willy" Malara. All rights reserved.
//

#import "NIMessageBases.h"

@interface NIGetServiceVersionMessage   : NIPlainMessage       @end
@interface NIGetDriverVersionMessage    : NIPlainMessage       @end
@interface NIGetFirmwareVersionMessage  : NIPlainMessage       @end
@interface NIGetSerialNumberMessage     : NIPlainMessage       @end
@interface NIGetDeviceAvailableMessage  : NIPlainMessage       @end
@interface NIDeviceStateChangeMessage   : NINumberValueMessage @end
@interface NIGetDisplayInvertedMessage  : NINumberValueMessage @end
@interface NIGetDisplayContrastMessage  : NINumberValueMessage @end
@interface NIGetDisplayBacklightMessage : NINumberValueMessage @end
@interface NIGetFloatPropertyMessage    : NINumberValueMessage @end
@interface NIGetDeviceEnabledMessage    : NINumberValueMessage @end
@interface NISetFocusMessage            : NINumberValueMessage @end

@interface NIDeviceConnectMessage : NIMessage
@property uint32_t   controllerId;
@property uint32_t   boh;
@property uint32_t   clientRole;
@property NSString * clientName;
@end

@interface NISetAsciiStringMessage : NIMessage
@property uint32_t   boh1;
@property uint32_t   boh2;
@property NSString * string;
@end
