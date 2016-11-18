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

@end
