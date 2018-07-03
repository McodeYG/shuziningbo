//
//  JstyleManagementWenZhangTableViewController.m
//  Exquisite
//
//  Created by 数字跃动 on 2017/10/9.
//  Copyright © 2017年 Jstyle. All rights reserved.
//

#import "JstyleManagementWenZhangTableViewController.h"
#import "JstyleManagementWenZhangCell.h"
#import "JstyleManagementTableListModel.h"

@interface JstyleManagementWenZhangTableViewController ()

@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, strong) NSMutableArray *dataArrM;

@property (nonatomic, strong) UILabel *nomoreLabel;

@end

static NSString *managementWenZhangCellID = @"managementWenZhangCellID";
static NSInteger page = 1;
@implementation JstyleManagementWenZhangTableViewController

- (UILabel *)nomoreLabel {
    if (_nomoreLabel == nil) {
        _nomoreLabel = [UILabel new];
        _nomoreLabel.text = @"暂无文章";
        _nomoreLabel.textColor = kDarkNineColor;
        _nomoreLabel.font = [UIFont systemFontOfSize:13];
    }
    return _nomoreLabel;
}

- (NSMutableArray *)dataArrM {
    if (_dataArrM == nil) {
        _dataArrM = [NSMutableArray array];
    }
    return _dataArrM;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = ISNightMode?kNightModeBackColor:kWhiteColor;
    //默认选择原创 已发布
    self.tOrFOriginalType = JstyleManagementWenZhangTableViewControllerTOrFOriginalTypeYuanChuang;
    self.statusType = JstyleManagementWenZhangTableViewControllerStatusTypeYiFaBu;
    
    [SVProgressHUD showWithStatus:@"正在加载"];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    [self loadDataWithTOrFOriginalType:JstyleManagementWenZhangTableViewControllerTOrFOriginalTypeYuanChuang statusType:JstyleManagementWenZhangTableViewControllerStatusTypeYiFaBu];
    
    self.tableView.backgroundColor = ISNightMode?kNightModeBackColor:kWhiteColor;
    [self.tableView registerNib:[UINib nibWithNibName:@"JstyleManagementWenZhangCell" bundle:nil] forCellReuseIdentifier:managementWenZhangCellID];
    self.tableView.estimatedRowHeight = 157;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    __weak typeof(self)weakSelf = self;
    self.tableView.mj_header = [JstyleRefreshGiftHeader headerWithRefreshingBlock:^{
        page = 1;
        [weakSelf.dataArrM removeAllObjects];
        [weakSelf loadDataWithTOrFOriginalType:self.tOrFOriginalType statusType:self.statusType];
    }];
    self.tableView.mj_footer = [JstyleRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        page++;
        [weakSelf loadDataWithTOrFOriginalType:self.tOrFOriginalType statusType:self.statusType];
    }];
    
    self.wenZhangBlock = ^(JstyleManagementWenZhangTableViewControllerTOrFOriginalType tOrFOriginalType, JstyleManagementWenZhangTableViewControllerStatusType statusType) {
        page = 1;
        [weakSelf.dataArrM removeAllObjects];
        [weakSelf.tableView reloadData];
        [SVProgressHUD showWithStatus:@"正在加载"];
        [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
        [weakSelf loadDataWithTOrFOriginalType:tOrFOriginalType statusType:statusType];
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
        if ([model.isImageArticle integerValue] == 1) {
//            JstylePictureTextViewController *pictureTextVC = [JstylePictureTextViewController new];
//            pictureTextVC.picRid = model.id;
//            [self.navigationController pushViewController:pictureTextVC animated:YES];
            NSLog(@"跳转图文专辑控制器");
        } else {
//            JMArticleDetailViewController *detailVC = [JMArticleDetailViewController new];
//            detailVC.rid = model.id;
//            detailVC.titleName = model.title;
//            detailVC.imgUrl = model.poster;
//            [self.navigationController pushViewController:detailVC animated:YES];
            NSLog(@"跳转文章详情控制器");
        }
    }
    
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArrM.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JstyleManagementWenZhangCell *cell = [tableView dequeueReusableCellWithIdentifier:managementWenZhangCellID forIndexPath:indexPath];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    //赋值模型
    if (indexPath.row < self.dataArrM.count) {
        cell.model = self.dataArrM[indexPath.row];
    }
    
    return cell;
}

- (void)loadDataWithTOrFOriginalType:(JstyleManagementWenZhangTableViewControllerTOrFOriginalType) tOrFOriginalType statusType:(JstyleManagementWenZhangTableViewControllerStatusType)statusType {
    
    
    JstyleNewsNetworkManager *manager = [JstyleNewsNetworkManager shareManager];
    
    NSMutableDictionary *paramaters = [NSMutableDictionary dictionary];
    [paramaters setObject:[[JstyleToolManager sharedManager] getUniqueId] forKey:@"uniqueid"];
    [paramaters setObject:@"1" forKey:@"type"];
    [paramaters setObject:[NSString stringWithFormat:@"%zd",page] forKey:@"page"];
    [paramaters setObject:[NSString stringWithFormat:@"%zd",tOrFOriginalType] forKey:@"TOrFOriginal"];
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
