//
//  HJGCDManager.h
//  HJAppHelper
//
//  Created by xingzhijishu on 16/11/17.
//  Copyright © 2016年 huangjian. All rights reserved.
//

#import <Foundation/Foundation.h>

/*https://bujige.net/blog/iOS-Complete-learning-GCD.html
  https://www.jianshu.com/p/2d57c72016c6
  有详细介绍
*/

/*
 虽然使用 GCD 只需两步，但是既然我们有两种队列（串行队列/并发队列），两种任务执行方式（同步执行/异步执行），那么我们就有了四种不同的组合方式。这四种不同的组合方式是：
 
 1.同步执行 + 并发队列
 2.异步执行 + 并发队列
 3.同步执行 + 串行队列
 4.异步执行 + 串行队列
 实际上，刚才还说了两种特殊队列：全局并发队列、主队列。全局并发队列可以作为普通并发队列来使用。但是主队列因为有点特殊，所以我们就又多了两种组合方式。这样就有六种不同的组合方式了。
 
 5.同步执行 + 主队列
 6异步执行 + 主队列
 
 */

@interface HJGCDManager : NSObject

/**
 新建一个串行队列

 @return 串行队列
 */
+ (dispatch_queue_t)serialDispatchQueue:(const char *)queueName;

/**
 创建一个并行队列

 @return 并行队列
 */
+ (dispatch_queue_t)concurrentDispatchQueue:(const char *)queueName;


/**
 系统提供一个串行主队列，只在主线程上执行代码

 @return 串行主队列
 */
+ (dispatch_queue_t)mainDispathQueue;


/**
 系统提供了全局并发队列

 @return 全局并发队列
 */
+ (dispatch_queue_t)globalDispatchQueue;


/**
 同步执行任务的创建方法

 @param queue 执行队列
 @param block 执行任务
 */
+ (void)dispatchSyncWithQueue:(dispatch_queue_t)queue block:(void(^)())block;

/**
 异步执行任务创建方法
 
 @param queue 执行队列
 @param block 执行任务
 */
+ (void)dispatchAsyncWithQueue:(dispatch_queue_t)queue block:(void(^)())block;

@end
