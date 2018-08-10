//
//  JstyleNewsFeaturedVideoViewController.m
//  JstyleNews
//
//  Created by 数字宁波 on 2017/10/25.
//  Copyright © 2017年 JstyleNews. All rights reserved.
//

#import "JstyleNewsFeaturedVideoViewController.h"
#import "JstyleNewsVideoHomeViewCell.h"
#import "JstyleNewsVideoHomeAdvertisementCell.h"
#import "JstyleNewsVideoDetailViewController.h"
#import "VRPlayerView.h"
#import "JstyleNewsActivityWebViewController.h"
#import "JstyleNewsVideoFullScreenShareView.h"
#import "JstylePictureTextViewController.h"
#import "JstyleNewsArticleDetailViewController.h"

@interface JstyleNewsFeaturedVideoViewController ()<UITableViewDelegate, UITableViewDataSource, VRPlayerViewDelegate>{
    VRPlayerView *vrPlayer;
    NSIndexPath *currentIndexPath;
}

@property(nonatomic, retain) JstyleNewsVideoHomeViewCell *currentCell;

@property (nonatomic, strong) JstyleNewsBaseTableView *tableView;
@property (nonatomic, strong) NSMutableArray *listArray;

@property (nonatomic, strong) FMDatabase *database;
@property (nonatomic, strong) NSMutableArray *cacheListArray;

@property (nonatomic, strong) JstyleNewsVideoHomeModel *shareModel;

@property (nonatomic, strong) JstyleNewsNoSinglePlaceholderView *noSingleView;

@end

static NSInteger page = 1;
@implementation JstyleNewsFeaturedVideoViewController

- (void)dealloc
{
    [self releaseVRPlayer];
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

- (void)addNoSingleView{
    
    if ([[JstyleToolManager sharedManager] getCurrentNetStatus] == NotReachable) {
        self.noSingleView = [[JstyleNewsNoSinglePlaceholderView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - YG_StatusAndNavightion_H - TabbarHeight)];
        [self.view addSubview:self.noSingleView];
        self.tableView.scrollEnabled = NO;
        __weak typeof(self)weakSelf = self;
        self.noSingleView.reloadBlock = ^{
            [SVProgressHUD showWithStatus:@"正在努力加载"];
            [weakSelf loadJstyleNewsFeaturedVideoDataSource];
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

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self releaseVRPlayer];
}

- (void)zj_viewDidLoadForIndex:(NSInteger)index {
  
}

- (void)addReshAction
{
    __weak typeof(self)weakSelf = self;
    self.tableView.mj_header = [JstyleRefreshGiftHeader headerWithRefreshingBlock:^{
        page = 1;
        [weakSelf loadJstyleNewsFeaturedVideoDataSource];
    }];
    
    self.tableView.mj_footer = [JstyleRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        page ++;
        [weakSelf loadJstyleNewsFeaturedVideoDataSource];
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
    
    [_tableView registerNib:[UINib nibWithNibName:@"JstyleNewsVideoHomeViewCell" bundle:nil] forCellReuseIdentifier:@"JstyleNewsVideoHomeViewCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"JstyleNewsVideoHomeAdvertisementCell" bundle:nil] forCellReuseIdentifier:@"JstyleNewsVideoHomeAdvertisementCell"];
    
    [self.view addSubview:_tableView];
}

#pragma mark -- tableView的代理方法
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.listArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!self.listArray.count) {
        static NSString *ID = @"cellID";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    JstyleNewsVideoHomeModel *model = self.listArray[indexPath.row];
    switch ([model.type integerValue]) {
        case 2:{
            static NSString *ID = @"JstyleNewsVideoHomeViewCell";
            JstyleNewsVideoHomeViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
            if (!cell) {
                cell = [[JstyleNewsVideoHomeViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
            }
            
            cell.videoPlayBtn.tag = indexPath.row;
            cell.startPlayVideoBlock = ^(UIButton *sender) {
                [self startPlayVideo:sender];
            };
            cell.videoShareBlock = ^(NSString *shareImgUrl, NSString *shareUrl, NSString *shareTitle, NSString *shareDesc) {
                [[JstyleToolManager sharedManager] shareVideoWithShareTitle:shareTitle shareDesc:shareDesc shareUrl:shareUrl shareImgUrl:shareImgUrl viewController:self];
            };
            
            if (vrPlayer && vrPlayer.superview) {
                NSArray *indexpaths = [tableView indexPathsForVisibleRows];
                if (![indexpaths containsObject:currentIndexPath] && currentIndexPath != nil) {//复用
                    if (![[UIApplication sharedApplication].keyWindow.subviews containsObject:vrPlayer]) {
                        [self releaseVRPlayer];
                    }
                }
            }
            
            if (self.listArray.count) {
                cell.model = self.listArray[indexPath.row];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
            break;
        case 3:{
            static NSString *ID = @"JstyleNewsVideoHomeAdvertisementCell";
            JstyleNewsVideoHomeAdvertisementCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
            if (!cell) {
                cell = [[JstyleNewsVideoHomeAdvertisementCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
            }
            
            if (self.listArray.count) {
                cell.model = self.listArray[indexPath.row];
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
    JstyleNewsVideoHomeModel *model = self.listArray[indexPath.row];
    switch ([model.type integerValue]) {
        case 2:{
            return [self.tableView cellHeightForIndexPath:indexPath model:self.listArray[indexPath.row] keyPath:@"model" cellClass:[JstyleNewsVideoHomeViewCell class] contentViewWidth:kScreenWidth];
        }
            break;
        case 3:
            return [self.tableView cellHeightForIndexPath:indexPath model:self.listArray[indexPath.row] keyPath:@"model" cellClass:[JstyleNewsVideoHomeAdvertisementCell class] contentViewWidth:kScreenWidth];
            break;
        default:
            return 0;
            break;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self releaseVRPlayer];
    if (indexPath.row >= self.listArray.count) return;
    JstyleNewsVideoHomeModel *model = self.listArray[indexPath.row];
    if ([model.type integerValue] == 3) {
        //广告活动
        switch ([model.banner_type integerValue]) {
            case 1:
                //文章
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
                break;
            case 2:{
                //视频直播
                JstyleNewsVideoDetailViewController *jstyleNewsVideoDVC = [JstyleNewsVideoDetailViewController new];
                jstyleNewsVideoDVC.videoUrl = model.url_sd;
                jstyleNewsVideoDVC.videoTitle = model.title;
                jstyleNewsVideoDVC.vid = model.sendId;
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
    }else{//视频
        JstyleNewsVideoDetailViewController *jstyleNewsVideoDVC = [JstyleNewsVideoDetailViewController new];
        jstyleNewsVideoDVC.videoUrl = model.url_sd;
        jstyleNewsVideoDVC.videoTitle = model.title;
        jstyleNewsVideoDVC.vid = model.sendId;
        jstyleNewsVideoDVC.videoType = model.videoType;
        [self.navigationController pushViewController:jstyleNewsVideoDVC animated:YES];
    }
}

#pragma mark - 获取数据
- (void)loadJstyleNewsFeaturedVideoDataSource
{
    NSDictionary *parameters = @{@"page":[NSString stringWithFormat:@"%ld",(long)page]};
    [[JstyleNewsNetworkManager shareManager] GETURL:HOME_PAGE_VIDEO_URL parameters:parameters success:^(id responseObject) {
        
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
        
        [self.listArray addObjectsFromArray:[NSArray modelArrayWithClass:[JstyleNewsVideoHomeModel class] json:responseObject[@"data"]]];
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

#pragma mark 视频列表播放的相关代码
//把播放器vrPlayer对象放到cell上，同时更新约束
- (void)toCell{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"JstyleLandscapeRight"];
    JstyleNewsVideoHomeViewCell *currentCell = (JstyleNewsVideoHomeViewCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:currentIndexPath.row inSection:0]];
    [vrPlayer removeFromSuperview];
    
    SEL selector = NSSelectorFromString(@"setOrientation:");
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
    [invocation setSelector:selector];
    [invocation setTarget:[UIDevice currentDevice]];
    int val = UIInterfaceOrientationPortrait;
    [invocation setArgument:&val atIndex:2];
    [invocation invoke];
    
    [currentCell.contentView addSubview:vrPlayer];
    [currentCell.contentView bringSubviewToFront:vrPlayer];
    vrPlayer.sd_layout
    .leftEqualToView(currentCell.backImageView)
    .rightEqualToView(currentCell.backImageView)
    .topEqualToView(currentCell.backImageView)
    .bottomEqualToView(currentCell.backImageView);
}

- (void)toFullScreenWithInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
    [[NSUserDefaults standardUserDefaults] setObject:@"JstyleLandscapeRight" forKey:@"JstyleLandscapeRight"];
    [vrPlayer removeFromSuperview];
    if(interfaceOrientation == UIInterfaceOrientationLandscapeRight){
        SEL selector = NSSelectorFromString(@"setOrientation:");
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
        [invocation setSelector:selector];
        [invocation setTarget:[UIDevice currentDevice]];
        int val = UIInterfaceOrientationLandscapeRight;//这里可以改变旋转的方向
        [invocation setArgument:&val atIndex:2];
        [invocation invoke];
    }
    [[UIApplication sharedApplication].keyWindow addSubview:vrPlayer];
    vrPlayer.sd_resetNewLayout
    .leftEqualToView([UIApplication sharedApplication].keyWindow)
    .rightEqualToView([UIApplication sharedApplication].keyWindow)
    .topEqualToView([UIApplication sharedApplication].keyWindow)
    .bottomEqualToView([UIApplication sharedApplication].keyWindow);
}

-(void)startPlayVideo:(UIButton *)sender{
    currentIndexPath = [NSIndexPath indexPathForRow:sender.tag inSection:0];
    
    UIView *cellView = [sender superview];
    while (![cellView isKindOfClass:[UITableViewCell class]])
    {
        cellView =  [cellView superview];
    }
    self.currentCell = (JstyleNewsVideoHomeViewCell *)cellView;
    if (sender.tag >= self.listArray.count) return;
    JstyleNewsVideoHomeModel *model = self.listArray[sender.tag];
    self.shareModel = model;
    
    if (vrPlayer) {
        [self releaseVRPlayer];
    }
    
    if ([self.currentCell.model.videoType isEqualToString:@"1"]) {//是VR
        vrPlayer = [[VRPlayerView alloc]initWithFrame:self.currentCell.backImageView.bounds withVrUrl:[NSURL URLWithString:model.url_sd] withVrType:(VrType_AVPlayer_VR)];
        vrPlayer.boxButton.hidden = NO;
        
    }else{
        vrPlayer = [[VRPlayerView alloc]initWithFrame:self.currentCell.backImageView.bounds withVrUrl:[NSURL URLWithString:model.url_sd] withVrType:(VrType_AVPlayer_Normal)];
        vrPlayer.boxButton.hidden = YES;
    }
    
    vrPlayer.backBtn.hidden = YES;
    vrPlayer.netBackBtn.hidden = YES;
    vrPlayer.delegate = self;
    vrPlayer.bottomView.hidden = YES;

    
    [self.currentCell.contentView addSubview:vrPlayer];
    [self.currentCell.contentView bringSubviewToFront:vrPlayer];
    vrPlayer.sd_layout
    .leftEqualToView(self.currentCell.backImageView)
    .rightEqualToView(self.currentCell.backImageView)
    .topEqualToView(self.currentCell.backImageView)
    .bottomEqualToView(self.currentCell.backImageView);
}

/**
 *  释放vrPlayer
 */
-(void)releaseVRPlayer{
    [vrPlayer pause];
    [vrPlayer releseTimer];
    [vrPlayer removeFromSuperview];
    vrPlayer.player = nil;
    vrPlayer = nil;
}

- (void)vrPlayerView:(VRPlayerView *)vrPlayerView backBtnClicked:(BOOL)backBtnSelected
{
    if (backBtnSelected) {
        [vrPlayer.fullScreenBtn sendActionsForControlEvents:(UIControlEventTouchUpInside)];
    }
}

- (void)vrPlayerView:(VRPlayerView *)vrPlayerView moreBtn:(UIButton *)moreBtn
{
    [vrPlayer.playPauseBtn sendActionsForControlEvents:(UIControlEventTouchUpInside)];
    JstyleNewsVideoFullScreenShareView *jstyleShareView = [[JstyleNewsVideoFullScreenShareView alloc] initWithFrame:CGRectMake(0, kScreenWidth, kScreenHeight, kScreenWidth) shareTitle:self.shareModel.title shareDesc:self.shareModel.describes shareUrl:self.shareModel.ashareurl shareImgUrl:self.shareModel.poster viewController:self];
    [UIView animateWithDuration:0.25 animations:^{
        jstyleShareView.y = 0;
    }];
    __weak JstyleNewsVideoFullScreenShareView *weakShareView = jstyleShareView;
    __weak UIButton *playPauseBtn = vrPlayer.playPauseBtn;
    jstyleShareView.closeBlock = ^{
        [UIView animateWithDuration:0.25 animations:^{
            weakShareView.y = kScreenWidth;
        } completion:^(BOOL finished) {
            [weakShareView removeFromSuperview];
            [playPauseBtn sendActionsForControlEvents:(UIControlEventTouchUpInside)];
        }];
    };
    [[UIApplication sharedApplication].keyWindow addSubview:jstyleShareView];
}

-(void)vrPlayerView:(VRPlayerView *)vrPlayerView clickedFullScreen:(UIButton *)fullScreen{
    if (fullScreen.isSelected) {
        vrPlayer.backBtn.hidden = NO;
        [self toFullScreenWithInterfaceOrientation:UIInterfaceOrientationLandscapeRight];
    }else{
        vrPlayer.backBtn.hidden = YES;
        [self toCell];
    }
}

/**创建缓存表*/
- (void)creatTableSqlite
{
    // 获取路径
    NSString * documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *dbPath = [documentsPath stringByAppendingPathComponent:@"NewsHomeVideoList.sqlite"];
    
    // 初始化FMDB
    self.database = [FMDatabase databaseWithPath:dbPath];
    
    [self.database open];
    // executeUpdate:@"create table 表名 (列名 类型,..... )"
    FMResultSet * resultSet = [self.database executeQuery:@"select * from NewsHomeVideoList"];
    if ([resultSet next] == NO){
        [self.database executeUpdate:@"create table NewsHomeVideoList (VideoData blob)"];
    }
    
    [self.database close];
}

- (void)insertSqlite:(NSDictionary *)sender {
    
    [self.database open];
    
    [self.database executeUpdate:@"DELETE FROM NewsHomeVideoList"];
    
    NSMutableArray *array = [NSMutableArray array];
    [array addObject:sender];
    
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:array];
    
    FMResultSet *resultSet =  [self.database executeQuery:@"insert into NewsHomeVideoList(VideoData) values(?)" withArgumentsInArray:@[data]];
    [resultSet next];
    
    [self.database close];
}

/**取出缓存数据*/
- (void)getCacheDictionary
{
    NSString * documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *dbPath = [documentsPath stringByAppendingPathComponent:@"NewsHomeVideoList.sqlite"];
    self.database = [FMDatabase databaseWithPath:dbPath];
    [self.database open];
    FMResultSet * resultSet = [self.database executeQuery:@"select * from NewsHomeVideoList"];
    NSArray *cacheArray;
    while ([resultSet next] == YES){
        NSData *data = [resultSet dataForColumn:@"VideoData"];
        cacheArray = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    }
    [self.database close];
    
    NSDictionary *dictionary = cacheArray[0];
    self.listArray = nil;
    NSArray *listArray = dictionary[@"list"];
    if (listArray.count) {
        [self.listArray addObjectsFromArray:[NSArray modelArrayWithClass:[JstyleNewsVideoHomeModel class] json:listArray]];
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

