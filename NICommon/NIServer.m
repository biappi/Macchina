//
//  NIServer.m
//  Macchina
//
//  Created by Antonio "Willy" Malara on 16/08/12.
//  Copyright (c) 2012 Antonio "Willy" Malara. All rights reserved.
//

#import "NIServer.h"
#import "NIMessage.h"

static CFDataRef ServerPortCallback(CFMessagePortRef local,
                                    SInt32 msgid,
                                    CFDataRef data,
                                    void *info);

@implementation NIServer
{
    NSString           * name;
    CFMessagePortRef     port;
    CFRunLoopSourceRef   source;
}

- (id)initWithName:(NSString *)theName;
{
    if ((self = [super init]) == nil)
        return nil;
    
    CFMessagePortContext context;
    memset(&context, 0, sizeof(context));
    context.info = (__bridge void *)(self);
    
    name = theName;    
    port = CFMessagePortCreateLocal(NULL,
                                    (__bridge CFStringRef)(name),
                                    ServerPortCallback,
                                    &context,
                                    NULL);
    
    return self;
}

- (void)dealloc;
{
    CFRunLoopSourceInvalidate(source);
    CFRelease(source);
    CFRelease(port);
}

- (void)scheduleInRunLoop:(NSRunLoop *)runloop;
{
    CFRunLoopRef rl = [runloop getCFRunLoop];
    
    source = CFMessagePortCreateRunLoopSource(NULL, port, 0);
    CFRunLoopAddSource(rl, source, kCFRunLoopCommonModes);
}

- (NSData *)handleIncomingData:(NSData *)data;
{
    @autoreleasepool {
        NIMessage * message = [NIMessage messageFromData:data];
        if (message == nil)
            return nil;
        
        NSData   * response       = nil;
        NSString * selectorString = [NSString stringWithFormat:@"handle%@:", NSStringFromClass([message class])];
        SEL        selector       = NSSelectorFromString(selectorString);
        
        if ([self respondsToSelector:selector] == NO)
        {
            NSLog(@" --- MESSAGECLASS NOT HANDLED: IMPLEMENT -[%@ %@]", [self className], selectorString);
            NSLog(@" --- LOST MESSAGE - %@", message);
            NSLog(@" ");
            
            return nil;
        }
        
        NSLog(@"%@ <- %@", name, message);
        response = [self performSelector:selector withObject:message];
        NSLog(@"%@ -> %@", name, response);
        NSLog(@" ");
        
        return response;
    }
}

- (NSString *)name;
{
    return name;
}

@end

CFDataRef ServerPortCallback (CFMessagePortRef local, SInt32 msgid, CFDataRef data, void * info)
{
    NIServer * server = (__bridge NIServer *)info;
    NSData   * nsdata = (__bridge NSData *)(data);
    return CFBridgingRetain([server handleIncomingData:nsdata]);
}
