//
//  HJNetworkCache.h
//  HJNetworkHelper
//
//  Created by xingzhijishu on 17/4/7.
//  Copyright © 2017年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

// 过期提醒
#define HJDeprecated(instead) NS_DEPRECATED(2_0, 2_0, 2_0, 2_0, instead)

@interface HJNetworkCache : NSObject

/**
 异步缓存网络数据,根据请求的 URL与parameters
 做KEY存储数据, 这样就能缓存多级页面的数据

 @param httpData 服务器返回的数据
 @param URL 请求的URL地址
 @param paraneters 请求的参数
 */
+ (void)hj_setHttpCahce:(id)httpData URL:(NSString *)URL parameters:(NSDictionary *)paraneters;

/**
 根据请求的 URL与parameters 取出缓存数据

 @param URL 请求的URL
 @param parameters 请求的参数
 @return 缓存的服务器数据
 */
+ (id)hj_httpCacheForURL:(NSString *)URL parameters:(NSDictionary *)parameters;

/**
 根据请求的 URL与parameters 异步取出缓存数据

 @param URL 请求的URL
 @param parameters 请求的参数
 @param block 异步回调缓存的数据
 */
+ (void)hj_httpCacheForURL:(NSString *)URL parameters:(NSDictionary *)parameters withBlock:(void(^)(id<NSCoding> object))block;

/**
 获取网络缓存的总大小 bytes(字节)

 @return 总大小
 */
+ (NSInteger)hj_getAllHttpCacheSize;

/**
 删除所有网络缓存
 */
+ (void)hj_removeAllHttpCache;

@end
