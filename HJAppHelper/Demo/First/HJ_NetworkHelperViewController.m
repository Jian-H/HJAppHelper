
//
//  HJ_NetworkHelperViewController.m
//  HJAppHelper
//
//  Created by xingzhijishu on 2017/4/12.
//  Copyright © 2017年 huangjian. All rights reserved.
//

#import "HJ_NetworkHelperViewController.h"
#import "HJNetworkHelper.h"

#define kDataUrl @"http://api.budejie.com/api/api_open.php"
#define kDownloadUrl @"http://wvideo.spriteapp.cn/video/2016/0328/56f8ec01d9bfe_wpd.mp4"

@interface HJ_NetworkHelperViewController ()

@end

@implementation HJ_NetworkHelperViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    [HJNetworkHelper hj_openLog];
    
    NSLog(@"缓存大小cache == %fKB",[HJNetworkCache hj_getAllHttpCacheSize] / 1024.f);
    
    self.mDownloadProgressView.progress = 0.f;
    
    [self getDataAutoCache:NO url:kDataUrl];
}

/**
 实时检测网络状态
 */
- (void)monitorNetworkStatus {
    
    [HJNetworkHelper hj_networkStatusWithBlock:^(HJNetworkStatusType status) {
        
        switch (status) {
            case HJNetworkStatusUnknown:
            case HJNetworkStatusNotReachable:
                self.mNetDataTextView.text = @"无网络";
                
                break;
                
            default:
                break;
        }
        
    }];
}

- (void)getDataAutoCache:(BOOL)isOn url:(NSString *)url {
    
    
    NSDictionary * parameters = @{ @"a":@"list", @"c":@"data",@"client":@"iphone",@"page":@"0",@"per":@"10", @"type":@"29"};
    
    self.mNetDataTextView.text = @"";
    self.mCacheDataTextView.text = @"";
    
    //自动缓存
    if (isOn) {
        
        [HJNetworkHelper hj_GET:url
                     parameters:parameters
                  responseCache:^(id responseCache) {
                      
                      self.mCacheDataTextView.text = [self jsonToString:responseCache];
                      
                      NSLog(@"==============读取缓存了==============");
                      
                  } success:^(id responseObject) {
                      
                      self.mNetDataTextView.text = [self jsonToString:responseObject];
                      
                  } failure:^(NSError *error) {
                      
                  }];
    } else {
        
        [HJNetworkHelper hj_GET:url
                     parameters:parameters
                        success:^(id responseObject) {
                            
                            self.mNetDataTextView.text = [self jsonToString:responseObject];
                            
                        } failure:^(NSError *error) {
                            
                        }];
    }
}

/**
 *  json转字符串
 */
- (NSString *)jsonToString:(NSDictionary *)dic {
    if(!dic){
        return nil;
    }
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)openCacheValueChanged:(UISwitch *)sender {
    
    [self getDataAutoCache:sender.on url:kDataUrl];
    
}

- (IBAction)downloadButtonAction:(UIButton *)sender {
    
    static NSURLSessionTask * task = nil;
    
    sender.selected = !sender.selected;
    
    NSString * title = sender.selected ? @"取消下载" : @"开始下载";
    
    [sender setTitle:title forState:UIControlStateNormal];
    [sender setTitle:title forState:UIControlStateSelected];
    
    if (sender.selected) {
        task = [HJNetworkHelper hj_downloadWithURL:kDownloadUrl
                                           fileDir:@"Download"
                                          progress:^(NSProgress *progress) {
                                              
                                              CGFloat stauts = 100.f * progress.completedUnitCount/progress.totalUnitCount;
                                              self.mDownloadProgressView.progress = stauts / 100.f;
                                              NSLog(@"下载进度 ： %.2f%% == %@",stauts,[NSThread currentThread]);
                                              
                                          } success:^(NSString *filePath) {
                                              
                                              UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"下载完成!"
                                                                                                  message:[NSString stringWithFormat:@"文件路径:%@",filePath]
                                                                                                 delegate:nil
                                                                                        cancelButtonTitle:@"确定"
                                                                                        otherButtonTitles:nil];
                                              [alertView show];
                                              
                                              NSLog(@"文件路径 ： %@",filePath);
                                              
                                              
                                          } failure:^(NSError *error) {
                                              
                                              UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"下载失败"
                                                                                                  message:[NSString stringWithFormat:@"%@",error]
                                                                                                 delegate:nil
                                                                                        cancelButtonTitle:@"确定"
                                                                                        otherButtonTitles:nil];
                                              [alertView show];
                                              
                                              
                                          }];
    } else {
        
        [task suspend];
        self.mDownloadProgressView.progress = 0;
    }
    
    
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
