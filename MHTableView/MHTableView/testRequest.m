//
//  testRequest.m
//  MHTableView
//
//  Created by MH on 2017/5/9.
//  Copyright © 2017年 MH. All rights reserved.
//

#import "testRequest.h"

@implementation testRequest
- (void)startCallBack:(RequestCallBackBlock)callBack {
    self.urlPath = @"appservice/basic/verify";
    self.requestMethod = MKRequestMethodPost;
    self.params = @{@"phone":self.phone}.mutableCopy;
//    NSString * token = @"";
//    if ([GW_UserModel ShareUserModel].token) {
//        token = [GW_UserModel ShareUserModel].token;
//    }
//    self.httpHeaderFields = @{@"version":@"1.0",@"token":token,@"deviceId":[SvUDIDTools UDID]};
    [super startCallBack:callBack];
}
@end
