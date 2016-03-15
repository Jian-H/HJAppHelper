//
//  HJAddressBookManager.m
//  HJAppHelper
//
//  Created by huangjian on 15/12/18.
//  Copyright © 2015年 huangjian. All rights reserved.
//

#import "HJAddressBookManager.h"

static HJAddressBookManager * manager = nil;

@implementation HJAddressBookManager

+ (instancetype)sharedInstance {

    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
       
        if (manager == nil) {
            manager = [[HJAddressBookManager alloc] init];
        }
        
    });
    return manager;
}

- (void)obtainAddressBookWithGetJurisdictionBlock:(void (^)(BOOL))jurisdictionBlock
                                        failBlock:(void(^)(BOOL))failBlock
                                haveNoPeopleBlock:(void (^)(BOOL))haveNoPeopleBlock
                                    finishedBlock:(void (^)(NSMutableArray *))finishedBlock {

    //定义通讯录名称
    ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, NULL);
    dispatch_semaphore_t sema = dispatch_semaphore_create(0);
    ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {
        dispatch_semaphore_signal(sema);
    });
    dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
    //如果没获得权限
    if (ABAddressBookGetAuthorizationStatus() != kABAuthorizationStatusAuthorized) {
        jurisdictionBlock(NO);
        return;
    } else {
        jurisdictionBlock(YES);
    }
    
    //获取通讯录失败
    if (addressBook == nil) {
        failBlock(YES);
        return;
    } else {
        failBlock(NO);
    }
    
    //获取通讯录数组
    CFArrayRef people = ABAddressBookCopyArrayOfAllPeople(addressBook);
    CFMutableArrayRef peopleMutable = CFArrayCreateMutableCopy(                          kCFAllocatorDefault,CFArrayGetCount(people),people);
    
    CFArraySortValues(
                      peopleMutable,
                      CFRangeMake(0, CFArrayGetCount(peopleMutable)),
                      (CFComparatorFunction) ABPersonComparePeopleByName,
                      (void*)(unsigned long) ABPersonGetSortOrdering()
                      );
    
    NSArray * allPoples = (__bridge NSArray*)peopleMutable;
    
    if (allPoples.count == 0) {//通讯录没有联系人
        haveNoPeopleBlock(YES);
        return;
    } else {
        haveNoPeopleBlock(NO);
    }
    
    NSMutableArray * peopleArray = [NSMutableArray array];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        //填装数组
        [allPoples enumerateObjectsWithOptions:(NSEnumerationReverse) usingBlock:^(id idPerson, NSUInteger idx, BOOL *stop) {
            
            HJAddressBookModel * model = [[HJAddressBookModel alloc] init];
            
            //获取姓名
            NSString * firstName = (__bridge  NSString *)ABRecordCopyValue((__bridge ABRecordRef)(idPerson), kABPersonFirstNameProperty);
            NSString * lastName = (__bridge NSString *)ABRecordCopyValue((__bridge ABRecordRef)(idPerson), kABPersonLastNameProperty);
            NSString * wholeName = @"";
            if ([firstName isEqualToString:@"(null)"]){
                firstName = @"";
            }
            if ([lastName isEqualToString:@"(null)"]){
                lastName = @"";
            }
            if (!lastName&&firstName) {
                wholeName = firstName;
            }else if (lastName&&!firstName){
                wholeName = lastName;
            }else{
                if (firstName != nil && lastName != nil){
                    wholeName = [NSString stringWithFormat:@"%@%@",lastName,firstName];
                }
            }
            
            model.name = wholeName;
            
            //昵称
            NSString * nickName = (__bridge NSString*)ABRecordCopyValue((__bridge ABRecordRef)(idPerson), kABPersonNicknameProperty);
            if (!nickName) {
                nickName = @"";
            }
            model.nickName = nickName;
            
            //头像
            NSData * headImage = (__bridge NSData*)ABPersonCopyImageData((__bridge ABRecordRef)(idPerson));
            model.headImage = headImage;
            
            //公司名
            NSString * companyName = (__bridge NSString*)ABRecordCopyValue((__bridge ABRecordRef)(idPerson), kABPersonOrganizationProperty);
            if (!companyName) {
                companyName = @"";
            }
            model.companyName = companyName;
            
            //部门
            NSString * department = (__bridge NSString*)ABRecordCopyValue((__bridge ABRecordRef)(idPerson), kABPersonDepartmentProperty);
            if(!department) {
                department = @"";
            }
            model.department = department;
            
            //职位
            NSString * position = (__bridge NSString*)ABRecordCopyValue((__bridge ABRecordRef)(idPerson), kABPersonJobTitleProperty);
            if (!position) {
                position = @"";
            }
            model.position = position;
            
                
            //电话
            ABMultiValueRef tmpPhones = ABRecordCopyValue((__bridge ABRecordRef)(idPerson), kABPersonPhoneProperty);
            
            NSMutableArray * phoneArray = [NSMutableArray array];
            for (NSInteger index = 0; index < ABMultiValueGetCount(tmpPhones); index++) {
                
                HJPhoneModel * phoneModel = [[HJPhoneModel alloc] init];
                
                //获取电话Label
                NSString * personPhoneLabel = (__bridge NSString*)ABAddressBookCopyLocalizedLabel(ABMultiValueCopyLabelAtIndex(tmpPhones, index));
                //获取該Label下的电话值
                NSString * personPhone = (__bridge NSString*)ABMultiValueCopyValueAtIndex(tmpPhones, index);
                
                phoneModel.phoneLabel = personPhoneLabel;
                phoneModel.phone = personPhone;
                
                [phoneArray addObject:phoneModel];
            }
            
            model.phone = [NSArray arrayWithArray:phoneArray];

            CFRelease(tmpPhones);
            
            
           //email
            NSMutableArray * emailArray = [NSMutableArray array];
            ABMultiValueRef email = ABRecordCopyValue((__bridge ABRecordRef)(idPerson), kABPersonEmailProperty);
            long emailcount = ABMultiValueGetCount(email);
            for (int index = 0; index < emailcount; index++)
            {
                
                HJEmailModel * emailModel = [[HJEmailModel alloc] init];
                //获取email标签
                NSString * emailLabel = (__bridge NSString*)ABAddressBookCopyLocalizedLabel(ABMultiValueCopyLabelAtIndex(email, index));
                //获取email值
                NSString * emailContent = (__bridge NSString*)ABMultiValueCopyValueAtIndex(email, index);
                
                emailModel.emailLabel = emailLabel;
                emailModel.email = emailContent;
                
                [emailArray addObject:emailModel];
            }
            model.email = [NSArray arrayWithArray:emailArray];
            
               
            //地址
            NSMutableArray * addressArray = [NSMutableArray array];
            ABMultiValueRef address = ABRecordCopyValue((__bridge ABRecordRef)(idPerson), kABPersonAddressProperty);
            long count = ABMultiValueGetCount(address);
            
            for (NSInteger index = 0; index < count; index++) {
                
                HJAddressModel * addressModel = [[HJAddressModel alloc] init];
                
                //获取地址Label
                NSString * addressLabel = (__bridge NSString*)ABMultiValueCopyLabelAtIndex(address, index);

                addressModel.addressLabel = addressLabel;
                
                //获取該label下的地址6属性
                NSDictionary * personaddress =(__bridge NSDictionary*) ABMultiValueCopyValueAtIndex(address, index);
                
                NSString * country = [personaddress valueForKey:(NSString *)kABPersonAddressCountryKey];
                if(!country) {
                    country = @"";
                }
                
                addressModel.country = country;
               
                NSString * city = [personaddress valueForKey:(NSString *)kABPersonAddressCityKey];
                if(!city) {
                    city = @"";
                }
                
                addressModel.city = city;
                
                NSString * state = [personaddress valueForKey:(NSString *)kABPersonAddressStateKey];
                if(!state) {
                    state = @"";
                }
                
                addressModel.state = state;
                    
                NSString * street = [personaddress valueForKey:(NSString *)kABPersonAddressStreetKey];
                if(!street) {
                    street = @"";
                }

                addressModel.street = street;
                
                NSString * zip = [personaddress valueForKey:(NSString *)kABPersonAddressZIPKey];
                if(!zip) {
                    zip = @"";
                }
                
                addressModel.zip = zip;
                
                NSString * coutntrycode = [personaddress valueForKey:(NSString *)kABPersonAddressCountryCodeKey];
                if(!coutntrycode) {
                    coutntrycode = @"";
                }
                
                addressModel.coutntrycode = coutntrycode;
                
                [addressArray addObject:addressModel];
            }
            
            model.address = [NSArray arrayWithArray:addressArray];
            
            
            
            [peopleArray addObject:model];
            
        }];
        
        finishedBlock(peopleArray);
    });
    
}

@end
