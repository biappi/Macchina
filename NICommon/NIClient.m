//
//  NIClient.m
//  Macchina
//
//  Created by Antonio "Willy" Malara on 16/08/12.
//  Copyright (c) 2012 Antonio "Willy" Malara. All rights reserved.
//

#import "NIClient.h"
#import "NIResponse.h"
#import "NIServer.h"

@implementation NIClient
{
    CFMessagePortRef   port;
    NSString         * name;
}

- (id)initWithName:(NSString *)theName;
{
    if ((self = [super init]) == nil)
        return nil;
    
    name = theName;
    port = CFMessagePortCreateRemote(NULL, (__bridge CFStringRef)(name));
    
    return self;
}

- (void)dealloc;
{
    CFRelease(port);
}

- (NSData *)sendMessage:(NIMessage *)message;
{
    CFDataRef replyData = NULL;
    CFMessagePortSendRequest(port,
                             message.messageId,
                             (__bridge CFDataRef)([message dataRepresentation]),
                             1,
                             1,
                             kCFRunLoopDefaultMode,
                             &replyData);
    
    NSLog(@"%@ -> %@", name, message);
    NSLog(@"%@ -> %@", name, [message dataRepresentation]);
    NSLog(@"%@ <- %@", name, replyData);
    NSLog(@" ");
    
    return CFBridgingRelease(replyData);
}

- (NSString *)name;
{
    return name;
}

@end
