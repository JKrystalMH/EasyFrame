//
//  MKRequst.m
//  MHTableView
//
//  Created by MH on 2017/5/8.
//  Copyright © 2017年 MH. All rights reserved.
//

#import "MKRequest.h"
#include <sys/sysctl.h>
#define WS(weakSelf)  __weak __typeof(&*self)weakSelf = self;
#define baseUrl     @"http://112.74.218.80/live/"
#import "StatusBarTool.h"

static AFHTTPSessionManager *_sessionManager;
@interface MKRequest ()
@property (nonatomic,strong) NSString * url;

@end

@implementation MKRequest
- (instancetype)init
{
    if (self = [super init]) {
        self.requestMethod = MKRequestMethodPost;
        self.networkActivityIndicatorEnabled = YES;
        self.timeoutInterval = 30.0f;
    }
    return self;
}



- (void)startCallBack:(RequestCallBackBlock)callBack{
    NetWorkType type = [StatusBarTool currentNetworkType];
    if (type == 0) {
        NSLog(@"请检查您的网络");
        return;
    }else if (type == 5){
        NSLog(@"使用WIFI中");
        [self goCallBack:callBack];
    }else{
        NSLog(@"使用移动网络中");
        [self goCallBack:callBack];
    }
    
}

- (void)goCallBack:(RequestCallBackBlock)callBack{
    [self requestHeader];
    self.url = [NSString stringWithFormat:@"%@%@",baseUrl,self.urlPath];
    NSLog(@"%@", self.url);
    NSLog(@"params:%@",self.params);
    switch (self.requestMethod) {
        case MKRequestMethodGet:
            [MKRequest getWithRequest:self callBackBlock:callBack];
            break;
            
        case MKRequestMethodPost:
            [MKRequest postWithRequest:self callBackBlock:callBack];
            break;
            
        case MKRequestMethodUploadFile:
            [MKRequest uploadFileWithRequest:self callBackBlock:callBack];
            break;
            
        case MKRequestMethodUploadImage:
            [MKRequest uploadImagesWithRequest:self callBackBlock:callBack];
            break;
            
        default:
            break;
    }
}

- (void)cancelRequest
{
    [self.manager.tasks makeObjectsPerformSelector:@selector(cancel)];
}

+ (void)getWithRequest:(MKRequest *)request callBackBlock:(RequestCallBackBlock)callback
{
    handleCertificate(request);
    handleIndicators(request, true);
   

    [request.manager GET:request.url parameters:request.params progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        handleIndicators(request, false);
        MKNetWorkManager *nm = [[MKNetWorkManager alloc] initWithJsonData:responseObject];
        nm.tag = request.tag;
        if (nm.status == 200) {
            callback(CallBackStatusSuccess, nm, nil);
        } else {
            callback(CallBackStatusRequestError, nil, [NSError errorWithDomain:nm.message code:9000 userInfo:nil]);
        }

    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if([error.userInfo.allKeys containsObject:@"com.alamofire.serialization.response.error.data"]){
            NSData *data = [error.userInfo objectForKey:@"com.alamofire.serialization.response.error.data"];
            NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSLog(@"----------ERROR MESSAGE : %@",string);
        }

        handleIndicators(request, false);
        callback(CallBackStatusRequestFailure, nil, [NSError errorWithDomain:@"网络不给力，请检查网络设置" code:error.code userInfo:error.userInfo]);
    }];
}

+ (void)postWithRequest:(MKRequest *)request callBackBlock:(RequestCallBackBlock)callback
{
    handleCertificate(request);
    handleIndicators(request, true);
    
    [request.manager POST:request.url parameters:request.params progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        handleIndicators(request, false);
        MKNetWorkManager *nm = [[MKNetWorkManager alloc] initWithJsonData:responseObject];
        nm.tag = request.tag;
        if (nm.status == 200) {
            callback(CallBackStatusSuccess, nm, nil);
        } else {
            callback(CallBackStatusRequestError, nil, [NSError errorWithDomain:nm.message code:9000 userInfo:nil]);
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if([error.userInfo.allKeys containsObject:@"com.alamofire.serialization.response.error.data"]){
            NSData *data = [error.userInfo objectForKey:@"com.alamofire.serialization.response.error.data"];
            NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSLog(@"----------ERROR MESSAGE : %@",string);
        }
        handleIndicators(request, false);
        callback(CallBackStatusRequestFailure, nil, [NSError errorWithDomain:@"网络不给力，请检查网络设置" code:error.code userInfo:error.userInfo]);
        
    }];
}

+ (void)uploadFileWithRequest:(MKRequest *)request callBackBlock:(RequestCallBackBlock)callback
{
    handleCertificate(request);
    handleIndicators(request, true);
    
    [request.manager POST:request.url parameters:request.params constructingBodyWithBlock:request.construtingBodyHandler progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        MKNetWorkManager *nm = [[MKNetWorkManager alloc] initWithJsonData:responseObject];
        nm.tag = request.tag;
        handleIndicators(request, false);
        if (nm.status == 200) {
            callback(CallBackStatusSuccess, nm, nil);
        } else {
           callback(CallBackStatusRequestError, nil, [NSError errorWithDomain:nm.message code:9000 userInfo:nil]);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if([error.userInfo.allKeys containsObject:@"com.alamofire.serialization.response.error.data"]){
            NSData *data = [error.userInfo objectForKey:@"com.alamofire.serialization.response.error.data"];
            NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSLog(@"----------ERROR MESSAGE : %@",string);
        }
        handleIndicators(request, false);
       callback(CallBackStatusRequestFailure, nil, [NSError errorWithDomain:@"网络不给力，请检查网络设置" code:error.code userInfo:error.userInfo]);
    }];
}

+ (void)uploadImagesWithRequest:(MKRequest *)request callBackBlock:(RequestCallBackBlock)callback
{
    __weak __typeof(&*request)weakRequest = request;
    request.construtingBodyHandler = ^(id<AFMultipartFormData> formData) {
        if (request.requestImages != nil) {
            [weakRequest.requestImages enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
                [formData appendPartWithFileData:obj name:@"file" fileName:key mimeType:@"image/*"];
            }];
        }
    };
    [self uploadFileWithRequest:request callBackBlock:callback];
}


+ (NSURLSessionTask *)downloadWithURL:(NSString *)URL
                              fileDir:(NSString *)fileDir
                             progress:(HttpProgress)progress
                              success:(void(^)(NSString *))success
                              failure:(HttpRequestFailed)failure
{
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:URL]];
    NSURLSessionDownloadTask *downloadTask = [_sessionManager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        
        //下载进度
        dispatch_sync(dispatch_get_main_queue(), ^{
            progress ? progress(downloadProgress) : nil;
        });
        NSLog(@"下载进度:%.2f%%",100.0*downloadProgress.completedUnitCount/downloadProgress.totalUnitCount);
        
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        
        //拼接缓存目录
        NSString *downloadDir = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:fileDir ? fileDir : @"Download"];
        
        //打开文件管理器
        NSFileManager *fileManager = [NSFileManager defaultManager];
        //创建Download目录
        [fileManager createDirectoryAtPath:downloadDir withIntermediateDirectories:YES attributes:nil error:nil];
        //拼接文件路径
        NSString *filePath = [downloadDir stringByAppendingPathComponent:response.suggestedFilename];
        
        NSLog(@"downloadDir = %@",downloadDir);
        //返回文件位置的URL路径
        return [NSURL fileURLWithPath:filePath];
        
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        
        if(failure && error) {failure(error) ; return ;};
        success ? success(filePath.absoluteString /** NSURL->NSString*/) : nil;
        
    }];
    
    //开始下载
    [downloadTask resume];
    return downloadTask;
}

+ (id)syncWithRequest:(MKRequest *)request
{
    handleIndicators(request, true);
    NSMutableURLRequest *mutableURLRequest = [[NSMutableURLRequest alloc] init];
    [mutableURLRequest setURL:[NSURL URLWithString:request.url]];
    [mutableURLRequest setTimeoutInterval:request.timeoutInterval];
    
    if (request.requestMethod == MKRequestMethodGet) {
        [mutableURLRequest setHTTPMethod:@"GET"];
    } else {
        [mutableURLRequest setHTTPMethod:@"POST"];
    }
    //请求头
    [request.acceptableContentTypes enumerateObjectsUsingBlock:^(id  _Nonnull obj, BOOL * _Nonnull stop) {
        [mutableURLRequest addValue:obj forHTTPHeaderField:@"Content-Type"];
    }];
    
    //请求体
    NSMutableData *postBody = [NSMutableData data];
    [request.params enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        if (!stop) {
            [postBody appendData:[[NSString stringWithFormat:@"%@=%@", key, obj] dataUsingEncoding:NSUTF8StringEncoding]];
        } else {
            [postBody appendData:[[NSString stringWithFormat:@"%@=%@&", key, obj] dataUsingEncoding:NSUTF8StringEncoding]];
        }
    }];
    [mutableURLRequest setHTTPBody:postBody];
    
    //发起请求
    NSHTTPURLResponse *urlResponse = nil;
    NSError *error = nil;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:mutableURLRequest returningResponse:&urlResponse error:&error];
    
    handleIndicators(request, false);
    
    if (error) {
        return error;
    }
    
    return responseData;
}

#pragma mark - private methods

void handleCertificate(MKRequest *request)
{
    if (request.certificatePath) {
        //先导入证书
        NSString *cerPath = [[NSBundle mainBundle] pathForResource:request.certificatePath ofType:@"cer"];   //证书的路径
        NSError * error;
        NSData * cerData = [NSData dataWithContentsOfFile:cerPath options:NSDataReadingMappedIfSafe error:&error];
        if (error) {
            NSLog(@"errordomain:%@",error.domain);
        }
        if (cerData) {
            AFSecurityPolicy * securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
            
            //allowInvalidCertificates，是否允许无效证书（也就是自建的证书），默认为NO
            securityPolicy.allowInvalidCertificates = YES;
            
            //validatesDomainName，是否需要验证域名，默认为YES；
            //假如证书的域名与你请求的域名不一致，需把该项设置为NO；如设成NO的话，即服务器使用其他可信任机构颁发的证书，也可以建立连接，这个非常危险，建议打开。
            //置为NO，主要用于这种情况：客户端请求的是子域名，而证书上的是另外一个域名。
            //因为SSL证书上的域名是独立的，假如证书上注册的域名是www.google.com，那么mail.google.com是无法验证通过的；当然，有钱可以注册通配符的域名*.google.com，但这个还是比较贵的。
            //如置为NO，建议自己添加对应域名的校验逻辑。
            securityPolicy.validatesDomainName = NO;
            
            securityPolicy.pinnedCertificates = [NSSet setWithObject:cerData];
            //**HTTPS请求专属**
            request.manager.securityPolicy = securityPolicy;
            //**
        }
    }
}

void handleIndicators(MKRequest *request, bool status)
{
    handleNetworkActivityIndicator(request, status);
}

void handleNetworkActivityIndicator(MKRequest *request, bool status)
{
    if (request.networkActivityIndicatorEnabled) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = status;
    }
}


- (NSMutableDictionary *)params
{
    if (!_params) {
        _params = [NSMutableDictionary dictionary];
    }
    return _params;
}
-(void)requestHeader{
//    [self.manager.requestSerializer setValue:@"1.0" forHTTPHeaderField:@"version"];
//    [self.manager.requestSerializer setValue:@"" forHTTPHeaderField:@"token"];
//    [self.manager.requestSerializer setValue:[self getUUIDString] forHTTPHeaderField:@"deviceId"];
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    CFShow((__bridge CFTypeRef)(infoDictionary));
    NSString *headStr = [NSString stringWithFormat:@"%@/IOS-%@/%@",[self getCurrentDeviceModel],[[UIDevice currentDevice] systemVersion],[infoDictionary objectForKey:@"CFBundleShortVersionString"]];
    NSString *buildStr = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
    NSString * new = [buildStr stringByReplacingOccurrencesOfString:@"." withString:@""];
    NSLog(@"build=%@-%@",buildStr,new);
    [self.manager.requestSerializer setValue:@"IOS" forHTTPHeaderField:@"versionType"];
    [self.manager.requestSerializer setValue:headStr forHTTPHeaderField:@"appType"];
    [self.manager.requestSerializer setValue:new forHTTPHeaderField:@"versionCode"];
//    NSUserDefaults * userDefaultes = [NSUserDefaults standardUserDefaults];
//    NSString * token = [userDefaultes stringForKey:Token];
//    if(token && token.length > 0){
//        [self.manager.requestSerializer setValue:token forHTTPHeaderField:@"token"];
//    }
}

- (NSMutableDictionary *)requestImages
{
    if (!_requestImages) {
        _requestImages = [NSMutableDictionary dictionary];
    }
    return _requestImages;
}

- (NSSet *)acceptableContentTypes
{
    if (!_acceptableContentTypes) {
        _acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html", @"text/json", @"text/plain", @"text/javascript", @"text/xml", @"image/*",@"charset/UTF-8", nil];
    }
    return _acceptableContentTypes;
}

- (AFHTTPSessionManager *)manager
{
    if (!_manager) {
        _manager = [AFHTTPSessionManager manager];
        [_manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
        _manager.requestSerializer.timeoutInterval = self.timeoutInterval;
        [_manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
        _manager.responseSerializer.acceptableContentTypes = self.acceptableContentTypes;
        _manager.requestSerializer = [AFHTTPRequestSerializer serializer];
        _manager.responseSerializer = [AFHTTPResponseSerializer serializer];
//        _manager.requestSerializer=[AFJSONRequestSerializer serializer]; //以json方式传递参数／／默认是form
        // _manager.requestSerializer=[AFPropertyListRequestSerializer serializer]; //plist xml  方式
    }
    return _manager;
}

//获得设备型号
- (NSString *)getCurrentDeviceModel
{
    size_t size;
    int nR = sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *machine = (char *)malloc(size);
    nR = sysctlbyname("hw.machine", machine, &size, NULL, 0);
    NSString *platform = [NSString stringWithCString:machine encoding:NSUTF8StringEncoding];
    free(machine);
    
    if ([platform isEqualToString:@"iPhone1,1"]) return @"iPhone 2G (A1203)";
    if ([platform isEqualToString:@"iPhone1,2"]) return @"iPhone 3G (A1241/A1324)";
    if ([platform isEqualToString:@"iPhone2,1"]) return @"iPhone 3GS (A1303/A1325)";
    if ([platform isEqualToString:@"iPhone3,1"]) return @"iPhone 4 (A1332)";
    if ([platform isEqualToString:@"iPhone3,2"]) return @"iPhone 4 (A1332)";
    if ([platform isEqualToString:@"iPhone3,3"]) return @"iPhone 4 (A1349)";
    if ([platform isEqualToString:@"iPhone4,1"]) return @"iPhone 4S (A1387/A1431)";
    if ([platform isEqualToString:@"iPhone5,1"]) return @"iPhone 5 (A1428)";
    if ([platform isEqualToString:@"iPhone5,2"]) return @"iPhone 5 (A1429/A1442)";
    if ([platform isEqualToString:@"iPhone5,3"]) return @"iPhone 5c (A1456/A1532)";
    if ([platform isEqualToString:@"iPhone5,4"]) return @"iPhone 5c (A1507/A1516/A1526/A1529)";
    if ([platform isEqualToString:@"iPhone6,1"]) return @"iPhone 5s (A1453/A1533)";
    if ([platform isEqualToString:@"iPhone6,2"]) return @"iPhone 5s (A1457/A1518/A1528/A1530)";
    if ([platform isEqualToString:@"iPhone7,1"]) return @"iPhone 6 Plus (A1522/A1524)";
    if ([platform isEqualToString:@"iPhone7,2"]) return @"iPhone 6 (A1549/A1586)";
    
    if ([platform isEqualToString:@"iPod1,1"])   return @"iPod Touch 1G (A1213)";
    if ([platform isEqualToString:@"iPod2,1"])   return @"iPod Touch 2G (A1288)";
    if ([platform isEqualToString:@"iPod3,1"])   return @"iPod Touch 3G (A1318)";
    if ([platform isEqualToString:@"iPod4,1"])   return @"iPod Touch 4G (A1367)";
    if ([platform isEqualToString:@"iPod5,1"])   return @"iPod Touch 5G (A1421/A1509)";
    
    if ([platform isEqualToString:@"iPad1,1"])   return @"iPad 1G (A1219/A1337)";
    
    if ([platform isEqualToString:@"iPad2,1"])   return @"iPad 2 (A1395)";
    if ([platform isEqualToString:@"iPad2,2"])   return @"iPad 2 (A1396)";
    if ([platform isEqualToString:@"iPad2,3"])   return @"iPad 2 (A1397)";
    if ([platform isEqualToString:@"iPad2,4"])   return @"iPad 2 (A1395+New Chip)";
    if ([platform isEqualToString:@"iPad2,5"])   return @"iPad Mini 1G (A1432)";
    if ([platform isEqualToString:@"iPad2,6"])   return @"iPad Mini 1G (A1454)";
    if ([platform isEqualToString:@"iPad2,7"])   return @"iPad Mini 1G (A1455)";
    
    if ([platform isEqualToString:@"iPad3,1"])   return @"iPad 3 (A1416)";
    if ([platform isEqualToString:@"iPad3,2"])   return @"iPad 3 (A1403)";
    if ([platform isEqualToString:@"iPad3,3"])   return @"iPad 3 (A1430)";
    if ([platform isEqualToString:@"iPad3,4"])   return @"iPad 4 (A1458)";
    if ([platform isEqualToString:@"iPad3,5"])   return @"iPad 4 (A1459)";
    if ([platform isEqualToString:@"iPad3,6"])   return @"iPad 4 (A1460)";
    
    if ([platform isEqualToString:@"iPad4,1"])   return @"iPad Air (A1474)";
    if ([platform isEqualToString:@"iPad4,2"])   return @"iPad Air (A1475)";
    if ([platform isEqualToString:@"iPad4,3"])   return @"iPad Air (A1476)";
    if ([platform isEqualToString:@"iPad4,4"])   return @"iPad Mini 2G (A1489)";
    if ([platform isEqualToString:@"iPad4,5"])   return @"iPad Mini 2G (A1490)";
    if ([platform isEqualToString:@"iPad4,6"])   return @"iPad Mini 2G (A1491)";
    
    if ([platform isEqualToString:@"i386"])      return @"iPhone Simulator";
    if ([platform isEqualToString:@"x86_64"])    return @"iPhone Simulator";
    return platform;
}


- (NSString *)getUUIDString
{
    CFUUIDRef uuidRef = CFUUIDCreate(kCFAllocatorDefault);
    CFStringRef strRef = CFUUIDCreateString(kCFAllocatorDefault , uuidRef);
    NSString *uuidString = [(__bridge NSString*)strRef stringByReplacingOccurrencesOfString:@"-" withString:@""];
    CFRelease(strRef);
    CFRelease(uuidRef);
    return uuidString;
}


@end
