//
//  main.m
//  MacchinaServer
//
//  Created by Antonio "Willy" Malara on 16/08/12.
//  Copyright (c) 2012 Antonio "Willy" Malara. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NIAgent.h"

int main(int argc, const char * argv[])
{
    @autoreleasepool
    {
        NIAgent * agent = [NIAgent new];
        [agent scheduleInRunLoop:[NSRunLoop currentRunLoop]];
        [[NSRunLoop currentRunLoop] run];
    }
    return 0;
}

