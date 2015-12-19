//
//  HJAddressBookModel.m
//  HJAppHelper
//
//  Created by huangjian on 15/12/18.
//  Copyright © 2015年 huangjian. All rights reserved.
//

#import "HJAddressBookModel.h"

@implementation HJAddressBookModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {

}

- (instancetype)copyWithZone:(NSZone *)zone {
    
    HJAddressBookModel * result = [[self class] allocWithZone:zone];
    result->_name           = [self.name copy];
    result->_nickName       = [self.nickName copy];
    result->_companyName    = [self.companyName copy];
    result->_headImage      = [self.headImage copy];
    result->_department     = [self.department copy];
    result->_position       = [self.position copy];
    result->_phone          = [self.phone copy];
    result->_address        = [self.address copy];
    result->_email          = [self.email copy];

    return result;
}

- (instancetype)mutableCopyWithZone:(NSZone *)zone {

    HJAddressBookModel * result = [[self class] allocWithZone:zone];
    result->_name           = [self.name mutableCopy];
    result->_nickName       = [self.nickName mutableCopy];
    result->_companyName    = [self.companyName mutableCopy];
    result->_headImage      = [self.headImage mutableCopy];
    result->_department     = [self.department mutableCopy];
    result->_position       = [self.position mutableCopy];
    result->_phone          = [self.phone mutableCopy];
    result->_address        = [self.address mutableCopy];
    result->_email          = [self.email mutableCopy];
    
    return result;
    
}

@end

@implementation HJPhoneModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {

}

- (instancetype)copyWithZone:(NSZone *)zone {

    HJPhoneModel * result = [[self class] allocWithZone:zone];
    
    result->_phoneLabel = [self.phoneLabel copy];
    result->_phone = [self.phone copy];
    
    return result;
    
}

- (instancetype)mutableCopyWithZone:(NSZone *)zone {

    HJPhoneModel * result = [[self class] allocWithZone:zone];
    
    result->_phoneLabel = [self.phoneLabel mutableCopy];
    result->_phone = [self.phone mutableCopy];
    
    return result;

}

@end

@implementation HJEmailModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {

}

- (instancetype)copyWithZone:(NSZone *)zone {
    
    HJEmailModel * result = [[self class] allocWithZone:zone];
    result->_emailLabel     = [self.emailLabel copy];
    result->_email          = [self.email copy];
    
    return result;
}

- (instancetype)mutableCopyWithZone:(NSZone *)zone {
    
    HJEmailModel * result = [[self class] allocWithZone:zone];
    result->_emailLabel     = [self.emailLabel mutableCopy];
    result->_email          = [self.email mutableCopy];
    
    return result;
}

@end

@implementation HJAddressModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {

}

- (instancetype)copyWithZone:(NSZone *)zone {

    HJAddressModel * result = [[self class] allocWithZone:zone];
    result->_addressLabel       = [self.addressLabel copy];
    result->_country            = [self.country copy];
    result->_city               = [self.city copy];
    result->_state              = [self.state copy];
    result->_street             = [self.street copy];
    result->_zip                = [self.zip copy];
    result->_coutntrycode       = [self.coutntrycode copy];
    
    return result;
}

- (instancetype)mutableCopyWithZone:(NSZone *)zone {
    
    HJAddressModel * result = [[self class] allocWithZone:zone];
    result->_addressLabel       = [self.addressLabel copy];
    result->_country            = [self.country mutableCopy];
    result->_city               = [self.city mutableCopy];
    result->_state              = [self.state mutableCopy];
    result->_street             = [self.street mutableCopy];
    result->_zip                = [self.zip mutableCopy];
    result->_coutntrycode       = [self.coutntrycode mutableCopy];
    
    return result;
    
}

@end;
