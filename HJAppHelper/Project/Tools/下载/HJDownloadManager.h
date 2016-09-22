//
//  HJDownloadManager.h
//  HJDownloadManager
//
//  Created by xingzhijishu on 16/9/14.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#if __has_include(<AFNetworking/AFNetworking.h>)
#import <AFNetworking/AFNetworking.h>

#else
#import "AFNetworking.h"
#endif

NS_ASSUME_NONNULL_BEGIN

FOUNDATION_EXPORT NSString * const HJDownloadCacheFolderName;

/** The download state */
typedef NS_ENUM(NSUInteger, HJDownloadState) {
    HJDownloadStateNone,           /** default */
    HJDownloadStateWillResume,     /** waiting */
    HJDownloadStateDownloading,    /** downloading */
    HJDownloadStateSuspened,       /** suspened */
    HJDownloadStateCompleted,      /** download completed */
    HJDownloadStateFailed          /** download failed */
};

/** The download prioritization */
typedef NS_ENUM(NSInteger, HJDownloadPrioritization) {
    HJDownloadPrioritizationFIFO,  /** first in first out */
    HJDownloadPrioritizationLIFO   /** last in first out */
};

/**
 *  The receipt of a downloader,we can get all the informationg by the receipt.
 */
@interface HJDownloadReceipt : NSObject <NSCoding>

/**
 * Download State
 */
@property (nonatomic, assign, readonly) HJDownloadState state;

@property (nonatomic, copy, readonly, nonnull) NSString *url;
@property (nonatomic, copy, readonly, nonnull) NSString *filePath;
@property (nonatomic, copy, readonly, nullable) NSString *filename;

@property (assign, nonatomic, readonly) long long totalBytesWritten;
@property (assign, nonatomic, readonly) long long totalBytesExpectedToWrite;

@property (nonatomic, copy, readonly, nonnull) NSProgress *progress;

@property (nonatomic, strong, readonly, nullable) NSError *error;
@end


@protocol HJDownloadControlDelegate <NSObject>

- (void)resumeWithURL:(NSString * _Nonnull)url;
- (void)resumeWithDownloadReceipt:(HJDownloadReceipt * _Nonnull)receipt;

- (void)suspendWithURL:(NSString * _Nonnull)url;
- (void)suspendWithDownloadReceipt:(HJDownloadReceipt * _Nonnull)receipt;

- (void)removeWithURL:(NSString * _Nonnull)url;
- (void)removeWithDownloadReceipt:(HJDownloadReceipt * _Nonnull)receipt;

@end


@interface HJDownloadManager : NSObject <HJDownloadControlDelegate>

/**
 Defines the order prioritization of incoming download requests being inserted into the queue. `HJDownloadPrioritizationFIFO` by default.
 */
@property (nonatomic, assign) HJDownloadPrioritization downloadPrioritizaton;

/**
 The shared default instance of `HJDownloadManager` initialized with default values.
 */
+ (instancetype)defaultInstance;

/**
 Default initializer
 
 @return An instance of `HJDownloadManager` initialized with default values.
 */
- (instancetype)init;

/**
 Initializes the `HJDownloadManager` instance with the given session manager, download prioritization, maximum active download count.
 
 @param sessionManager The session manager to use to download file.
 @param downloadPrioritization The download prioritization of the download queue.
 @param maximumActiveDownloads  The maximum number of active downloads allowed at any given time. Recommend `4`.
 
 @return The new `HJDownloadManager` instance.
 */
- (instancetype)initWithSession:(NSURLSession *)session
         downloadPrioritization:(HJDownloadPrioritization)downloadPrioritization
         maximumActiveDownloads:(NSInteger)maximumActiveDownloads;

///-----------------------------
/// @name Running Download Tasks
///-----------------------------

/**
 Creates an `HJDownloadReceipt` with the specified request.
 
 @param url The URL  for the request.
 @param downloadProgressBlock A block object to be executed when the download progress is updated. Note this block is called on the session queue, not the main queue.
 @param destination A block object to be executed in order to determine the destination of the downloaded file. This block takes two arguments, the target path & the server response, and returns the desired file URL of the resulting download. The temporary file used during the download will be automatically deleted after being moved to the returned URL.
 
 @warning If using a background `NSURLSessionConfiguration` on iOS, these blocks will be lost when the app is terminated. Background sessions may prefer to use `-setDownloadTaskDidFinishDownloadingBlock:` to specify the URL for saving the downloaded file, rather than the destination block of this method.
 */
- (HJDownloadReceipt *)downloadFileWithURL:(NSString * _Nullable)url
                                  progress:(nullable void (^)(NSProgress *downloadProgress, HJDownloadReceipt *receipt))downloadProgressBlock
                               destination:(nullable NSURL * (^)(NSURL *targetPath, NSURLResponse *response))destination
                                   success:(nullable void (^)(NSURLRequest *request, NSHTTPURLResponse  * _Nullable response, NSURL *filePath))success
                                   failure:(nullable void (^)(NSURLRequest *request, NSHTTPURLResponse * _Nullable response, NSError *error))failure;

- (HJDownloadReceipt * _Nullable)downloadReceiptForURL:(NSString *)url;

@end

NS_ASSUME_NONNULL_END
