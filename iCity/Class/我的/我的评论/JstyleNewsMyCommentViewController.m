//
//  JstyleNewsMyCommentViewController.m
//  JstyleNews
//
//  Created by 数字跃动 on 2017/10/25.
//  Copyright © 2017年 JstyleNews. All rights reserved.
//

#import "JstyleNewsMyCommentViewController.h"
#import "JstyleNewsMyCommentTableViewCell.h"
#import "JstyleNewsMyCommentListModel.h"
#import "JstyleNewsVideoDetailViewController.h"
#import "JstyleNewsPlaceholderView.h"
#import "JstyleNewsArticleDetailViewController.h"

@interface JstyleNewsMyCommentViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) JstyleNewsBaseTableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) JstyleNewsPlaceholderView *placeholderView;

@end

static NSInteger page = 1;

static NSString *JstyleNewsMyCommentTableViewCellID = @"JstyleNewsMyCommentTableViewCellID";
@implementation JstyleNewsMyCommentViewController

- (JstyleNewsPlaceholderView *)placeholderView {
    if (_placeholderView == nil) {
        _placeholderView = [[JstyleNewsPlaceholderView alloc] initWithFrame:[UIScreen mainScreen].bounds placeholderImage:[UIImage imageNamed:@"评论空白"] placeholderText:@"暂无相关评论哟~"];
    }
    return _placeholderView;
}

- (NSMutableArray *)dataArray {
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (UITableView *)tableView {
    if (_tableView == nil) {
        
        _tableView = [[JstyleNewsBaseTableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - kTopMargin) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSelectionStyleNone;
        [_tableView registerNib:[UINib nibWithNibName:@"JstyleNewsMyCommentTableViewCell" bundle:nil] forCellReuseIdentifier:JstyleNewsMyCommentTableViewCellID];
        _tableView.estimatedRowHeight = 124;
        
        __weak typeof(self)weakSelf = self;
        _tableView.mj_header = [JstyleRefreshGiftHeader headerWithRefreshingBlock:^{
            page = 1;
            [weakSelf loadDatas];
        }];
        _tableView.mj_footer = [JstyleRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            page++;
            [weakSelf loadDatas];
        }];
    }
    return _tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupNavigationBar];
    [self.view addSubview:self.tableView];
    [self.tableView.mj_header beginRefreshing];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.tableView reloadData];
}

- (void)setupNavigationBar {
    self.navigationItem.title = @"评论";//我的评论
    self.automaticallyAdjustsScrollViewInsets = YES;
}

#pragma mark - Table view data source
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 124;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JstyleNewsMyCommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:JstyleNewsMyCommentTableViewCellID forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    JstyleNewsMyCommentListModel *model = self.dataArray[indexPath.row];
    
    if (indexPath.row < self.dataArray.count) {
        cell.model = model;
    }
    
    __weak typeof(self)weakSelf = self;
    //根据type跳转对应控制器
    cell.titleTapBlock = ^{
        
        switch (model.type.integerValue) {
            case 1:
            {
                ///跳转文章详情
                JstyleNewsArticleDetailViewController *articleDetailVC = [JstyleNewsArticleDetailViewController new];
                
                JstyleNewsArticleDetailModel * detail_model = [JstyleNewsArticleDetailModel new];
                articleDetailVC.rid = model.id;
                detail_model.title = model.article_title;
                detail_model.content = model.article_content;
                detail_model.author_img = model.author_img;
                detail_model.author_did = model.author_did;
                detail_model.author_name = model.author_name;
                detail_model.poster = model.poster;
                detail_model.ctime = model.article_ctime;
                detail_model.cname = model.cname;
                detail_model.isShowAuthor = model.isShowAuthor;
                detail_model.TOrFOriginal = model.TOrFOriginal;
                articleDetailVC.titleModel = detail_model;
                [weakSelf.navigationController pushViewController:articleDetailVC animated:YES];
            }
                break;
            case 2:
            {
                ///跳转视频详情
                JstyleNewsVideoDetailViewController *videoVC = [JstyleNewsVideoDetailViewController new];
                videoVC.vid = model.id;
                videoVC.videoTitle = model.title;
                videoVC.videoUrl = model.url_sd;
                [weakSelf.navigationController pushViewController:videoVC animated:YES];
            }
                break;
            case 3:
            {
//                ///跳转发现详情
//                switch (model.find_type.integerValue) {
//                    case 1:
//                    {
//                        //1话题
//                        JstyleNewsDiscoveryTopicViewController *topicVC = [JstyleNewsDiscoveryTopicViewController new];
//                        topicVC.hid = model.id;
//                        [weakSelf.navigationController pushViewController:topicVC animated:YES];
//                    }
//                        break;
//                    case 2:
//                    {
//                        //2投票
//                        JstyleNewsDiscoveryVoteViewController *voteVC = [JstyleNewsDiscoveryVoteViewController new];
//                        voteVC.hid = model.id;
//                        [weakSelf.navigationController pushViewController:voteVC animated:YES];
//                    }
//                        break;
//                    case 3:
//                    {
//                        //3测试
//                        JstyleNewsDiscoveryTestViewController *testVC = [JstyleNewsDiscoveryTestViewController new];
//                        testVC.hid = model.id;
//                        [weakSelf.navigationController pushViewController:testVC animated:YES];
//                    }
//                        break;
//                    default:
//                        break;
//                }
            }
                break;
            default:
                break;
        }
        
    };
    
    return cell;
}

- (void)loadDatas {
    
    JstyleToolManager *tool = [JstyleToolManager sharedManager];
    
    JstyleNewsNetworkManager *manager = [JstyleNewsNetworkManager shareManager];
    
    NSDictionary *paramagers = @{
                                 @"uid":[tool getUserId],
                                 @"page":[NSString stringWithFormat:@"%ld",(long)page]
                                 };
    [manager GETURL:USERINFO_COMMENTLIST_URL parameters:paramagers success:^(id responseObject) {
        
        NSDictionary *dictionary = responseObject;
        
        if (page==1) {
            [self.dataArray removeAllObjects];
        }
        if ([dictionary[@"code"] isEqualToString:@"1"]) {
            NSArray *currentData = [NSArray modelArrayWithClass:[JstyleNewsMyCommentListModel class] json:dictionary[@"data"]];
            [self.placeholderView removeFromSuperview];
            self.placeholderView = nil;
            
            if (currentData.count != 0) {
                [self.dataArray addObjectsFromArray:currentData];
                
                [self.tableView reloadData];
                
                if (currentData.count < 10) {
                    page = 1;
                    [self.tableView.mj_header endRefreshing];
                    [self.tableView.mj_footer endRefreshingWithNoMoreData];
                } else {
                    [self.tableView.mj_header endRefreshing];
                    [self.tableView.mj_footer endRefreshing];
                }
                
            } else {
                page = 1;
                [self.tableView reloadData];
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
                [self.tableView.mj_header endRefreshing];
            }
        } else {
            
            [self.tableView reloadData];
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
            [self.tableView.mj_header endRefreshing];
            
            if (page==1&&self.dataArray.count==0) {
                [self.tableView addSubview:self.placeholderView];
            }
            page = 1;
        }
        
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
    }];
    
    
    
}


@end
