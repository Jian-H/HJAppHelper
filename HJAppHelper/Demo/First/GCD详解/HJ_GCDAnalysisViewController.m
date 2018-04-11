//
//  HJ_GCDAnalysisViewController.m
//  HJAppHelper
//
//  Created by xingzhijishu on 2018/4/10.
//  Copyright © 2018年 huangjian. All rights reserved.
//

#import "HJ_GCDAnalysisViewController.h"
#import "HJGCDManager.h"

@interface HJ_GCDAnalysisViewController ()

@end

@implementation HJ_GCDAnalysisViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)testButtonAction:(UIButton *)sender {

    NSLog(@"currentThread---%@",[NSThread currentThread]);  // 打印当前线程
    
    dispatch_queue_t serialDispatchQueue = [HJGCDManager serialDispatchQueue:"serialDispatchQueue"];
    
    dispatch_queue_t concurrentDispatchQueue = [HJGCDManager concurrentDispatchQueue:"concurrentDispatchQueue"];
    
    dispatch_queue_t mainDispathQueue = [HJGCDManager mainDispathQueue];
    
    dispatch_queue_t globalDispatchQueue = [HJGCDManager globalDispatchQueue];
    
    switch (sender.tag) {
        case 1: {
            
            /**
             * 同步执行 + 并发队列
             * 特点：在当前线程中执行任务，不会开启新线程，执行完一个任务，再执行下一个任务。
             */

            NSLog(@"同步执行 + 并发队列 - begin");
            
            [HJGCDManager dispatchSyncWithQueue:concurrentDispatchQueue block:^{
                
                // 追加任务1
                for (int i = 0; i < 2; ++i) {
                    [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
                    NSLog(@"1---%@",[NSThread currentThread]);      // 打印当前线程
                }
            }];
            
            [HJGCDManager dispatchSyncWithQueue:concurrentDispatchQueue block:^{
    
                // 追加任务2
                for (int i = 0; i < 2; ++i) {
                    [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
                    NSLog(@"2---%@",[NSThread currentThread]);      // 打印当前线程
                }
            }];

            [HJGCDManager dispatchSyncWithQueue:concurrentDispatchQueue block:^{
                
                // 追加任务3
                for (int i = 0; i < 2; ++i) {
                    [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
                    NSLog(@"3---%@",[NSThread currentThread]);      // 打印当前线程
                }
            }];

            
            NSLog(@"同步执行 + 并发队列 - end");
        }
            break;
        case 2: {
            
            /**
             * 异步执行 + 并发队列
             * 特点：可以开启多个线程，任务交替（同时）执行
             */
            
            NSLog(@"异步执行 + 并发队列 - begin");
            
            [HJGCDManager dispatchAsyncWithQueue:concurrentDispatchQueue block:^{
                
                // 追加任务1
                for (int i = 0; i < 2; ++i) {
                    [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
                    NSLog(@"1---%@",[NSThread currentThread]);      // 打印当前线程
                }
            }];
            
            [HJGCDManager dispatchAsyncWithQueue:concurrentDispatchQueue block:^{
                
                // 追加任务2
                for (int i = 0; i < 2; ++i) {
                    [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
                    NSLog(@"2---%@",[NSThread currentThread]);      // 打印当前线程
                }
            }];
            
            [HJGCDManager dispatchAsyncWithQueue:concurrentDispatchQueue block:^{
                
                // 追加任务3
                for (int i = 0; i < 2; ++i) {
                    [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
                    NSLog(@"3---%@",[NSThread currentThread]);      // 打印当前线程
                }
            }];
            
            
            NSLog(@"异步执行 + 并发队列 - end");
        }
            break;
        case 3: {
            
            /**
             * 同步执行 + 串行队列
             * 特点：不会开启新线程，在当前线程执行任务。任务是串行的，执行完一个任务，再执行下一个任务
             */
            
            NSLog(@"同步执行 + 串行队列 - begin");
            
            [HJGCDManager dispatchSyncWithQueue:serialDispatchQueue block:^{
                
                // 追加任务1
                for (int i = 0; i < 2; ++i) {
                    [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
                    NSLog(@"1---%@",[NSThread currentThread]);      // 打印当前线程
                }
            }];
            
            [HJGCDManager dispatchSyncWithQueue:serialDispatchQueue block:^{
                
                // 追加任务2
                for (int i = 0; i < 2; ++i) {
                    [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
                    NSLog(@"2---%@",[NSThread currentThread]);      // 打印当前线程
                }
            }];
            
            [HJGCDManager dispatchSyncWithQueue:serialDispatchQueue block:^{
                
                // 追加任务3
                for (int i = 0; i < 2; ++i) {
                    [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
                    NSLog(@"3---%@",[NSThread currentThread]);      // 打印当前线程
                }
            }];
            
            
            NSLog(@"同步执行 + 串行队列 - end");
            
        }
            break;
        case 4: {
            
            /**
             * 异步执行 + 串行队列
             * 特点：会开启新线程，但是因为任务是串行的，执行完一个任务，再执行下一个任务
             */
            
            NSLog(@"异步执行 + 串行队列 - begin");
            
            [HJGCDManager dispatchAsyncWithQueue:serialDispatchQueue block:^{
                
                // 追加任务1
                for (int i = 0; i < 2; ++i) {
                    [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
                    NSLog(@"1---%@",[NSThread currentThread]);      // 打印当前线程
                }
            }];
            
            [HJGCDManager dispatchAsyncWithQueue:serialDispatchQueue block:^{
                
                // 追加任务2
                for (int i = 0; i < 2; ++i) {
                    [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
                    NSLog(@"2---%@",[NSThread currentThread]);      // 打印当前线程
                }
            }];
            
            [HJGCDManager dispatchAsyncWithQueue:serialDispatchQueue block:^{
                
                // 追加任务3
                for (int i = 0; i < 2; ++i) {
                    [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
                    NSLog(@"3---%@",[NSThread currentThread]);      // 打印当前线程
                }
            }];
            
            
            NSLog(@"异步执行 + 串行队列 - end");
            
        }
            break;
        case 5: {
            
            /**
             * 同步执行 + 主队列
             * 特点：1.在主线程中调用:互相等待卡住不可行
                    2.在其他线程中调用:不会开启新线程，执行完一个任务，再执行下一个任务
             * 在主线程中使用同步执行 + 主队列，追加到主线程的任务1、任务2、任务3都不再执行了，而且syncMain---end也没有打印，在XCode 9上还会报崩溃。
             */
            
            NSLog(@"同步执行 + 主队列 - begin");
            
            [HJGCDManager dispatchSyncWithQueue:mainDispathQueue block:^{
                
                // 追加任务1
                for (int i = 0; i < 2; ++i) {
                    [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
                    NSLog(@"1---%@",[NSThread currentThread]);      // 打印当前线程
                }
            }];
            
            [HJGCDManager dispatchSyncWithQueue:mainDispathQueue block:^{
                
                // 追加任务2
                for (int i = 0; i < 2; ++i) {
                    [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
                    NSLog(@"2---%@",[NSThread currentThread]);      // 打印当前线程
                }
            }];
            
            [HJGCDManager dispatchSyncWithQueue:mainDispathQueue block:^{
                
                // 追加任务3
                for (int i = 0; i < 2; ++i) {
                    [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
                    NSLog(@"3---%@",[NSThread currentThread]);      // 打印当前线程
                }
            }];
            
            
            NSLog(@"同步执行 + 主队列 - end");
            
        }
            break;
        case 6: {
            
            /**
             * 异步执行 + 主队列
             * 特点：只在主线程中执行任务，执行完一个任务，再执行下一个任务
             */
            
            NSLog(@"异步执行 + 主队列 - begin");
            
            [HJGCDManager dispatchAsyncWithQueue:mainDispathQueue block:^{
                
                // 追加任务1
                for (int i = 0; i < 2; ++i) {
                    [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
                    NSLog(@"1---%@",[NSThread currentThread]);      // 打印当前线程
                }
            }];
            
            [HJGCDManager dispatchAsyncWithQueue:mainDispathQueue block:^{
                
                // 追加任务2
                for (int i = 0; i < 2; ++i) {
                    [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
                    NSLog(@"2---%@",[NSThread currentThread]);      // 打印当前线程
                }
            }];
            
            [HJGCDManager dispatchAsyncWithQueue:mainDispathQueue block:^{
                
                // 追加任务3
                for (int i = 0; i < 2; ++i) {
                    [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
                    NSLog(@"3---%@",[NSThread currentThread]);      // 打印当前线程
                }
            }];
            
            
            NSLog(@"异步执行 + 主队列 - end");
            
        }
            break;
        
        case 7: {
            
            [HJGCDManager dispatchAsyncWithQueue:globalDispatchQueue block:^{
                
                // 异步追加任务1
                for (int i = 0; i < 2; ++i) {
                    [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
                    NSLog(@"1---%@",[NSThread currentThread]);      // 打印当前线程
                }
                
                // 同步回到主线程
                [HJGCDManager dispatchSyncWithQueue:mainDispathQueue block:^{
                    
                    // 追加任务2
                    for (int i = 0; i < 2; ++i) {
                        [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
                        NSLog(@"2---%@",[NSThread currentThread]);      // 打印当前线程
                    }

                }];
                
            }];
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
