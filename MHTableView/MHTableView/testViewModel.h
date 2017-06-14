//
//  testViewModel.h
//  MHTableView
//
//  Created by MH on 2017/5/9.
//  Copyright © 2017年 MH. All rights reserved.
//

#import "MKViewModel.h"
typedef void(^callSuccess)(BOOL isSuccess);
@interface testViewModel : MKViewModel

@property (nonatomic,strong) callSuccess callback;
@property (nonatomic,copy,readonly) NSString * phone;
- (void)getCodeWithPhone:(NSString *)phone isSuccess:(callSuccess)isSuccess;
@end
