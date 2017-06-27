//
//  HJ_AddressBookViewController.h
//  HJAppHelper
//
//  Created by xingzhijishu on 2017/6/27.
//  Copyright © 2017年 huangjian. All rights reserved.
//

#import "HJ_BaseViewController.h"

@interface HJ_AddressBookViewController : HJ_BaseViewController

@property (weak, nonatomic) IBOutlet UITableView *mTableView;

@end

/*
 
 iOS10配置须知
 
 　　在iOS10中，如果你的App想要访问用户的相机、相册、麦克风、通讯录等等权限，都需要进行相关的配置，不然会直接crash。
 
 需要在info.plist中添加App需要的一些设备权限。
 
 　　NSBluetoothPeripheralUsageDescription
 
 　　访问蓝牙
 
 　　NSCalendarsUsageDescription
 
 　　访问日历
 
 　　NSCameraUsageDescription
 
 　　相机
 
 　　NSPhotoLibraryUsageDescription
 
 　　相册
 
 　　NSContactsUsageDescription
 
 　　通讯录
 
 　　NSLocationAlwaysUsageDescription
 
 　　始终访问位置
 
 　　NSLocationUsageDescription
 
 　　位置
 
 　　NSLocationWhenInUseUsageDescription
 
 　　在使用期间访问位置
 
 　　NSMicrophoneUsageDescription
 
 　　麦克风
 
 　　NSAppleMusicUsageDescription
 
 　　访问媒体资料库
 
 　　NSHealthShareUsageDescription
 
 　　访问健康分享
 
 　　NSHealthUpdateUsageDescription
 
 　　访问健康更新
 
 　　NSMotionUsageDescription
 
 　　访问运动与健身
 
 　　NSRemindersUsageDescription
 
 */
