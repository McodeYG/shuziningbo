//
//  JstyleManagementPingLunTableViewController.m
//  Exquisite
//
//  Created by 数字跃动 on 2017/10/11.
//  Copyright © 2017年 Jstyle. All rights reserved.
//

#import "JstyleManagementPingLunTableViewController.h"
#import "JstyleManagementPingLunCell.h"
#import "JstyleManagementCommentModel.h"

static NSString *managementPingLunCellID = @"managementPingLunCellID";
static NSInteger page = 1;
@interface JstyleManagementPingLunTableViewController ()

@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, strong) NSMutableArray *dataArrM;

@end

@implementation JstyleManagementPingLunTableViewController

- (NSMutableArray *)dataArrM {
    if (_dataArrM == nil) {
        _dataArrM = [NSMutableArray array];
    }
    return _dataArrM;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = kNightModeBackColor;
    self.tableView.backgroundColor = kNightModeBackColor;
    self.tableView.estimatedRowHeight = 124;
    [self.tableView registerNib:[UINib nibWithNibName:@"JstyleManagementPingLunCell" bundle:nil] forCellReuseIdentifier:managementPingLunCellID];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [SVProgressHUD showWithStatus:@"正在加载"];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    [self loadData];
    
    __weak typeof(self)weakSelf = self;
    self.tableView.mj_header = [JstyleRefreshGiftHeader headerWithRefreshingBlock:^{
        page = 1;
        [weakSelf.dataArrM removeAllObjects];
        [weakSelf loadData];
    }];
    self.tableView.mj_footer = [JstyleRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        page++;
        [weakSelf loadData];
    }];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArrM.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JstyleManagementPingLunCell *cell = [tableView dequeueReusableCellWithIdentifier:managementPingLunCellID forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.row < self.dataArrM.count) {
        JstyleManagementCommentModel *model = self.dataArrM[indexPath.row];
        
        cell.model = model;
        cell.titleTapBlock = ^{
//            JMArticleDetailViewController *detailVC = [JMArticleDetailViewController new];
//            detailVC.rid = model.id;
//            detailVC.titleName = model.title;
//            detailVC.imgUrl = model.poster;
//            [self.navigationController pushViewController:detailVC animated:YES];
            NSLog(@"跳转文章详情控制器");
        };
    }
    
    return cell;
}

- (void)loadData {
    
    
    JstyleNewsNetworkManager *manager = [JstyleNewsNetworkManager shareManager];
    
    NSDictionary *paramaters = @{
                                 @"uniqueid":[[JstyleToolManager sharedManager] getUniqueId]
                                 };
    
    [manager GET:MANAGER_COMMENT_URL parameters:paramaters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *responseData = responseObject;
        if ([responseData[@"code"] isEqualToString:@"1"]) {
            if (responseData[@"data"]) {
                NSArray *msgArr = responseData[@"data"];
                self.dataArray = [NSArray modelArrayWithClass:[JstyleManagementCommentModel class] json:msgArr];
            }
            [self.dataArrM addObjectsFromArray:self.dataArray];
            [self.tableView.mj_footer endRefreshing];
        } else if ([responseData[@"code"] isEqualToString:@"-1"]){
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }
        
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
        [SVProgressHUD dismiss];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        [SVProgressHUD dismiss];
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
