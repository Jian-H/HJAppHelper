//
//  HJ_FirstViewController.m
//  HJAppHelper
//
//  Created by xingzhijishu on 2017/4/10.
//  Copyright © 2017年 huangjian. All rights reserved.
//

#import "HJ_FirstViewController.h"
#import "HJ_PublicTableViewCell.h"
#import "HJ_NetworkHelperViewController.h"
#import "HJ_KeyChainManagerViewController.h"

@interface HJ_FirstViewController () <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) NSMutableArray * mTitleArray;

@end

@implementation HJ_FirstViewController

- (NSMutableArray *)mTitleArray {

    if (!_mTitleArray) {
        _mTitleArray = [NSMutableArray arrayWithObjects:@"网路数据缓存与下载",
                                                        @"KeyChain（钥匙串）增删改查",
                                                        nil];
    }
    return _mTitleArray;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.mTitleArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    HJ_PublicTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HJ_PublicTableViewCell class]) forIndexPath:indexPath];
    
    cell.mTitleLabel.text = [self.mTitleArray objectAtIndex:indexPath.row];
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"First" bundle:[NSBundle mainBundle]];
    
    switch (indexPath.row) {
        case 0: {
            
            HJ_NetworkHelperViewController * networkHelperViewController = [storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([HJ_NetworkHelperViewController class])];
            
            networkHelperViewController.hidesBottomBarWhenPushed = YES;
            
            [self.navigationController pushViewController:networkHelperViewController animated:YES];
            
        }
            break;
            
        case 1: {
            HJ_KeyChainManagerViewController * keyChainManagerViewController = [storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([HJ_KeyChainManagerViewController class])];
            
            keyChainManagerViewController.hidesBottomBarWhenPushed = YES;
            
            [self.navigationController pushViewController:keyChainManagerViewController animated:YES];
        }
            break;
            
        default:
            break;
    }
    
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
