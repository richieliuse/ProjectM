//
//  BNRTimeBlock.m
//  DemoProj
//
//  Created by Richie Liu on 13-2-19.
//  Copyright (c) 2013年 Richie Liu. All rights reserved.
//

#import "BNRTimeBlock.h"
#import <mach/mach_time.h>  // for mach_absolute_time() and friends

CGFloat BNRTimeBlock(void (^block)(void))
{
    mach_timebase_info_data_t info;

    if (mach_timebase_info(&info) != KERN_SUCCESS) {
        return -1.0;
    }

    uint64_t start = mach_absolute_time();
    block();
    uint64_t    end = mach_absolute_time();
    uint64_t    elapsed = end - start;

    uint64_t nanos = elapsed * info.numer / info.denom;
    return (CGFloat)nanos / NSEC_PER_SEC;
} // BNRTimeBlock
