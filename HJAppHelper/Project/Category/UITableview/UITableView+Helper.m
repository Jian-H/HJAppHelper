//
//  UITableView+Helper.m
//  HJAppHelper
//
//  Created by huangjian on 16/3/15.
//  Copyright © 2016年 huangjian. All rights reserved.
//

#import "UITableView+Helper.h"

@implementation UITableView (Helper)

- (void)setExtraCellLineHidden {
    
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor clearColor];
    [self setTableFooterView:view];
}


@end
