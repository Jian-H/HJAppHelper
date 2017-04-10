//
//  NSObject+RuntimeHelper.m
//  HJAppHelper
//
//  Created by xingzhijishu on 17/2/16.
//  Copyright © 2017年 huangjian. All rights reserved.
//

#import "NSObject+RuntimeHelper.h"

@implementation NSObject (RuntimeHelper)

#pragma mark -- 获取属性列表
- (void)getPropertyList {

    unsigned int count = 0;
    
    objc_property_t * propertyList = class_copyPropertyList([self class], &count);
    
    for (unsigned int index = 0; index < count; index++) {
        
        const char * properName = property_getName(propertyList[index]);
        NSLog(@"Property------>%@",[NSString stringWithUTF8String:properName]);
    }
}

#pragma mark -- 获取方法列表
- (void)getMethodList {

    unsigned int count = 0;
    
    Method * methodList = class_copyMethodList([self class], &count);
    
    for (unsigned int index = 0; index < count; index ++) {
        
        Method method = methodList[index];
        NSLog(@"Method------>%@",NSStringFromSelector(method_getName(method)));
    }
}

#pragma mark -- 获取成员变量列表
- (void)getIvarList {

    unsigned int count = 0;
    
    Ivar * ivarList = class_copyIvarList([self class], &count);
    
    for (unsigned int index = 0; index < count; index++) {
        
        Ivar ivar = ivarList[index];
        const char * ivarName = ivar_getName(ivar);
        NSLog(@"Ivar----->%@",[NSString stringWithUTF8String:ivarName]);
    }
}

#pragma mark -- 获取协议列表
- (void)getProtocolList {

    unsigned int count = 0;
    
    __unsafe_unretained Protocol ** protocolList = class_copyProtocolList([self class], &count);
    
    for (unsigned int index = 0; index < count; index++) {
        
        Protocol * protocol = protocolList[index];
        const char * protocolName = property_getName((__bridge objc_property_t)(protocol));
        NSLog(@"protocol----->%@",[NSString stringWithUTF8String:protocolName]);
        
    }
    
}

#pragma mark -- 成员变量值替换
- (void)changeIvar:(NSString *)ivarName toObject:(id)object {
    
    unsigned int count = 0;
    
    Ivar * ivarList = class_copyIvarList([self class], &count);
    
    for (unsigned int index = 0; index < count; index++) {
        
        Ivar ivar = ivarList[index];
        const char * ivarNameChar = ivar_getName(ivar);
        
        NSString * ivarNameStr = [NSString stringWithUTF8String:ivarNameChar];
        
        if ([ivarName isEqualToString:[NSString stringWithFormat:@"_%@",ivarNameStr]]) {
            object_setIvar(self, ivar, object);
            break;
        }
        
    }
}

#pragma mark -- 获得实例方法
- (Method)getClassMethodWithSelector:(SEL)selector {

    Class objClass = object_getClass([self class]);
    SEL oriSEL = @selector(selector);
    Method oriMethod = class_getInstanceMethod(objClass, oriSEL);
    
    return oriMethod;
}

#pragma mark -- 添加方法
- (BOOL)addCustomerMethod:(SEL)method originSelector:(SEL)selector {

    Method cusMethod = class_getInstanceMethod([self class], method);

    BOOL result = class_addMethod([self class], selector, method_getImplementation(cusMethod), method_getTypeEncoding(cusMethod));

    return result;
}

@end
