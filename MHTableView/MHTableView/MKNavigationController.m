//
//  MKNavigationController.m
//  MKNavigationController
//
//  Created by MH on 2017/5/8.
//  Copyright © 2017年 MH. All rights reserved.
//

#import "MKNavigationController.h"

@interface MKNavigationController ()

@end

@implementation MKNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.delegate = self;
    //self.navigationBar.translucent = NO;
//    [self.navigationBar setBarTintColor:[UIColor blackColor]];
    //    [self.navigationBar setTintColor:[UIColor whiteColor]];
    self.navigationBar.titleTextAttributes = @{
                                               NSForegroundColorAttributeName: [UIColor whiteColor],
                                               NSFontAttributeName: [UIFont systemFontOfSize:18]
                                               };
    
    NSArray *viewcontrollers=self.navigationController.viewControllers;
    if (viewcontrollers.count>1) {
        if ([viewcontrollers objectAtIndex:viewcontrollers.count-1]==self) {
            //push方式
        }
    }
    else{
        //present方式
    }
    
    
    if ([self.navigationController.viewControllers indexOfObject:self] == NSNotFound){
        //用户点击了返回按钮
        
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setClosePopGesture:(BOOL)closePopGesture{
    _closePopGesture = closePopGesture;
    if (_closePopGesture) {
        //侧滑失效
        self.interactivePopGestureRecognizer.delegate = (id)self;
    }
}

//push时，隐藏底部tabbar
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    if (self.viewControllers.count > 0) {
        [viewController setHidesBottomBarWhenPushed:YES];
    }
    [super pushViewController:viewController animated:YES];
}

- (void)back{
    [self popViewControllerAnimated:YES];
}

//解决根视图时侧滑返回卡死现象
- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    
    if ([navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
    if (navigationController.viewControllers.count == 1) {
        navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
}

//解决返回时导航栏错位的问题
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    BOOL isHomePage = [viewController isKindOfClass:[self class]];
    
    [self.navigationController setNavigationBarHidden:isHomePage animated:YES];
}
@end
