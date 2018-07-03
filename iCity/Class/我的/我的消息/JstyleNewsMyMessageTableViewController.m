//
//  JstyleNewsMyMessageTableViewController.m
//  JstyleNews
//
//  Created by 数字跃动 on 2017/12/25.
//  Copyright © 2017年 JstyleNews. All rights reserved.
//

#import "JstyleNewsMyMessageTableViewController.h"
#import "JstyleNewsMyMessageTableViewCell.h"
#import "JstyleNewsMyMessageNoticeModel.h"
#import "JstylePictureTextViewController.h"
#import "JstyleNewsVideoDetailViewController.h"
#import "JstyleNewsArticleDetailViewController.h"

#import "JstyleNewsActivityWebViewController.h"
#import "JstyleNewsPlaceholderView.h"

@interface JstyleNewsMyMessageTableViewController ()

@property (nonatomic, strong) NSMutableArray *messageDataArray;
@property (nonatomic, strong) JstyleNewsPlaceholderView *placeholderView;

@end

static NSInteger page = 1;

static NSString *JstyleNewsMyMessageTableViewCellID = @"JstyleNewsMyMessageTableViewCellID";

@implementation JstyleNewsMyMessageTableViewController

- (JstyleNewsPlaceholderView *)placeholderView {
    if (_placeholderView == nil) {
        _placeholderView = [[JstyleNewsPlaceholderView alloc] initWithFrame:[UIScreen mainScreen].bounds placeholderImage:[UIImage imageNamed:@"消息空白"] placeholderText:@"暂时还没有通知~"];
    }
    return _placeholderView;
}

- (NSMutableArray *)messageDataArray {
    if (_messageDataArray == nil) {
        _messageDataArray = [NSMutableArray array];
    }
    return _messageDataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.tableView.backgroundColor = ISNightMode?kNightModeBackColor:kBackGroundColor;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:@"JstyleNewsMyMessageTableViewCell" bundle:nil] forCellReuseIdentifier:JstyleNewsMyMessageTableViewCellID];
    
    [self addMJHeaderFooterWithTableView:self.tableView];
    [self.tableView.mj_header beginRefreshing];
}

- (void)addMJHeaderFooterWithTableView:(UITableView *)tableView {
    
    __weak typeof(self)weakSelf = self;
    tableView.mj_header = [JstyleRefreshGiftHeader headerWithRefreshingBlock:^{
        page = 1;
        [weakSelf.messageDataArray removeAllObjects];
        [weakSelf loadDatasWithType:@"1"];
    }];
    
    tableView.mj_footer = [JstyleRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        page++;
        [weakSelf loadDatasWithType:@"1"];
    }];
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.0001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.0001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 121.5;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row >= self.messageDataArray.count) {
        return;
    }
    JstyleNewsMyMessageNoticeModel *model = self.messageDataArray[indexPath.row];
    
    switch (model.type.integerValue) {
//        case 1://1.发现话题
//        {
//            JstyleNewsDiscoveryTopicViewController *topicVC = [JstyleNewsDiscoveryTopicViewController new];
//            topicVC.hid = model.id;
//            [self.navigationController pushViewController:topicVC animated:YES];
//        }
//            break;
//        case 2://2.发现投票
//        {
//            JstyleNewsDiscoveryVoteViewController *voteVC = [JstyleNewsDiscoveryVoteViewController new];
//            voteVC.hid = model.id;
//            [self.navigationController pushViewController:voteVC animated:YES];
//        }
//            break;
//        case 4://4.发现测试
//        {
//            JstyleNewsDiscoveryTestViewController *testVC = [JstyleNewsDiscoveryTestViewController new];
//            testVC.hid = model.id;
//            [self.navigationController pushViewController:testVC animated:YES];
//        }
//            break;
        case 6://6.文章 or 图集
        {
            
            if (model.isImageArticle.integerValue == 1) {
                //1是图片集
                JstylePictureTextViewController *pictureVC = [JstylePictureTextViewController new];
                pictureVC.rid = model.id;
                [self.navigationController pushViewController:pictureVC animated:YES];
            } else {
                //2不是图片集(是文章详情)
                JstyleNewsArticleDetailViewController *articleVC = [JstyleNewsArticleDetailViewController new];
                articleVC.rid = model.id;
                [self.navigationController pushViewController:articleVC animated:YES];
            }
        }
            break;
        case 7://7.视频
        {
            //视频 or 直播
            JstyleNewsVideoDetailViewController *videoDetailVC = [JstyleNewsVideoDetailViewController new];
            videoDetailVC.vid = model.id;
            videoDetailVC.videoUrl = model.url_sd;
            videoDetailVC.videoTitle = model.title;
            videoDetailVC.videoType = model.videoType;
            [self.navigationController pushViewController:videoDetailVC animated:YES];
        }
            break;
        case 8://8.直播
        {
            //视频 or 直播
            JstyleNewsVideoDetailViewController *videoDetailVC = [JstyleNewsVideoDetailViewController new];
            videoDetailVC.vid = model.id;
            videoDetailVC.videoUrl = model.url_sd;
            videoDetailVC.videoTitle = model.title;
            [self.navigationController pushViewController:videoDetailVC animated:YES];
        }
            break;
        case 9://9.活动
        {
            JstyleNewsActivityWebViewController *activityVC = [JstyleNewsActivityWebViewController new];
            activityVC.urlString = model.url_sd;
            [self.navigationController pushViewController:activityVC animated:YES];
        }
            break;
        default:
            break;
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.messageDataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JstyleNewsMyMessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:JstyleNewsMyMessageTableViewCellID forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.row < self.messageDataArray.count) {
        cell.model = self.messageDataArray[indexPath.row];
    }
    return cell;
}

- (void)loadDatasWithType:(NSString *)type {
    
    JstyleNewsNetworkManager *manager = [JstyleNewsNetworkManager shareManager];
    
    NSDictionary *paramaters = @{
                                 @"uid":[[JstyleToolManager sharedManager] getUserId],
                                 @"type":type,
                                 @"page":[NSString stringWithFormat:@"%zd",page]
                                 };
    
    [manager GETURL:USERINFO_MSGLIST_URL parameters:paramaters success:^(id responseObject) {
        
        NSDictionary *dictionary = responseObject;
        
        if ([dictionary[@"code"] isEqualToString:@"1"]) {
            
            NSArray *currentArray = [NSArray modelArrayWithClass:[JstyleNewsMyMessageNoticeModel class] json:dictionary[@"data"]];
            [self.placeholderView removeFromSuperview];
            self.placeholderView = nil;
            
            [self.messageDataArray addObjectsFromArray:currentArray];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
