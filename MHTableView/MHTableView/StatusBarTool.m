//
//  StatusBarTool.m
//  WIFI检测
//
//  Created by MH on 2017/5/3.
//  Copyright © 2017年 伟航创达. All rights reserved.
//

#import "StatusBarTool.h"
#import <SystemConfiguration/CaptiveNetwork.h>
#import <ifaddrs.h>
#import <arpa/inet.h>
@implementation StatusBarTool
+(NSString *)currentBatteryPercent{
    NSArray *infoArray = [[[[UIApplication sharedApplication] valueForKeyPath:@"statusBar"] valueForKeyPath:@"foregroundView"] subviews];
    
    for (id info in infoArray)
    {
        if ([info isKindOfClass:NSClassFromString(@"UIStatusBarBatteryPercentItemView")])
        {
            NSString *percentString = [info valueForKeyPath:@"percentString"];
            NSLog(@"电量为：%@",percentString);
            return percentString;
        }
    }
    return @"";
}
+(NetWorkType )currentNetworkType{
    
    NSArray *infoArray = [[[[UIApplication sharedApplication] valueForKeyPath:@"statusBar"] valueForKeyPath:@"foregroundView"] subviews];
    
    NetWorkType type;
    for (id info in infoArray)
    {
        if ([info isKindOfClass:NSClassFromString(@"UIStatusBarDataNetworkItemView")]) {
            type = [[info valueForKeyPath:@"dataNetworkType"] integerValue];
            NSLog(@"%lu", (unsigned long)type);
            
            return (NetWorkType)type;
        }
        
    }
    return NetWorkTypeNone;
}
+(NSString *)currentTimeString{
    NSArray *infoArray = [[[[UIApplication sharedApplication] valueForKeyPath:@"statusBar"] valueForKeyPath:@"foregroundView"] subviews];
    
    for (id info in infoArray)
    {
        if ([info isKindOfClass:NSClassFromString(@"UIStatusBarTimeItemView")])
        {
            NSString *timeString = [info valueForKeyPath:@"timeString"];
            NSLog(@"当前显示时间为：%@",timeString);
            return timeString;
        }
    }
    return @"";
}

+(NSString *)serviceCompany{
    NSArray *infoArray = [[[[UIApplication sharedApplication] valueForKeyPath:@"statusBar"] valueForKeyPath:@"foregroundView"] subviews];
    
    for (id info in infoArray)
    {
        if ([info isKindOfClass:NSClassFromString(@"UIStatusBarServiceItemView")])
        {
            NSString *serviceString = [info valueForKeyPath:@"serviceString"];
            NSLog(@"公司为：%@",serviceString);
            return serviceString;
        }
    }
    return @"";
}

//注意：Wi-Fi列表和列表中的Wi-Fi信号强度是获取不到的，只能得到自己当前iPhone链接的Wi-Fi的名字和对应的Wi-Fi信号强度。
+ (NSString*)getSignalStrength{
    UIApplication *app = [UIApplication sharedApplication];
    NSArray *subviews = [[[app valueForKey:@"statusBar"] valueForKey:@"foregroundView"] subviews];
    UIView *dataNetworkItemView = nil;
    
    for (UIView * subview in subviews) {
        if([subview isKindOfClass:[NSClassFromString(@"UIStatusBarDataNetworkItemView") class]]) {
            dataNetworkItemView = subview;
            break;
        }
    }
    
    int signalStrength = [[dataNetworkItemView valueForKey:@"_wifiStrengthBars"] intValue];
    NSString * signal = @"";
    if (signalStrength == 1) {
        signal = @"弱";
    }else if (signalStrength == 2){
        signal = @"中";
    }else if (signalStrength >= 3){
        signal = @"强";
    }else{
        signal = @"无";
    }
    NSLog(@"signal %d", signalStrength);
    return signal;
}

+ (NSString *)getIPAddress
{
    NSString *address = @"error";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    
    // retrieve the current interfaces - returns 0 on success
    success = getifaddrs(&interfaces);
    if (success == 0) {
        // Loop through linked list of interfaces
        temp_addr = interfaces;
        while (temp_addr != NULL) {
            if( temp_addr->ifa_addr->sa_family == AF_INET) {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if ([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                    // Get NSString from C String
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                }
            }
            
            temp_addr = temp_addr->ifa_next;
        }
    }
    
    // Free memory
    freeifaddrs(interfaces);
    
    return address;
}

+ (NSString *)getWifiName
{
    NSString *wifiName = nil;
    
    CFArrayRef wifiInterfaces = CNCopySupportedInterfaces();
    
    if (!wifiInterfaces) {
        return nil;
    }
    
    NSArray *interfaces = (__bridge NSArray *)wifiInterfaces;
    
    for (NSString *interfaceName in interfaces) {
        CFDictionaryRef dictRef = CNCopyCurrentNetworkInfo((__bridge CFStringRef)(interfaceName));
        
        if (dictRef) {
            NSDictionary *networkInfo = (__bridge NSDictionary *)dictRef;
            NSLog(@"network info -> %@", networkInfo);
            wifiName = [networkInfo objectForKey:(__bridge NSString *)kCNNetworkInfoKeySSID];
            
            CFRelease(dictRef);
        }
    }
    
    CFRelease(wifiInterfaces);
    return wifiName;
}


+ (NSString *)formattedBandWidth:(unsigned long long)size
{
    NSString *formattedStr = nil;
    if (size == 0){
        formattedStr = NSLocalizedString(@"0 KB",@"");
        
    }else if (size > 0 && size < 1024){
        formattedStr = [NSString stringWithFormat:@"%qubytes", size];
        
    }else if (size >= 1024 && size < pow(1024, 2)){
        formattedStr = [NSString stringWithFormat:@"%quKB", (size / 1024)];
        
    }else if (size >= pow(1024, 2) && size < pow(1024, 3)){
        int intsize = size / pow(1024, 2);
        formattedStr = [NSString stringWithFormat:@"%dMB", intsize];
        
    }else if (size >= pow(1024, 3)){
        int intsize = size / pow(1024, 3);
        formattedStr = [NSString stringWithFormat:@"%dGB", intsize];
    }
    
    return formattedStr;
}
+ (int)formatBandWidthInt:(unsigned long long) size{
    
    size *= 8;
    int intsize = 0;
    if (size >= pow(1024, 2) && size < pow(1024, 3)){
        intsize = size / pow(1024, 2);
        unsigned long long l = pow(1024, 2);
        int  model = (int)(size % l);
        if (model > l/2) {
            intsize +=1;
        }
    }
    return intsize;
}

+ (NSString *)formatBandWidth:(unsigned long long)size
{
    size *=8;
    
    NSString *formattedStr = nil;
    if (size == 0){
        formattedStr = NSLocalizedString(@"0",@"");
        
    }else if (size > 0 && size < 1024){
        formattedStr = [NSString stringWithFormat:@"%qu", size];
        
    }else if (size >= 1024 && size < pow(1024, 2)){
        int intsize = (int)(size / 1024);
        int model = size % 1024;
        if (model > 512) {
            intsize += 1;
        }
        
        formattedStr = [NSString stringWithFormat:@"%dK",intsize ];
        
    }else if (size >= pow(1024, 2) && size < pow(1024, 3)){
        unsigned long long l = pow(1024, 2);
        int intsize = size / pow(1024, 2);
        int  model = (int)(size % l);
        if (model > l/2) {
            intsize +=1;
        }
        formattedStr = [NSString stringWithFormat:@"%dM", intsize];
        
    }else if (size >= pow(1024, 3)){
        int intsize = size / pow(1024, 3);
        formattedStr = [NSString stringWithFormat:@"%dG", intsize];
    }
    
    return formattedStr;
}

+ (NSString *)formattedFileSize:(unsigned long long)size
{
    return [self formattedFileSize:size suffixLenth:NULL];
}

+ (NSString *)formattedFileSize:(unsigned long long)size suffixLenth:(NSInteger *)length
{
    NSInteger len = 0;
    NSString *formattedStr = nil;
    if (size == 0)
        formattedStr = NSLocalizedString(@"0 KB",@""), len = 2;
    else
        if (size > 0 && size < 1024)
            formattedStr = [NSString stringWithFormat:@"%qubytes", size], *length = 2, len = 7;
        else
            if (size >= 1024 && size < pow(1024, 2))
                formattedStr = [NSString stringWithFormat:@"%.2fKB", (size / 1024.)], len = 2;
            else
                if (size >= pow(1024, 2) && size < pow(1024, 3))
                    formattedStr = [NSString stringWithFormat:@"%.2fMB", (size / pow(1024, 2))], len = 2;
                else
                    if (size >= pow(1024, 3))
                        formattedStr = [NSString stringWithFormat:@"%.2fGB", (size / pow(1024, 3))], len = 2;
    if (length) {
        *length = len;
    }
    return formattedStr;
}

+ (unsigned long long) antiFormatBandWith:(NSString *)sizeStr
{
    unsigned long long fileSize = 0;
    if(![sizeStr isEqualToString:NSLocalizedString(@"0 KB",@"")]){
        if([sizeStr hasSuffix:@"bytes"])
            fileSize = [[[sizeStr componentsSeparatedByString:@"bytes"] objectAtIndex:0] longLongValue];
        else if([sizeStr hasSuffix:@"KB"])
            fileSize = [[[sizeStr componentsSeparatedByString:@"KB"] objectAtIndex:0] floatValue] * 1024;
        else if([sizeStr hasSuffix:@"MB"])
            fileSize = [[[sizeStr componentsSeparatedByString:@"MB"] objectAtIndex:0] floatValue] * pow(1024, 2);
        else if([sizeStr hasSuffix:@"GB"])
            fileSize = [[[sizeStr componentsSeparatedByString:@"GB"] objectAtIndex:0] floatValue] * pow(1024, 3);
    }
    
    return fileSize;
}


@end
