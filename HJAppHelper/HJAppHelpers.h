//
//  HJAppHelpers.h
//  HJAppHelper
//
//  Created by huangjian on 15/10/21.
//  Copyright © 2015年 huangjian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>  //MD5加密所需要导入的
#import <CommonCrypto/CommonCryptor.h> //加密所需

@interface HJAppHelpers : NSObject

/*
 * 加密
 */
// MD5加密 只能称为一种不可逆的加密算法，只能用作一些检验过程，不能恢复其原文。
+ (NSString *)md5HexDigest:(NSString *)input;

//apple还提供了RSA、DES、AES等加密算法，见到国外的网站关于AES加密的算法，在此经过加工可以用于字符串加密机密，可用于安全性要求较高的应用。


//将NSData分类，添加NSData加密解密方法
//加密
+ (NSData *)stringChangeToData:(NSString *)input;
+ (NSData *)AES256EncryptWithKey:(NSString*)key value:(NSData *)value;
//解密
+ (NSData*)AES256DecryptWithKey:(NSString*)key value:(NSData *)value;
//上述代码AES256EncryptWithKey方法为加密函数，AES256DecryptWithKey为解密函数，加密和解密方法使用的参数密钥均为32位长度的字符串，所以可以将任意的字符串经过md5计算32位字符串作为密钥，这样可以允许客户输入任何长度的密钥，并且不同密钥的MD5值也不会重复。


@end
