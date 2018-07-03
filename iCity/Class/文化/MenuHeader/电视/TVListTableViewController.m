//
//  TVListTableViewController.m
//  iCity
//
//  Created by mayonggang on 2018/6/21.
//  Copyright © 2018年 LongYuan. All rights reserved.
//

#import "TVListTableViewController.h"
#import "JstyleNewsVideoDetailViewController.h"
#import "ICityTVModel.h"


static NSInteger page = 1;
@interface TVListTableViewController ()
@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation TVListTableViewController


- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}


-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.tableView.backgroundColor = kNightModeBackColor;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"电视台";
    
    
    [self registCell];
    
    self.tableView.showsVerticalScrollIndicator = NO;
    
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
//    self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 10, 0, 10);
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
    kweakSelf
    [cell setFocusBlock:^(ICityTVModel *model) {
        if ([[JstyleToolManager sharedManager] isTourist]) {
            [[JstyleToolManager sharedManager] loginInViewController];
            return;
        }
        [weakSelf addJstyleNewsManagerSubscriptionWithModel:model];
        
    }];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 96;
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
    videoVC.videoname = model.videoname;
    [self.navigationController pushViewController:videoVC animated:YES];
    
}
#pragma mark - 下载数据
- (void)loadData {
    JstyleNewsNetworkManager *manger = [JstyleNewsNetworkManager shareManager];
    
    NSString * uid = [[JstyleToolManager sharedManager] getUserId];
    if (![uid isNotBlank]) {
        uid = @" ";
    }
    if ([_sendId isNotBlank]) {
        
        NSDictionary *paramaters = @{
                                     @"page":[NSString stringWithFormat:@"%zd",page],
                                     @"uid":uid,
                                     @"tvcid":_sendId
                                     };
        [manger GETURL:Culture_TV_List_URL parameters:paramaters success:^(id responseObject) {
            
            if ([responseObject[@"code"] isEqualToString:@"1"]) {
                
                if (page == 0) {
                    [self.dataArray removeAllObjects];
                }
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
    
    }else{
        NSLog(@"没有_sendId");
    }
    
}

//添加关注电视节目
- (void)addJstyleNewsManagerSubscriptionWithModel:(ICityTVModel *)model
{
    if ([[JstyleToolManager sharedManager] isTourist]) {
        [[JstyleToolManager sharedManager] loginInViewController];
        return;
    }
    NSDictionary *parameters = @{@"platform_type":@"2",
                                 @"did":model.author_did,
                                 @"uid":[[JstyleToolManager sharedManager] getUserId]
                                 };
    NSLog(@"[[JstyleToolManager sharedManager] getUserId] = %@",[[JstyleToolManager sharedManager] getUserId]);
    [[JstyleNewsNetworkManager shareManager] GETURL:MANAGER_SUBSCRIPTION_URL parameters:parameters success:^(id responseObject) {
        if ([responseObject[@"code"] integerValue] == 1) {
            NSString *followType = responseObject[@"data"][@"follow_type"];

            for (ICityTVModel * mo in self.dataArray) {
                if ([mo.author_did isEqualToString:model.author_did]) {
                    mo.isShowAuthor = followType;
                }
            }
            
            [self.tableView reloadData];
        }else{
            if ([responseObject[@"data"] isKindOfClass:[NSString class]]) {
                ZTShowAlertMessage(responseObject[@"data"]);
            }
        }
    } failure:nil];
}





@end
