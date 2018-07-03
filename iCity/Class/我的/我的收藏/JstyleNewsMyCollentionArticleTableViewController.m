//
//  JstyleNewsMyCollentionArticleTableViewController.m
//  JstyleNews
//
//  Created by 王磊 on 2017/12/22.
//  Copyright © 2017年 JstyleNews. All rights reserved.
//

#import "JstyleNewsMyCollentionArticleTableViewController.h"
#import "JstyleNewsMyCollectionArticleTableViewCell.h"
#import "JstyleNewsMyCollectionModel.h"
#import "JstyleNewsArticleDetailViewController.h"
#import "JstyleNewsPlaceholderView.h"

@interface JstyleNewsMyCollentionArticleTableViewController ()

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) JstyleNewsPlaceholderView *placeholderView;

@end

static NSInteger page = 1;

static NSString *JstyleNewsMyCollectionArticleTableViewCellID = @"JstyleNewsMyCollectionArticleTableViewCellID";

@implementation JstyleNewsMyCollentionArticleTableViewController

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
    [self.tableView registerNib:[UINib nibWithNibName:@"JstyleNewsMyCollectionArticleTableViewCell" bundle:nil] forCellReuseIdentifier:JstyleNewsMyCollectionArticleTableViewCellID];
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
    if (indexPath.row==self.dataArray.count||indexPath.row>self.dataArray.count) {
        return 0;
    }
    JstyleNewsMyCollectionModel * model = self.dataArray[indexPath.row];
    if ([model.poster isNotBlank]) {
        return ArticleImg_H + 31;
    } else {//无图情况
        
        CGRect labelF  = [[NSString stringWithFormat:@"%@",model.title] getAttributedStringRectWithSpace:3
                                                                                                withFont:18
                                                                                               withWidth:SCREEN_W-20];
        return labelF.size.height+15+12+31;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    JstyleNewsMyCollectionArticleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:JstyleNewsMyCollectionArticleTableViewCellID forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (indexPath.row < self.dataArray.count) {
        cell.model = self.dataArray[indexPath.row];
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    JstyleNewsArticleDetailViewController *articleVC = [JstyleNewsArticleDetailViewController new];
    if (indexPath.row < self.dataArray.count) {
        JstyleNewsMyCollectionModel * dataModel = self.dataArray[indexPath.row];
        articleVC.rid = dataModel.id;
        JstyleNewsArticleDetailModel * model = [JstyleNewsArticleDetailModel new];
        model.title = dataModel.title;
        model.content = dataModel.content;
        model.author_img = dataModel.author_img;
        model.author_did = dataModel.author_did;
        model.author_name = dataModel.author_name;
        
        model.poster = dataModel.poster;
        model.ctime = dataModel.ctime;
        model.cname = dataModel.cname;
        model.isShowAuthor = dataModel.isShowAuthor;
        model.TOrFOriginal = dataModel.torFOriginal;
        articleVC.titleModel = model;
    }
    [self.navigationController pushViewController:articleVC animated:YES];
}

- (void)loadDatas {
    
    JstyleToolManager *tool = [JstyleToolManager sharedManager];
    
    JstyleNewsNetworkManager *manager = [JstyleNewsNetworkManager shareManager];
    
    NSDictionary *paramaters = @{
                                 @"uid":[tool getUserId],
                                 @"uuid":[tool getUDID],
                                 @"type":@"1",
                                 @"page":[NSString stringWithFormat:@"%zd",page]
                                 };
    [manager GETURL:USERINFO_FOLLOWLIST_URL parameters:paramaters success:^(id responseObject) {
        
        NSDictionary *dictionary = responseObject;
        
        if ([dictionary[@"code"] isEqualToString:@"1"]) {
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
