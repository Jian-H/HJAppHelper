//
//  NSObject+RuntimeHelper.h
//  HJAppHelper
//
//  Created by xingzhijishu on 17/2/16.
//  Copyright © 2017年 huangjian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

@interface NSObject (RuntimeHelper)

#pragma mark -- 获取属性列表
- (void)getPropertyList;

#pragma mark -- 获取方法列表
- (void)getMethodList;

#pragma mark -- 获取成员变量列表
- (void)getIvarList;

#pragma mark -- 获取协议列表
- (void)getProtocolList;

#pragma mark -- 成员变量值替换
- (void)changeIvar:(NSString *)ivarName toObject:(id)object;

#pragma mark -- 获得实例方法
- (Method)getClassMethodWithSelector:(SEL)selector;

#pragma mark -- 添加方法

/**
 执行selector方法的时候添加method

 @param method 添加的方法
 @param selector 执行的方法
 @return 成功值
 */
- (BOOL)addCustomerMethod:(SEL)method originSelector:(SEL)selector;

@end
