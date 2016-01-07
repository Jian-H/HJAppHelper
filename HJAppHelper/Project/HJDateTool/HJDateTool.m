//
//  HJDateTool.m
//  HJAppHelper
//
//  Created by huangjian on 15/12/31.
//  Copyright © 2015年 huangjian. All rights reserved.
//

#import "HJDateTool.h"

@implementation HJDateTool

+ (NSString *)calculateTimeWithDay:(NSString *)dateString
{
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate * destDate = [NSDate dateWithTimeIntervalSince1970:[dateString doubleValue]];
    NSCalendar * greCalendar = [NSCalendar currentCalendar];
    greCalendar.firstWeekday = 2;
    NSUInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit | NSWeekdayCalendarUnit | NSWeekOfYearCalendarUnit;
    NSDateComponents * dateComponents = [greCalendar components:unitFlags fromDate:destDate];
    NSDateComponents * currentDateComponents = [greCalendar components:unitFlags fromDate:[NSDate date]];
    NSString * destDateString = nil;
    if (dateComponents.year == currentDateComponents.year && dateComponents.month == currentDateComponents.month && dateComponents.day == currentDateComponents.day){
        destDateString = @"今天";
    }else{
        NSDateComponents * tempDateComponents = [[NSDateComponents alloc] init];
        [tempDateComponents setDay:-1];
        NSDate *newDate = [greCalendar dateByAddingComponents:tempDateComponents toDate:[NSDate date] options:0];
        NSDateComponents *dateComponents1 = [greCalendar components:unitFlags fromDate:newDate];
        if (dateComponents1.year==dateComponents.year && dateComponents1.month==dateComponents.month && dateComponents1.day == dateComponents.day){
            destDateString = @"昨天";
        }else
        {
            if (dateComponents.weekOfYear == currentDateComponents.weekOfYear){
                switch (dateComponents.weekday) {
                    case 1:
                        return @"星期日";
                        break;
                    case 2:
                        return @"星期一";
                        break;
                    case 3:
                        return @"星期二";
                        break;
                    case 4:
                        return @"星期三";
                        break;
                    case 5:
                        return @"星期四";
                        break;
                    case 6:
                        return @"星期五";
                        break;
                    case 7:
                        return @"星期六";
                        break;
                    default:
                        break;
                }
            }
        }
    }
    if (destDateString.length > 0){
        if ([destDateString isEqualToString:@"今天"]){
            destDateString = @"";
            if (dateComponents.hour<10){
                destDateString = [destDateString stringByAppendingString:[NSString stringWithFormat:@"0%zd:",dateComponents.hour]];
            }else{
                destDateString = [destDateString stringByAppendingString:[NSString stringWithFormat:@"%zd:",dateComponents.hour]];
            }
            if (dateComponents.minute<10){
                destDateString = [destDateString stringByAppendingString:[NSString stringWithFormat:@"0%zd",dateComponents.minute]];
            }else{
                destDateString = [destDateString stringByAppendingString:[NSString stringWithFormat:@"%zd",dateComponents.minute]];
            }
        }
    }else{
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat: @"yyyy-MM-dd"];
        destDateString = [dateFormatter stringFromDate:destDate];
    }
    return destDateString;
}

@end
