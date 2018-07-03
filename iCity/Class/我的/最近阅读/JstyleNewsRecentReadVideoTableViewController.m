//
//  JstyleNewsRecentReadVideoTableViewController.m
//  JstyleNews
//
//  Created by 数字跃动 on 2017/12/27.
//  Copyright © 2017年 JstyleNews. All rights reserved.
//

#import "JstyleNewsRecentReadVideoTableViewController.h"
#import "JstyleNewsMyCollectionVedioTableViewCell.h"
#import "JstyleNewsRecentReadModel.h"
#import "JstyleNewsPlaceholderView.h"
#import "JstyleNewsVideoDetailViewController.h"

@interface JstyleNewsRecentReadVideoTableViewController ()

@property (nonatomic, strong) NSMutableArray<JstyleNewsRecentReadModel *> *dataArray;
@property (nonatomic, strong) JstyleNewsPlaceholderView *placeholderView;

@end

static NSInteger page = 1;

static NSString *JstyleNewsMyCollectionVedioTableViewCellID = @"JstyleNewsMyCollectionVedioTableViewCellID";

@implementation JstyleNewsRecentReadVideoTableViewController

- (JstyleNewsPlaceholderView *)placeholderView {
    if (_placeholderView == nil) {
        _placeholderView = [[JstyleNewsPlaceholderView alloc] initWithFrame:[UIScreen mainScreen].bounds placeholderImage:[UIImage imageNamed:@"文章空白"] placeholderText:@"快去体会阅读的乐趣吧~"];
    }
    return _placeholderView;
}

- (NSMutableArray<JstyleNewsRecentReadModel *> *)dataArray {
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
    [self.tableView.mj_header beginRefreshing];
}

- (void)setupUI {
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = ISNightMode?kNightModeBackColor:kBackGroundColor;
    [self.tableView registerNib:[UINib nibWithNibName:@"JstyleNewsMyCollectionVedioTableViewCell" bundle:nil] forCellReuseIdentifier:JstyleNewsMyCollectionVedioTableViewCellID];
    self.tableView.estimatedRowHeight = 121.5;
    
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
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
     return ArticleImg_H + 31;
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    JstyleNewsMyCollectionVedioTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:JstyleNewsMyCollectionVedioTableViewCellID forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.row < self.dataArray.count) {
        cell.recentModel = self.dataArray[indexPath.row];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    JstyleNewsRecentReadModel *model = self.dataArray[indexPath.row];
    
    JstyleNewsVideoDetailViewController *videoDetailVC = [JstyleNewsVideoDetailViewController new];
    videoDetailVC.vid = model.id;
    videoDetailVC.videoUrl = model.url_sd;
    videoDetailVC.videoTitle = model.title;
    [self.navigationController pushViewController:videoDetailVC animated:YES];
}

- (void)loadData {
    
    JstyleNewsNetworkManager *manager = [JstyleNewsNetworkManager shareManager];
    
    NSDictionary *paramaters = @{
                                 @"uuid":[[JstyleToolManager sharedManager] getUDID],
                                 @"uid":[[JstyleToolManager sharedManager] getUserId],
                                 @"type":@"2",
                                 @"page":[NSString stringWithFormat:@"%zd",page]
                                 };
    
    [manager GETURL:RECENT_READ_URL parameters:paramaters success:^(id responseObject) {
        
        NSDictionary *dictionary = responseObject;
        
        if ([dictionary[@"code"] isEqualToString:@"1"]) {
            
            [self.placeholderView removeFromSuperview];
            self.placeholderView = nil;
            
            NSArray *currentArray = [NSArray modelArrayWithClass:[JstyleNewsMyCollectionModel class] json:dictionary[@"data"]];
            
            [self.dataArray addObjectsFromArray:currentArray];
            [self.tableView reloadData];
            
            [self.tableView.mj_header endRefreshing];
            
            if (currentArray.count != 0) {
                [self.tableView.mj_footer endRefreshing];
                if (currentArray.count < 10) {
                    page = 1;
                    [self.tableView.mj_footer endRefreshingWithNoMoreData];
                }
            } else {
                page = 1;
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

@end
