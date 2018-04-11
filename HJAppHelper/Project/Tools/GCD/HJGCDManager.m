//
//  HJGCDManager.m
//  HJAppHelper
//
//  Created by xingzhijishu on 16/11/17.
//  Copyright © 2016年 huangjian. All rights reserved.
//

#import "HJGCDManager.h"

@implementation HJGCDManager

/**
 新建一个串行队列
 
 @return 串行队列
 */
+ (dispatch_queue_t)serialDispatchQueue:(const char *)queueName {//"com.example.gcd.mySerialDispatchQueue" queueName类似这样

    //新建一个串行队列,第一个参数是队列名称，第二个参数对于串行队列必须为NULL或者DISPATCH_QUEUE_SERIAL
    dispatch_queue_t mySerialDispatchQueue = dispatch_queue_create(queueName, DISPATCH_QUEUE_SERIAL);
    
    return mySerialDispatchQueue;
}

/**
 创建一个并行队列
 
 @return 并行队列
 */
+ (dispatch_queue_t)concurrentDispatchQueue:(const char *)queueName {//"com.example.gcd.MyConcurrentDispatchQueue" queueName类似这样

    //创建一个并行队列，第一个参数是队列名称，第二个参数必须为 DISPATCH_QUEUE_CONCURRENT
    dispatch_queue_t myConcurrentDispatchQueue = dispatch_queue_create(queueName, DISPATCH_QUEUE_CONCURRENT);
    
    return myConcurrentDispatchQueue;
}

/**
 系统提供一个串行主队列，只在主线程上执行代码
 
 @return 串行主队列
 */
+ (dispatch_queue_t)mainDispathQueue {

    dispatch_queue_t mainDispathQueue = dispatch_get_main_queue();
    
    return mainDispathQueue;
}

/**
 系统提供了全局并发队列
 
 @return 全局并发队列
 */
+ (dispatch_queue_t)globalDispatchQueue {
    //第一个参数表示队列优先级，一般用DISPATCH_QUEUE_PRIORITY_DEFAULT。第二个参数暂时没用，用0即可。
    dispatch_queue_t globalDispatchQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    return globalDispatchQueue;
}

/**
 同步执行任务的创建方法
 
 @param queue 执行队列
 @param block 执行任务
 */
+ (void)dispatchSyncWithQueue:(dispatch_queue_t)queue block:(void(^)())block {
    dispatch_sync(queue, block);
}

/**
 异步执行任务创建方法
 
 @param queue 执行队列
 @param block 执行任务
 */
+ (void)dispatchAsyncWithQueue:(dispatch_queue_t)queue block:(void(^)())block {
    dispatch_async(queue, block);
}

/**
 栅栏方法
 
 @param queue 执行队列
 @param block 执行任务
 */
+ (void)dispatchBarrierAsyncWithQueue:(dispatch_queue_t)queue block:(void(^)())block {
    dispatch_barrier_sync(queue, block);
}

/**
 延时执行方法
 
 @param queue 执行队列
 @param seconds 延时秒数
 @param block 执行任务
 */
+ (void)dispatchAfterWithWithQueue:(dispatch_queue_t)queue seconds:(float)seconds block:(void(^)())block {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(seconds * NSEC_PER_SEC)), queue, block);
}

/**
 一次性代码（只执行一次）
 
 @param block 执行任务
 */
+ (void)dispatchOnceWithBlock:(void(^)())block {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, block);
}

/**
 快速迭代方法
 
 @param queue 执行队列
 @param time 次数
 @param block 执行任务
 */
+ (void)dispatchApplyWithQueue:(dispatch_queue_t)queue time:(size_t)time block:(void(^)(size_t index))block {
    
    dispatch_apply(time, queue, block);
}

@end
