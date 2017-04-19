//
//  HJ_KeyChainManager.h
//  HJAppHelper
//
//  Created by xingzhijishu on 2017/4/19.
//  Copyright © 2017年 huangjian. All rights reserved.
//

#import <Foundation/Foundation.h>

#define singleton_interface(className) \
+ (className *)shared##className;

// @implementation
#define singleton_implementation(className) \
static className *_instance; \
+ (id)allocWithZone:(NSZone *)zone \
{ \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
_instance = [super allocWithZone:zone]; \
}); \
return _instance; \
} \
+ (className *)shared##className \
{ \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
_instance = [[self alloc] init]; \
}); \
return _instance; \
}

@interface HJ_KeyChainManager : NSObject

singleton_interface(HJ_KeyChainManager)

- (BOOL)hj_addKeyChainWithKey:(NSString *)key value:(NSString *)value;

- (BOOL)hj_updateKeyChainWithKey:(NSString *)key value:(NSString *)value;

- (BOOL)hj_deleteKeyChainWithKey:(NSString *)key;

- (id)hj_getKeyChainValueWithKey:(NSString *)key;

@end
