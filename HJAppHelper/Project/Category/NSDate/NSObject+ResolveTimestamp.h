//
//  NSObject+ResolveTimestamp.h
//  HJAppHelper
//
//  Created by huangjian on 16/3/15.
//  Copyright © 2016年 huangjian. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  用来解析时间戳的类别
 */
@interface NSObject (ResolveTimestamp)

#pragma mark -- 获得格式为"YYYY-MM-dd HH:mm:ss"的NSDate数据
- (NSDate *)getNSDateWithCreateTime:(NSString *)createtime;
#pragma mark -- 获得老时间离现在的时间的差的数据
- (NSTimeInterval)getNSDateSinceOldTimeWithCreateTime:(NSString *)createtime;
#pragma mark -- 获得格式为"YYYY-MM-dd HH:mm:ss"的当前数据
- (NSString *)getNowDateTimeString;
#pragma mark -- 获得指定时间的时间戳
- (NSString *)getNowDateTimeStringWithDate:(NSDate *)date;
#pragma mark -- 获得格式为"YYYY-MM-dd"的时间数据
- (NSString *)getYMDWithCreateTime:(NSString *)createtime;
#pragma mark -- 获得格式为"MM-dd HH:mm:ss"的时间数据
- (NSString *)getMDHMSWithCreateTime:(NSString *)createtime;
#pragma mark -- 获得格式为"YY-MM-dd HH:mm"的时间数据
- (NSString *)getMDHMWithCreateTime:(NSString *)createtime;
#pragma mark -- 获得格式为"YYYY年MM月dd日 HH:mm"的NSDate数据
- (NSString *)getNSDateHaveChineseWithCreateTime:(NSString *)createtime;
#pragma mark -- 获得格式为"YYYY-MM-dd HH:mm"的当前NSDate数据
- (NSString *)getNSDateYMDHMWithNowTimeWith:(NSDate *)date;
#pragma mark - 获得时间戳（通过YYYY-MM-dd HH:mm的字符串）
- (NSString *)getStringWithDateOfString:(NSString *)dateString;
#pragma mark -- 获得格式为"YYYY-MM-dd"的当前NSDate数据
- (NSString *)getNSDateYMDWithNowTimeWith:(NSDate *)date;
#pragma mark -- 获得毫秒时间戳
- (UInt64)getRecordTimeWithDate:(NSDate *)date;

@end
