//
//  MKCollectionView.m
//  MKCollectionView
//
//  Created by MH on 2017/5/8.
//  Copyright © 2017年 MH. All rights reserved.
//

#import "MKCollectionView.h"

@implementation MKCollectionView

- (instancetype)initWithFrame:(CGRect)frame andCollectionViewLayout:(UICollectionViewFlowLayout*)collectionViewLayout andScrollDirection:(UICollectionViewScrollDirection)scrollDirection andDelegate:(id)delegate andBackgroundColor:(UIColor*)backgroundColor andUpBlock:(collectionPullingUpBlock)blockUp andDownBlock:(collectionPullingDownBlock)blockDown{
    //设置collectionView滚动方向
    [collectionViewLayout setScrollDirection:scrollDirection];
    self = [super initWithFrame:frame collectionViewLayout:collectionViewLayout];
    if (self) {
        self.backgroundView.backgroundColor = backgroundColor;
        self.delegate = delegate;
        self.dataSource = delegate;
        self.emptyDataSetSource = delegate;
        self.emptyDataSetDelegate = delegate;
        self.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            // 进入刷新状态后会自动调用这个block
            blockUp();
        }];
        
        MJRefreshBackStateFooter * foot = [MJRefreshBackStateFooter footerWithRefreshingBlock:^{
            // 进入刷新状态后会自动调用这个block
            blockDown();
        }];
        self.mj_footer = foot;
    }
    return self;
}

- (void)endLoading{
    [self.mj_header endRefreshing];
    [self.mj_footer endRefreshing];
}
- (void)endNoMoreData{
    [self.mj_footer endRefreshingWithNoMoreData];
}

@end
