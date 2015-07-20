//
//  NSString+Util.m
//  Immersion
//
//  Created by HuangYiFeng on 7/20/15.
//  Copyright (c) 2015 HYF. All rights reserved.
//

#import "NSString+Util.h"

@implementation NSString (Util)

+ (NSString *)stringFromTimeInterval:(NSTimeInterval)interval
{
    NSInteger second = (NSInteger)interval % 60;
    NSInteger minute = interval / 60;
    
    NSString *retVal = [NSString stringWithFormat:@"%02ld:%02ld", minute, second];
    return retVal;
}

@end
