//
//  MKNetWorkManager.m
//  MHTableView
//
//  Created by MH on 2017/5/8.
//  Copyright © 2017年 MH. All rights reserved.
//

#import "MKNetWorkManager.h"
#import "YYModel.h"
//#import "MHUIUtil.h"
@interface MKNetWorkManager()

/**
 *  NetworkModel 初始化方法
 *
 *  @param dictionary 字典
 *
 *  @return NetworkModel对象实例
 */
- (instancetype)initWithDictionary : (NSDictionary *)dictionary;

@end

@implementation MKNetWorkManager


- (instancetype)initWithDictionary : (NSDictionary *)dictionary{
    
    if (self = [super init]) {
        NSDictionary * dict = dictionary;
        self.jsonDict = dictionary;
        self.status = [[dict objectForKey:@"status"] intValue];
        self.message = [dict objectForKey:@"msg"];
        self.data = [dict objectForKey:@"data"];
        NSLog(@"NetworkModelStatusType:(%zd）",self.status);
        NSLog(@"message:(%@)",self.message);
        NSLog(@"data:(%@)",self.data);
    }
    return self;
}

- (instancetype)initWithJsonData : (NSData *)jsonData
{
    NSString *jsonStr;
    if ( nil == jsonData ) {
        jsonStr =  [NSString stringWithUTF8String:[jsonData bytes]];
    }else {
       jsonStr = [jsonData yy_modelToJSONString];
    }
    NSError *error;
    NSDictionary *dict;
    if ([jsonData isKindOfClass:[NSDictionary class]]) {
        dict = (NSDictionary *)jsonData;
    }else{
        dict = (NSDictionary *)[NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:&error];
    }
    
    if (dict == nil || [dict count] <= 0) {
        self = [super init];
        if (self) {
            self.status = NetworkModelStatusTypeNoContent;
            self.message = @"服务器返回数据为空！";
            if(error != nil){
                self.status = NetworkModelStatusTypeServerDataFromatError;
                self.message = @"服务器返回数据格式有误！";
            }
            self.data = jsonStr;
            NSLog(@"NetworkModelStatusType---(%zd",self.status);
            NSLog(@"jsonStr---(%@)",jsonStr);
            NSLog(@"message---(%@)",self.message);
        }
    }
    else{
        if (self.status == NetworkModelStatusTypeUserNoLogin) {
            NSLog(@"账号未登录");
        }
        self = [self initWithDictionary:dict];
    }
    return self;
}

+ (void)alert:(MKNetWorkManager*)result{
//    [MHUIUtil alert:result.message];
}

- (NSString *)description{
    return [NSString stringWithFormat:@"---（%zd）---%@---",self.status,self.message];
}


@end
