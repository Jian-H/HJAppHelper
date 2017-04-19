//
//  HJ_KeyChainManagerViewController.m
//  HJAppHelper
//
//  Created by xingzhijishu on 2017/4/19.
//  Copyright © 2017年 huangjian. All rights reserved.
//

#import "HJ_KeyChainManagerViewController.h"
#import "HJ_KeyChainManager.h"

@interface HJ_KeyChainManagerViewController ()

@end

@implementation HJ_KeyChainManagerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)addButtonAction:(UIButton *)sender {
    
    if (!self.mValueTextField.text && self.mValueTextField.text.length == 0) {
        return;
    }
    
    [[HJ_KeyChainManager sharedHJ_KeyChainManager] hj_addKeyChainWithKey:self.mKeyTextField.text value:self.mValueTextField.text];
}

- (IBAction)deleteButtonAction:(UIButton *)sender {
    
    if (!self.mKeyTextField.text && self.mKeyTextField.text.length == 0) {
        return;
    }
    [[HJ_KeyChainManager sharedHJ_KeyChainManager] hj_deleteKeyChainWithKey:self.mKeyTextField.text];
    
    self.mValueTextField.text = @"";
}

- (IBAction)updateButtonAction:(UIButton *)sender {
    
    [[HJ_KeyChainManager sharedHJ_KeyChainManager] hj_updateKeyChainWithKey:self.mKeyTextField.text value:self.mValueTextField.text];
}

- (IBAction)selectButtonAction:(UIButton *)sender {
    
    NSString * value = [[HJ_KeyChainManager sharedHJ_KeyChainManager] hj_getKeyChainValueWithKey:self.mKeyTextField.text];

    self.mValueTextField.text = value;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
