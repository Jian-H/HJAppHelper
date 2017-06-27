//
//  HJ_AddressBookCell.h
//  HJAppHelper
//
//  Created by xingzhijishu on 2017/6/27.
//  Copyright © 2017年 huangjian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HJAddressBookModel.h"

@interface HJ_AddressBookCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *mNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *mInfoLabel;

- (void)configAddressBookCellWithItem:(HJAddressBookModel *)item;

@end
