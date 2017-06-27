//
//  HJ_AddressBookViewController.m
//  HJAppHelper
//
//  Created by xingzhijishu on 2017/6/27.
//  Copyright © 2017年 huangjian. All rights reserved.
//

#import "HJ_AddressBookViewController.h"
#import "HJAddressBookManager.h"
#import "HJ_AddressBookCell.h"

@interface HJ_AddressBookViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray <HJAddressBookModel *> * mDataSource;

@end

@implementation HJ_AddressBookViewController

- (NSMutableArray <HJAddressBookModel *> *)mDataSource {

    if (!_mDataSource) {
        _mDataSource = [NSMutableArray array];
    }
    return _mDataSource;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[HJAddressBookManager sharedInstance] obtainAddressBookWithGetJurisdictionBlock:^(BOOL haveJurisdiction) {
        
        if (!haveJurisdiction) {
            NSLog(@"没权限");
        }

        
    } failBlock:^(BOOL fail) {
        
        if (fail) {
            NSLog(@"获取失败");
        }

        
    } haveNoPeopleBlock:^(BOOL haveNoPeople) {
        
        if (haveNoPeople) {
            NSLog(@"通讯录无人");
        }
        
    } finishedBlock:^(NSMutableArray<HJAddressBookModel *> *addressBooks) {
        
        self.mDataSource = addressBooks;
        
        [self.mTableView reloadData];
        
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.mDataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    HJ_AddressBookCell * cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HJ_AddressBookCell class]) forIndexPath:indexPath];
    
    [cell configAddressBookCellWithItem:self.mDataSource[indexPath.row]];
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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
