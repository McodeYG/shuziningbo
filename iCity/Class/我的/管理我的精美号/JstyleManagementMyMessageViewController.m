//
//  JstyleManagementMyMessageViewController.m
//  Exquisite
//
//  Created by 数字宁波 on 2017/10/12.
//  Copyright © 2017年 Jstyle. All rights reserved.
//

#import "JstyleManagementMyMessageViewController.h"
#import "JstyleManagementMyMessageViewCell.h"
#import "NinaPagerView.h"
#import "JstyleManagementSystemNoticeDetailViewController.h"

@interface JstyleManagementMyMessageViewController ()<UITableViewDelegate, UITableViewDataSource, NinaPagerViewDelegate>

@property (nonatomic, strong) JstyleNewsBaseTableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation JstyleManagementMyMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpViews];
    [self addReshAction];
    [self.tableView.mj_header beginRefreshing];
}

- (void)addReshAction
{
    __weak typeof(self)weakSelf = self;
    self.tableView.mj_header = [JstyleRefreshGiftHeader headerWithRefreshingBlock:^{
        [weakSelf.dataArray removeAllObjects];
        [weakSelf getJstyleMyMessageDataSource];
    }];
}

- (void)setUpViews
{
    _tableView = [[JstyleNewsBaseTableView alloc]initWithFrame:CGRectZero style:(UITableViewStyleGrouped)];
    _tableView.separatorInset = UIEdgeInsetsMake(0, 15, 0, 0);
    _tableView.delegate = self;
    _tableView.dataSource = self;
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    
    
    [_tableView registerNib:[UINib nibWithNibName:@"JstyleManagementMyMessageViewCell" bundle:nil] forCellReuseIdentifier:@"JstyleManagementMyMessageViewCell"];
    
    [self.view addSubview:_tableView];
    _tableView.sd_layout
    .topEqualToView(self.view)
    .bottomSpaceToView(self.view, YG_SafeBottom_H)
    .leftEqualToView(self.view)
    .rightEqualToView(self.view);
}

#pragma mark -- tableView的代理方法

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"JstyleManagementMyMessageViewCell";
    JstyleManagementMyMessageViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[JstyleManagementMyMessageViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    
    cell.model = self.dataArray[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.tableView cellHeightForIndexPath:indexPath model:self.dataArray[indexPath.row] keyPath:@"model" cellClass:[JstyleManagementMyMessageViewCell class] contentViewWidth:kScreenWidth];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    JstyleManagementSystemNoticeDetailViewController *noticeDetailVC = [JstyleManagementSystemNoticeDetailViewController new];
    noticeDetailVC.URLString = [self.dataArray[indexPath.row] ID];
    [self.navigationController pushViewController:noticeDetailVC animated:YES];
    
}

#pragma mark - 获取数据
- (void)getJstyleMyMessageDataSource
{
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:[[JstyleToolManager sharedManager] getUniqueId],@"uniqueid",self.type,@"type", nil];
    // 初始化Manager
    JstyleNewsNetworkManager *manager = [JstyleNewsNetworkManager shareManager];
    [manager GET:MANAGER_MYMESSAGE_URL parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dictionary = responseObject;
        
        if ([dictionary[@"code"] integerValue] != 1) {
            [self.tableView.mj_header endRefreshing];
            return ;
        }
        
        for (NSDictionary *dict in dictionary[@"data"]) {
            JstyleManagementMyMessageModel *model = [JstyleManagementMyMessageModel new];
            [model setValuesForKeysWithDictionary:dict];
            [self.dataArray addObject:model];
        }
        
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self.tableView.mj_header endRefreshing];
    }];
}

- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    [[SDImageCache sharedImageCache] clearMemory];
    [[YYWebImageManager sharedManager].cache.memoryCache removeAllObjects];
    
}

@end
