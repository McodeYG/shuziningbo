//
//  JstyleNewsMyNoticeTableViewController.m
//  JstyleNews
//
//  Created by 数字跃动 on 2017/12/25.
//  Copyright © 2017年 JstyleNews. All rights reserved.
//

#import "JstyleNewsMyNoticeTableViewController.h"
#import "JstyleNewsMyMessageNoticeTableViewCell.h"
#import "JstyleNewsMyMessageNoticeModel.h"
#import "JstyleNewsPlaceholderView.h"

@interface JstyleNewsMyNoticeTableViewController ()

@property (nonatomic, strong) NSMutableArray *noticeDataArray;
@property (nonatomic, strong) JstyleNewsPlaceholderView *placeholderView;

@end

static NSInteger page = 1;

static NSString *JstyleNewsMyMessageNoticeTableViewCellID = @"JstyleNewsMyMessageNoticeTableViewCellID";

@implementation JstyleNewsMyNoticeTableViewController

- (JstyleNewsPlaceholderView *)placeholderView {
    if (_placeholderView == nil) {
        _placeholderView = [[JstyleNewsPlaceholderView alloc] initWithFrame:[UIScreen mainScreen].bounds placeholderImage:[UIImage imageNamed:@"消息空白"] placeholderText:@"暂时还没有通知~"];
    }
    return _placeholderView;
}


- (NSMutableArray *)noticeDataArray {
    if (_noticeDataArray == nil) {
        _noticeDataArray = [NSMutableArray array];
    }
    return _noticeDataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.backgroundColor = ISNightMode?kNightModeBackColor:kBackGroundColor;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:@"JstyleNewsMyMessageNoticeTableViewCell" bundle:nil] forCellReuseIdentifier:JstyleNewsMyMessageNoticeTableViewCellID];
    
    [self addMJHeaderFooterWithTableView:self.tableView];
    [self.tableView.mj_header beginRefreshing];
}

- (void)addMJHeaderFooterWithTableView:(UITableView *)tableView {
    
    __weak typeof(self)weakSelf = self;
    tableView.mj_header = [JstyleRefreshGiftHeader headerWithRefreshingBlock:^{
        page = 1;
        [weakSelf.noticeDataArray removeAllObjects];
        [weakSelf loadDatasWithType:@"2"];
    }];
    
    tableView.mj_footer = [JstyleRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        page++;
        [weakSelf loadDatasWithType:@"2"];
    }];
}


#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.0001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 83;
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.noticeDataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    JstyleNewsMyMessageNoticeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:JstyleNewsMyMessageNoticeTableViewCellID forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.row < self.noticeDataArray.count) {
        cell.model = self.noticeDataArray[indexPath.row];
    }
    return cell;
}

- (void)loadDatasWithType:(NSString *)type {
    
    JstyleNewsNetworkManager *manager = [JstyleNewsNetworkManager shareManager];
    
    NSDictionary *patamaters = @{
                                 @"uid":[[JstyleToolManager sharedManager] getUserId],
                                 @"type":type,
                                 @"page":[NSString stringWithFormat:@"%zd",page]
                                 };
    [manager GETURL:USERINFO_MSGLIST_URL parameters:patamaters success:^(id responseObject) {
        
        NSDictionary *dictionary = responseObject;
        
        if ([dictionary[@"code"] isEqualToString:@"1"]) {
            
            NSArray *currentArray = [NSArray modelArrayWithClass:[JstyleNewsMyMessageNoticeModel class] json:dictionary[@"data"]];
            
            [self.placeholderView removeFromSuperview];
            self.placeholderView = nil;
            
            [self.noticeDataArray addObjectsFromArray:currentArray];
            [self.tableView reloadData];
            
            [self.tableView.mj_header endRefreshing];
            
            if (currentArray.count != 0) {
                [self.tableView.mj_footer endRefreshing];
                if (currentArray.count < 10) {
                    [self.tableView.mj_footer endRefreshingWithNoMoreData];
                }
            } else {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }
            
        } else {
            if (page == 1) {
                [self.tableView addSubview:self.placeholderView];
            }
            
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }
        
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
        
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
