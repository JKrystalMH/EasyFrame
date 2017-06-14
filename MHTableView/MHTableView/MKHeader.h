//
//  MKHeader.h
//  MHTableView
//
//  Created by MH on 2017/5/15.
//  Copyright © 2017年 MH. All rights reserved.
//

#ifndef MKHeader_h
#define MKHeader_h


/*
 ********UI**********
 */
//图片
#define Img(a) [UIImage imageNamed:a]
//尺寸
#define SCREEN_WIDTH [[UIScreen mainScreen] bounds].size.width
#define SCREEN_HEIGHT [[UIScreen mainScreen] bounds].size.height

#define IS_IPHONE4 SCREEN_HEIGHT==480
#define IS_IPHONE5 SCREEN_HEIGHT==568
#define IS_IPHONE6 SCREEN_HEIGHT==667
#define IS_IPHONE6PS SCREEN_HEIGHT==736

#define SCREEN_SCALE_RATE SCREEN_WIDTH/320
#define SCREEN_W_RATE SCREEN_WIDTH/320
#define SCREEN_H_RATE ((IS_IPHONE4)?(1.0):(SCREEN_HEIGHT/568))
#define SCREEN_HALFSCALE_RATE (1.0 + ((int)((int)(SCREEN_SCALE_RATE*100)%100)/200.0))

#define UIColor_Hex(string) [UIColor colorWithHexString:string]
#define RGBColor(R,G,B) [UIColor colorWithRed:R/255.0f green:G/255.0f blue:B/255.0f alpha:1]
#define RGBAColor(R,G,B,A) [UIColor colorWithRed:R/255.0f green:G/255.0f blue:B/255.0f alpha:A]
#define BCWhiteColor(W,A) [UIColor colorWithWhite:W/255.0f alpha:A]

//字体
#define Font(f) [UIFont systemFontOfSize:f]
#define BoldFont(f) [UIFont boldSystemFontOfSize:f]


/*
 ********其他**********
 */
#define WS(weakSelf)  __weak __typeof(&*self)weakSelf = self;
#define IOSVersion                          [[[UIDevice currentDevice] systemVersion] floatValue]
#define ApplicationDelegate                 ((AppDelegate *)[[UIApplication sharedApplication] delegate])

//日志输出
#ifdef DEBUG
#define NSLog(format, ...) printf("[%s] %s [第%d行] %s\n", __TIME__, __FUNCTION__, __LINE__, [[NSString stringWithFormat:format, ## __VA_ARGS__] UTF8String]);
#else
#define NSLog(format, ...)
#endif



#endif /* MKHeader_h */
