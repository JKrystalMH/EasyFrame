//
//  MKViewController.h
//  MKViewController
//
//  Created by MH on 2017/5/8.
//  Copyright © 2017年 MH. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^noDataClickBlock)(void);

@interface MKViewController : UIViewController


@property (nonatomic, strong) MKTableView * tableView;

@property (nonatomic, strong) MKCollectionView * collectionView;


@property (nonatomic, copy) NSString * noDataTitle;

@property (nonatomic, copy) NSString * noDataButtonTitle;

@property (nonatomic, copy) NSString * noDataDescription;

@property (nonatomic, strong) UIImage * noDataImage;

@property (nonatomic, assign) noDataClickBlock  noDataClickBlock;

@end
