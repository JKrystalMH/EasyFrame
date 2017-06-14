//
//  MKTableView.m
//  MKTableView
//
//  Created by MH on 2017/5/8.
//  Copyright © 2017年 MH. All rights reserved.
//

#import "MKTableView.h"



@implementation MKTableView

- (instancetype)initWithFrame:(CGRect)frame andStyle:(UITableViewStyle)style andDelegate:(id)delegate andSeparatorStyle:(UITableViewCellSeparatorStyle)separatorStyle andBackgroundColor:(UIColor*)backgroundColor andUpBlock:(tablePullingUpBlock)blockUp andDownBlock:(tablePullingDownBlock)blockDown{
    self = [super initWithFrame:frame style:style];
    if (self) {
        self.backgroundView.backgroundColor = backgroundColor;
        self.delegate = delegate;
        self.dataSource = delegate;
        self.emptyDataSetSource = delegate;
        self.emptyDataSetDelegate = delegate;
        self.separatorStyle = separatorStyle;
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
