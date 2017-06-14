//
//  testRequest.h
//  MHTableView
//
//  Created by MH on 2017/5/9.
//  Copyright © 2017年 MH. All rights reserved.
//

#import "MKRequest.h"

@interface testRequest : MKRequest
/** 手机号 */
@property (nonatomic, copy) NSString * phone;
/** 验证码 */
@property (nonatomic, copy) NSString * code;
@end
