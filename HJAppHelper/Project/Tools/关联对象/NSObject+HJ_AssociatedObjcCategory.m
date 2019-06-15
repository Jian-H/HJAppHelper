//
//  NSObject+HJ_AssociatedObjcCategory.m
//  HJAppHelper
//
//  Created by xingzhijishu on 2019/6/15.
//  Copyright © 2019 huangjian. All rights reserved.
//

#import "NSObject+HJ_AssociatedObjcCategory.h"

@implementation NSObject (HJ_AssociatedObjcCategory)

ASSOCIATED(name, setName, NSString *, OBJC_ASSOCIATION_COPY_NONATOMIC)

ASSOCIATED_BOOL(isRight, setIsRight)

@end
