//
//  JstyleNewsSearchVideosViewController.m
//  JstyleNews
//
//  Created by JingHongMuYun on 2017/12/1.
//  Copyright © 2017年 JstyleNews. All rights reserved.
//

#import "JstyleNewsSearchVideosViewController.h"
#import "JstyleNewsPlaceholderView.h"
#import "SearchVideoCell.h"
#import "JstyleNewsVideoDetailViewController.h"

@interface JstyleNewsSearchVideosViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) JstyleNewsBaseTableView *tableView;

@property (nonatomic, strong) NSMutableArray *videoArray;

@property (nonatomic, strong) JstyleNewsPlaceholderView *placeholderView;

@end

static NSInteger page = 1;
@implementation JstyleNewsSearchVideosViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.view.backgroundColor = kWhiteColor;
    [self addTableView];
    [self addReshAction];
    [self.tableView.mj_header beginRefreshing];
}

- (void)zj_viewDidLoadForIndex:(NSInteger)index {
    
}

- (void)addReshAction
{
    __weak typeof(self)weakSelf = self;
    self.tableView.mj_header = [JstyleRefreshGiftHeader headerWithRefreshingBlock:^{
        page = 1;
        [weakSelf.videoArray removeAllObjects];
        [weakSelf loadJstyleNewsSearchVideoDataSource];
    }];
    
    self.tableView.mj_footer = [JstyleRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        page ++;
        [weakSelf loadJstyleNewsSearchVideoDataSource];
    }];
}

- (void)addTableView
{
    _tableView = [[JstyleNewsBaseTableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) style:(UITableViewStylePlain)];
    _tableView.separatorInset = UIEdgeInsetsMake(0, 15, 0, 15);
//    _tableView.separatorColor = kSingleLineColor;
//    _tableView.backgroundColor = kWhiteColor;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    self.tableView.tableFooterView = [UIView new];
    
    [_tableView registerNib:[UINib nibWithNibName:@"JstyleNewsSearchVideosViewCell" bundle:nil] forCellReuseIdentifier:@"JstyleNewsSearchVideosViewCell"];
    
    [self.view addSubview:_tableView];
    _tableView.sd_layout
    .topEqualToView(self.view)
    .bottomEqualToView(self.view)
    .leftEqualToView(self.view)
    .rightEqualToView(self.view);
}

#pragma mark -- tableView的代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.videoArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SearchVideoCell * cell = [SearchVideoCell initWithTableView:tableView];
    
    if (indexPath.row < self.videoArray.count) {
        cell.model = self.videoArray[indexPath.row];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 30+ArticleImg_H;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row >= self.videoArray.count) return;
    SearchModel *model = self.videoArray[indexPath.row];
    JstyleNewsVideoDetailViewController *jstyleNewsVideoDVC = [JstyleNewsVideoDetailViewController new];
    jstyleNewsVideoDVC.videoUrl = model.url_sd;
    jstyleNewsVideoDVC.videoTitle = model.title;
    jstyleNewsVideoDVC.vid = model.sendId;
    jstyleNewsVideoDVC.videoType = model.videoType;
    [self.navigationController pushViewController:jstyleNewsVideoDVC animated:YES];
}

#pragma mark - 获取数据
- (void)loadJstyleNewsSearchVideoDataSource
{
    NSDictionary *parameters = @{@"page":[NSString stringWithFormat:@"%d",(int)page],
                                 @"key":self.keyword,
                                 @"uid":[[JstyleToolManager sharedManager] getUserId],
                                 @"uuid":[[JstyleToolManager sharedManager] getUDID],
                                 @"type":@"3"
                                 };
    [[JstyleNewsNetworkManager shareManager] GETURL:SEARCH_RESULT_URL parameters:parameters success:^(id responseObject) {
        
        if ([responseObject[@"code"] integerValue] != 1) {
            if (self.videoArray.count) {
                [self.tableView.mj_header endRefreshing];
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }else{
                [self.tableView.mj_header endRefreshing];
                [self.tableView.mj_footer endRefreshing];
            }
            [self addPlaceholderView];
            return;
        }
        
        [self.videoArray addObjectsFromArray:[NSArray modelArrayWithClass:[SearchModel class] json:responseObject[@"data"][@"resultList"]]];
        
        [self addPlaceholderView];
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    } failure:^(NSError *error) {
        [self addPlaceholderView];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
}

- (void)addPlaceholderView{
    [_placeholderView removeFromSuperview];
    _placeholderView = [[JstyleNewsPlaceholderView alloc] initWithFrame:[UIScreen mainScreen].bounds placeholderImage:[UIImage imageNamed:@"文章空白"] placeholderText:@"暂时没有搜索到视频哦~"];
    
    if (!self.videoArray.count) {
        [self.placeholderView removeFromSuperview];
        [self.tableView addSubview:self.placeholderView];
    }else{
        [self.placeholderView removeFromSuperview];
    }
}

- (NSMutableArray *)videoArray
{
    if (!_videoArray) {
        _videoArray = [NSMutableArray array];
    }
    return _videoArray;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
