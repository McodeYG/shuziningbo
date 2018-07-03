//
//  ICityBoardcastTableViewController.m
//  HSQiCITY
//
//  Created by chunzheng wang on 2018/5/1.
//  Copyright © 2018年 chunzheng wang. All rights reserved.
//

#import "ICityBoardcastTableViewController.h"
#import "ICityBoradcastModel.h"
#import "ICityBoardcastTableViewCell.h"
#import "ICityFMViewController.h"

static NSInteger page = 1;
static NSString*const boardcellID = @"boardcellID";

@interface ICityBoardcastTableViewController ()

@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation ICityBoardcastTableViewController

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"广播";
    
//    UITableView * tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_W, SCREEN_H-YG_StatusAndNavightion_H-YG_SafeBottom_H) style:(UITableViewStylePlain)];
//    tableView.delegate = self;
//    tableView.dataSource = self;
//    [self.view addSubview:tableView];
//    self.tableView = tableView;
    
    __weak typeof(self) weakSelf = self;
    self.tableView.mj_header = [JstyleRefreshGiftHeader headerWithRefreshingBlock:^{
        page = 1;
        [weakSelf.dataArray removeAllObjects];
        [weakSelf loadData];
    }];
    self.tableView.mj_footer = [JstyleRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        page++;
        [weakSelf loadData];
    }];
    
    [self.tableView.mj_header beginRefreshing];
}
-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.tableView.backgroundColor = kNightModeBackColor;
    NSDictionary *navbarTitleTextAttributes = @{
                                                NSForegroundColorAttributeName:kNightModeTitleColor,
                                                NSFontAttributeName:[UIFont systemFontOfSize:18]
                                                };
    [self.navigationController.navigationBar setTitleTextAttributes:navbarTitleTextAttributes];
    //    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:kNavigationBarColor] forBarMetrics:UIBarMetricsDefault];
    //导航栏
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:kNightModeBackColor] forBarMetrics:UIBarMetricsDefault];
}

-(void)registCell{
    self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    [self.tableView registerClass:[ICityBoardcastTableViewCell class] forCellReuseIdentifier:boardcellID];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    //去掉多余分割线
    return  [UIView new];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ICityBoardcastTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:boardcellID forIndexPath:indexPath];
    cell.model = self.dataArray[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ICityFMViewController *fmVC = [ICityFMViewController new];
    fmVC.index = indexPath.row;
    fmVC.fmDatas = self.dataArray;
    [self.navigationController pushViewController:fmVC animated:YES];
}

-(void)loadData {
    
    JstyleNewsNetworkManager *manger = [JstyleNewsNetworkManager shareManager];
    NSDictionary *paramaters = @{
                                 @"page":[NSString stringWithFormat:@"%zd",page]
                                 };
    [manger GETURL:Culture_Broadcast_List_URL parameters:paramaters success:^(id responseObject) {
        
        if ([responseObject[@"code"] isEqualToString:@"1"]) {
            
            NSArray *currentData = [NSArray modelArrayWithClass:[ICityBoradcastModel class] json:responseObject[@"data"]];
            
            [self.dataArray addObjectsFromArray:currentData];
            
            [self.tableView reloadData];
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
            
        } else {
            
            [self.tableView reloadData];
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }
        
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
}

-(UIStatusBarStyle)preferredStatusBarStyle {
    
    return ISNightMode?UIStatusBarStyleLightContent:UIStatusBarStyleDefault;
}

@end
