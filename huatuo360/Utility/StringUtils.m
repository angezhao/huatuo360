//
//  StringUtils.m
//  huatuo360
//
//  Created by Zhao Ange on 12-4-22.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "StringUtils.h"

@implementation StringUtils

+(NSUInteger)getStringLength:(NSString*)str{
    NSUInteger nameLength = 0;
    if(str != nil)
    {
        for(int i=0; i< [str length];i++){
            int a = [str characterAtIndex:i];
            if( a > 0x4e00 && a < 0x9fff)
                nameLength += 2;
            else 
                nameLength++;
        }
        NSLog(@"%i", nameLength);
    }
    return nameLength;
}
@end
