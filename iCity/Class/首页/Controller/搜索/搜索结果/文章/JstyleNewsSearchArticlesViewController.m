//
//  JstyleNewsSearchArticlesViewController.m
//  JstyleNews
//
//  Created by JingHongMuYun on 2017/12/12.
//  Copyright © 2017年 JstyleNews. All rights reserved.
//

#import "JstyleNewsSearchArticlesViewController.h"
#import "JstyleNewsPlaceholderView.h"

#import "JstylePictureTextViewController.h"
#import "JstyleNewsArticleDetailViewController.h"
#import "SearchImageArticleCell.h"
#import "SearchTextArticleCell.h"

@interface JstyleNewsSearchArticlesViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) JstyleNewsBaseTableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, strong) JstyleNewsPlaceholderView *placeholderView;

@end

static NSInteger page = 1;
@implementation JstyleNewsSearchArticlesViewController

- (void)viewDidLoad {
    [super viewDidLoad];

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
        [weakSelf.dataArray removeAllObjects];
        [weakSelf loadJstyleNewsSearchArticleDataSource];
    }];
    
    self.tableView.mj_footer = [JstyleRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        page ++;
        [weakSelf loadJstyleNewsSearchArticleDataSource];
    }];
}

- (void)addTableView
{
    _tableView = [[JstyleNewsBaseTableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) style:(UITableViewStylePlain)];
    _tableView.separatorInset = UIEdgeInsetsMake(0, 15, 0, 15);
    _tableView.delegate = self;
    _tableView.dataSource = self;
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    self.tableView.tableFooterView = [UIView new];
    
    [_tableView registerNib:[UINib nibWithNibName:@"JstyleNewsSearchArticlesViewCell" bundle:nil] forCellReuseIdentifier:@"JstyleNewsSearchArticlesViewCell"];
    
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
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    SearchModel * model = self.dataArray[indexPath.row];
    if ([model.head_type integerValue]==1) {
        
        SearchTextArticleCell * cell = [SearchTextArticleCell initWithTableView:tableView];
        cell.model = model;
        return cell;
        
    }else{//三图
        SearchImageArticleCell * cell = [SearchImageArticleCell initWithTableView:tableView];
        cell.model = model;
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SearchModel * model = self.dataArray[indexPath.row];
    if ([model.head_type integerValue]==2) {//三图
        
        CGRect frame = [model.title getAttributedStringRectWithSpace:3
                                                                withFont:18
                                                               withWidth:(SCREEN_W-20)];
        CGFloat img_W = ArticleImg_W;
        CGFloat img_H = img_W/16*10;
        
        return 10+frame.size.height+10+img_H+42;
        
    } else {//1图
        if ([model.poster isNotBlank]) {
            return 30+ArticleImg_H;
        } else {
            CGRect frame = [model.title getAttributedStringRectWithSpace:3
                                                                withFont:18
                                                               withWidth:(SCREEN_W-20)];
            return 10+15+12+frame.size.height+31.0;
        }
        
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row >= self.dataArray.count) return;
    SearchModel *model = self.dataArray[indexPath.row];
    if ([model.isImageArticle integerValue] == 1) {
        //图集
        JstylePictureTextViewController *jstyleNewsPictureTVC = [JstylePictureTextViewController new];
        jstyleNewsPictureTVC.rid = model.sendId;
        [self.navigationController pushViewController:jstyleNewsPictureTVC animated:YES];
    }else{
        //文章
        JstyleNewsArticleDetailViewController *jstyleNewsArticleDVC = [JstyleNewsArticleDetailViewController new];
        jstyleNewsArticleDVC.rid = model.sendId;
        [self.navigationController pushViewController:jstyleNewsArticleDVC animated:YES];
    }
}

#pragma mark - 获取数据
- (void)loadJstyleNewsSearchArticleDataSource
{
    NSDictionary *parameters = @{@"page":[NSString stringWithFormat:@"%ld",page],
                                 @"key":self.keyword,
                                 @"uid":[[JstyleToolManager sharedManager] getUserId],
                                 @"uuid":[[JstyleToolManager sharedManager] getUDID],
                                 @"type":@"2"
                                 };
    [[JstyleNewsNetworkManager shareManager] GETURL:SEARCH_RESULT_URL parameters:parameters success:^(id responseObject) {
        
        if ([responseObject[@"code"] integerValue] != 1) {
            if (self.dataArray.count) {
                [self.tableView.mj_header endRefreshing];
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }else{
                [self.tableView.mj_header endRefreshing];
                [self.tableView.mj_footer endRefreshing];
            }
            [self addPlaceholderView];
            return;
        }
        
        [self.dataArray addObjectsFromArray:[NSArray modelArrayWithClass:[SearchModel class] json:responseObject[@"data"][@"resultList"]]];
        
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
    _placeholderView = [[JstyleNewsPlaceholderView alloc] initWithFrame:[UIScreen mainScreen].bounds placeholderImage:[UIImage imageNamed:@"文章空白"] placeholderText:@"暂时没有搜索到文章哦~"];
    
    if (!self.dataArray.count) {
        [self.placeholderView removeFromSuperview];
        [self.tableView addSubview:self.placeholderView];
    }else{
        [self.placeholderView removeFromSuperview];
    }
}

- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
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


