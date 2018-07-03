//
//  JstyleManagementZhiBoTableViewController.m
//  Exquisite
//
//  Created by 王磊 on 2017/10/10.
//  Copyright © 2017年 Jstyle. All rights reserved.
//

#import "JstyleManagementZhiBoTableViewController.h"
#import "JstyleManagementZhiBoCell.h"
#import "JstyleManagementTableListModel.h"

@interface JstyleManagementZhiBoTableViewController ()

@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, strong) NSMutableArray *dataArrM;

@end

static NSString *managementZhiBoCellID = @"managementZhiBoCellID";
static NSInteger page = 1;
@implementation JstyleManagementZhiBoTableViewController

- (NSMutableArray *)dataArrM {
    if (_dataArrM == nil) {
        _dataArrM = [NSMutableArray array];
    }
    return _dataArrM;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = ISNightMode?kNightModeBackColor:kWhiteColor;
    self.tableView.backgroundColor = ISNightMode?kNightModeBackColor:kWhiteColor;
    [self.tableView registerNib:[UINib nibWithNibName:@"JstyleManagementZhiBoCell" bundle:nil] forCellReuseIdentifier:managementZhiBoCellID];
    self.tableView.estimatedRowHeight = 157;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    //默认已发布
    self.statusType = JstyleManagementZhiBoTableViewControllerStatusTypeYiFaBu;
    
    [SVProgressHUD showWithStatus:@"正在加载"];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    [self loadDataWithStatusType:JstyleManagementZhiBoTableViewControllerStatusTypeYiFaBu];
    
    __weak typeof(self) weakSelf = self;
    self.tableView.mj_header = [JstyleRefreshGiftHeader headerWithRefreshingBlock:^{
        page = 1;
        [weakSelf.dataArrM removeAllObjects];
        [weakSelf loadDataWithStatusType:JstyleManagementZhiBoTableViewControllerStatusTypeYiFaBu];
    }];
    self.tableView.mj_footer = [JstyleRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        page++;
        [weakSelf loadDataWithStatusType:JstyleManagementZhiBoTableViewControllerStatusTypeYiFaBu];
    }];
    
    self.zhiBoBlock = ^(JstyleManagementZhiBoTableViewControllerStatusType statusType) {
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
//        JstyleVerticalLiveDetailViewController *playerVC = [JstyleVerticalLiveDetailViewController new];
//        playerVC.vid = model.id;
//        playerVC.urlStr = model.url_sd;
//        playerVC.roomId = model.roomid;
//        playerVC.titleStr = model.title;
//        LBNavigationController *lbnavigationVC = [[LBNavigationController alloc] initWithRootViewController:playerVC];
//        [self.navigationController presentViewController:lbnavigationVC animated:YES completion:nil];
        NSLog(@"进入竖屏直播详情");
    }
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArrM.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JstyleManagementZhiBoCell *cell = [tableView dequeueReusableCellWithIdentifier:managementZhiBoCellID forIndexPath:indexPath];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.row < self.dataArrM.count) {
        cell.model = self.dataArrM[indexPath.row];
    }
    
    return cell;
}

- (void)loadDataWithStatusType:(JstyleManagementZhiBoTableViewControllerStatusType)statusType {
    
    JstyleNewsNetworkManager *manager = [JstyleNewsNetworkManager shareManager];
    
    NSMutableDictionary *paramaters = [NSMutableDictionary dictionary];
    [paramaters setObject:[[JstyleToolManager sharedManager] getUniqueId] forKey:@"uniqueid"];
    [paramaters setObject:@"3" forKey:@"type"];
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

@end
