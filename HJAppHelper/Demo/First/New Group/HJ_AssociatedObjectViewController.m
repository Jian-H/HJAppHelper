//
//  HJ_AssociatedObjectViewController.m
//  HJAppHelper
//
//  Created by xingzhijishu on 2019/6/15.
//  Copyright © 2019 huangjian. All rights reserved.
//

#import "HJ_AssociatedObjectViewController.h"
#import "NSObject+HJ_AssociatedObjcCategory.h"

@interface HJ_AssociatedObjectViewController ()

@end

@implementation HJ_AssociatedObjectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.name = @"HJian";
    self.isRight = YES;
    NSLog(@"name = %@ isRight = %zi",self.name, self.isRight);
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
