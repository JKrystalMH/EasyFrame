//
//  MKViewModel.h
//  MHTableView
//
//  Created by MH on 2017/5/9.
//  Copyright © 2017年 MH. All rights reserved.
//

#import <YYModel/YYModel.h>
#import "MKRequest.h"
typedef NSUInteger VCCallBackAction;
@interface NSObject(ViewModel)

-(void)callBackAction:(VCCallBackAction)action Result:(MKNetWorkManager *)result;

@end

@interface MKViewModel : NSObject

@property (nonatomic,strong)NSMutableArray *requests;
@property (nonatomic,assign)NSObject *viewController;


//- (instancetype)initWithViewController : (NSObject *)_viewcontroller;
+ (MKViewModel*)shareInstance;
- (void)addRequest : (MKRequest *)request;
- (void)delRequest : (MKRequest *)request;
- (void)delRequestWithTag : (int)tag;
- (void)cancelAndClearAll;
- (void)cancelRequest : (MKRequest *)request;
- (void)cancelAndRemoveRequest : (MKRequest *)request;
- (void)cancelAndRemoveRequestWithTag : (int)tag;

- (void)startCallBack:(RequestCallBackBlock)callBack Request : (MKRequest *)request WithTag : (int)tag;
@end
