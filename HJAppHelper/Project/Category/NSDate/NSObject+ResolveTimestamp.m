//
//  NSObject+ResolveTimestamp.m
//  HJAppHelper
//
//  Created by huangjian on 16/3/15.
//  Copyright © 2016年 huangjian. All rights reserved.
//

#import "NSObject+ResolveTimestamp.h"

@implementation NSObject (ResolveTimestamp)

#pragma mark -- 获得格式为"YYYY-MM-dd HH:mm:ss"的NSDate数据
- (NSDate *)getNSDateWithCreateTime:(NSString *)createtime {
    //解析时间戳
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:[createtime intValue]];
    return confromTimesp;
}

#pragma mark -- 获得格式为"YYYY-MM-dd"的时间数据
- (NSString *)getYMDWithCreateTime:(NSString *)createtime {
    //解析时间戳
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:[createtime intValue]];
    NSString * timeString = [formatter stringFromDate:confromTimesp];
    return timeString;
}

#pragma mark -- 获得格式为"MM-dd HH:mm:ss"的时间数据
- (NSString *)getMDHMSWithCreateTime:(NSString *)createtime {
    //解析时间戳
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"MM-dd HH:mm:ss"];
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:[createtime intValue]];
    NSString * timeString = [formatter stringFromDate:confromTimesp];
    return timeString;
}

#pragma mark -- 获得格式为"MM-dd HH:mm"的时间数据
- (NSString *)getMDHMWithCreateTime:(NSString *)createtime {
    //解析时间戳
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"MM-dd HH:mm"];
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:[createtime intValue]];
    NSString * timeString = [formatter stringFromDate:confromTimesp];
    return timeString;
}

#pragma mark -- 获得老时间离现在的时间的差的数据
- (NSTimeInterval)getNSDateSinceOldTimeWithCreateTime:(NSString *)createtime {
    //解析时间戳
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:[createtime intValue]];
    NSTimeInterval time = [[NSDate date] timeIntervalSinceDate:confromTimesp];
    return time;
}

#pragma mark -- 获得格式为"YYYY-MM-dd HH:mm:ss"的当前数据
- (NSString *)getNowDateTimeString {
    //获得当前时间戳
    NSDate * nowDate =[NSDate date];
    NSString *nowDateString = [NSString stringWithFormat:@"%ld", (long)[nowDate timeIntervalSince1970]];
    return nowDateString;
}

#pragma mark -- 获得指定时间的时间戳
- (NSString *)getNowDateTimeStringWithDate:(NSDate *)date {
    NSString *nowDateString = [NSString stringWithFormat:@"%ld", (long)[date timeIntervalSince1970]];
    return nowDateString;
}

#pragma mark -- 获得毫秒时间戳
- (UInt64)getRecordTimeWithDate:(NSDate *)date {
    UInt64 recordTime = [[NSDate date] timeIntervalSince1970]*1000;
    return recordTime;
}

#pragma mark -- 获得格式为"YYYY年MM月dd日 HH:mm"的NSDate数据
- (NSString *)getNSDateHaveChineseWithCreateTime:(NSString *)createtime {
    //解析时间戳
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:[createtime intValue]];
    NSString * backString = [formatter stringFromDate:confromTimesp];
    NSArray * stringArray = [backString componentsSeparatedByString:@" "];
    NSString * YMDString = [stringArray firstObject];
    NSArray * YMDArray = [YMDString componentsSeparatedByString:@"-"];
    if (YMDArray.count == 3) {
        backString = [NSString stringWithFormat:@"%@年%@月%@日 %@",YMDArray[0],YMDArray[1],YMDArray[2],[stringArray lastObject]];
    }
    return backString;
}

#pragma mark -- 获得格式为"YYYY-MM-dd HH:mm"的当前NSDate数据
- (NSString *)getNSDateYMDHMWithNowTimeWith:(NSDate *)date {
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString * backString = [formatter stringFromDate:date];
    return backString;
}

#pragma mark -- 获得格式为"YYYY-MM-dd"的当前NSDate数据
- (NSString *)getNSDateYMDWithNowTimeWith:(NSDate *)date {
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString * backString = [formatter stringFromDate:date];
    return backString;
}

#pragma mark - 获得时间戳（通过YYYY-MM-dd HH:mm的字符串）
- (NSString *)getStringWithDateOfString:(NSString *)dateString {
    NSString * string = nil;
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSDate * date = [formatter dateFromString:dateString];
    string = [self getNowDateTimeStringWithDate:date];
    return string;
}

@end
