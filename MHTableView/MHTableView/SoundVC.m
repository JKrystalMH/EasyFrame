//
//  SoundVC.m
//  MHTableView
//
//  Created by MH on 2017/5/15.
//  Copyright © 2017年 MH. All rights reserved.
//

#import "SoundVC.h"

@interface SoundVC ()<UITableViewDataSource,UITableViewDataSource,DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>
@property (nonatomic, strong) NSMutableArray *  array;

@end

@implementation SoundVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.noDataTitle = @"这是一张空白页";
    self.noDataDescription = @"什么都没有啊，咋个办呢";
    self.noDataButtonTitle = @"刷新看看";
    self.noDataClickBlock = ^{
        NSLog(@"刷新");
    };
    self.noDataImage = [UIImage imageNamed:@"icon_zb_cha"];
    
    
    self.array = [NSMutableArray array];
    //    [self.array addObject:@"sadsa"];
    self.tableView = [[MKTableView alloc] initWithFrame:CGRectMake(0, 0, 320, 576) andStyle:UITableViewStylePlain andDelegate:self andSeparatorStyle:UITableViewCellSeparatorStyleNone andBackgroundColor:[UIColor whiteColor] andUpBlock:^{
        [self.tableView endLoading];
    } andDownBlock:^{
        [self.tableView endLoading];
    }];
    [self.view addSubview:self.tableView];
    [self.tableView reloadData];


}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil)  {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    cell.selectionStyle = 0;
    cell.textLabel.text = self.array[indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.array.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}


@end
