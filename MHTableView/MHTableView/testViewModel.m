//
//  testViewModel.m
//  MHTableView
//
//  Created by MH on 2017/5/9.
//  Copyright © 2017年 MH. All rights reserved.
//

#import "testViewModel.h"
#import "testRequest.h"
@implementation testViewModel
- (void)getCodeWithPhone:(NSString *)phone isSuccess:(callSuccess)isSuccess{
    self.callback = isSuccess;
    testRequest * request = [testRequest new];
    request.phone = phone;
    [[MKViewModel shareInstance]startCallBack:^(CallBackStatus callBackStatus, MKNetWorkManager *result, NSError *error) {
        if (callBackStatus == CallBackStatusSuccess) {
            _phone = result.message;
        }
        if (self.callback) {
            self.callback(YES);
            self.callback(nil);
        }
    } Request:request WithTag:1];
}

@end
