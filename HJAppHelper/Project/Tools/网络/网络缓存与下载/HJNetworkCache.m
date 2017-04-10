//
//  HJNetworkCache.m
//  HJNetworkHelper
//
//  Created by xingzhijishu on 17/4/7.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "HJNetworkCache.h"
#import "YYCache.h"

@implementation HJNetworkCache

static NSString * const HJNetworkResponseCache = @"HJNetworkResponseCache";
static YYCache * _dataCache;

+ (void)initialize {
    
    _dataCache = [YYCache cacheWithName:HJNetworkResponseCache];
}

+ (void)hj_setHttpCahce:(id)httpData URL:(NSString *)URL parameters:(NSDictionary *)paraneters {

    NSString * cacheKey = [self hj_cacheKeyWithURL:URL parameters:paraneters];
    //异步缓存，不会阻塞主线程
    [_dataCache setObject:httpData forKey:cacheKey withBlock:^{
        
    }];
}

+ (id)hj_httpCacheForURL:(NSString *)URL parameters:(NSDictionary *)parameters {
    
    NSString *cacheKey = [self hj_cacheKeyWithURL:URL parameters:parameters];
    return [_dataCache objectForKey:cacheKey];
}


+ (void)hj_httpCacheForURL:(NSString *)URL parameters:(NSDictionary *)parameters withBlock:(void (^)(id<NSCoding>))block {

    NSString * cacheKey = [self hj_cacheKeyWithURL:URL parameters:parameters];
    [_dataCache objectForKey:cacheKey withBlock:^(NSString * _Nonnull key, id<NSCoding>  _Nonnull object) {
       
        dispatch_async(dispatch_get_main_queue(), ^{
           
            block(object);
        });
    }];
}

+ (NSInteger)hj_getAllHttpCacheSize {

    return [_dataCache.diskCache totalCost];
}

+ (void)hj_removeAllHttpCache {
    
    [_dataCache.diskCache removeAllObjects];
}


/**
 根据URL 和 parameters 拼接出存储KEY

 @param URL 存储的URL
 @param parameters 参数
 @return 存储对应的KEY
 */
+ (NSString *)hj_cacheKeyWithURL:(NSString *)URL parameters:(NSDictionary *)parameters {

    if (!parameters) {
        return URL;
    }
    
    //将参数字典转换成字符串
    NSData * stringData = [NSJSONSerialization dataWithJSONObject:parameters options:0 error:nil];
    NSString * parametersString = [[NSString alloc] initWithData:stringData encoding:NSUTF8StringEncoding];
    
    NSString * cacheKey = [NSString stringWithFormat:@"%@%@",URL,parametersString];
    
    return cacheKey;
}

@end
