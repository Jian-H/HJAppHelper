//
//  AppDelegate.m
//  HJAppHelper
//
//  Created by huangjian on 15/10/21.
//  Copyright © 2015年 huangjian. All rights reserved.
//

#import "AppDelegate.h"
#import "HJAppHelpers.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    NSString * md5HJ = [HJAppHelpers md5HexDigest:@"黄健"];
    NSLog(@"md5HJ : %@",md5HJ);
    
    NSData * data = [@"黄健" dataUsingEncoding:NSUTF8StringEncoding];
    
    //加密
    NSData * encryptData = [HJAppHelpers AES256EncryptWithKey:@"hj" value:data];
    NSString * enStr = [[NSString alloc] initWithData:encryptData encoding:NSUTF8StringEncoding];
     NSLog(@"enStr : %@",enStr);
    //解密
    NSData * decData = [HJAppHelpers AES256DecryptWithKey:@"hj" value:encryptData];
    NSString * decStr = [[NSString alloc] initWithData:decData encoding:NSUTF8StringEncoding];
    NSLog(@"decStr : %@",decStr);
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
