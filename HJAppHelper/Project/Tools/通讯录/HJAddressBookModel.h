//
//  HJAddressBookModel.h
//  HJAppHelper
//
//  Created by huangjian on 15/12/18.
//  Copyright © 2015年 huangjian. All rights reserved.
//

#import <Foundation/Foundation.h>

@class HJPhoneModel,HJEmailModel,HJAddressModel;

@interface HJAddressBookModel : NSObject <NSCopying,NSMutableCopying>

@property (nonatomic, strong) NSString * name;              //姓名
@property (nonatomic, strong) NSString * nickName;          //昵称
@property (nonatomic, strong) NSData  * headImage;          //头像
@property (nonatomic, strong) NSString * companyName;       //公司名
@property (nonatomic, strong) NSString * department;        //部门
@property (nonatomic, strong) NSString * position;          //职位
@property (nonatomic, strong) NSArray <HJPhoneModel *>  * phone;             //手机 (包括固话)
@property (nonatomic, strong) NSArray <HJAddressModel *> * address;            //地址
@property (nonatomic, strong) NSArray <HJEmailModel *> * email;              //邮箱

@end

@interface HJPhoneModel : NSObject <NSCopying,NSMutableCopying>

@property (nonatomic, strong) NSString * phoneLabel;         //电话标签
@property (nonatomic, strong) NSString * phone;              //电话号码

@end

@interface HJEmailModel : NSObject <NSCopying,NSMutableCopying>

@property (nonatomic, strong) NSString * emailLabel;
@property (nonatomic, strong) NSString * email;

@end

@interface HJAddressModel : NSObject <NSCopying,NSMutableCopying>

@property (nonatomic, strong) NSString * addressLabel;      //地址标签
@property (nonatomic, strong) NSString * country;           //国家
@property (nonatomic, strong) NSString * city;              //城市
@property (nonatomic, strong) NSString * state;             //省
@property (nonatomic, strong) NSString * street;            //街道
@property (nonatomic, strong) NSString * zip;               //邮编
@property (nonatomic, strong) NSString * coutntrycode;      //国家编码

@end
