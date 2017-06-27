//
//  HJAddressBookManager.h
//  HJAppHelper
//
//  Created by huangjian on 15/12/18.
//  Copyright © 2015年 huangjian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import "HJAddressBookModel.h"

/**
 *  需要导入 AddressBook.framework + AddressBookUI.framework
 */
@interface HJAddressBookManager : NSObject

+ (instancetype)sharedInstance;

/**
 *  获取通讯录信息
 *
 *  @param jurisdictionBlock 权限判断
 *  @param failBlock         是否获取失败
 *  @param haveNoPeopleBlock 是否无人
 *  @param finishedBlock     返回通讯录列表，存放 HJAddressBookModel
 */
- (void)obtainAddressBookWithGetJurisdictionBlock:(void(^)(BOOL haveJurisdiction))jurisdictionBlock
                                        failBlock:(void(^)(BOOL fail))failBlock
                                haveNoPeopleBlock:(void(^)(BOOL haveNoPeople))haveNoPeopleBlock
                                    finishedBlock:(void(^)(NSMutableArray <HJAddressBookModel *> * addressBooks))finishedBlock ;

@end
