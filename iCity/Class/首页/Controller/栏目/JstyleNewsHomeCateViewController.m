//
//  JstyleNewsHomeCateViewController.m
//  JstyleNews
//
//  Created by JingHongMuYun on 2017/12/7.
//  Copyright © 2017年 JstyleNews. All rights reserved.
//

#import "JstyleNewsHomeCateViewController.h"
#import "JstyleNewsOneImageArticleViewCell.h"
#import "JstyleNewsOnePlusImageArticleViewCell.h"
#import "JstyleNewsThreeImageArticleViewCell.h"
#import "JstyleNewsAdvertisementViewCell.h"
#import "JstyleNewsArticleDetailViewController.h"
#import "JstylePictureTextViewController.h"
#import "JstyleNewsVideoDetailViewController.h"
#import "JstyleNewsActivityWebViewController.h"

@interface JstyleNewsHomeCateViewController ()<UITableViewDelegate,UITableViewDataSource,UIViewControllerPreviewingDelegate>

@property (nonatomic, strong) JstyleNewsBaseTableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSMutableArray *detailDataArray;

@property (nonatomic, strong) FMDatabase *database;
@property (nonatomic, strong) NSMutableArray *cacheListArray;

@property (nonatomic, strong) JstyleNewsNoSinglePlaceholderView *noSingleView;

@end

static NSInteger page = 1;
@implementation JstyleNewsHomeCateViewController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.view.backgroundColor = kWhiteColor;
    [self addTableView];
    [self addReshAction];
    
    [self creatTableSqlite];
    @try {[self getCacheDictionary];}
    @catch (NSException *exception) {}
    @finally {[self.tableView.mj_header beginRefreshing];}
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeFontSize) name:KJstyleNewsChangeFontSizeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tabbarButtonClickDidRepeat) name:@"TabbarButtonClickDidRepeatNotification" object:nil];
    
    [self addNoSingleView];
}

#pragma mark - 3DTouch预览
- (UIViewController *)previewingContext:(id<UIViewControllerPreviewing>)previewingContext viewControllerForLocation:(CGPoint)location {
    
    NSIndexPath *indexPath = [self.tableView indexPathForCell:(UITableViewCell* )[previewingContext sourceView]];
    
    JstyleNewsArticleDetailViewController *detailVC = [[JstyleNewsArticleDetailViewController alloc] init];
    JstylePictureTextViewController *pictureVC = [[JstylePictureTextViewController alloc] init];
    detailVC.preferredContentSize = CGSizeMake(0.0f,500.0f);
    if (indexPath.row < self.dataArray.count) {
        detailVC.rid = [self.dataArray[indexPath.row] id];
        detailVC.titleModel = self.detailDataArray[indexPath.row];
        
        pictureVC.rid = [self.dataArray[indexPath.row] id];
        
        CGRect rect = CGRectMake(0, 0, self.view.frame.size.width,[self.tableView cellForRowAtIndexPath:indexPath].height);
        previewingContext.sourceRect = rect;
    }
    
    return [self.dataArray[indexPath.row] isImageArticle].integerValue == 1 ? pictureVC:detailVC;
}

- (void)previewingContext:(id <UIViewControllerPreviewing>)previewingContext commitViewController:(UIViewController *)viewControllerToCommit {
    
    [self showViewController:viewControllerToCommit sender:self];
}

- (void)addNoSingleView{
    
    if ([[JstyleToolManager sharedManager] getCurrentNetStatus] == NotReachable) {
        self.noSingleView = [[JstyleNewsNoSinglePlaceholderView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - YG_StatusAndNavightion_H - TabbarHeight)];
        [self.view addSubview:self.noSingleView];
        self.tableView.scrollEnabled = NO;
        __weak typeof(self)weakSelf = self;
        self.noSingleView.reloadBlock = ^{
            [SVProgressHUD showWithStatus:@"正在努力加载"];
            [weakSelf loadJstyleNewsHomeCateDataSource];
        };
    }
}

- (void)changeFontSize
{
    [self.tableView reloadData];
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

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"HiddenNavigationBar" object:nil userInfo:@{@"contentOffset":[NSString stringWithFormat:@"%f",scrollView.contentOffset.y],@"height":[NSString stringWithFormat:@"%f",scrollView.frame.size.height],@"contentSizeHeight":[NSString stringWithFormat:@"%f",scrollView.contentSize.height]}];
}

- (void)zj_viewDidLoadForIndex:(NSInteger)index {
    
}

- (void)addReshAction
{
    __weak typeof(self)weakSelf = self;
    self.tableView.mj_header = [JstyleRefreshGiftHeader headerWithRefreshingBlock:^{
        page = 1;
        [weakSelf loadJstyleNewsHomeCateDataSource];
    }];
    
    self.tableView.mj_footer = [JstyleRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        page ++;
        [weakSelf loadJstyleNewsHomeCateDataSource];
    }];
}

- (void)addTableView
{
    _tableView = [[JstyleNewsBaseTableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - YG_StatusAndNavightion_H - TabbarHeight) style:(UITableViewStylePlain)];
    _tableView.separatorInset = UIEdgeInsetsMake(0, 10, 0, 10);
//    _tableView.separatorColor = kSingleLineColor;
//    _tableView.backgroundColor = kWhiteColor;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    self.tableView.tableFooterView = [UIView new];
    
    [_tableView registerNib:[UINib nibWithNibName:@"JstyleNewsOneImageArticleViewCell" bundle:nil] forCellReuseIdentifier:@"JstyleNewsOneImageArticleViewCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"JstyleNewsOnePlusImageArticleViewCell" bundle:nil] forCellReuseIdentifier:@"JstyleNewsOnePlusImageArticleViewCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"JstyleNewsThreeImageArticleViewCell" bundle:nil] forCellReuseIdentifier:@"JstyleNewsThreeImageArticleViewCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"JstyleNewsAdvertisementViewCell" bundle:nil] forCellReuseIdentifier:@"JstyleNewsAdvertisementViewCell"];
    
    [self.view addSubview:_tableView];
}

#pragma mark -- tableView的代理方法
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!self.dataArray.count) {
        static NSString *ID = @"cellID";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    JstyleNewsHomePageModel *model = self.dataArray[indexPath.row];
    switch ([model.type integerValue]) {
        case 1:{//大图图集
            if ([model.head_type integerValue] == 1 && [model.isImageArticle integerValue] == 1) {
                static NSString *ID = @"JstyleNewsOnePlusImageArticleViewCell";
                JstyleNewsOnePlusImageArticleViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
                if (!cell) {
                    cell = [[JstyleNewsOnePlusImageArticleViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
                }

                if (indexPath.row < self.dataArray.count) {
                    cell.model = model;
                }
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                [cell setupPreviewingDelegateWithController:self];
                return cell;
            }else if ([model.head_type integerValue] == 1) {//一图文章
                static NSString *ID = @"JstyleNewsOneImageArticleViewCell";
                JstyleNewsOneImageArticleViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
                if (!cell) {
                    cell = [[JstyleNewsOneImageArticleViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
                }
                
                if (indexPath.row < self.dataArray.count) {
                    cell.model = model;
                }
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                [cell setupPreviewingDelegateWithController:self];
                return cell;
            }else{//三图文章
                static NSString *ID = @"JstyleNewsThreeImageArticleViewCell";
                JstyleNewsThreeImageArticleViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
                if (!cell) {
                    cell = [[JstyleNewsThreeImageArticleViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
                }

                if (indexPath.row < self.dataArray.count) {
                    cell.model = model;
                }
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                [cell setupPreviewingDelegateWithController:self];
                return cell;
            }
        }
            break;
        case 3:{
            static NSString *ID = @"JstyleNewsAdvertisementViewCell";
            JstyleNewsAdvertisementViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
            if (!cell) {
                cell = [[JstyleNewsAdvertisementViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
            }
            
            if (indexPath.row < self.dataArray.count) {
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row >= self.dataArray.count) return 0;
    JstyleNewsHomePageModel *model = self.dataArray[indexPath.row];
    switch ([model.type integerValue]) {
        case 1:{
            if ([model.head_type integerValue] == 1 && [model.isImageArticle integerValue] == 1) {
                return [self.tableView cellHeightForIndexPath:indexPath model:self.dataArray[indexPath.row] keyPath:@"model" cellClass:[JstyleNewsOnePlusImageArticleViewCell class] contentViewWidth:kScreenWidth];
            }else if ([model.head_type integerValue] == 1) {

                if ([model.poster isNotBlank]) {
                    return ArticleImg_H + 31;//OneImageArticleView
                } else {//无图情况
                    
                    CGRect labelF  = [[NSString stringWithFormat:@"%@",model.title] getAttributedStringRectWithSpace:3
                                                                                                            withFont:JSTitleFontNumber
                                                                                                           withWidth:SCREEN_W-20];
                    return labelF.size.height+15+12+31;//OneImageArticleView
                }
            }else{
                return [self.tableView cellHeightForIndexPath:indexPath model:self.dataArray[indexPath.row] keyPath:@"model" cellClass:[JstyleNewsThreeImageArticleViewCell class] contentViewWidth:kScreenWidth];
            }
        }
            break;
        case 3:{
            return [self.tableView cellHeightForIndexPath:indexPath model:self.dataArray[indexPath.row] keyPath:@"model" cellClass:[JstyleNewsAdvertisementViewCell class] contentViewWidth:kScreenWidth];
        }
            break;
        default:
            return 0;
            break;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row >= self.dataArray.count) return;
    JstyleNewsArticleDetailModel *detailModel = self.detailDataArray[indexPath.row];
    JstyleNewsHomePageModel *model = self.dataArray[indexPath.row];
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
                    //文章
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

#pragma mark - 获取数据
- (void)loadJstyleNewsHomeCateDataSource
{
    NSDictionary *parameters = @{@"page":[NSString stringWithFormat:@"%ld",page],
                                 @"cid":self.cid
                                 };
    [[JstyleNewsNetworkManager shareManager] GETURL:HOME_PICTURE_ARTICLE_URL parameters:parameters success:^(id responseObject) {
        
        if ([responseObject[@"code"] integerValue] != 1) {
            if (self.dataArray.count) {
                [self.tableView.mj_header endRefreshing];
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }else{
                [self.tableView.mj_header endRefreshing];
                [self.tableView.mj_footer endRefreshing];
            }
            return;
        }
        if (page == 1){
            [self.dataArray removeAllObjects];
            [self.cacheListArray removeAllObjects];
            [self.detailDataArray removeAllObjects];
        }
        [self.dataArray addObjectsFromArray:[NSArray modelArrayWithClass:[JstyleNewsHomePageModel class] json:responseObject[@"data"]]];
        [self.cacheListArray addObjectsFromArray:responseObject[@"data"]];
        [[JstyleToolManager sharedManager].homeCateCacheDict setObject:self.cacheListArray forKey:[NSString stringWithFormat:@"%@", self.cid]];
        [self insertSqlite:[JstyleToolManager sharedManager].homeCateCacheDict];
        
        [self.detailDataArray addObjectsFromArray:[NSArray modelArrayWithClass:[JstyleNewsArticleDetailModel class] json:responseObject[@"data"]]];
        
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        
        [SVProgressHUD dismiss];
        [self.noSingleView removeFromSuperview];
        self.noSingleView = nil;
        self.tableView.scrollEnabled = YES;
        
    } failure:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        
        [self.noSingleView showNoConnectedLabelWithStatus:@"没有网络连接,请检查您的网络"];
        [SVProgressHUD dismiss];
    }];
}

/**创建缓存表*/
- (void)creatTableSqlite
{
    // 获取路径
    NSString * documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *dbPath = [documentsPath stringByAppendingPathComponent:@"NewsHomeCateList.sqlite"];
    
    // 初始化FMDB
    self.database = [FMDatabase databaseWithPath:dbPath];
    
    [self.database open];
    // executeUpdate:@"create table 表名 (列名 类型,..... )"
    FMResultSet * resultSet = [self.database executeQuery:@"select * from NewsHomeCateList"];
    if ([resultSet next] == NO){
        [self.database executeUpdate:@"create table NewsHomeCateList (NewsCateData blob)"];
    }
    
    [self.database close];
}

- (void)insertSqlite:(NSDictionary *)dictionary {
    
    [self.database open];
    
    [self.database executeUpdate:@"DELETE FROM NewsHomeCateList"];
    
    NSMutableArray *array = [NSMutableArray array];
    [array addObject:dictionary];
    
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:array];
    
    FMResultSet *resultSet =  [self.database executeQuery:@"insert into NewsHomeCateList(NewsCateData) values(?)" withArgumentsInArray:@[data]];
    [resultSet next];
    
    [self.database close];
}

/**取出缓存数据*/
- (void)getCacheDictionary
{
    NSString * documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *dbPath = [documentsPath stringByAppendingPathComponent:@"NewsHomeCateList.sqlite"];
    self.database = [FMDatabase databaseWithPath:dbPath];
    [self.database open];
    FMResultSet * resultSet = [self.database executeQuery:@"select * from NewsHomeCateList"];
    NSArray *cacheArray;
    while ([resultSet next] == YES){
        NSData *data = [resultSet dataForColumn:@"NewsCateData"];
        cacheArray = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    }
    [self.database close];
    
    NSDictionary *dictionary = cacheArray[0];
    self.dataArray = nil;
    self.detailDataArray = nil;
    NSArray *listArray = dictionary[[NSString stringWithFormat:@"%@", self.cid]];
    if (listArray.count) {
        [self.dataArray addObjectsFromArray:[NSArray modelArrayWithClass:[JstyleNewsHomePageModel class] json:listArray]];
        [self.detailDataArray addObjectsFromArray:[NSArray modelArrayWithClass:[JstyleNewsArticleDetailModel class] json:listArray]];
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
        if (self.dataArray.count > 0) {
            self.tableView.scrollEnabled = YES;
            [self.noSingleView removeFromSuperview];
            self.noSingleView = nil;
            [SVProgressHUD dismiss];
        }
    });
    return;
}

- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (NSMutableArray *)detailDataArray {
    if (_detailDataArray == nil) {
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

@end

