//
//  NIImageConversions.m
//  Macchina
//
//  Created by Antonio "Willy" Malara on 17/08/12.
//  Copyright (c) 2012 Antonio "Willy" Malara. All rights reserved.
//

#import "NIImageConversions.h"
#import "TestImage.h"

NSData * NI24BPPToST7529Data(uint16_t width, uint16_t height, const uint8_t * bitmap)
{
    size_t    pixels    = width * height;
    size_t    imageSize = pixels / 3 * 2;
    uint8_t * imageData = (uint8_t *)malloc(imageSize);
    
    memset(imageData, 0, imageSize);
    
    for (int i = 0; i < pixels; i++)
    {
        const uint8_t * source = bitmap + (i * 3);
        
        uint32_t srcColor =
            *(source)     << 0x0F |
            *(source + 1) << 0x08 |
            *(source + 2);
        
        uint8_t dstColor = srcColor ? 0x1F : 0x00;
        size_t  dstPixel = (i / 3) * 2;
        
        switch (i % 3)
        {
            case 0:
                imageData[dstPixel    ]  = dstColor << 3;
                break;
                
            case 1:
                imageData[dstPixel    ] |= dstColor >> 2;
                imageData[dstPixel + 1]  = dstColor << 6;
                break;
                
            case 2:
                imageData[dstPixel + 1] |= dstColor;
                break;
        }
    }
    
    return [NSData dataWithBytesNoCopy:imageData length:imageSize freeWhenDone:YES];
}

NIDisplayDrawMessage * TestImageDataMessage()
{
    NIDisplayDrawMessage * test = [NIDisplayDrawMessage new];
    test.sizeWidth  = gimp_image.width;
    test.sizeHeight = gimp_image.height;
    test.st7529EncodedImage = NI24BPPToST7529Data(gimp_image.width,
                                                  gimp_image.height,
                                                  gimp_image.pixel_data);
    
    return test;
}