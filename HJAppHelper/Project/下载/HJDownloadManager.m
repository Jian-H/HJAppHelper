//
//  HJDownloadManager.m
//  HJAppHelper
//
//  Created by huangjian on 15/12/5.
//  Copyright © 2015年 huangjian. All rights reserved.
//

#import "HJDownloadManager.h"
#import "HJEncryptHelpers.h"

static HJDownloadManager * manager = nil;

@implementation HJDownloadManager

+ (instancetype)sharedInstance {

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        if (manager == nil) {
            manager = [[HJDownloadManager alloc] init];
        }
    });
    return manager;
}

- (void)hj_downloadImageWithUrl:(NSString *)url progressBlock:(void (^)(NSUInteger, long long, long long))progressBlock successBlock:(void (^)(UIImage *))successBlock failureBlock:(void (^)(NSError *))failureBlock {
    
    NSArray * array = [url componentsSeparatedByString:@"/"];
    NSString * imageName = [array lastObject];
    
    imageName = [NSString stringWithFormat:@"%@_%@",[HJEncryptHelpers md5HexDigest:url],imageName];
    
    NSFileManager * fm = [NSFileManager defaultManager];
    
    NSString * savePath = [NSHomeDirectory() stringByAppendingString:[NSString stringWithFormat:@"/Documents/download"]];
    [fm createDirectoryAtPath:savePath withIntermediateDirectories:YES attributes:nil error:nil];
    savePath = [savePath stringByAppendingPathComponent:imageName];
    
    if ([fm fileExistsAtPath:savePath]) {
        
        UIImage * image = [[UIImage alloc] initWithContentsOfFile:savePath];
        successBlock(image);
        return;
    }
    
    NSString * cachePath = [NSHomeDirectory() stringByAppendingString:@"/tmpImage"];
    [fm createDirectoryAtPath:cachePath
  withIntermediateDirectories:YES
                   attributes:nil
                        error:nil];
    
    
    
    cachePath = [cachePath stringByAppendingPathComponent:imageName];
    
    NSURLRequest * request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    
    unsigned long long downloadedBytes = 0;
    
    if ([fm fileExistsAtPath:cachePath]) {
        
        NSError * error = nil;
        NSDictionary * fileDict = [fm attributesOfItemAtPath:cachePath
                                                       error:&error];
        if (!error && fileDict) {
            
            downloadedBytes = [fileDict fileSize];
            
            if (downloadedBytes) {
                
                NSMutableURLRequest * mutableURLRequest = (NSMutableURLRequest *)[request mutableCopy];
                NSString * requestRange =  [NSString stringWithFormat:@"bytes=%llu-", downloadedBytes];
                [mutableURLRequest setValue:requestRange forHTTPHeaderField:@"Range"];
                
                request = mutableURLRequest;
            }
            
        } else {
            [fm removeItemAtPath:cachePath
                           error:nil];
        }
        
    }
    
    [[NSURLCache sharedURLCache] removeCachedResponseForRequest:request];
    
    if (!mOperation) {
        mOperation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    }
    
    mOperation.outputStream = [NSOutputStream outputStreamToFileAtPath:cachePath append:YES];
    
    [mOperation setDownloadProgressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
        
        //NSLog(@"bytesRead : %ld\ntotalBytesRead : %lld\ntotalBytesExpectedToRead : %lld\n==========\n",bytesRead,totalBytesRead,totalBytesExpectedToRead);
        
        progressBlock(bytesRead,totalBytesRead,totalBytesExpectedToRead);
    }];
    
    [mOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        NSError * error = nil;
        
        [[NSFileManager defaultManager] moveItemAtPath:cachePath toPath:savePath error:&error];
        if (error) {
            NSLog(@"moveError : %@",error.localizedDescription);
        }
        [operation.responseData writeToFile:savePath atomically:YES];
        
        UIImage * image = [[UIImage alloc] initWithContentsOfFile:savePath];
        successBlock(image);
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
       
        NSLog(@"error : %@",error.localizedDescription);
        failureBlock(error);
        
    }];
    
    [mOperation start];
}

- (void)cancel {
    if (mOperation) {
        [mOperation cancel];
    }
}

@end
