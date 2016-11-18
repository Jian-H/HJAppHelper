//
//  HJGCDManager.h
//  HJAppHelper
//
//  Created by xingzhijishu on 16/11/17.
//  Copyright © 2016年 huangjian. All rights reserved.
//

#import <Foundation/Foundation.h>

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

@end
