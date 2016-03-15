//
//  HJVerifyManager.h
//  HJAppHelper
//
//  Created by huangjian on 16/1/19.
//  Copyright © 2016年 huangjian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HJVerifyManager : NSObject

/**
 *  手机号码正则匹配
 *
 *  @param phone 手机号码
 *
 *  @return 验证手机号码是否规范
 */
+ (BOOL)validatePhone:(NSString *)phone;

/**
 *  密码验证
 *
 *  @param password 以字母开头，长度在6-18之间
 *
 *  @return 密码格式规范性
 */
+ (BOOL)validatePassword:(NSString *)password;

/**
 *  邮箱验证
 *
 *  @param email 邮箱
 *
 *  @return 邮箱格式的规范性
 */
+ (BOOL)validateEmail:(NSString *)email;

@end
