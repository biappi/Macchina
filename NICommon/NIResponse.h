//
//  NIResponse.h
//  Macchina
//
//  Created by Antonio "Willy" Malara on 16/08/12.
//  Copyright (c) 2012 Antonio "Willy" Malara. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NIResponse : NSObject
+ (id)responseWithData:(NSData *)data;
- (id)initWithData:(NSData *)data;
- (NSData *)dataRepresentation;
@end

@interface NISingleInt32Response : NIResponse
@property uint32_t response;
@end

@interface NIDeviceConnectResponse : NIResponse
@property BOOL success;
@property NSString * inPortName;
@property NSString * outPortName;
@end
