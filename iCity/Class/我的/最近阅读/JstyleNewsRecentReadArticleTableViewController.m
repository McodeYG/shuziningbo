//
//  JstyleNewsRecentReadArticleTableViewController.m
//  JstyleNews
//
//  Created by 数字跃动 on 2017/12/27.
//  Copyright © 2017年 JstyleNews. All rights reserved.
//

#import "JstyleNewsRecentReadArticleTableViewController.h"
#import "JstyleNewsMyCollectionTableViewCell.h"
#import "JstyleNewsMyCollectionModel.h"
#import "JstyleNewsPlaceholderView.h"
#import "JstyleNewsArticleDetailViewController.h"
#import "JstylePictureTextViewController.h"

@interface JstyleNewsRecentReadArticleTableViewController ()

@property (nonatomic, strong) NSMutableArray<JstyleNewsMyCollectionModel *> *dataArray;
@property (nonatomic, strong) JstyleNewsPlaceholderView *placeholderView;

@end

static NSInteger page = 1;

static NSString *JstyleNewsMyCollectionTableViewCellID = @"JstyleNewsMyCollectionTableViewCellID";

@implementation JstyleNewsRecentReadArticleTableViewController

- (JstyleNewsPlaceholderView *)placeholderView {
    if (_placeholderView == nil) {
        _placeholderView = [[JstyleNewsPlaceholderView alloc] initWithFrame:[UIScreen mainScreen].bounds placeholderImage:[UIImage imageNamed:@"文章空白"] placeholderText:@"快去体会阅读的乐趣吧~"];
    }
    return _placeholderView;
}

- (NSMutableArray<JstyleNewsMyCollectionModel *> *)dataArray {
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
    [self.tableView registerNib:[UINib nibWithNibName:@"JstyleNewsMyCollectionTableViewCell" bundle:nil] forCellReuseIdentifier:JstyleNewsMyCollectionTableViewCellID];
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

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    JstyleNewsMyCollectionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:JstyleNewsMyCollectionTableViewCellID forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.row < self.dataArray.count) {
        cell.collectionModel = self.dataArray[indexPath.row];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row < self.dataArray.count) {
        JstyleNewsMyCollectionModel *dataModel = self.dataArray[indexPath.row];
        
        if (dataModel.isImageArticle.integerValue == 1) {
            //图集
            JstylePictureTextViewController *pictureVC = [JstylePictureTextViewController new];
            pictureVC.rid = dataModel.id;
            [self.navigationController pushViewController:pictureVC animated:YES];
        } else {
            //文章
            JstyleNewsArticleDetailViewController *articleDetailVC = [JstyleNewsArticleDetailViewController new];
            JstyleNewsArticleDetailModel * model = [JstyleNewsArticleDetailModel new];
            articleDetailVC.rid = dataModel.id;
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
            articleDetailVC.titleModel = model;
            [self.navigationController pushViewController:articleDetailVC animated:YES];
        }
    }
}

- (void)loadData {
    
    JstyleNewsNetworkManager *manager = [JstyleNewsNetworkManager shareManager];
    
    NSDictionary *paramaters = @{
                                 @"uuid":[[JstyleToolManager sharedManager] getUDID],
                                 @"uid":[[JstyleToolManager sharedManager] getUserId],
                                 @"type":@"1",
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
