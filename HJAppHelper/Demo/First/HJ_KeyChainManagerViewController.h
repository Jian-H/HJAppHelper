//
//  HJ_KeyChainManagerViewController.h
//  HJAppHelper
//
//  Created by xingzhijishu on 2017/4/19.
//  Copyright © 2017年 huangjian. All rights reserved.
//

#import "HJ_BaseViewController.h"

@interface HJ_KeyChainManagerViewController : HJ_BaseViewController

@property (weak, nonatomic) IBOutlet UITextField *mKeyTextField;

@property (weak, nonatomic) IBOutlet UITextField *mValueTextField;

- (IBAction)addButtonAction:(UIButton *)sender;
- (IBAction)deleteButtonAction:(UIButton *)sender;
- (IBAction)updateButtonAction:(UIButton *)sender;
- (IBAction)selectButtonAction:(UIButton *)sender;

@end
