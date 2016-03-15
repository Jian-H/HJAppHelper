//
//  NSMutableArray+SafeArray.h
//  HJAppHelper
//
//  Created by huangjian on 16/3/15.
//  Copyright © 2016年 huangjian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableArray (SafeArray)

- (id) safeObjectAtIndex:(NSUInteger)index;
- (void) safeAddObject:(id)anObject;
- (void) safeRemoveObjectAtIndex:(NSUInteger)index ;

@end
