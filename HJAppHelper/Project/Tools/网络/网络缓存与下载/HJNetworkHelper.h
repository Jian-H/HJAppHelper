//
//  HJNetworkHelper.h
//  HJNetworkHelper
//
//  Created by xingzhijishu on 17/4/7.
//  Copyright © 2017年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "HJNetworkCache.h"

#ifndef kIsNetwork
#define kIsNetwork     [HJNetworkHelper isNetwork]  // 一次性判断是否有网的宏
#endif

#ifndef kIsWWANNetwork
#define kIsWWANNetwork [HJNetworkHelper isWWANNetwork]  // 一次性判断是否为手机网络的宏
#endif

#ifndef kIsWiFiNetwork
#define kIsWiFiNetwork [HJNetworkHelper isWiFiNetwork]  // 一次性判断是否为WiFi网络的宏
#endif

typedef NS_ENUM(NSUInteger, HJNetworkStatusType) {
    /** 未知网络*/
    HJNetworkStatusUnknown,
    /** 无网络*/
    HJNetworkStatusNotReachable,
    /** 手机网络*/
    HJNetworkStatusReachableViaWWAN,
    /** WIFI网络*/
    HJNetworkStatusReachableViaWiFi,
};
typedef NS_ENUM(NSUInteger, HJRequestSerializer) {
    /** 设置请求数据为JSON格式*/
    HJRequestSerializerJSON,
    /** 设置请求数据为二进制格式*/
    HJRequestSerializerHTTP,
};

typedef NS_ENUM(NSUInteger, HJResponseSerializer) {
    /** 设置响应数据为JSON格式*/
    HJResponseSerializerJSON,
    /** 设置响应数据为二进制格式*/
    HJResponseSerializerHTTP,
};

/**
 请求成功的Block
 
 @param responseObject 请求返回的数据
 */
typedef void(^HJHttpRequestSuccess)(id responseObject);

/**
 请求失败的block
 
 @param error 失败返回error
 */
typedef void(^HJHttpRequestFailed)(NSError * error);

/**
 缓存的block
 
 @param responseCache 缓存数据
 */
typedef void(^HJHttpRequestCache)(id responseCache);

/**
 上传或者下载的进度
 
 @param progress Progress.completedUnitCount:当前大小 - Progress.totalUnitCount:总大小
 */
typedef void(^HJHttpProgress)(NSProgress * progress);

/**
 网络状态的block

 @param status 网络状态值
 */
typedef void(^HJNetworkStatus)(HJNetworkStatusType status);


@interface HJNetworkHelper : NSObject

/**
 判断是否有网

 @return 有网YES，无网NO
 */
+ (BOOL)hj_isNetwork;

/**
 判断是不是手机数据流量

 @return 数据流量YES，否则NO
 */
+ (BOOL)hj_isWWANNetwork;

/**
 判断是不是WiFi

 @return WiFi为YES，否则NO
 */
+ (BOOL)hj_isWiFiNetwork;

/**
 实时获取网络状态,通过Block回调实时获取(此方法可多次调用)

 @param networkStatus 网络状态
 */
+ (void)hj_networkStatusWithBlock:(HJNetworkStatus)networkStatus;

/**
 开启日志打印 （Debug级别）
 */
+ (void)hj_openLog;

/**
 关闭日志打印
 */
+ (void)hj_closeLog;

/**
 取消所有HTTP请求
 */
+ (void)hj_cancelAllRequest;

/**
 取消指定URL的HTTP请求

 @param URL 指定的URL
 */
+ (void)hj_cancelRequestWithURL:(NSString *)URL;

/**
 GET请求,无缓存

 @param URL 请求地址
 @param parameters 请求参数
 @param success 请求成功的回调
 @param failure 请求失败的回调
 @return 返回的对象可取消请求,调用cancel方法
 */

+ (__kindof NSURLSessionTask *)hj_GET:(NSString *)URL
                           parameters:(NSDictionary *)parameters
                              success:(HJHttpRequestSuccess)success
                              failure:(HJHttpRequestFailed)failure;


/**
 GET请求,自动缓存

 @param URL 请求地址
 @param parameters 请求参数
 @param responseCache 缓存数据的回调
 @param success 请求成功的回调
 @param failure 请求失败的回调
 @return 返回的对象可取消请求,调用cancel方法
 */
+ (__kindof NSURLSessionTask *)hj_GET:(NSString *)URL
                           parameters:(NSDictionary *)parameters
                        responseCache:(HJHttpRequestCache)responseCache
                              success:(HJHttpRequestSuccess)success
                              failure:(HJHttpRequestFailed)failure;

/**
 POST请求,无缓存

 @param URL 请求地址
 @param parameters 请求参数
 @param success 请求成功的回调
 @param failure 请求失败的回调
 @return 返回的对象可取消请求,调用cancel方法
 */
+ (__kindof NSURLSessionTask *)hj_POST:(NSString *)URL
                            parameters:(NSDictionary *)parameters
                               success:(HJHttpRequestSuccess)success
                               failure:(HJHttpRequestFailed)failure;

/**
 POST请求,自动缓存

 @param URL 请求地址
 @param parameters 请求参数
 @param responseCache 缓存数据的回调
 @param success 请求成功的回调
 @param failure 请求失败的回调
 @return 返回的对象可取消请求,调用cancel方法
 */
+ (__kindof NSURLSessionTask *)hj_POST:(NSString *)URL
                            parameters:(NSDictionary *)parameters
                         responseCache:(HJHttpRequestCache)responseCache
                               success:(HJHttpRequestSuccess)success
                               failure:(HJHttpRequestFailed)failure;

/**
 上传文件

 @param URL 请求地址
 @param parameters 请求参数
 @param name 文件对应服务器上的字段
 @param filePath 文件本地的沙盒路径
 @param progress 上传进度信息
 @param success 请求成功的回调
 @param failure 请求失败的回调
 @return 返回的对象可取消请求,调用cancel方法
 */
+ (__kindof NSURLSessionTask *)hj_uploadFileWithURL:(NSString *)URL
                                         parameters:(NSDictionary *)parameters
                                               name:(NSString *)name
                                           filePath:(NSString *)filePath
                                           progress:(HJHttpProgress)progress
                                            success:(HJHttpRequestSuccess)success
                                            failure:(HJHttpRequestFailed)failure;

/**
 上传单/多张图片

 @param URL 请求地址
 @param parameters 请求参数
 @param name 图片对应服务器上的字段
 @param images 图片数组
 @param fileNames 图片文件名数组, 可以为nil, 数组内的文件名默认为当前日期时间"yyyyMMddHHmmss"
 @param imageScale 图片文件压缩比 范围 (0.f ~ 1.f)
 @param imageType 图片文件的类型,例:png、jpg(默认类型)....
 @param progress 上传进度信息
 @param success 请求成功的回调
 @param failure 请求成功的回调
 @return 返回的对象可取消请求,调用cancel方法
 */
+ (__kindof NSURLSessionTask *)hj_uploadImagesWithURL:(NSString *)URL
                                           parameters:(NSDictionary *)parameters
                                                 name:(NSString *)name
                                               images:(NSArray<UIImage *> *)images
                                            fileNames:(NSArray<NSString *> *)fileNames
                                           imageScale:(CGFloat)imageScale
                                            imageType:(NSString *)imageType
                                             progress:(HJHttpProgress)progress
                                              success:(HJHttpRequestSuccess)success
                                              failure:(HJHttpRequestFailed)failure;

/**
 下载文件

 @param URL 请求地址
 @param fileDir 文件存储目录(默认存储目录为Download)
 @param progress 文件下载的进度信息
 @param success 下载成功的回调(回调参数filePath:文件的路径)
 @param failure 下载失败的回调
 @return 返回NSURLSessionDownloadTask实例，可用于暂停继续，暂停调用suspend方法，开始下载调用resume方法
 */
+ (__kindof NSURLSessionTask *)hj_downloadWithURL:(NSString *)URL
                                          fileDir:(NSString *)fileDir
                                         progress:(HJHttpProgress)progress
                                          success:(void(^)(NSString *filePath))success
                                          failure:(HJHttpRequestFailed)failure;



#pragma mark - 重置AFHTTPSessionManager相关属性
/**
 *  设置网络请求参数的格式:默认为二进制格式
 *
 *  @param requestSerializer HJRequestSerializerJSON(JSON格式),HJRequestSerializerHTTP(二进制格式),
 */
+ (void)hj_setRequestSerializer:(HJRequestSerializer)requestSerializer;

/**
 *  设置服务器响应数据格式:默认为JSON格式
 *
 *  @param responseSerializer HJResponseSerializerJSON(JSON格式),HJResponseSerializerHTTP(二进制格式)
 */
+ (void)hj_setResponseSerializer:(HJResponseSerializer)responseSerializer;

/**
 *  设置请求超时时间:默认为30S
 *
 *  @param time 时长
 */
+ (void)hj_setRequestTimeoutInterval:(NSTimeInterval)time;

/**
 *  设置请求头
 */
+ (void)hj_setValue:(NSString *)value forHTTPHeaderField:(NSString *)field;

/**
 *  是否打开网络状态转圈菊花:默认打开
 *
 *  @param open YES(打开), NO(关闭)
 */
+ (void)hj_openNetworkActivityIndicator:(BOOL)open;

/**
 配置自建证书的Https请求, 参考链接: http://blog.csdn.net/syg90178aw/article/details/52839103
 
 @param cerPath 自建Https证书的路径
 @param validatesDomainName 是否需要验证域名，默认为YES. 如果证书的域名与请求的域名不一致，需设置为NO; 即服务器使用其他可信任机构颁发
 的证书，也可以建立连接，这个非常危险, 建议打开.validatesDomainName=NO, 主要用于这种情况:客户端请求的是子域名, 而证书上的是另外
 一个域名。因为SSL证书上的域名是独立的,假如证书上注册的域名是www.google.com, 那么mail.google.com是无法验证通过的.
 */
+ (void)hj_setSecurityPolicyWithCerPath:(NSString *)cerPath validatesDomainName:(BOOL)validatesDomainName;

@end
