//
//  JstyleNewsVideoViewController.m
//  JstyleNews
//
//  Created by 数字跃动 on 2017/9/13.
//  Copyright © 2017年 JstyleNews. All rights reserved.
//

#import "JstyleNewsVideoViewController.h"
#import "JstyleNewsCustomBannerViewCell.h"
#import "JstyleNewsVideoHomeViewCell.h"
#import "JstyleNewsVideoHomeAdvertisementCell.h"
#import "JstyleNewsVideoDetailViewController.h"
#import "VRPlayerView.h"

#import "JstyleNewsArticleDetailViewController.h"
#import "JstylePictureTextViewController.h"
#import "JstyleNewsVideoDetailViewController.h"
#import "JstyleNewsActivityWebViewController.h"
#import "JstyleNewsVideoFullScreenShareView.h"

@interface JstyleNewsVideoViewController ()<UITableViewDelegate, UITableViewDataSource, VRPlayerViewDelegate, SDCycleScrollViewDelegate>{
    VRPlayerView *vrPlayer;
    NSIndexPath *currentIndexPath;
}

@property(nonatomic, retain) JstyleNewsVideoHomeViewCell *currentCell;

@property (nonatomic, strong) JstyleNewsBaseTableView *tableView;

@property (nonatomic, strong) NSMutableArray *bannerArray;
@property (nonatomic, strong) NSMutableArray *listArray;
@property (nonatomic, strong) SDCycleScrollView *bannerView;

@property (nonatomic, strong) FMDatabase *database;
@property (nonatomic, strong) NSMutableArray *cacheBannerArray;
@property (nonatomic, strong) NSMutableArray *cacheListArray;

@property (nonatomic, strong) JstyleNewsVideoHomeModel *shareModel;

@property (nonatomic, strong) JstyleNewsNoSinglePlaceholderView *noSingleView;

@end

static NSInteger page = 1;
@implementation JstyleNewsVideoViewController

- (void)dealloc
{
    [self releaseVRPlayer];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"视频";
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
            [weakSelf loadJstyleNewsVideoListData];
            [weakSelf getCacheDictionary];
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

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.translucent = NO;
    [_bannerView adjustWhenControllerViewWillAppera];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self releaseVRPlayer];
}

- (void)addReshAction
{
    __weak typeof(self)weakSelf = self;
    self.tableView.mj_header = [JstyleRefreshGiftHeader headerWithRefreshingBlock:^{
        page = 1;
        if (self.showBanner) {
            [weakSelf loadJstyleNewsVideoBannerData];
        }else{
            [weakSelf loadJstyleNewsVideoListData];
        }
    }];
    
    self.tableView.mj_footer = [JstyleRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        page ++;
        [weakSelf loadJstyleNewsVideoListData];
    }];
}

- (void)addTableView
{
    _tableView = [[JstyleNewsBaseTableView alloc]initWithFrame:CGRectZero style:(UITableViewStyleGrouped)];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.separatorInset = UIEdgeInsetsMake(0, 15, 0, 15);
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
    _tableView.sd_layout
    .topEqualToView(self.view)
    .bottomSpaceToView(self.view, YG_StatusAndNavightion_H + YG_SafeBottom_H)
    .leftEqualToView(self.view)
    .rightEqualToView(self.view);
}

#pragma mark -- tableView的代理方法

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    static NSString *ID = @"BannerHeader";
    UITableViewHeaderFooterView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:ID];
    if(headerView == nil){
        headerView = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:ID];
    }
    if (self.bannerArray.count) {
        NSMutableArray *imageArray = [[NSMutableArray alloc] init];
        for (JstyleNewsVideoHomeModel *model in self.bannerArray) {
            [imageArray addObject:model.poster];
        }
        [_bannerView removeFromSuperview];
        _bannerView = nil;
        _bannerView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0,0,kScreenWidth,165*kScreenWidth/375.0) delegate:self placeholderImage:nil];
        _bannerView.imageURLStringsGroup = imageArray;
        
        if (_bannerView.imageURLStringsGroup.count < 2) {
            _bannerView.autoScroll = NO;
        }else{
            _bannerView.autoScroll = YES;
        }
        _bannerView.bannerImageViewContentMode = UIViewContentModeScaleAspectFill;
        _bannerView.placeholderImage = SZ_Place_S_N;
        _bannerView.autoScrollTimeInterval = 4.0f;
        _bannerView.currentPageDotColor = kPinkColor;
        _bannerView.pageDotColor = [kDarkOneColor colorWithAlphaComponent:0.3];
        _bannerView.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
        _bannerView.pageControlRightOffset = 0;
        _bannerView.pageControlBottomOffset = 0;
        [headerView addSubview:_bannerView];
    }
    headerView.contentView.backgroundColor = ISNightMode?kDarkThreeColor:kWhiteColor;
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (self.bannerArray.count) return 175*kScreenWidth/375.0;
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
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
            //视频
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
    if (!(indexPath.row < self.listArray.count)) return 0;
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
    if ([model.type integerValue] == 2) {
        JstyleNewsVideoDetailViewController *jstyleNewsVideoDVC = [JstyleNewsVideoDetailViewController new];
        jstyleNewsVideoDVC.videoUrl = model.url_sd;
        jstyleNewsVideoDVC.videoTitle = model.title;
        jstyleNewsVideoDVC.vid = model.sendId;
        jstyleNewsVideoDVC.videoType = model.videoType;
        [self.navigationController pushViewController:jstyleNewsVideoDVC animated:YES];
    }else if ([model.type integerValue] == 3) {
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
    }
}

//自定义banner样式
- (Class)customCollectionViewCellClassForCycleScrollView:(SDCycleScrollView *)view
{
    return [JstyleNewsCustomBannerViewCell class];
}

- (void)setupCustomCell:(UICollectionViewCell *)cell forIndex:(NSInteger)index cycleScrollView:(SDCycleScrollView *)view
{
    if (index < self.bannerArray.count) {
        JstyleNewsVideoHomeModel *model = self.bannerArray[index];
        JstyleNewsCustomBannerViewCell *bannerCell = (JstyleNewsCustomBannerViewCell *)cell;
        [bannerCell.backImageView setImageWithURL:[NSURL URLWithString:model.poster] placeholder:SZ_Place_S_N options:(YYWebImageOptionSetImageWithFadeAnimation) completion:nil];
        //bannerCell.nameLabel.text = [NSString stringWithFormat:@"%@", model.title];
    }
}

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    JstyleNewsVideoHomeModel *model = self.bannerArray[index];
    switch ([model.banner_type integerValue]) {
        case 1:{
            if ([model.isImageArticle integerValue] == 1) {
                //图集
                JstylePictureTextViewController *jstyleNewsPictureTVC = [JstylePictureTextViewController new];
                jstyleNewsPictureTVC.rid = model.rid;
                [self.navigationController pushViewController:jstyleNewsPictureTVC animated:YES];
            }else{
                //文章
                JstyleNewsArticleDetailViewController *jstyleNewsArticleDVC = [JstyleNewsArticleDetailViewController new];
                jstyleNewsArticleDVC.rid = model.rid;
                [self.navigationController pushViewController:jstyleNewsArticleDVC animated:YES];
            }
        }
            break;
        case 2:{
            //视频直播
            JstyleNewsVideoDetailViewController *jstyleNewsVideoDVC = [JstyleNewsVideoDetailViewController new];
            jstyleNewsVideoDVC.videoUrl = model.url_sd;
            jstyleNewsVideoDVC.videoTitle = model.title;
            jstyleNewsVideoDVC.vid = model.rid;
            jstyleNewsVideoDVC.videoType = model.videoType;
            [self.navigationController pushViewController:jstyleNewsVideoDVC animated:YES];
        }
            break;
        case 3:{
            //广告活动
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

/**获取banner数据*/
- (void)loadJstyleNewsVideoBannerData
{
    NSDictionary *parameters = @{@"bcolumn":@"5"};
    [[JstyleNewsNetworkManager shareManager] GETURL:BANNER_LIST_URL parameters:parameters success:^(id responseObject) {
        if ([responseObject[@"code"] integerValue] == 1) {
            [self.bannerArray removeAllObjects];
            [self.cacheBannerArray removeAllObjects];
            
            [self.bannerArray addObjectsFromArray:[NSArray modelArrayWithClass:[JstyleNewsVideoHomeModel class] json:responseObject[@"data"]]];
            [self.cacheBannerArray addObjectsFromArray:responseObject[@"data"]];
            [[JstyleToolManager sharedManager].videoCacheDict setObject:self.cacheBannerArray forKey:@"banner"];
            [self insertSqlite:[JstyleToolManager sharedManager].videoCacheDict];
        }
        
        [self loadJstyleNewsVideoListData];
    } failure:^(NSError *error) {
        [self loadJstyleNewsVideoListData];
    }];
}

#pragma mark - 获取数据
- (void)loadJstyleNewsVideoListData
{
    NSDictionary *parameters = @{@"page":[NSString stringWithFormat:@"%ld",page],
                                 @"cid":self.cid
                                 };
    [[JstyleNewsNetworkManager shareManager] GETURL:HOME_PAGE_VIDEO_URL parameters:parameters success:^(id responseObject) {
        
        if ([responseObject[@"code"] integerValue] != 1) {
            if (self.listArray.count) {
                [self.tableView reloadData];
                [self.tableView.mj_header endRefreshing];
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }else{
                [self.tableView reloadData];
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
        [[JstyleToolManager sharedManager].videoCacheDict setObject:self.cacheListArray forKey:[NSString stringWithFormat:@"%@", self.cid]];
        [self insertSqlite:[JstyleToolManager sharedManager].videoCacheDict];
        
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
    if (ISNightMode) {
        [[UIApplication sharedApplication].keyWindow insertSubview:vrPlayer belowSubview:[NightModeManager defaultManager].nightView];
    }else{
        [[UIApplication sharedApplication].keyWindow addSubview:vrPlayer];
    }
    
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
    //VR视频相关处理
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
    [vrPlayer removeFromSuperview];
    [vrPlayer pause];
    [vrPlayer releseTimer];
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
    NSString *dbPath = [documentsPath stringByAppendingPathComponent:@"VideoHomePage.sqlite"];
    
    // 初始化FMDB
    self.database = [FMDatabase databaseWithPath:dbPath];
    
    [self.database open];
    // executeUpdate:@"create table 表名 (列名 类型,..... )"
    FMResultSet * resultSet = [self.database executeQuery:@"select * from VideoHomePage"];
    if ([resultSet next] == NO){
        [self.database executeUpdate:@"create table VideoHomePage (VideoHomeData blob)"];
    }
    
    [self.database close];
}

- (void)insertSqlite:(NSDictionary *)dictionary {
    
    [self.database open];
    
    [self.database executeUpdate:@"DELETE FROM VideoHomePage"];
    
    NSMutableArray *array = [NSMutableArray array];
    [array addObject:dictionary];
    
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:array];
    
    FMResultSet *resultSet =  [self.database executeQuery:@"insert into VideoHomePage(VideoHomeData) values(?)" withArgumentsInArray:@[data]];
    [resultSet next];
    
    [self.database close];
}

/**取出缓存数据*/
- (void)getCacheDictionary
{
    NSString * documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *dbPath = [documentsPath stringByAppendingPathComponent:@"VideoHomePage.sqlite"];
    self.database = [FMDatabase databaseWithPath:dbPath];
    [self.database open];
    FMResultSet * resultSet = [self.database executeQuery:@"select * from VideoHomePage"];
    NSArray *cacheArray;
    while ([resultSet next] == YES){
        NSData *data = [resultSet dataForColumn:@"VideoHomeData"];
        cacheArray = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    }
    [self.database close];
    
    NSDictionary *dictionary = cacheArray[0];
    self.bannerArray = nil;
    self.listArray = nil;
    NSArray *bannerArray = dictionary[@"banner"];
    NSArray *listArray = dictionary[[NSString stringWithFormat:@"%@", self.cid]];
    if (bannerArray.count && self.showBanner) {
        [self.bannerArray addObjectsFromArray:[NSArray modelArrayWithClass:[JstyleNewsVideoHomeModel class] json:bannerArray]];
    }
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

- (NSMutableArray *)bannerArray
{
    if (!_bannerArray) {
        _bannerArray = [NSMutableArray array];
    }
    return _bannerArray;
}

- (NSMutableArray *)cacheBannerArray
{
    if (!_cacheBannerArray) {
        _cacheBannerArray = [NSMutableArray array];
    }
    return _cacheBannerArray;
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
