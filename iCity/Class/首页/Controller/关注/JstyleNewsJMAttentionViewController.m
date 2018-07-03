//
//  JstyleNewsJMAttentionViewController.m
//  JstyleNews
//
//  Created by JingHongMuYun on 2018/3/28.
//  Copyright © 2018年 JstyleNews. All rights reserved.
//

#import "JstyleNewsJMAttentionViewController.h"
#import "JstyleNewsArticleDetailModel.h"
#import "JstyleNewsJMAttentionItemViewCell.h"
#import "JstyleNewsJMAttentionTuiJianTableViewCell.h"
#import "JstyleNewsJMAttentionArticleSmallImageCell.h"
#import "JstyleNewsJMAttentionArticleBigImageCell.h"
#import "JstyleNewsJMAttentionArticleThreeImageCell.h"
#import "JstyleNewsAdvertisementViewCell.h"
#import "JstyleNewsJMAttentionVideoLiveCell.h"
#import "JstyleNewsJMAttentionMoreViewController.h"
//#import "JstyleNewsRankingListViewController.h"
#import "JstyleMySubscribeViewController.h"
#import "JstylePictureTextViewController.h"
#import "JstyleNewsArticleDetailViewController.h"
#import "JstyleNewsVideoDetailViewController.h"
#import "JstyleNewsActivityWebViewController.h"

@interface JstyleNewsJMAttentionViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) JstyleNewsBaseTableView *tableView;
@property (nonatomic, strong) FMDatabase *database;
@property (nonatomic, copy) NSArray *tuiJianArray;
@property (nonatomic, copy) NSArray *cacheTuiJianArray;
@property (nonatomic, strong) NSMutableArray *listArray;
@property (nonatomic, strong) NSMutableArray *cacheListArray;
@property (nonatomic, strong) NSMutableDictionary *cacheDict;
@property (nonatomic, strong) NSMutableArray *detailDataArray;
@property (nonatomic, strong) JstyleNewsNoSinglePlaceholderView *noSingleView;
@property (nonatomic, assign) BOOL isClearArray;

@end

@implementation JstyleNewsJMAttentionViewController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addTableView];
    [self addReshAction];
    
    [self creatTableSqlite];
    @try {[self getCacheDictionary];}
    @catch (NSException *exception) {}
    @finally {[self.tableView.mj_header beginRefreshing];}
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeFontSize) name:KJstyleNewsChangeFontSizeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tabbarButtonClickDidRepeat) name:@"TabbarButtonClickDidRepeatNotification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applyTheme) name:NightModeManagerNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(attentionRefresh:) name:@"AttentionRefresh" object:nil];
    
    [self addNoSingleView];
}

- (void)changeFontSize
{
    [self.tableView reloadData];
}

- (void)applyTheme {
    [self.tableView reloadData];
}

- (void)attentionRefresh:(NSNotification *)notification
{
    NSDictionary *userInfo = notification.userInfo;
    [self reloadDataWithDid:userInfo[@"did"] followType:userInfo[@"followType"]];
}

- (void)tabbarButtonClickDidRepeat
{
    //判断window是否在窗口上
    if (self.view.window == nil) return;
    //判断当前的view是否与窗口重合  nil代表屏幕左上角
    if (![self.view hu_intersectsWithAnotherView:nil]) return;
    //刷新
    [self.tableView.mj_header beginRefreshing];
}

- (void)addTableView
{
    _tableView = [[JstyleNewsBaseTableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - YG_StatusAndNavightion_H - TabbarHeight)];
    _tableView.separatorInset = UIEdgeInsetsMake(0, 15, 0, 15);
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.estimatedRowHeight = 0;
    _tableView.estimatedSectionHeaderHeight = 0;
    _tableView.estimatedSectionFooterHeight = 0;
    _tableView.tableFooterView = [UIView new];
    
    [_tableView registerNib:[UINib nibWithNibName:@"JstyleNewsJMAttentionItemViewCell" bundle:nil] forCellReuseIdentifier:@"JstyleNewsJMAttentionItemViewCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"JstyleNewsJMAttentionArticleSmallImageCell" bundle:nil] forCellReuseIdentifier:@"JstyleNewsJMAttentionArticleSmallImageCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"JstyleNewsJMAttentionArticleBigImageCell" bundle:nil] forCellReuseIdentifier:@"JstyleNewsJMAttentionArticleBigImageCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"JstyleNewsJMAttentionArticleThreeImageCell" bundle:nil] forCellReuseIdentifier:@"JstyleNewsJMAttentionArticleThreeImageCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"JstyleNewsJMAttentionVideoLiveCell" bundle:nil] forCellReuseIdentifier:@"JstyleNewsJMAttentionVideoLiveCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"JstyleNewsAdvertisementViewCell" bundle:nil] forCellReuseIdentifier:@"JstyleNewsAdvertisementViewCell"];
    
    [self.view addSubview:_tableView];
}

static NSInteger page = 1;
- (void)addReshAction
{
    __weak typeof(self)weakSelf = self;
    self.tableView.mj_header = [JstyleRefreshGiftHeader headerWithRefreshingBlock:^{
        page = 1;
        JstyleNewsJMAttentionListModel *model = self.listArray.firstObject;
        [weakSelf loadJstyleNewsJMAttentionListWithRefresh:@"1" time:model.timestamp];
    }];
    
    self.tableView.mj_footer = [JstyleRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        page ++;
        JstyleNewsJMAttentionListModel *model = self.listArray.lastObject;
        [weakSelf loadJstyleNewsJMAttentionListWithRefresh:@"0" time:model.timestamp];
    }];
}

#pragma mark -- tableView的代理方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
        case 1:
            return 1;
            break;
        case 2:
            return self.listArray.count;
            break;
        default:
            return 0;
            break;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 1) return [self addHeaderViewWithTitle:@"推荐关注" moreBtnTitle:@"查看更多"];
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 1) return 50;
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:{
            static NSString *ID = @"JstyleNewsJMAttentionItemViewCell";
            JstyleNewsJMAttentionItemViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
            if (!cell) {
                cell = [[JstyleNewsJMAttentionItemViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
            }
            
            __weak typeof(self)weakSelf = self;
            [cell setAttentionMoreBlock:^{
                JstyleNewsJMAttentionMoreViewController *jstyleNewsJMAttentionMVC = [JstyleNewsJMAttentionMoreViewController new];
                [weakSelf.navigationController pushViewController:jstyleNewsJMAttentionMVC animated:YES];
            }];

            [cell setMyAttentionBlock:^{
                JstyleMySubscribeViewController *jstyleMySVC = [JstyleMySubscribeViewController new];
                [weakSelf.navigationController pushViewController:jstyleMySVC animated:YES];
            }];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
            break;
        case 1:{
            static NSString *ID = @"JstyleNewsJMAttentionTuiJianTableViewCell";
            JstyleNewsJMAttentionTuiJianTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
            if (!cell) {
                cell = [[JstyleNewsJMAttentionTuiJianTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
            }
            
            [cell.tuiJianCollectionView reloadDataWithDataArray:self.tuiJianArray];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
            break;
        case 2:{
            JstyleNewsJMAttentionListModel *model = self.listArray[indexPath.row];
            __weak typeof(self)weakSelf = self;
            switch ([model.type integerValue]) {
                case 1:{
                    if ([model.head_type integerValue] == 1 && [model.isImageArticle integerValue] == 1) {
                        static NSString *ID = @"JstyleNewsJMAttentionArticleBigImageCell";
                        JstyleNewsJMAttentionArticleBigImageCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
                        if (!cell) {
                            cell = [[JstyleNewsJMAttentionArticleBigImageCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
                        }
                        
                        [cell setFocusBtnBlock:^(NSString *did) {
                            [weakSelf  addJstyleNewsJmNumsFocusOnWithDid:did indexPath:indexPath];
                        }];
                        if (indexPath.row < self.listArray.count) {
                            cell.model = self.listArray[indexPath.row];
                        }
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                        return cell;
                    }else if ([model.head_type integerValue] == 1) {
                        static NSString *ID = @"JstyleNewsJMAttentionArticleSmallImageCell";
                        JstyleNewsJMAttentionArticleSmallImageCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
                        if (!cell) {
                            cell = [[JstyleNewsJMAttentionArticleSmallImageCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
                        }
                        
                        [cell setFocusBtnBlock:^(NSString *did) {
                            [weakSelf  addJstyleNewsJmNumsFocusOnWithDid:did indexPath:indexPath];
                        }];
                        if (indexPath.row < self.listArray.count) {
                            cell.model = self.listArray[indexPath.row];
                        }
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                        return cell;
                    }else{
                        static NSString *ID = @"JstyleNewsJMAttentionArticleThreeImageCell";
                        JstyleNewsJMAttentionArticleThreeImageCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
                        if (!cell) {
                            cell = [[JstyleNewsJMAttentionArticleThreeImageCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
                        }
                        
                        [cell setFocusBtnBlock:^(NSString *did) {
                            [weakSelf  addJstyleNewsJmNumsFocusOnWithDid:did indexPath:indexPath];
                        }];
                        if (indexPath.row < self.listArray.count) {
                            cell.model = self.listArray[indexPath.row];
                        }
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                        return cell;
                    }
                }
                    break;
                case 2:{
                    static NSString *ID = @"JstyleNewsJMAttentionVideoLiveCell";
                    JstyleNewsJMAttentionVideoLiveCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
                    if (!cell) {
                        cell = [[JstyleNewsJMAttentionVideoLiveCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
                    }
                    
                    [cell setFocusBtnBlock:^(NSString *did) {
                        [weakSelf  addJstyleNewsJmNumsFocusOnWithDid:did indexPath:indexPath];
                    }];
                    if (indexPath.row < self.listArray.count) {
                        cell.model = self.listArray[indexPath.row];
                    }
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    return cell;
                }
                    break;
                case 3:{
                    static NSString *ID = @"JstyleNewsAdvertisementViewCell";
                    JstyleNewsAdvertisementViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
                    if (!cell) {
                        cell = [[JstyleNewsAdvertisementViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
                    }
                    
                    if (indexPath.row < self.listArray.count) {
                        cell.model = model;
                    }
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    return cell;
                }
                    break;
                default:
                    return nil;
                    break;
            }
        }
            break;
        default:
            return nil;
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
            return 60;
            break;
        case 1:
            return 200;
            break;
        case 2:{
            if (!(indexPath.row < self.listArray.count)) return 0;
            JstyleNewsJMAttentionListModel *model = self.listArray[indexPath.row];
            switch ([model.type integerValue]) {
                case 1:{
                    if ([model.head_type integerValue] == 1 && [model.isImageArticle integerValue] == 1) {
                        return [self.tableView cellHeightForIndexPath:indexPath model:model keyPath:@"model" cellClass:[JstyleNewsJMAttentionArticleBigImageCell class] contentViewWidth:kScreenWidth];
                    }else if ([model.head_type integerValue] == 1) {
                        return (276+50)/2;
                    }else{
                        return [self.tableView cellHeightForIndexPath:indexPath model:model keyPath:@"model" cellClass:[JstyleNewsJMAttentionArticleThreeImageCell class] contentViewWidth:kScreenWidth];
                    }
                }
                    break;
                case 2:
                    return [self.tableView cellHeightForIndexPath:indexPath model:model keyPath:@"model" cellClass:[JstyleNewsJMAttentionVideoLiveCell class] contentViewWidth:kScreenWidth];
                    break;
                case 3:
                    return [self.tableView cellHeightForIndexPath:indexPath model:model keyPath:@"model" cellClass:[JstyleNewsAdvertisementViewCell class] contentViewWidth:kScreenWidth];
                    break;
                default:
                    return 0;
                    break;
            }
        }
            break;
        default:
            return 0;
            break;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    [self releaseVRPlayer];
    if (indexPath.row >= self.listArray.count || indexPath.row >= self.detailDataArray.count || indexPath.section != 2) return;
    
    JstyleNewsJMAttentionListModel *model = self.listArray[indexPath.row];
    JstyleNewsArticleDetailModel *detailModel = self.detailDataArray[indexPath.row];
    switch ([model.type integerValue]) {
        case 1:{
            if ([model.isImageArticle integerValue] == 1) {
                //图集
                JstylePictureTextViewController *jstyleNewsPictureTVC = [JstylePictureTextViewController new];
                jstyleNewsPictureTVC.rid = model.id;
                [self.navigationController pushViewController:jstyleNewsPictureTVC animated:YES];
            }else{
                //文章
                JstyleNewsArticleDetailViewController *jstyleNewsArticleDVC = [JstyleNewsArticleDetailViewController new];
                jstyleNewsArticleDVC.rid = detailModel.id;
                jstyleNewsArticleDVC.titleModel = detailModel;
                [self.navigationController pushViewController:jstyleNewsArticleDVC animated:YES];
            }
        }
            break;
        case 2:{
            //视频直播
            JstyleNewsVideoDetailViewController *jstyleNewsVideoDVC = [JstyleNewsVideoDetailViewController new];
            jstyleNewsVideoDVC.videoUrl = model.url_sd;
            jstyleNewsVideoDVC.videoTitle = model.title;
            jstyleNewsVideoDVC.vid = model.id;
            jstyleNewsVideoDVC.videoType = model.videoType;
            [self.navigationController pushViewController:jstyleNewsVideoDVC animated:YES];
        }
            break;
        case 3:{
            //广告活动
            switch ([model.banner_type integerValue]) {
                case 1:
                    //文章或图集
                    if ([model.isImageArticle integerValue] == 1) {
                        //图集
                        JstylePictureTextViewController *jstyleNewsPictureTVC = [JstylePictureTextViewController new];
                        jstyleNewsPictureTVC.rid = model.id;
                        [self.navigationController pushViewController:jstyleNewsPictureTVC animated:YES];
                    }else{
                        //文章
                        JstyleNewsArticleDetailViewController *jstyleNewsArticleDVC = [JstyleNewsArticleDetailViewController new];
                        jstyleNewsArticleDVC.rid = detailModel.id;
                        jstyleNewsArticleDVC.titleModel = detailModel;
                        [self.navigationController pushViewController:jstyleNewsArticleDVC animated:YES];
                    }
                    break;
                case 2:{
                    //视频直播
                    JstyleNewsVideoDetailViewController *jstyleNewsVideoDVC = [JstyleNewsVideoDetailViewController new];
                    jstyleNewsVideoDVC.videoUrl = model.url_sd;
                    jstyleNewsVideoDVC.videoTitle = model.title;
                    jstyleNewsVideoDVC.vid = model.id;
                    jstyleNewsVideoDVC.videoType = model.videoType;

                    [self.navigationController pushViewController:jstyleNewsVideoDVC animated:YES];
                }
                    break;
                case 3:{
                    //h5
                    JstyleNewsActivityWebViewController *jstyleNewsActivityWVC = [JstyleNewsActivityWebViewController new];
                    jstyleNewsActivityWVC.urlString = model.h5url;
                    jstyleNewsActivityWVC.isShare = model.isShare.integerValue;
                    [self.navigationController pushViewController:jstyleNewsActivityWVC animated:YES];
                }
                    break;
                default:
                    break;
            }
        }
            break;
        default:
            break;
    }
}

- (void)loadJstyleNewsJMAttentionListWithRefresh:(NSString *)refresh time:(NSString *)time
{
    NSDictionary *parameters = @{@"uid":[JstyleToolManager sharedManager].getUserId,
                                 @"uuid":[JstyleToolManager sharedManager].getUDID,
                                 @"page":[NSString stringWithFormat:@"%ld",page],
                                 @"refresh":refresh,
                                 @"last_time":[NSString stringWithFormat:@"%@",time]};
    
    [[JstyleNewsNetworkManager shareManager] GETURL:JMNUM_HOME_LIST_URL parameters:parameters success:^(id responseObject) {
        if ([responseObject[@"code"] integerValue] == 1) {
            if ([refresh integerValue] == 1) {
                if (!_isClearArray) {
                    _isClearArray = YES;
                    [self.listArray removeAllObjects];
                    [self.cacheListArray removeAllObjects];
                    [self.detailDataArray removeAllObjects];
                    self.tuiJianArray = @[];
                    self.cacheTuiJianArray = @[];
                    self.cacheDict = nil;
                }
                [self.listArray insertObjects:[NSArray modelArrayWithClass:[JstyleNewsJMAttentionListModel class] json:responseObject[@"data"][@"articleList"]] atIndex:0];
                [self.detailDataArray insertObjects:[NSArray modelArrayWithClass:[JstyleNewsArticleDetailModel class] json:responseObject[@"data"][@"articleList"]] atIndex:0];
                [self.cacheListArray insertObjects:responseObject[@"data"][@"articleList"] atIndex:0];
            }else{
                [self.listArray addObjectsFromArray:[NSArray modelArrayWithClass:[JstyleNewsJMAttentionListModel class] json:responseObject[@"data"][@"articleList"]]];
                [self.detailDataArray addObjectsFromArray:[NSArray modelArrayWithClass:[JstyleNewsArticleDetailModel class] json:responseObject[@"data"][@"articleList"]]];
                [self.cacheListArray addObjectsFromArray:responseObject[@"data"][@"articleList"]];
            }
            [self.cacheDict setObject:self.cacheListArray forKey:@"list"];
            if ([refresh isEqualToString:@"1"]) {
                self.tuiJianArray = [NSArray modelArrayWithClass:[JstyleNewsJMAttentionListModel class] json:responseObject[@"data"][@"medialist"]];
                self.cacheTuiJianArray = responseObject[@"data"][@"medialist"];
                [self.cacheDict setObject:self.cacheTuiJianArray forKey:@"tuijian"];
            }
            [self insertSqlite:self.cacheDict];
        }
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    } failure:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
}

//关注iCity号
- (void)addJstyleNewsJmNumsFocusOnWithDid:(NSString *)did indexPath:(NSIndexPath *)indexPath
{
    if ([[JstyleToolManager sharedManager] isTourist]) {
        [[JstyleToolManager sharedManager] loginInViewController];
        return;
    }
    
    NSDictionary *parameters = @{@"platform_type":@"2",
                                 @"did":did,
                                 @"uid":[[JstyleToolManager sharedManager] getUserId]};
    [[JstyleNewsNetworkManager shareManager] GETURL:MANAGER_SUBSCRIPTION_URL parameters:parameters success:^(id responseObject) {
        if ([responseObject[@"code"] integerValue] == 1) {
            NSString *followType = responseObject[@"data"][@"follow_type"];
            [self reloadDataWithDid:did followType:followType];
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

- (void)reloadDataWithDid:(NSString *)did followType:(NSString *)followType
{
    for (JstyleNewsJMAttentionListModel *model in self.listArray) {
        if ([model.author_did isEqualToString:did]) {
            model.isShowAuthor = followType;
        }
    }
    for (JstyleNewsJMAttentionListModel *model in self.tuiJianArray) {
        if ([model.did isEqualToString:did]) {
            model.isFollow = followType;
        }
    }
    [self.tableView reloadData];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"HiddenNavigationBar" object:nil userInfo:@{@"contentOffset":[NSString stringWithFormat:@"%f",scrollView.contentOffset.y],@"height":[NSString stringWithFormat:@"%f",scrollView.frame.size.height],@"contentSizeHeight":[NSString stringWithFormat:@"%f",scrollView.contentSize.height]}];
}

- (void)addNoSingleView{
    
    if ([[JstyleToolManager sharedManager] getCurrentNetStatus] == NotReachable) {
        self.noSingleView = [[JstyleNewsNoSinglePlaceholderView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - YG_StatusAndNavightion_H - TabbarHeight)];
        [self.view addSubview:self.noSingleView];
        self.tableView.scrollEnabled = NO;
        __weak typeof(self)weakSelf = self;
        self.noSingleView.reloadBlock = ^{
            [SVProgressHUD showWithStatus:@"正在努力加载"];
            [weakSelf loadJstyleNewsJMAttentionListWithRefresh:@"1" time:@""];
        };
    }
}

- (UIView *)addHeaderViewWithTitle:(NSString *)title moreBtnTitle:(NSString *)moreBtnTitle
{
    UIView *headerView = [[UIView alloc] init];
    headerView.backgroundColor = kNightModeBackColor;
    
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.font = JSFontWithWeight(15, UIFontWeightMedium);
    nameLabel.text = title;
    nameLabel.textColor = ISNightMode?kDarkNineColor:kDarkZeroColor;
    [headerView addSubview:nameLabel];
    nameLabel.sd_layout
    .centerYEqualToView(headerView)
    .leftSpaceToView(headerView, 15)
    .widthIs(150)
    .heightIs(18);
    
    UIButton *checkMoreBtn = [[UIButton alloc] init];
    checkMoreBtn.titleLabel.font = JSFont(13);
    [checkMoreBtn setTitle:moreBtnTitle forState:(UIControlStateNormal)];
    [checkMoreBtn setTitleColor:kDarkNineColor forState:(UIControlStateNormal)];
    [checkMoreBtn setContentHorizontalAlignment:(UIControlContentHorizontalAlignmentRight)];
    [checkMoreBtn addTarget:self action:@selector(checkMoreBtnClicked:) forControlEvents:(UIControlEventTouchUpInside)];
    [checkMoreBtn setEnlargeEdgeWithTop:10 right:10 bottom:10 left:10];
    [headerView addSubview:checkMoreBtn];
    checkMoreBtn.sd_layout
    .centerYEqualToView(headerView)
    .rightSpaceToView(headerView, 15)
    .widthIs(150)
    .heightIs(18);
    
    return headerView;
}

- (void)checkMoreBtnClicked:(UIButton *)sender
{
    JstyleNewsJMAttentionMoreViewController *jstyleNewsJMAttentionMVC = [JstyleNewsJMAttentionMoreViewController new];
    [self.navigationController pushViewController:jstyleNewsJMAttentionMVC animated:YES];
}

/**创建缓存表*/
- (void)creatTableSqlite
{
    // 获取路径
    NSString * documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *dbPath = [documentsPath stringByAppendingPathComponent:@"AttentionCacheList.sqlite"];
    
    // 初始化FMDB
    self.database = [FMDatabase databaseWithPath:dbPath];
    
    [self.database open];
    // executeUpdate:@"create table 表名 (列名 类型,..... )"
    FMResultSet * resultSet = [self.database executeQuery:@"select * from AttentionCacheList"];
    if ([resultSet next] == NO){
        [self.database executeUpdate:@"create table AttentionCacheList (AttentionCacheData blob)"];
    }
    
    [self.database close];
}

- (void)insertSqlite:(NSDictionary *)sender {
    
    [self.database open];
    
    [self.database executeUpdate:@"DELETE FROM AttentionCacheList"];
    
    NSMutableArray *array = [NSMutableArray array];
    [array addObject:sender];
    
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:array];
    
    FMResultSet *resultSet =  [self.database executeQuery:@"insert into AttentionCacheList(AttentionCacheData) values(?)" withArgumentsInArray:@[data]];
    [resultSet next];
    
    [self.database close];
}

/**取出缓存数据*/
- (void)getCacheDictionary
{
    NSString * documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *dbPath = [documentsPath stringByAppendingPathComponent:@"AttentionCacheList.sqlite"];
    self.database = [FMDatabase databaseWithPath:dbPath];
    [self.database open];
    FMResultSet * resultSet = [self.database executeQuery:@"select * from AttentionCacheList"];
    NSArray *cacheArray;
    while ([resultSet next] == YES){
        NSData *data = [resultSet dataForColumn:@"AttentionCacheData"];
        cacheArray = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    }
    [self.database close];
    
    NSDictionary *dictionary = cacheArray[0];
    self.tuiJianArray = nil;
    self.listArray = nil;
    self.detailDataArray = nil;
    NSArray *tuijianArray = dictionary[@"tuijian"];
    NSArray *listArray = dictionary[@"list"];
    if (tuijianArray.count) {
        self.tuiJianArray = [NSArray modelArrayWithClass:[JstyleNewsJMAttentionListModel class] json:tuijianArray];
    }
    if (listArray.count) {
        [self.listArray addObjectsFromArray:[NSArray modelArrayWithClass:[JstyleNewsJMAttentionListModel class] json:listArray]];
        [self.detailDataArray addObjectsFromArray:[NSArray modelArrayWithClass:[JstyleNewsArticleDetailModel class] json:listArray]];
    }
    
    if (self.listArray.count) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.noSingleView removeFromSuperview];
            self.noSingleView = nil;
            self.tableView.scrollEnabled = YES;
            [self.tableView reloadData];
        });
    }
    return;
}

- (NSMutableArray *)listArray
{
    if (!_listArray) {
        _listArray = [NSMutableArray array];
    }
    return _listArray;
}

- (NSMutableArray *)detailDataArray
{
    if (!_detailDataArray) {
        _detailDataArray = [NSMutableArray array];
    }
    return _detailDataArray;
}

- (NSMutableArray *)cacheListArray
{
    if (!_cacheListArray) {
        _cacheListArray = [NSMutableArray array];
    }
    return _cacheListArray;
}

- (NSMutableDictionary *)cacheDict
{
    if (!_cacheDict) {
        _cacheDict = [NSMutableDictionary dictionary];
    }
    return _cacheDict;
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
