//
//  MKRequst.h
//  MHTableView
//
//  Created by MH on 2017/5/8.
//  Copyright © 2017年 MH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJRefresh.h"
#import "MKNetWorkManager.h"

#ifndef mkIsNetwork
#define mkIsNetwork     [MKNetWorkManager isNetwork]  // 一次性判断是否有网的宏
#endif

#ifndef mkIsWWANNetwork
#define mkIsWWANNetwork [MKNetWorkManager isWWANNetwork]  // 一次性判断是否为手机网络的宏
#endif

#ifndef mkIsWiFiNetwork
#define mkIsWiFiNetwork [MKNetWorkManager isWiFiNetwork]  // 一次性判断是否为WiFi网络的宏
#endif

#if NS_BLOCKS_AVAILABLE
typedef void (^RequestCallBackBlock)(CallBackStatus callBackStatus,MKNetWorkManager * result,NSError *error);
#endif

typedef NS_ENUM(NSInteger, MKRequestMethod) {
    MKRequestMethodGet,                //GET
    MKRequestMethodPost,               //POST
    MKRequestMethodUploadFile,         //上传文件
    MKRequestMethodUploadImage         //上传图片
};


/** 请求成功的Block */
typedef void(^HttpRequestSuccess)(id responseObject);

/** 请求失败的Block */
typedef void(^HttpRequestFailed)(NSError *error);

/** 缓存的Block */
typedef void(^HttpRequestCache)(id responseCache);

/** 上传或者下载的进度, Progress.completedUnitCount:当前大小 - Progress.totalUnitCount:总大小*/
typedef void (^HttpProgress)(NSProgress *progress);

/** 上传文件的回调参数*/
typedef void(^MKConstrutingBodyHandler)(id<AFMultipartFormData> formData);
@class MKRequest;
@interface MKRequest : NSObject

/**
 *  域名
 */
@property(nonatomic, strong)NSString *baseURL;
/**
 *  请求路径
 */
@property(nonatomic, strong)NSString *urlPath;
/**
 *  请求方式
 */
@property (nonatomic, assign) MKRequestMethod requestMethod;
/**
 *  Http头参数设置
 */
@property(nonatomic, strong)NSDictionary *httpHeaderFields;
/**
 *  使用字典参数
 */
@property(nonatomic, strong)NSMutableDictionary *params;
/**
 *  默认是60S
 */
@property(nonatomic, assign)NSTimeInterval timeoutInterval;
/**
 *  上传文件字典
 */
@property(nonatomic, strong)NSMutableDictionary *requestFiles_Upload;
/**
 *  上传图组
 */
@property (nonatomic ,strong) NSMutableDictionary *requestImages;


@property (nonatomic, strong) NSSet *acceptableContentTypes;                    //允许响应的HTTP内容类型，默认为text/plain，application/json，text/html
@property (nonatomic, strong) NSString *certificatePath;                        //证书路径，会开启HTTPS连接
@property (nonatomic, strong) AFHTTPSessionManager *manager;                    //AFNetworkingManager
@property (nonatomic, copy) MKConstrutingBodyHandler construtingBodyHandler;    //上传文件的回调
@property (nonatomic, assign) BOOL networkActivityIndicatorEnabled;


@property(nonatomic, strong,readonly)AFHTTPRequestSerializer *request;
@property(nonatomic, assign)int tag;
@property(nonatomic, assign, getter = isCanceled)BOOL canceled;

/**
 *  通用的网络请求
 *
 *  @param callBack 网络请求回调
 */
- (void)startCallBack:(RequestCallBackBlock)callBack;

/**
 *  取消的网络请求
 *
 */
- (void)cancelRequest;

@end
