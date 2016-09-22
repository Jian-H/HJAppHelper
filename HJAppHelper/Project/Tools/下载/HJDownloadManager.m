//
//  HJDownloadManager.m
//  HJDownloadManager
//
//  Created by xingzhijishu on 16/9/14.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "HJDownloadManager.h"

#import <CommonCrypto/CommonDigest.h>


NSString * const HJDownloadCacheFolderName = @"HJDownloadCache";

static NSString * cacheFolder() {
    NSFileManager *filemgr = [NSFileManager defaultManager];
    static NSString *cacheFolder;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!cacheFolder) {
            NSString *cacheDir = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES).lastObject;
            cacheFolder = [cacheDir stringByAppendingPathComponent:HJDownloadCacheFolderName];
        }
        NSError *error = nil;
        if(![filemgr createDirectoryAtPath:cacheFolder withIntermediateDirectories:YES attributes:nil error:&error]) {
            NSLog(@"Failed to create cache directory at %@", cacheFolder);
            cacheFolder = nil;
        }
    });
    
    return cacheFolder;
}

static NSString * LocalReceiptsPath() {
    return [cacheFolder() stringByAppendingPathComponent:@"receipts.data"];
}

static unsigned long long fileSizeForPath(NSString *path) {
    
    signed long long fileSize = 0;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:path]) {
        NSError *error = nil;
        NSDictionary *fileDict = [fileManager attributesOfItemAtPath:path error:&error];
        if (!error && fileDict) {
            fileSize = [fileDict fileSize];
        }
    }
    return fileSize;
}

static NSString * getMD5String(NSString *str) {
    
    if (str == nil) return nil;
    
    const char *cstring = str.UTF8String;
    unsigned char bytes[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cstring, (CC_LONG)strlen(cstring), bytes);
    
    NSMutableString *md5String = [NSMutableString string];
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [md5String appendFormat:@"%02x", bytes[i]];
    }
    return md5String;
}


typedef void (^sucessBlock)(NSURLRequest * _Nullable, NSHTTPURLResponse * _Nullable, NSURL * _Nonnull);
typedef void (^failureBlock)(NSURLRequest * _Nullable, NSHTTPURLResponse * _Nullable,  NSError * _Nonnull);
typedef void (^progressBlock)(NSProgress * _Nonnull,HJDownloadReceipt *);


@interface HJDownloadReceipt()

@property (nonatomic, copy) NSString *url;
@property (nonatomic, copy) NSString *filePath;
@property (nonatomic, copy) NSString *filename;
@property (nonatomic, assign) HJDownloadState state;

@property (assign, nonatomic) long long totalBytesWritten;
@property (assign, nonatomic) long long totalBytesExpectedToWrite;
@property (nonatomic, copy) NSProgress *progress;

@property (strong, nonatomic) NSOutputStream *stream;

@property (nonatomic,copy)sucessBlock successBlock;
@property (nonatomic,copy)failureBlock failureBlock;
@property (nonatomic,copy)progressBlock progressBlock;
@end
@implementation HJDownloadReceipt

- (NSOutputStream *)stream
{
    if (_stream == nil) {
        _stream = [NSOutputStream outputStreamToFileAtPath:self.filePath append:YES];
    }
    return _stream;
}

- (NSString *)filePath {
    
    NSString *path = [cacheFolder() stringByAppendingPathComponent:self.filename];
    if (![path isEqualToString:_filePath] ) {
        if (_filePath && ![[NSFileManager defaultManager] fileExistsAtPath:_filePath]) {
            NSString *dir = [_filePath stringByDeletingLastPathComponent];
            [[NSFileManager defaultManager] createDirectoryAtPath:dir withIntermediateDirectories:YES attributes:nil error:nil];
        }
        _filePath = path;
    }
    
    return _filePath;
}


- (NSString *)filename {
    if (_filename == nil) {
        NSString *pathExtension = self.url.pathExtension;
        if (pathExtension.length) {
            _filename = [NSString stringWithFormat:@"%@.%@", getMD5String(self.url), pathExtension];
        } else {
            _filename = getMD5String(self.url);
        }
    }
    return _filename;
}

- (NSProgress *)progress {
    if (_progress == nil) {
        _progress = [[NSProgress alloc] initWithParent:nil userInfo:nil];
    }
    _progress.totalUnitCount = self.totalBytesExpectedToWrite;
    _progress.completedUnitCount = self.totalBytesWritten;
    return _progress;
}

- (long long)totalBytesWritten {
    
    return fileSizeForPath(self.filePath);
}


- (instancetype)initWithURL:(NSString *)url {
    if (self = [self init]) {
        
        self.url = url;
        self.totalBytesExpectedToWrite = 1;
    }
    return self;
}

#pragma mark - NSCoding
- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.url forKey:NSStringFromSelector(@selector(url))];
    [aCoder encodeObject:self.filePath forKey:NSStringFromSelector(@selector(filePath))];
    [aCoder encodeObject:@(self.state) forKey:NSStringFromSelector(@selector(state))];
    [aCoder encodeObject:self.filename forKey:NSStringFromSelector(@selector(filename))];
    [aCoder encodeObject:@(self.totalBytesWritten) forKey:NSStringFromSelector(@selector(totalBytesWritten))];
    [aCoder encodeObject:@(self.totalBytesExpectedToWrite) forKey:NSStringFromSelector(@selector(totalBytesExpectedToWrite))];
    
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        self.url = [aDecoder decodeObjectForKey:NSStringFromSelector(@selector(url))];
        self.filePath = [aDecoder decodeObjectForKey:NSStringFromSelector(@selector(filePath))];
        self.state = [[aDecoder decodeObjectOfClass:[NSNumber class] forKey:NSStringFromSelector(@selector(state))] unsignedIntegerValue];
        self.filename = [aDecoder decodeObjectForKey:NSStringFromSelector(@selector(filename))];
        self.totalBytesWritten = [[aDecoder decodeObjectOfClass:[NSNumber class] forKey:NSStringFromSelector(@selector(totalBytesWritten))] unsignedIntegerValue];
        self.totalBytesExpectedToWrite = [[aDecoder decodeObjectOfClass:[NSNumber class] forKey:NSStringFromSelector(@selector(totalBytesExpectedToWrite))] unsignedIntegerValue];
        
    }
    return self;
}


@end

@interface HJDownloadManager () <NSURLSessionDataDelegate>

@property (nonatomic, strong) dispatch_queue_t synchronizationQueue;
@property (strong, nonatomic) NSURLSession *session;

@property (nonatomic, assign) NSInteger maximumActiveDownloads;
@property (nonatomic, assign) NSInteger activeRequestCount;

@property (nonatomic, strong) NSMutableArray *queuedTasks;
@property (nonatomic, strong) NSMutableDictionary *tasks;

@property (nonatomic, strong) NSMutableArray *allDownloadReceipts;

@end

@implementation HJDownloadManager 

+ (NSURLSessionConfiguration *)defaultURLSessionConfiguration {
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    configuration.HTTPShouldSetCookies = YES;
    configuration.HTTPShouldUsePipelining = NO;
    configuration.requestCachePolicy = NSURLRequestUseProtocolCachePolicy;
    configuration.allowsCellularAccess = YES;
    configuration.timeoutIntervalForRequest = 60.0;
    
    return configuration;
}


- (instancetype)init {
    
    
    NSURLSessionConfiguration *defaultConfiguration = [self.class defaultURLSessionConfiguration];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    queue.maxConcurrentOperationCount = 1;
    NSURLSession *session = [NSURLSession sessionWithConfiguration:defaultConfiguration delegate:self delegateQueue:queue];
    
    return [self initWithSession:session
          downloadPrioritization:HJDownloadPrioritizationFIFO
          maximumActiveDownloads:4 ];
}


- (instancetype)initWithSession:(NSURLSession *)session downloadPrioritization:(HJDownloadPrioritization)downloadPrioritization maximumActiveDownloads:(NSInteger)maximumActiveDownloads {
    if (self = [super init]) {
        
        self.session = session;
        self.downloadPrioritizaton = downloadPrioritization;
        self.maximumActiveDownloads = maximumActiveDownloads;
        
        self.queuedTasks = [[NSMutableArray alloc] init];
        self.tasks = [[NSMutableDictionary alloc] init];
        self.activeRequestCount = 0;
        
        
        NSString *name = [NSString stringWithFormat:@"com.hj.downloadManager.synchronizationqueue-%@", [[NSUUID UUID] UUIDString]];
        self.synchronizationQueue = dispatch_queue_create([name cStringUsingEncoding:NSASCIIStringEncoding], DISPATCH_QUEUE_SERIAL);
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillTerminate:) name:UIApplicationWillTerminateNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidReceiveMemoryWarning:) name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
        
    }
    
    return self;
}

+ (instancetype)defaultInstance {
    static HJDownloadManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}


- (NSMutableArray *)allDownloadReceipts {
    if (_allDownloadReceipts == nil) {
        NSArray *receipts = [NSKeyedUnarchiver unarchiveObjectWithFile:LocalReceiptsPath()];
        _allDownloadReceipts = receipts != nil ? receipts.mutableCopy : [NSMutableArray array];
    }
    return _allDownloadReceipts;
}

- (void)saveReceipts:(NSArray <HJDownloadReceipt *>*)receipts {
    [NSKeyedArchiver archiveRootObject:receipts toFile:LocalReceiptsPath()];
}

- (HJDownloadReceipt *)updateReceiptWithURL:(NSString *)url state:(HJDownloadState)state {
    HJDownloadReceipt *receipt = [self downloadReceiptForURL:url];
    receipt.state = state;
    @synchronized (self) {
        [self saveReceipts:self.allDownloadReceipts];
    }
    
    return receipt;
}


- (HJDownloadReceipt *)downloadFileWithURL:(NSString *)url
                                  progress:(void (^)(NSProgress * _Nonnull,HJDownloadReceipt *receipt))downloadProgressBlock
                               destination:(NSURL *  (^)(NSURL * _Nonnull, NSURLResponse * _Nonnull))destination
                                   success:(nullable void (^)(NSURLRequest * _Nullable, NSHTTPURLResponse * _Nullable, NSURL * _Nonnull))success
                                   failure:(nullable void (^)(NSURLRequest * _Nullable, NSHTTPURLResponse * _Nullable, NSError * _Nonnull))failure {
    
    __block HJDownloadReceipt *receipt = [self downloadReceiptForURL:url];
    
    dispatch_sync(self.synchronizationQueue, ^{
        NSString *URLIdentifier = url;
        if (URLIdentifier == nil) {
            if (failure) {
                NSError *error = [NSError errorWithDomain:NSURLErrorDomain code:NSURLErrorBadURL userInfo:nil];
                dispatch_async(dispatch_get_main_queue(), ^{
                    failure(nil, nil, error);
                });
            }
            return;
        }
        
        receipt.successBlock = success;
        receipt.failureBlock = failure;
        receipt.progressBlock = downloadProgressBlock;
        
        if (receipt.state == HJDownloadStateCompleted) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (receipt.successBlock) {
                    receipt.successBlock(nil,nil,[NSURL URLWithString:receipt.url]);
                }
            });
            return ;
        }
        
        if (receipt.state == HJDownloadStateDownloading) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (receipt.progressBlock) {
                    receipt.progressBlock(receipt.progress,receipt);
                }
            });
            return ;
        }
        
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:receipt.url]];
        NSString *range = [NSString stringWithFormat:@"bytes=%zd-", receipt.totalBytesWritten];
        [request setValue:range forHTTPHeaderField:@"Range"];
        
        NSURLSessionDataTask *task = [self.session dataTaskWithRequest:request];
        task.taskDescription = receipt.url;
        self.tasks[receipt.url] = task;
        [self.queuedTasks addObject:task];
        
        [self resumeWithURL:receipt.url];
        
        
    });
    return receipt;
}

- (NSURLSessionDownloadTask*)safelyRemoveTaskWithURLIdentifier:(NSString *)URLIdentifier {
    __block NSURLSessionDownloadTask *task = nil;
    dispatch_sync(self.synchronizationQueue, ^{
        task = [self removeTaskWithURLIdentifier:URLIdentifier];
    });
    return task;
}

//This method should only be called from safely within the synchronizationQueue
- (NSURLSessionDownloadTask *)removeTaskWithURLIdentifier:(NSString *)URLIdentifier {
    NSURLSessionDownloadTask *task = self.tasks[URLIdentifier];
    [self.tasks removeObjectForKey:URLIdentifier];
    return task;
}

- (void)safelyDecrementActiveTaskCount {
    dispatch_sync(self.synchronizationQueue, ^{
        if (self.activeRequestCount > 0) {
            self.activeRequestCount -= 1;
        }
    });
}

- (void)safelyStartNextTaskIfNecessary {
    dispatch_sync(self.synchronizationQueue, ^{
        if ([self isActiveRequestCountBelowMaximumLimit]) {
            while (self.queuedTasks.count > 0) {
                NSURLSessionDownloadTask *task = [self dequeueTask];
                HJDownloadReceipt *receipt = [self downloadReceiptForURL:task.taskDescription];
                if (task.state == NSURLSessionTaskStateSuspended && receipt.state == HJDownloadStateWillResume) {
                    [self startTask:task];
                    break;
                }
            }
        }
    });
}


- (void)startTask:(NSURLSessionDownloadTask *)task {
    [task resume];
    ++self.activeRequestCount;
    [self updateReceiptWithURL:task.taskDescription state:HJDownloadStateDownloading];
}

- (void)enqueueTask:(NSURLSessionDownloadTask *)task {
    switch (self.downloadPrioritizaton) {
        case HJDownloadPrioritizationFIFO:  //
            [self.queuedTasks addObject:task];
            break;
        case HJDownloadPrioritizationLIFO:  //
            [self.queuedTasks insertObject:task atIndex:0];
            break;
    }
}

- (NSURLSessionDownloadTask *)dequeueTask {
    NSURLSessionDownloadTask *task = nil;
    task = [self.queuedTasks firstObject];
    [self.queuedTasks removeObject:task];
    return task;
}

- (BOOL)isActiveRequestCountBelowMaximumLimit {
    return self.activeRequestCount < self.maximumActiveDownloads;
}


#pragma mark -
- (HJDownloadReceipt *)downloadReceiptForURL:(NSString *)url {
    
    if (url == nil) return nil;
    for (HJDownloadReceipt *receipt in self.allDownloadReceipts) {
        if ([receipt.url isEqualToString:url]) {
            return receipt;
        }
    }
    HJDownloadReceipt *receipt = [[HJDownloadReceipt alloc] initWithURL:url];
    receipt.state = HJDownloadStateNone;
    receipt.totalBytesExpectedToWrite = 1;
    @synchronized (self) {
        [self.allDownloadReceipts addObject:receipt];
        [self saveReceipts:self.allDownloadReceipts];
    }
    
    return receipt;
}

#pragma mark -  NSNotification
- (void)applicationWillTerminate:(NSNotification *)not {
    
    [self suspendAll];
}

- (void)applicationDidReceiveMemoryWarning:(NSNotification *)not {
    
    [self suspendAll];
}

#pragma mark - HJDownloadControlDelegate

- (void)resumeWithURL:(NSString *)url {
    
    if (url == nil) return;
    
    HJDownloadReceipt *receipt = [self downloadReceiptForURL:url];
    [self resumeWithDownloadReceipt:receipt];
    
}
- (void)resumeWithDownloadReceipt:(HJDownloadReceipt *)receipt {
    
    if ([self isActiveRequestCountBelowMaximumLimit]) {
        [self startTask:self.tasks[receipt.url]];
    }else {
        receipt.state = HJDownloadStateWillResume;
        [self saveReceipts:self.allDownloadReceipts];
        [self enqueueTask:self.tasks[receipt.url]];
    }
}

- (void)suspendAll {
    
    for (NSURLSessionDownloadTask *task in self.queuedTasks) {
        [task suspend];
        HJDownloadReceipt *receipt = [self downloadReceiptForURL:task.taskDescription];
        receipt.state = HJDownloadStateSuspened;
    }
    @synchronized (self) {
        [self saveReceipts:self.allDownloadReceipts];
    }
    
    
}
-(void)suspendWithURL:(NSString *)url {
    
    if (url == nil) return;
    
    HJDownloadReceipt *receipt = [self downloadReceiptForURL:url];
    [self suspendWithDownloadReceipt:receipt];
    
}
- (void)suspendWithDownloadReceipt:(HJDownloadReceipt *)receipt {
    
    [self updateReceiptWithURL:receipt.url state:HJDownloadStateSuspened];
    NSURLSessionDataTask *task = self.tasks[receipt.url];
    if (task) {
        [task suspend];
    }
}


- (void)removeWithURL:(NSString *)url {
    
    if (url == nil) return;
    
    HJDownloadReceipt *receipt = [self downloadReceiptForURL:url];
    [self removeWithDownloadReceipt:receipt];
    
}
- (void)removeWithDownloadReceipt:(HJDownloadReceipt *)receipt {
    
    NSURLSessionDataTask *task = self.tasks[receipt.url];
    if (task) {
        [task cancel];
    }
    
    [self.queuedTasks removeObject:task];
    [self safelyRemoveTaskWithURLIdentifier:receipt.url];
    
    @synchronized (self) {
        [self.allDownloadReceipts removeObject:receipt];
        [self saveReceipts:self.allDownloadReceipts];
    }
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    [fileManager removeItemAtPath:receipt.filePath error:nil];
    
}
#pragma mark - <NSURLSessionDataDelegate>
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSHTTPURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler
{
    HJDownloadReceipt *receipt = [self downloadReceiptForURL:dataTask.taskDescription];
    receipt.totalBytesExpectedToWrite = dataTask.countOfBytesExpectedToReceive;
    receipt.state = HJDownloadStateDownloading;
    @synchronized (self) {
        [self saveReceipts:self.allDownloadReceipts];
    }
    
    [receipt.stream open];
    
    completionHandler(NSURLSessionResponseAllow);
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data
{
    HJDownloadReceipt *receipt = [self downloadReceiptForURL:dataTask.taskDescription];
    
    [receipt.stream write:data.bytes maxLength:data.length];
    
    receipt.progress.totalUnitCount = receipt.totalBytesExpectedToWrite;
    receipt.progress.completedUnitCount = receipt.totalBytesWritten;
    dispatch_async(dispatch_get_main_queue(), ^{
        if (receipt.progressBlock) {
            receipt.progressBlock(receipt.progress,receipt);
        }
    });
    
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error
{
    HJDownloadReceipt *receipt = [self downloadReceiptForURL:task.taskDescription];
    [receipt.stream close];
    receipt.stream = nil;
    
    if (error) {
        receipt.state = HJDownloadStateFailed;
        dispatch_async(dispatch_get_main_queue(), ^{
            if (receipt.failureBlock) {
                receipt.failureBlock(task.originalRequest,(NSHTTPURLResponse *)task.response,error);
            }
        });
    }else {
        receipt.state = HJDownloadStateCompleted;
        dispatch_async(dispatch_get_main_queue(), ^{
            if (receipt.successBlock) {
                receipt.successBlock(task.originalRequest,(NSHTTPURLResponse *)task.response,task.originalRequest.URL);
            }
        });
    }
    @synchronized (self) {
        [self saveReceipts:self.allDownloadReceipts];
    }
    [self safelyDecrementActiveTaskCount];
    [self safelyStartNextTaskIfNecessary];
    
}

@end
