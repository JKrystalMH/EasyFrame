//
//  MKCollectionView.h
//  MKCollectionView
//
//  Created by MH on 2017/5/8.
//  Copyright © 2017年 MH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MJRefresh.h"

#if NS_BLOCKS_AVAILABLE
typedef void (^collectionPullingUpBlock)(void);
typedef void (^collectionPullingDownBlock)(void);
#endif

@interface MKCollectionView : UICollectionView

/** 初始化 */
- (instancetype)initWithFrame:(CGRect)frame andCollectionViewLayout:(UICollectionViewFlowLayout*)collectionViewLayout andScrollDirection:(UICollectionViewScrollDirection)scrollDirection andDelegate:(id)delegate andBackgroundColor:(UIColor*)backgroundColor andUpBlock:(collectionPullingUpBlock)blockUp andDownBlock:(collectionPullingDownBlock)blockDown;

/** 加载结束后 */
- (void)endLoading;
/** 最后一行之后没有数据 */
- (void)endNoMoreData;

@end
