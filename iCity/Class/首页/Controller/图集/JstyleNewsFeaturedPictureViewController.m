//
//  JstyleNewsFeaturedPictureViewController.m
//  JstyleNews
//
//  Created by 赵涛 on 2017/10/25.
//  Copyright © 2017年 JstyleNews. All rights reserved.
//

#import "JstyleNewsFeaturedPictureViewController.h"
#import "JstyleNewsFeaturedPictureViewCell.h"
#import "JstyleNewsAdvertisementViewCell.h"
#import "JstylePictureTextViewController.h"

@interface JstyleNewsFeaturedPictureViewController ()<UITableViewDelegate,UITableViewDataSource,UIViewControllerPreviewingDelegate>

@property (nonatomic, strong) JstyleNewsBaseTableView *tableView;
@property (nonatomic, strong) NSMutableArray *listArray;

@property (nonatomic, strong) FMDatabase *database;
@property (nonatomic, strong) NSMutableArray *cacheListArray;

@property (nonatomic, strong) JstyleNewsNoSinglePlaceholderView *noSingleView;

@end

static NSInteger page = 1;
@implementation JstyleNewsFeaturedPictureViewController

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



- (UIViewController *)previewingContext:(id<UIViewControllerPreviewing>)previewingContext viewControllerForLocation:(CGPoint)location {
    
    NSIndexPath *indexPath = [self.tableView indexPathForCell:(UITableViewCell* )[previewingContext sourceView]];
    
    JstylePictureTextViewController *pictureVC = [[JstylePictureTextViewController alloc] init];
    pictureVC.preferredContentSize = CGSizeMake(0.0f,500.0f);
    if (indexPath.row < self.listArray.count) {
        pictureVC.rid = [self.listArray[indexPath.row] id];
        CGRect rect = CGRectMake(0, 0, self.view.frame.size.width,[self.tableView cellForRowAtIndexPath:indexPath].height);
        previewingContext.sourceRect = rect;
    }
    
    return pictureVC;
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
            [weakSelf loadJstyleNewsFeaturedPictureDataSource];
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
        [weakSelf loadJstyleNewsFeaturedPictureDataSource];
    }];
    
    self.tableView.mj_footer = [JstyleRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        page ++;
        [weakSelf loadJstyleNewsFeaturedPictureDataSource];
    }];
}

- (void)addTableView
{
    _tableView = [[JstyleNewsBaseTableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - YG_StatusAndNavightion_H - TabbarHeight) style:(UITableViewStylePlain)];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.separatorInset = UIEdgeInsetsMake(0, 10, 0, 10);
//    _tableView.separatorColor = kSingleLineColor;
//    _tableView.backgroundColor = kWhiteColor;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    self.tableView.tableFooterView = [UIView new];
    
    [_tableView registerNib:[UINib nibWithNibName:@"JstyleNewsFeaturedPictureViewCell" bundle:nil] forCellReuseIdentifier:@"JstyleNewsFeaturedPictureViewCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"JstyleNewsAdvertisementViewCell" bundle:nil] forCellReuseIdentifier:@"JstyleNewsAdvertisementViewCell"];
    
    [self.view addSubview:_tableView];
}

#pragma mark -- tableView的代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.listArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!self.listArray.count) {
        return nil;
    }
    JstyleNewsHomePageModel *model = self.listArray[indexPath.row];
    switch ([model.type integerValue]) {
        case 1:{
            static NSString *ID = @"JstyleNewsFeaturedPictureViewCell";
            JstyleNewsFeaturedPictureViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
            if (!cell) {
                cell = [[JstyleNewsFeaturedPictureViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
            }
            
            if (indexPath.row < self.listArray.count) {
                cell.model = model;
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            [cell setupPreviewingDelegateWithController:self];
            
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    JstyleNewsHomePageModel *model = self.listArray[indexPath.row];
    switch ([model.type integerValue]) {
        case 1:{
            return [self.tableView cellHeightForIndexPath:indexPath model:self.listArray[indexPath.row] keyPath:@"model" cellClass:[JstyleNewsFeaturedPictureViewCell class] contentViewWidth:kScreenWidth];
        }
            break;
        case 3:{
            return [self.tableView cellHeightForIndexPath:indexPath model:self.listArray[indexPath.row] keyPath:@"model" cellClass:[JstyleNewsAdvertisementViewCell class] contentViewWidth:kScreenWidth];
        }
            break;
        default:
            return 0;
            break;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row >= self.listArray.count) return;
    JstyleNewsHomePageModel *model = self.listArray[indexPath.row];
    if ([model.type integerValue] == 3) {
        
    }else{
        JstylePictureTextViewController *jstylePictureTextVC = [JstylePictureTextViewController new];
        jstylePictureTextVC.rid = model.id;
        [self.navigationController pushViewController:jstylePictureTextVC animated:YES];
    }
}

#pragma mark - 获取数据
- (void)loadJstyleNewsFeaturedPictureDataSource
{
    NSDictionary *parameters = @{@"page":[NSString stringWithFormat:@"%ld",page],
                                 @"isImageArticle":@"1"
                                 };
    [[JstyleNewsNetworkManager shareManager] GETURL:HOME_PICTURE_ARTICLE_URL parameters:parameters success:^(id responseObject) {
        
        if ([responseObject[@"code"] integerValue] != 1) {
            if (self.listArray.count) {
                [self.tableView.mj_header endRefreshing];
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }else{
                [self.tableView.mj_header endRefreshing];
                [self.tableView.mj_footer endRefreshing];
            }
            return;
        }
        
        if (page == 1) {
            [self.listArray removeAllObjects];
            [self.cacheListArray removeAllObjects];
        }
        
        [self.listArray addObjectsFromArray:[NSArray modelArrayWithClass:[JstyleNewsHomePageModel class] json:responseObject[@"data"]]];
        [self.cacheListArray addObjectsFromArray:responseObject[@"data"]];
        [self insertSqlite:@{@"list":self.cacheListArray}];
        
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        
        [SVProgressHUD dismiss];
        self.tableView.scrollEnabled = YES;
        [self.noSingleView removeFromSuperview];
        self.noSingleView = nil;
        
    } failure:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        
        [SVProgressHUD dismiss];
        [self.noSingleView showNoConnectedLabelWithStatus:@"没有网络连接,请检查您的网络"];
    }];
}

/**创建缓存表*/
- (void)creatTableSqlite
{
    // 获取路径
    NSString * documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *dbPath = [documentsPath stringByAppendingPathComponent:@"NewsHomePicturesList.sqlite"];
    
    // 初始化FMDB
    self.database = [FMDatabase databaseWithPath:dbPath];
    
    [self.database open];
    // executeUpdate:@"create table 表名 (列名 类型,..... )"
    FMResultSet * resultSet = [self.database executeQuery:@"select * from NewsHomePicturesList"];
    if ([resultSet next] == NO){
        [self.database executeUpdate:@"create table NewsHomePicturesList (PicturesData blob)"];
    }
    
    [self.database close];
}

- (void)insertSqlite:(NSDictionary *)sender {
    
    [self.database open];
    
    [self.database executeUpdate:@"DELETE FROM NewsHomePicturesList"];
    
    NSMutableArray *array = [NSMutableArray array];
    [array addObject:sender];
    
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:array];
    
    FMResultSet *resultSet =  [self.database executeQuery:@"insert into NewsHomePicturesList(PicturesData) values(?)" withArgumentsInArray:@[data]];
    [resultSet next];
    
    [self.database close];
}

/**取出缓存数据*/
- (void)getCacheDictionary
{
    NSString * documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *dbPath = [documentsPath stringByAppendingPathComponent:@"NewsHomePicturesList.sqlite"];
    self.database = [FMDatabase databaseWithPath:dbPath];
    [self.database open];
    FMResultSet * resultSet = [self.database executeQuery:@"select * from NewsHomePicturesList"];
    NSArray *cacheArray;
    while ([resultSet next] == YES){
        NSData *data = [resultSet dataForColumn:@"PicturesData"];
        cacheArray = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    }
    [self.database close];
    
    NSDictionary *dictionary = cacheArray[0];
    self.listArray = nil;
    NSArray *listArray = dictionary[@"list"];
    if (listArray.count) {
        [self.listArray addObjectsFromArray:[NSArray modelArrayWithClass:[JstyleNewsHomePageModel class] json:listArray]];
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

- (NSMutableArray *)cacheListArray
{
    if (!_cacheListArray) {
        _cacheListArray = [NSMutableArray array];
    }
    return _cacheListArray;
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


