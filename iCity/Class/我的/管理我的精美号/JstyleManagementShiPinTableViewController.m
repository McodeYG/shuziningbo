//
//  JstyleManagementShiPinTableViewController.m
//  Exquisite
//
//  Created by 数字跃动 on 2017/10/10.
//  Copyright © 2017年 Jstyle. All rights reserved.
//

#import "JstyleManagementShiPinTableViewController.h"
#import "JstyleManagementShiPinCell.h"
#import "JstyleManagementTableListModel.h"

@interface JstyleManagementShiPinTableViewController ()

@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, strong) NSMutableArray *dataArrM;

@end

static NSString *managementShiPinCellID = @"managementShiPinCellID";
static NSInteger page = 1;
@implementation JstyleManagementShiPinTableViewController

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
    [self.tableView registerNib:[UINib nibWithNibName:@"JstyleManagementShiPinCell" bundle:nil] forCellReuseIdentifier:managementShiPinCellID];
    self.tableView.estimatedRowHeight = 157;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    //默认已发布
    self.statusType = JstyleManagementShiPinTableViewControllerStatusTypeYiFaBu;
    
    [SVProgressHUD showWithStatus:@"正在加载"];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    [self loadDataWithStatusType:JstyleManagementShiPinTableViewControllerStatusTypeYiFaBu];
    
    __weak typeof(self)weakSelf = self;
    self.tableView.mj_header = [JstyleRefreshGiftHeader headerWithRefreshingBlock:^{
        page = 1;
        [weakSelf.dataArrM removeAllObjects];
        [weakSelf loadDataWithStatusType:JstyleManagementShiPinTableViewControllerStatusTypeYiFaBu];
    }];
    self.tableView.mj_footer = [JstyleRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        page++;
        [weakSelf loadDataWithStatusType:JstyleManagementShiPinTableViewControllerStatusTypeYiFaBu];
    }];

    self.shiPinBlock = ^(JstyleManagementShiPinTableViewControllerStatusType statusType) {
        page = 1;
        [weakSelf.dataArrM removeAllObjects];
        [weakSelf.tableView reloadData];
        [SVProgressHUD showWithStatus:@"正在加载"];
        [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
        [weakSelf loadDataWithStatusType:statusType];
    };
    
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    //发通知 移除下拉小菜单
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ManagementMyJstyleAccountRemoveListViewNotification" object:nil];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //发通知 移除下拉小菜单
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ManagementMyJstyleAccountRemoveListViewNotification" object:nil];
    
    if (indexPath.row < self.dataArrM.count) {
        JstyleManagementTableListModel *model = self.dataArrM[indexPath.row];
        
//        JstyleVideoPlayerViewController *videoPlayerVC = [JstyleVideoPlayerViewController new];
//        videoPlayerVC.liveUrlStr = model.url;
//        videoPlayerVC.liveName = model.title;
//        videoPlayerVC.liveID = model.id;
//        videoPlayerVC.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:model.poster]]];
//        [self.navigationController pushViewController:videoPlayerVC animated:YES];
        NSLog(@"跳转视频详情");
    }
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArrM.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JstyleManagementShiPinCell *cell = [tableView dequeueReusableCellWithIdentifier:managementShiPinCellID forIndexPath:indexPath];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    //赋值模型
    if (indexPath.row < self.dataArrM.count) {
        cell.model = self.dataArrM[indexPath.row];
    }
    
    return cell;
}

- (void)loadDataWithStatusType:(JstyleManagementShiPinTableViewControllerStatusType)statusType {
    
    
    JstyleNewsNetworkManager *manager = [JstyleNewsNetworkManager shareManager];
    
    NSMutableDictionary *paramaters = [NSMutableDictionary dictionary];
    [paramaters setObject:[[JstyleToolManager sharedManager] getUniqueId] forKey:@"uniqueid"];
    [paramaters setObject:@"2" forKey:@"type"];
    [paramaters setObject:[NSString stringWithFormat:@"%zd",page] forKey:@"page"];
    [paramaters setObject:[NSString stringWithFormat:@"%zd",statusType] forKey:@"status"];
    
    [manager GET:MANAGER_LIST_URL parameters:paramaters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *responseData = responseObject;
        if ([responseData[@"code"] isEqualToString:@"1"]) {
            if (responseData[@"data"]) {
                NSArray *msgArr = responseData[@"data"];
                self.dataArray = [NSArray modelArrayWithClass:[JstyleManagementTableListModel class] json:msgArr];
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
