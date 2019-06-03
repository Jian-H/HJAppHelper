//
//  HJ_WatermarkManager.h
//  HJAppHelper
//
//  Created by xingzhijishu on 2019/6/3.
//  Copyright © 2019 huangjian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HJ_WatermarkManager : NSObject

+ (UIImage *)addWatermark:(UIImage *)image text:(NSString *)text;

+ (UIImage *)visibleWatermark:(UIImage *)image;

@end

NS_ASSUME_NONNULL_END
