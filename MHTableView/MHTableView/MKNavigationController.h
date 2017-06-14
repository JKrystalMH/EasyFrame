//
//  MKNavigationController.h
//  MKNavigationController
//
//  Created by MH on 2017/5/8.
//  Copyright © 2017年 MH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MKNavigationController : UINavigationController<UINavigationControllerDelegate>
-(void)back;

/** 是否禁用侧滑返回 */
@property (nonatomic, assign)  BOOL  closePopGesture;
@end
