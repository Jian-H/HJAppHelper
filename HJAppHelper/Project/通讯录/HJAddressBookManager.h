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

@interface HJAddressBookManager : NSObject

+ (instancetype)sharedInstance;


- (void)obtainAddressBookWithGetJurisdictionBlock:(void(^)(BOOL haveJurisdiction))jurisdictionBlock
                                        failBlock:(void(^)(BOOL fail))failBlock
                                haveNoPeopleBlock:(void(^)(BOOL haveNoPeople))haveNoPeopleBlock
                                    finishedBlock:(void(^)(NSMutableArray * addressBooks))finishedBlock ;

@end
