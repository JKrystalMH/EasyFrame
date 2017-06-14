//
//  MKTableView.h
//  MKTableView
//
//  Created by MH on 2017/5/8.
//  Copyright © 2017年 MH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MJRefresh.h"

#if NS_BLOCKS_AVAILABLE
typedef void (^tablePullingUpBlock)(void);
typedef void (^tablePullingDownBlock)(void);
#endif

@interface MKTableView : UITableView
/** 初始化 */
- (instancetype)initWithFrame:(CGRect)frame andStyle:(UITableViewStyle)style andDelegate:(id)delegate andSeparatorStyle:(UITableViewCellSeparatorStyle)separatorStyle andBackgroundColor:(UIColor*)backgroundColor andUpBlock:(tablePullingUpBlock)blockUp andDownBlock:(tablePullingDownBlock)blockDown;

/** 加载结束后 */
- (void)endLoading;
/** 最后一行之后没有数据 */
- (void)endNoMoreData;


/*
 // 返回标题文字
 - (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView{}
 
 // 返回图片
 - (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView{}
 
 // 返回详情文字
 - (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView {}
 
 // 返回可以点击的按钮 上面带文字
 - (NSAttributedString *)buttonTitleForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state {}
 
 // 处理按钮的点击事件
 - (void)emptyDataSet:(UIScrollView *)scrollView didTapButton:(UIButton *)button {}
 
 // 空白区域点击事件
 - (void)emptyDataSet:(UIScrollView *)scrollView didTapView:(UIView *)view {}
 
 // 标题文字与详情文字的距离
 - (CGFloat)spaceHeightForEmptyDataSet:(UIScrollView *)scrollView {}
 
 // 返回空白区域的颜色自定义
 - (UIColor *)backgroundColorForEmptyDataSet:(UIScrollView *)scrollView {}
 
 / 标题文字与详情文字同时调整垂直偏移量
 - (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView {}
 
 // 返回图片的 tintColor
 - (UIColor *)imageTintColorForEmptyDataSet:(UIScrollView *)scrollView {}
 
 // 返回可点击按钮的 image
 - (UIImage *)buttonImageForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state {}
 
 // 返回可点击按钮的 backgroundImage
 - (UIImage *)buttonBackgroundImageForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state {}
 
 // 返回自定义 view
 - (UIView *)customViewForEmptyDataSet:(UIScrollView *)scrollView {}
 
 // 是否显示空白页，默认YES
 - (BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView {}
 
 // 是否允许点击，默认YES
 - (BOOL)emptyDataSetShouldAllowTouch:(UIScrollView *)scrollView {}
 
 // 是否允许滚动，默认NO
 - (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView {}
 
 // 图片是否要动画效果，默认NO
 - (BOOL)emptyDataSetShouldAnimateImageView:(UIScrollView *)scrollView {
 }
 
 - (CAAnimation *)imageAnimationForEmptyDataSet:(UIScrollView *)scrollView {
 CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath: @"transform"];
 animation.fromValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
 animation.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeRotation(M_PI_2, 0.0, 0.0,   1.0)];
 animation.duration = 0.25;
 animation.cumulative = YES;
 animation.repeatCount = MAXFLOAT;
 return animation;
 }
 
 // 空白页将要出现
 - (void)emptyDataSetWillAppear:(UIScrollView *)scrollView {}
 
 // 空白页已经出现
 - (void)emptyDataSetDidAppear:(UIScrollView *)scrollView {}
 
 // 空白页将要消失
 - (void)emptyDataSetWillDisappear:(UIScrollView *)scrollView {}
 
 // 空白页已经消失
 - (void)emptyDataSetDidDisappear:(UIScrollView *)scrollView {}
 */
@end
