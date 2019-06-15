//
//  NSObject+HJ_AssociatedObjcCategory.h
//  HJAppHelper
//
//  Created by xingzhijishu on 2019/6/15.
//  Copyright © 2019 huangjian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HJ_AssociatedObjectHelper.h"

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (HJ_AssociatedObjcCategory)

@property (nonatomic, strong) NSString * name;
@property (nonatomic, assign) BOOL isRight;

@end

NS_ASSUME_NONNULL_END
