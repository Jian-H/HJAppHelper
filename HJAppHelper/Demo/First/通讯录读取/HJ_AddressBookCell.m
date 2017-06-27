//
//  HJ_AddressBookCell.m
//  HJAppHelper
//
//  Created by xingzhijishu on 2017/6/27.
//  Copyright © 2017年 huangjian. All rights reserved.
//

#import "HJ_AddressBookCell.h"

@implementation HJ_AddressBookCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)configAddressBookCellWithItem:(HJAddressBookModel *)item {

    self.mNameLabel.text = item.name;
    
    if (item.phone.count) {
        HJPhoneModel * phoneModel = [item.phone firstObject];
        self.mInfoLabel.text = phoneModel.phone;
    } else {
        self.mInfoLabel.text = @"无号码";
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
