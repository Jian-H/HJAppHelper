//
//  NSMutableArray+SafeArray.m
//  HJAppHelper
//
//  Created by huangjian on 16/3/15.
//  Copyright © 2016年 huangjian. All rights reserved.
//

#import "NSMutableArray+SafeArray.h"

@implementation NSMutableArray (SafeArray)

- (id) safeObjectAtIndex:(NSUInteger)index {
    if (self.count > index) {
        return [self objectAtIndex:index];
    }
    else return nil;
}
- (void) safeAddObject:(id)anObject {
    if (anObject) {
        [self addObject:anObject];
    }
}

- (void) safeRemoveObjectAtIndex:(NSUInteger)index {
    if (self.count > index) {
        return [self removeObjectAtIndex:index];
    }
}


@end
