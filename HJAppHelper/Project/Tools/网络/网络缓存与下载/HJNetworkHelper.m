//
//  HJNetworkHelper.m
//  HJNetworkHelper
//
//  Created by xingzhijishu on 17/4/7.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "HJNetworkHelper.h"
#import "AFNetworking.h"
#import "AFNetworkActivityIndicatorManager.h"

#ifdef DEBUG
#define HJLog(...) printf("[%s] %s [第%d行]: %s\n", __TIME__ ,__PRETTY_FUNCTION__ ,__LINE__, [[NSString stringWithFormat:__VA_ARGS__] UTF8String])
#else
#define HJLog(...)
#endif

#define NSStringFormat(format,...) [NSString stringWithFormat:format,##__VA_ARGS__]

@implementation HJNetworkHelper

static BOOL _isOpenLog; //是否已开启日志打印
static NSMutableArray * _allSessionTask;
static AFHTTPSessionManager * _sessionManager;

+ (BOOL)hj_isNetwork {

    return [AFNetworkReachabilityManager sharedManager].reachable;
}

+ (BOOL)hj_isWWANNetwork {
    
    return [AFNetworkReachabilityManager sharedManager].reachableViaWWAN;
}

+ (BOOL)hj_isWiFiNetwork {
    
    return [AFNetworkReachabilityManager sharedManager].reachableViaWiFi;
}

+ (void)hj_networkStatusWithBlock:(HJNetworkStatus)networkStatus {

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
       
        [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
           
            switch (status) {
                case AFNetworkReachabilityStatusUnknown:
                    
                    networkStatus ? networkStatus(HJNetworkStatusUnknown) : nil;
                    HJLog(@"未知网络");
                    break;
                    
                case AFNetworkReachabilityStatusNotReachable:
                    
                    networkStatus ? networkStatus(HJNetworkStatusNotReachable) : nil;
                    HJLog(@"无网络");
                    break;
                
                case AFNetworkReachabilityStatusReachableViaWWAN:
                
                    networkStatus ? networkStatus(HJNetworkStatusReachableViaWWAN) : nil;
                    HJLog(@"手机自带网络");
                    break;
                
                case AFNetworkReachabilityStatusReachableViaWiFi:
                    
                    networkStatus ? networkStatus(HJNetworkStatusReachableViaWiFi) : nil;
                    HJLog(@"WiFi");
                    break;
                    
                default:
                    break;
            }
            
        }];
        
    });
}

+ (void)hj_openLog {
    _isOpenLog = YES;
}

+ (void)hj_closeLog {
    _isOpenLog = NO;
}

+ (void)hj_cancelAllRequest {

    //锁操作
    @synchronized (self) {
        [[self allSessionTask] enumerateObjectsUsingBlock:^(NSURLSessionTask *  _Nonnull task, NSUInteger idx, BOOL * _Nonnull stop) {
            [task cancel];
        }];
        [[self allSessionTask] removeAllObjects];
    }
}

+ (void)hj_cancelRequestWithURL:(NSString *)URL {

    if (!URL) {
        return;
    }
    
    @synchronized (self) {
        [[self allSessionTask] enumerateObjectsUsingBlock:^(NSURLSessionTask *  _Nonnull task, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([task.currentRequest.URL.absoluteString hasPrefix:URL]) {
                [task cancel];
                [[self allSessionTask] removeObject:task];
                *stop = YES;
            }
        }];
    }
}

+ (__kindof NSURLSessionTask *)hj_GET:(NSString *)URL parameters:(NSDictionary *)parameters success:(HJHttpRequestSuccess)success failure:(HJHttpRequestFailed)failure {

    return [self hj_GET:URL parameters:parameters responseCache:nil success:success failure:failure];
}

+ (NSURLSessionTask *)hj_GET:(NSString *)URL
                  parameters:(NSDictionary *)parameters
               responseCache:(HJHttpRequestCache)responseCache
                     success:(HJHttpRequestSuccess)success
                     failure:(HJHttpRequestFailed)failure {

    //读取缓存
    responseCache ? responseCache([HJNetworkCache hj_httpCacheForURL:URL parameters:parameters]) : nil;
    
    NSURLSessionTask * sessionTask = [_sessionManager GET:URL
                                               parameters:parameters
                                                 progress:^(NSProgress * _Nonnull downloadProgress) {
                                                     
                                                 } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                                                     
                                                     HJLog(@"%@",_isOpenLog ? NSStringFormat(@"responseObject = %@",[self jsonToString:responseObject]) : @"HJNetworkHelper已关闭日志打印");
                                                     [[self allSessionTask] removeObject:task];
                                                     
                                                     success ? success(responseObject) : nil;
                                                     //对数据进行异步缓存
                                                     responseCache ? [HJNetworkCache hj_setHttpCahce:responseObject URL:URL parameters:parameters] : nil;
                                                     
                                                 } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                                     
                                                     HJLog(@"%@",_isOpenLog ? NSStringFormat(@"error = %@",error) : @"HJNetworkHelper已关闭日志打印");
                                                     
                                                     [[self allSessionTask] removeObject:task];
                                                     
                                                     failure ? failure(error) : nil;
                                                 }];
    
    //添加最新的sessionTask到数组
    sessionTask ? [[self allSessionTask] addObject:sessionTask] : nil;

    return sessionTask;
}

+ (__kindof NSURLSessionTask *)hj_POST:(NSString *)URL parameters:(NSDictionary *)parameters success:(HJHttpRequestSuccess)success failure:(HJHttpRequestFailed)failure {

    return [self hj_POST:URL parameters:parameters responseCache:nil success:success failure:failure];
}

+ (__kindof NSURLSessionTask *)hj_POST:(NSString *)URL parameters:(NSDictionary *)parameters responseCache:(HJHttpRequestCache)responseCache success:(HJHttpRequestSuccess)success failure:(HJHttpRequestFailed)failure {

    responseCache ? responseCache([HJNetworkCache hj_httpCacheForURL:URL parameters:parameters]) : nil;
    
    NSURLSessionTask * sessionTask = [_sessionManager POST:URL
                                                parameters:parameters
                                                  progress:^(NSProgress * _Nonnull uploadProgress) {
                                                      
                                                  } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                                                      
                                                      HJLog(@"%@",_isOpenLog ? NSStringFormat(@"responseObject = %@",[self jsonToString:responseObject]) : @"HJNetworkHelper已关闭日志打印");
                                                      
                                                      [[self allSessionTask] removeObject:task];
                                                      
                                                      success ? success(responseObject) : nil;
                                                      
                                                      //对数据进行异步缓存
                                                      responseCache ? [HJNetworkCache hj_setHttpCahce:responseObject URL:URL parameters:parameters] : nil;
                                                      
                                                      
                                                  } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                                      
                                                      HJLog(@"%@",_isOpenLog ? NSStringFormat(@"error = %@",error) : @"HJNetworkHelper已关闭日志打印");
                                                      
                                                      [[self allSessionTask] removeObject:task];
                                                      failure ? failure(error) : nil;

                                                  }];

    //添加最新的sessionTask到数组
    sessionTask ? [[self allSessionTask] addObject:sessionTask] : nil;
    
    return sessionTask;
}

+ (__kindof NSURLSessionTask *)hj_uploadFileWithURL:(NSString *)URL parameters:(NSDictionary *)parameters name:(NSString *)name filePath:(NSString *)filePath progress:(HJHttpProgress)progress success:(HJHttpRequestSuccess)success failure:(HJHttpRequestFailed)failure {

    NSURLSessionTask * sessionTask = [_sessionManager POST:URL parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        NSError *error = nil;
        [formData appendPartWithFileURL:[NSURL URLWithString:filePath] name:name error:&error];
        (failure && error) ? failure(error) : nil;
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        //上传进度
        dispatch_sync(dispatch_get_main_queue(), ^{
            progress ? progress(uploadProgress) : nil;
        });
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        HJLog(@"%@",_isOpenLog ? NSStringFormat(@"responseObject = %@",[self jsonToString:responseObject]) : @"HJNetworkHelper已关闭日志打印");
        
        [[self allSessionTask] removeObject:task];
        success ? success(responseObject) : nil;
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        HJLog(@"%@",_isOpenLog ? NSStringFormat(@"error = %@",error) : @"HJNetworkHelper已关闭日志打印");
        
        [[self allSessionTask] removeObject:task];
        failure ? failure(error) : nil;
    }];
    
    // 添加sessionTask到数组
    sessionTask ? [[self allSessionTask] addObject:sessionTask] : nil ;
    
    return sessionTask;
};

+ (__kindof NSURLSessionTask *)hj_uploadImagesWithURL:(NSString *)URL parameters:(NSDictionary *)parameters name:(NSString *)name images:(NSArray<UIImage *> *)images fileNames:(NSArray<NSString *> *)fileNames imageScale:(CGFloat)imageScale imageType:(NSString *)imageType progress:(HJHttpProgress)progress success:(HJHttpRequestSuccess)success failure:(HJHttpRequestFailed)failure {

    NSURLSessionTask * sessionTask = [_sessionManager POST:URL parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        for (NSUInteger i = 0; i < images.count; i++) {
            // 图片经过等比压缩后得到的二进制文件
            NSData *imageData = UIImageJPEGRepresentation(images[i], imageScale ?: 1.f);
            // 默认图片的文件名, 若fileNames为nil就使用
            
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            formatter.dateFormat = @"yyyyMMddHHmmss";
            NSString *str = [formatter stringFromDate:[NSDate date]];
            NSString *imageFileName = NSStringFormat(@"%@%ld.%@",str,i,imageType?:@"jpg");
            
            [formData appendPartWithFileData:imageData
                                        name:name
                                    fileName:fileNames ? NSStringFormat(@"%@.%@",fileNames[i],imageType?:@"jpg") : imageFileName
                                    mimeType:NSStringFormat(@"image/%@",imageType ?: @"jpg")];
        }
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        //上传进度
        dispatch_sync(dispatch_get_main_queue(), ^{
            progress ? progress(uploadProgress) : nil;
        });
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        HJLog(@"%@",_isOpenLog ? NSStringFormat(@"responseObject = %@",[self jsonToString:responseObject]) : @"HJNetworkHelper已关闭日志打印");
        
        [[self allSessionTask] removeObject:task];
        success ? success(responseObject) : nil;
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        HJLog(@"%@",_isOpenLog ? NSStringFormat(@"error = %@",error) : @"HJNetworkHelper已关闭日志打印");
        
        [[self allSessionTask] removeObject:task];
        failure ? failure(error) : nil;
    }];
    
    // 添加sessionTask到数组
    sessionTask ? [[self allSessionTask] addObject:sessionTask] : nil ;
    
    return sessionTask;
}

+ (__kindof NSURLSessionTask *)hj_downloadWithURL:(NSString *)URL fileDir:(NSString *)fileDir progress:(HJHttpProgress)progress success:(void (^)(NSString *))success failure:(HJHttpRequestFailed)failure {

    NSURLRequest * request = [NSURLRequest requestWithURL:[NSURL URLWithString:URL]];
    NSURLSessionDownloadTask * downloadTask = [_sessionManager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        //下载进度
        dispatch_sync(dispatch_get_main_queue(), ^{
            progress ? progress(downloadProgress) : nil;
        });
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        //拼接缓存目录
        NSString *downloadDir = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:fileDir ? fileDir : @"Download"];
        //打开文件管理器
        NSFileManager *fileManager = [NSFileManager defaultManager];
        //创建Download目录
        [fileManager createDirectoryAtPath:downloadDir withIntermediateDirectories:YES attributes:nil error:nil];
        //拼接文件路径
        NSString *filePath = [downloadDir stringByAppendingPathComponent:response.suggestedFilename];
        
        //返回文件位置的URL路径
        return [NSURL fileURLWithPath:filePath];
        
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        
        [[self allSessionTask] removeObject:downloadTask];
        if(failure && error) {failure(error) ; return ;};
        success ? success(filePath.absoluteString /** NSURL->NSString*/) : nil;
        
    }];
    //开始下载
    [downloadTask resume];
    // 添加sessionTask到数组
    downloadTask ? [[self allSessionTask] addObject:downloadTask] : nil ;
    return downloadTask;
}

#pragma mark - 重置AFHTTPSessionManager相关属性
+ (void)hj_setRequestSerializer:(HJRequestSerializer)requestSerializer {
    _sessionManager.requestSerializer = requestSerializer==HJRequestSerializerHTTP ? [AFHTTPRequestSerializer serializer] : [AFJSONRequestSerializer serializer];
}

+ (void)hj_setResponseSerializer:(HJResponseSerializer)responseSerializer {
    _sessionManager.responseSerializer = responseSerializer==HJResponseSerializerHTTP ? [AFHTTPResponseSerializer serializer] : [AFJSONResponseSerializer serializer];
}

+ (void)hj_setRequestTimeoutInterval:(NSTimeInterval)time {
    _sessionManager.requestSerializer.timeoutInterval = time;
}

+ (void)hj_setValue:(NSString *)value forHTTPHeaderField:(NSString *)field {
    [_sessionManager.requestSerializer setValue:value forHTTPHeaderField:field];
}

+ (void)hj_openNetworkActivityIndicator:(BOOL)open {
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:open];
}

+ (void)hj_setSecurityPolicyWithCerPath:(NSString *)cerPath validatesDomainName:(BOOL)validatesDomainName {
    NSData *cerData = [NSData dataWithContentsOfFile:cerPath];
    // 使用证书验证模式
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];
    // 如果需要验证自建证书(无效证书)，需要设置为YES
    securityPolicy.allowInvalidCertificates = YES;
    // 是否需要验证域名，默认为YES;
    securityPolicy.validatesDomainName = validatesDomainName;
    securityPolicy.pinnedCertificates = [[NSSet alloc] initWithObjects:cerData, nil];
    
    [_sessionManager setSecurityPolicy:securityPolicy];
}

#pragma mark -- 私有方法

/**
 存储着所有的请求task数组
 */
+ (NSMutableArray *)allSessionTask {

    if (!_allSessionTask) {
        _allSessionTask = [[NSMutableArray alloc] init];
    }
    return _allSessionTask;
}

/**
 *  所有的HTTP请求共享一个AFHTTPSessionManager
 *  原理参考地址:http://www.jianshu.com/p/5969bbb4af9f
 */
+ (void)initialize {
    _sessionManager = [AFHTTPSessionManager manager];
    // 设置请求的超时时间
    _sessionManager.requestSerializer.timeoutInterval = 30.f;
    // 设置服务器返回结果的类型:JSON (AFJSONResponseSerializer,AFHTTPResponseSerializer)
    _sessionManager.responseSerializer = [AFJSONResponseSerializer serializer];
    _sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html", @"text/json", @"text/plain", @"text/javascript", @"text/xml", @"image/*", nil];
    // 打开状态栏的等待菊花
    [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
}

/**
 *  json转字符串
 */
+ (NSString *)jsonToString:(id)data {
    if(!data) { return nil; }
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:data options:NSJSONWritingPrettyPrinted error:nil];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

@end

#pragma mark - NSDictionary,NSArray的分类
/*
 ************************************************************************************
 *新建NSDictionary与NSArray的分类, 控制台打印json数据中的中文
 ************************************************************************************
 */

#ifdef DEBUG
@implementation NSArray (HJ)

- (NSString *)descriptionWithLocale:(id)locale {
    NSMutableString *strM = [NSMutableString stringWithString:@"(\n"];
    [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [strM appendFormat:@"\t%@,\n", obj];
    }];
    [strM appendString:@")"];
    
    return strM;
}

@end

@implementation NSDictionary (HJ)

- (NSString *)descriptionWithLocale:(id)locale {
    NSMutableString *strM = [NSMutableString stringWithString:@"{\n"];
    [self enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        [strM appendFormat:@"\t%@ = %@;\n", key, obj];
    }];
    
    [strM appendString:@"}\n"];
    
    return strM;
}
@end
#endif
