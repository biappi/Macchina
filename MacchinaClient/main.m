//
//  main.m
//  MacchinaClient
//
//  Created by Antonio "Willy" Malara on 16/08/12.
//  Copyright (c) 2012 Antonio "Willy" Malara. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NIAgentClient.h"

int main(int argc, const char * argv[])
{
    @autoreleasepool
    {
        NIAgentClient * agent = [NIAgentClient new];
        [agent connect];
        [[NSRunLoop currentRunLoop] run];
    }
    return 0;
}

