//
//  HJ_NetworkHelperViewController.h
//  HJAppHelper
//
//  Created by xingzhijishu on 2017/4/12.
//  Copyright © 2017年 huangjian. All rights reserved.
//

#import "HJ_BaseViewController.h"

@interface HJ_NetworkHelperViewController : HJ_BaseViewController

@property (weak, nonatomic) IBOutlet UITextView *mNetDataTextView;
@property (weak, nonatomic) IBOutlet UITextView *mCacheDataTextView;
@property (weak, nonatomic) IBOutlet UIProgressView *mDownloadProgressView;

- (IBAction)openCacheValueChanged:(UISwitch *)sender;
- (IBAction)downloadButtonAction:(UIButton *)sender;

@end
