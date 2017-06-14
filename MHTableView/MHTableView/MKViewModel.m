//
//  MKViewModel.m
//  MHTableView
//
//  Created by MH on 2017/5/9.
//  Copyright © 2017年 MH. All rights reserved.
//

#import "MKViewModel.h"

@implementation MKViewModel
+ (MKViewModel*)shareInstance{
    static MKViewModel *__singletion;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __singletion=[[MKViewModel alloc]init];
    });
    return __singletion;
}

- (NSMutableArray *)requests
{
    if (!_requests) {
        _requests = [NSMutableArray array];
    }
    return _requests;
}
//- (instancetype)initWithViewController : (NSObject *)_viewcontroller{
//    self = [super init];
//    if (self) {
//        self.viewController = _viewcontroller;
//        self.requests = [NSMutableArray array];
//    }
//    return self;
//}

- (void)addRequest : (MKRequest *)request{
    [self.requests addObject:request];
}


- (void)delRequest : (MKRequest *)request{
    [self.requests removeObject:request];
}

- (void)delRequestWithTag : (int)tag{
    for (MKRequest *request in self.requests) {
        if (request.tag == tag) {
            [self.requests removeObject:request];
            break;
        }
    }
}

- (void)cancelRequest : (MKRequest *)request{
    [request cancelRequest];
}

- (void)cancelAndRemoveRequest : (MKRequest *)request{
    [request cancelRequest];
    [self.requests removeObject:request];
}

- (void)cancelAndRemoveRequestWithTag : (int)tag{
    for (MKRequest *request in self.requests) {
        if (request.tag == tag) {
            [self cancelAndRemoveRequest:request];
            break;
        }
    }
}

- (void)cancelAndClearAll{
    if (self.requests && [self.requests count] > 0) {
        for (MKRequest *request in self.requests) {
            [self cancelRequest:request];
        }
        [self.requests removeAllObjects];
    }
//    self.viewController = nil;
}

- (void)startCallBack:(RequestCallBackBlock)callBack Request : (MKRequest *)request WithTag : (int)tag{
    [self cancelAndRemoveRequestWithTag:tag];
    request.tag = tag;
    [self addRequest:request];
    [request startCallBack:callBack];
}

@end

@implementation NSObject(ViewModel)

-(void)callBackAction:(VCCallBackAction)action Result:(MKNetWorkManager *)result{
    
}

@end
