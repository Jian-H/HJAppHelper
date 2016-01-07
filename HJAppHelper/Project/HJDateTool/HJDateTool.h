//
//  HJDateTool.h
//  HJAppHelper
//
//  Created by huangjian on 15/12/31.
//  Copyright © 2015年 huangjian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HJDateTool : NSObject

/**
 *  时间戳转换时间
 *
 *  @param dateString 时间戳
 *
 *  @return 具体描述时间
 */
+ (NSString *)calculateTimeWithDay:(NSString *)dateString;

@end
