//
//  StatusBarTool.h
//  WIFI检测
//
//  Created by MH on 2017/5/3.
//  Copyright © 2017年 伟航创达. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
//0 - 无网络 ; 1 - 2G ; 2 - 3G ; 3 - 4G ; 5 - WIFI

typedef NS_ENUM(NSUInteger, NetWorkType) {
    NetWorkTypeNone=0,
    NetWorkType2G=1,
    NetWorkType3G=2,
    NetWorkType4G=3,
    NetWorkTypeWiFI=5,
};

@interface StatusBarTool : NSObject
/**
 *
 *
 *  @return 当前网络类型
 */
+(NetWorkType )currentNetworkType;


/**
 *
 *
 *  @return SIM卡所属的运营商（公司）
 */
+(NSString *)serviceCompany;

/**
 *
 *
 *  @return 当前电池电量百分比
 */
+(NSString *)currentBatteryPercent;

/**
 *
 *
 *  @return 当前时间显示的字符串
 */
+(NSString *)currentTimeString;

/**
 *
 *
 *  @return 当前WIFI信号强度
 */
+ (NSString *)getSignalStrength;

/**
 *
 *
 *  @return 当前IP地址
 */
+ (NSString *)getIPAddress;

/**
 *
 *
 *  @return 当前WIFI名称
 */
+ (NSString *)getWifiName;



+ (unsigned long long) antiFormatBandWith:(NSString *)sizeStr;
+ (NSString *)formattedFileSize:(unsigned long long)size;
//suffixLenth 单位字符串长度
+ (NSString *)formattedFileSize:(unsigned long long)size suffixLenth:(NSInteger *)length;
+ (NSString *)formattedBandWidth:(unsigned long long)size;
+ (NSString *)formatBandWidth:(unsigned long long)size;
+ (int)formatBandWidthInt:(unsigned long long) size;
@end
