//
//  HJImageColorTool.h
//  HJAppHelper
//
//  Created by huangjian on 16/3/9.
//  Copyright © 2016年 huangjian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface HJImageColorTool : NSObject

#pragma mark - 获取主色调
+ (UIColor *)mostColorWithImage:(UIImage *)image;

#pragma mark - 获取均色调
+ (UIColor *)averageColorWithImage:(UIImage *)image;

@end
