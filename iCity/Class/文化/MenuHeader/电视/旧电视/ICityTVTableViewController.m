//
//  ICityTVTableViewController.m
//  ICityTable
//
//  Created by chunzheng wang on 2018/5/1.
//  Copyright © 2018年 chunzheng wang. All rights reserved.
//

#import "ICityTVTableViewController.h"
#import "JstyleNewsVideoDetailViewController.h"
#import "ICityTVModel.h"


static NSInteger page = 1;
@interface ICityTVTableViewController ()

@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation ICityTVTableViewController

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}


-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.tableView.backgroundColor = kNightModeBackColor;

    [self.navigationController setNavigationBarHidden:NO animated:YES];
    NSDictionary *navbarTitleTextAttributes = @{
                                                NSForegroundColorAttributeName:kNightModeTitleColor,
                                                NSFontAttributeName:[UIFont systemFontOfSize:18]
                                                };
    [self.navigationController.navigationBar setTitleTextAttributes:navbarTitleTextAttributes];
    //    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:kNavigationBarColor] forBarMetrics:UIBarMetricsDefault];
    //导航栏
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:kNightModeBackColor] forBarMetrics:UIBarMetricsDefault];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"电视台";
    
    
    [self registCell];
    
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

-(void)registCell{
    self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    [self.tableView registerClass:[ICityTVTableViewCell class] forCellReuseIdentifier:cellID];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    //去掉多余分割线
    return  [UIView new];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ICityTVTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
    
    cell.model = self.dataArray[indexPath.row];
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 95;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSLog(@"进入电视详情");
    ICityTVModel *model = self.dataArray[indexPath.item];
    JstyleNewsVideoDetailViewController *videoVC = [JstyleNewsVideoDetailViewController new];
    videoVC.videoUrl = model.address;
    videoVC.videoTitle = model.videoname;
    videoVC.vid = model.vid;
    videoVC.videoType = model.videoType;
    [self.navigationController pushViewController:videoVC animated:YES];
    
}
- (void)loadData {
    JstyleNewsNetworkManager *manger = [JstyleNewsNetworkManager shareManager];
    NSDictionary *paramaters = @{
                                 @"page":[NSString stringWithFormat:@"%zd",page]
                                 };
    [manger GETURL:Culture_TV_List_URL parameters:paramaters success:^(id responseObject) {
        
        if ([responseObject[@"code"] isEqualToString:@"1"]) {
            
            NSArray *currentData = [NSArray modelArrayWithClass:[ICityTVModel class] json:responseObject[@"data"]];
            
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

- (NSArray *)SettingOtherData{
    if (_SettingOtherData == nil) {
        _SettingOtherData = [NSArray array];
    }
    return _SettingOtherData;
}


-(UIStatusBarStyle)preferredStatusBarStyle {
    
    return ISNightMode?UIStatusBarStyleLightContent:UIStatusBarStyleDefault;
}

@end
