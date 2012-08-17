//
//  NIImageConversions.h
//  Macchina
//
//  Created by Antonio "Willy" Malara on 17/08/12.
//  Copyright (c) 2012 Antonio "Willy" Malara. All rights reserved.
//

#import "NIProtocolMessages.h"

NIDisplayDrawMessage * TestImageDataMessage();
NSData * NI24BPPToST7529Data(uint16_t width, uint16_t height, const uint8_t * bitmap);