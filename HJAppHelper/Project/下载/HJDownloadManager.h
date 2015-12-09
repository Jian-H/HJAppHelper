//
//  HJDownloadManager.h
//  HJAppHelper
//
//  Created by huangjian on 15/12/5.
//  Copyright © 2015年 huangjian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

@interface HJDownloadManager : NSObject {
    AFHTTPRequestOperation * mOperation;
}

+ (instancetype)sharedInstance;

- (void)hj_downloadImageWithUrl:(NSString *)url
                  progressBlock:(void(^)(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead))progressBlock
                   successBlock:(void(^)(UIImage * image))successBlock
                   failureBlock:(void(^)(NSError *error))failureBlock;


- (void)cancel;

@end
