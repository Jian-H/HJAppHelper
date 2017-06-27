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


/**
 身份证号码验证

 @param identityCard 身份证号码
 @return 身份证号码格式的规范性
 */
+ (BOOL)validateIdentityCard:(NSString *)identityCard;

/**
 车牌号验证

 @param carNum 车牌号
 @return 车牌号格式的规范性
 */
+ (BOOL)validateCarNum:(NSString *)carNum;

+ (BOOL)validateMacAddress:(NSString *)macAddress;

/**
 网址验证

 @param url 网址
 @return 网址格式的规范性
 */
+ (BOOL)validateUrl:(NSString *)url;

/**
 汉字验证

 @param chinese 汉字
 @return 汉字的规范性
 */
+ (BOOL)validateChinese:(NSString *)chinese;

+ (BOOL)validatePostalCode:(NSString *)postalCode;

+ (BOOL)validateTaxNo:(NSString *)taxNo;

+ (BOOL)validateString:(NSString *)string
              minLenth:(NSInteger)minLenth
              maxLenth:(NSInteger)maxLenth
        containChinese:(BOOL)containChinese
   firstCannotBeDigtal:(BOOL)firstCannotBeDigtal;

+ (BOOL)validateString:(NSString *)string
              minLenth:(NSInteger)minLenth
              maxLenth:(NSInteger)maxLenth
        containChinese:(BOOL)containChinese
         containDigtal:(BOOL)containDigtal
         containLetter:(BOOL)containLetter
 containOtherCharacter:(NSString *)containOtherCharacter
   firstCannotBeDigtal:(BOOL)firstCannotBeDigtal;

//精确的身份证号码有效性检测
+ (BOOL)accurateVerifyIDCardNumber:(NSString *)value;

/** 银行卡号有效性问题Luhn算法
 254  *  现行 16 位银联卡现行卡号开头 6 位是 622126～622925 之间的，7 到 15 位是银行自定义的，
 255  *  可能是发卡分行，发卡网点，发卡序号，第 16 位是校验码。
 256  *  16 位卡号校验位采用 Luhm 校验方法计算：
 257  *  1，将未带校验位的 15 位卡号从右依次编号 1 到 15，位于奇数位号上的数字乘以 2
 258  *  2，将奇位乘积的个十位全部相加，再加上所有偶数位上的数字
 259  *  3，将加法和加上校验位能被 10 整除。
 260  */
+ (BOOL)bankCardluhmCheck:(NSString *)bankCardNum;

+ (BOOL)validateIPAddress:(NSString *)ipAddress;

@end
