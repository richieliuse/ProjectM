//
//  NSObject+ParamsExtend.h
//  DemoProj
//
//  Created by Jonathan Liu on 13-1-31.
//  Copyright (c) 2013年 Jonathan Liu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (ParamsExtend)

- (id)performSelector:(SEL)aSelector withObjects:(NSArray *)objects;
- (id)performSelector:(SEL)aSelector withParameters:(void *)firstParameter, ...;

@end
