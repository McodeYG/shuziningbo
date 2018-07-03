//
//  JstyleNewsMyCollectionVideoTableViewController.m
//  JstyleNews
//
//  Created by 数字跃动 on 2017/12/25.
//  Copyright © 2017年 JstyleNews. All rights reserved.
//

#import "JstyleNewsMyCollectionVideoTableViewController.h"
#import "JstyleNewsMyCollectionVedioTableViewCell.h"
#import "JstyleNewsMyCollectionModel.h"
#import "JstyleNewsVideoDetailViewController.h"
#import "JstyleNewsPlaceholderView.h"

@interface JstyleNewsMyCollectionVideoTableViewController ()

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) JstyleNewsPlaceholderView *placeholderView;

@end

static NSInteger page = 1;

static NSString *JstyleNewsMyCollectionVedioTableViewCellID = @"JstyleNewsMyCollectionVedioTableViewCellID";

@implementation JstyleNewsMyCollectionVideoTableViewController

- (JstyleNewsPlaceholderView *)placeholderView {
    if (_placeholderView == nil) {
        _placeholderView = [[JstyleNewsPlaceholderView alloc] initWithFrame:[UIScreen mainScreen].bounds placeholderImage:[UIImage imageNamed:@"收藏空白"] placeholderText:@"快去把那些精彩内容占为己有吧~"];
    }
    return _placeholderView;
}

- (NSMutableArray *)dataArray {
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.tableView.mj_header beginRefreshing];
}

- (void)setupUI {
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = ISNightMode?kNightModeBackColor:kBackGroundColor;
    [self.tableView registerNib:[UINib nibWithNibName:@"JstyleNewsMyCollectionVedioTableViewCell" bundle:nil] forCellReuseIdentifier:JstyleNewsMyCollectionVedioTableViewCellID];
    self.tableView.estimatedRowHeight = 121.5;
    
    [self addMJHeaderFooter];
}

- (void)addMJHeaderFooter {
    
    __weak typeof(self)weakSelf = self;
    self.tableView.mj_header = [JstyleRefreshGiftHeader headerWithRefreshingBlock:^{
        page = 1;
        [weakSelf.dataArray removeAllObjects];
        [weakSelf loadDatas];
    }];
    
    self.tableView.mj_footer = [JstyleRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        page++;
        [weakSelf loadDatas];
    }];
}

#pragma mark - UITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return ArticleImg_H + 31;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    JstyleNewsMyCollectionVedioTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:JstyleNewsMyCollectionVedioTableViewCellID forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (indexPath.row < self.dataArray.count) {
        cell.model = self.dataArray[indexPath.row];
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    JstyleNewsVideoDetailViewController *video = [JstyleNewsVideoDetailViewController new];
    if (indexPath.row < self.dataArray.count) {
        JstyleNewsMyCollectionModel * model = self.dataArray[indexPath.row];
        video.vid = model.id;
        video.videoUrl = model.url_sd;
        video.videoTitle = model.title;
        video.videoType = model.videoType;
        
    }
    [self.navigationController pushViewController:video animated:YES];
}

- (void)loadDatas {
    
    JstyleToolManager *tool = [JstyleToolManager sharedManager];
    
    JstyleNewsNetworkManager *manager = [JstyleNewsNetworkManager shareManager];
    
    NSDictionary *paramaters = @{
                                 @"uid":[tool getUserId],
                                 @"uuid":[tool getUDID],
                                 @"type":@"2",
                                 @"page":[NSString stringWithFormat:@"%ld",(long)page]
                                 };
    [manager GETURL:USERINFO_FOLLOWLIST_URL parameters:paramaters success:^(id responseObject) {
        
        NSDictionary *dictionary = responseObject;

        if ([dictionary[@"code"] isEqualToString:@"1"]) {
            NSLog(@"马永刚 = %@",responseObject);
            NSArray *currentData = [NSArray modelArrayWithClass:[JstyleNewsMyCollectionModel class] json:dictionary[@"data"]];
            [self.placeholderView removeFromSuperview];
            self.placeholderView = nil;
            
            if (currentData.count != 0) {
                
                [self.dataArray addObjectsFromArray:currentData];
                
                [self.tableView reloadData];
                
                [self.tableView.mj_header endRefreshing];
                if (currentData.count < 10) {
                    [self.tableView.mj_footer endRefreshingWithNoMoreData];
                } else {
                    [self.tableView.mj_footer endRefreshing];
                }
            } else {
                page = 1;
                [self.tableView reloadData];
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
                [self.tableView.mj_header endRefreshing];
            }
        } else {
            if (page == 1) {
                [self.tableView addSubview:self.placeholderView];
            }
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
            [self.tableView.mj_header endRefreshing];
        }
        
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
        [self.tableView.mj_header endRefreshing];
        
    }];
}

@end
