//
//  NSObject+ParamsExtend.m
//  DemoProj
//
//  Created by Jonathan Liu on 13-1-31.
//  Copyright (c) 2013年 Jonathan Liu. All rights reserved.
//

#import "NSObject+ParamsExtend.h"

@implementation NSObject (ParamsExtend)

- (id)performSelector:(SEL)aSelector withObjects:(NSArray *)objects
{
    NSMethodSignature   *signature = [self methodSignatureForSelector:aSelector];
    NSInvocation        *invocation = [NSInvocation invocationWithMethodSignature:signature];

    [invocation setTarget:self];
    [invocation setSelector:aSelector];

    NSUInteger i = 1;

    for (id object in objects) {
        [invocation setArgument:&object atIndex:++i];
    }

    [invocation invoke];

    if ([signature methodReturnLength]) {
        id data;
        [invocation getReturnValue:&data];
        return data;
    }

    return nil;
}

- (id)performSelector:(SEL)aSelector withParameters:(void *)firstParameter, ...
{
    NSMethodSignature   *signature = [self methodSignatureForSelector:aSelector];
    NSUInteger          length = [signature numberOfArguments];
    NSInvocation        *invocation = [NSInvocation invocationWithMethodSignature:signature];

    [invocation setTarget:self];
    [invocation setSelector:aSelector];

    [invocation setArgument:&firstParameter atIndex:2];
    va_list arg_ptr;
    va_start(arg_ptr, firstParameter);

    for (NSUInteger i = 3; i < length; ++i) {
        void *parameter = va_arg(arg_ptr, void *);
        [invocation setArgument:&parameter atIndex:i];
    }

    va_end(arg_ptr);

    [invocation invoke];

    if ([signature methodReturnLength]) {
        id data;
        [invocation getReturnValue:&data];
        return data;
    }

    return nil;
}

@end
