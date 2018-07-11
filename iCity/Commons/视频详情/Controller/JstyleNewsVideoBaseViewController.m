//
//  JstyleNewsVideoBaseViewController.m
//  JstyleNews
//
//  Created by JingHongMuYun on 2017/12/7.
//  Copyright © 2017年 JstyleNews. All rights reserved.
//

#import "JstyleNewsVideoBaseViewController.h"
#import "JstyleNewsVideoTagChooseViewController.h"
#import "JstyleNewsVideoViewController.h"
#import "ZJScrollPageView.h"
#import "WRNavigationBar.h"

@interface JstyleNewsVideoBaseViewController ()<ZJScrollPageViewDelegate>

@property(weak, nonatomic) ZJScrollPageView *scrollPageView;

@property (nonatomic, copy) NSMutableDictionary *channelsDict;

@property (nonatomic, strong) NSMutableArray *myTitlesArray;

@property (nonatomic, strong) NSMutableArray *tjTitlesArray;

@property (nonatomic, strong) FMDatabase *database;

@property (nonatomic, strong) NSArray *cacheArray;

@property (nonatomic, strong) NSMutableDictionary *cacheDict;

@property (nonatomic, strong) NSArray *cacheTitlesArray;

@property (nonatomic, strong) UIButton *reloadBtn;

@property (nonatomic, strong) JstyleNewsNoSinglePlaceholderView *noSingleView;

@end

@implementation JstyleNewsVideoBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self addPageView];
    [self creatTableSqlite];
    [self getCacheDictionary];
    [self loadJstyleNewsMyChannelDataSource:YES];
    [self loadJstyleNewsTjChannelDataSource];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return [[LEETheme currentThemeTag] isEqualToString:ThemeName_White] ? UIStatusBarStyleDefault : UIStatusBarStyleLightContent;
}

- (void)addNoSingleView{
    
    if ([[JstyleToolManager sharedManager] getCurrentNetStatus] == NotReachable) {
        self.noSingleView = [[JstyleNewsNoSinglePlaceholderView alloc] initWithFrame:CGRectMake(0, YG_StatusAndNavightion_H, kScreenWidth, kScreenHeight - YG_StatusAndNavightion_H - TabbarHeight - YG_StatusAndNavightion_H)];
        [self.view addSubview:self.noSingleView];
        
        __weak typeof(self)weakSelf = self;
        self.noSingleView.reloadBlock = ^{
            [SVProgressHUD showWithStatus:@"正在努力加载"];
            [weakSelf loadJstyleNewsMyChannelDataSource:YES];
            [weakSelf loadJstyleNewsTjChannelDataSource];
        };
    }
}

- (void)addReloadBtn
{
    [_reloadBtn removeFromSuperview];
    _reloadBtn = [[UIButton alloc] init];
    _reloadBtn.titleLabel.font = JSFont(15);
    [_reloadBtn setTitle:@"重新加载" forState:(UIControlStateNormal)];
    [_reloadBtn setTitleColor:kPinkColor forState:(UIControlStateNormal)];
    _reloadBtn.layer.borderWidth = 1;
    _reloadBtn.layer.borderColor = kPinkColor.CGColor;
    [_reloadBtn addTarget:self action:@selector(reloadBtnClicked:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.scrollPageView.contentView insertSubview:_reloadBtn atIndex:1];
    _reloadBtn.sd_layout
    .centerXEqualToView(self.scrollPageView.contentView)
    .centerYEqualToView(self.scrollPageView.contentView).offset(- 50)
    .widthIs(90)
    .heightIs(30);
}

- (void)reloadBtnClicked:(UIButton *)sender
{
    [self loadJstyleNewsMyChannelDataSource:YES];
    [self loadJstyleNewsTjChannelDataSource];
}

#pragma mark - LazyLoad
- (void)addPageView {
    UIImageView *holdImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, YG_StatusAndNavightion_H)];
    UIImage *bgImage = [[UIImage imageNamed:@"背景渐变"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0) resizingMode:UIImageResizingModeStretch];
    holdImageView.image = bgImage;
    holdImageView.lee_theme
    .LeeCustomConfig(ThemeLogoHeaderImage, ^(id item, id value) {
        UIImage *bgImage;
        if ([[LEETheme currentThemeTag] isEqualToString:ThemeName_Red]) {//(IS_iPhoneX ? @"背景渐变-扁-iPhone X" : @"背景渐变-扁")
            bgImage = [[UIImage imageNamed:@"背景渐变"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0) resizingMode:UIImageResizingModeStretch];
        } else {
            bgImage = [value resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0) resizingMode:UIImageResizingModeStretch];
        }
        [holdImageView setImage:bgImage];
    });
    [self.view addSubview:holdImageView];
    
    //必要的设置, 如果没有设置可能导致内容显示不正常
    self.automaticallyAdjustsScrollViewInsets = NO;
    ZJSegmentStyle *style = [[ZJSegmentStyle alloc] init];
    //显示遮盖
    style.showCover = YES;
    style.coverCornerRadius = 2;
    style.adjustCoverOrLineWidth = YES;
    style.coverHeight = 24;
    style.coverBackgroundColor = [UIColor colorFromHexString:@"#AA001A"];;
    style.segmentViewBounces = NO;
    style.normalTitleColor = RGBACOLOR(255, 255, 255, 1);
    style.selectedTitleColor = RGBACOLOR(255, 255, 255, 1);
    style.titleFont = JSFontWithWeight(15, UIFontWeightRegular);
    style.selectedTitleFont = JSFontWithWeight(15, UIFontWeightHeavy);
    // 颜色渐变
    style.gradualChangeTitleColor = YES;
    // 显示附加的按钮
    style.showExtraButton = YES;
    // 设置附加按钮的背景图片
    style.extraBtnBackgroundImageName = @"编辑加号";
    style.segmentHeight = 40;
    style.autoAdjustTitlesWidth = YES;
    
    //    style.segmentViewComponent = SegmentViewComponentShowCover |  SegmentViewComponentShowExtraButton | SegmentViewComponentGraduallyChangeTitleColor;
    // 当标题宽度总和小于ZJScrollPageView的宽度的时候, 标题会自适应宽度
    
    // 初始化
    CGRect scrollPageViewFrame = CGRectMake(0, YG_StatusBarH+4, kScreenWidth, kScreenHeight);
    
    ZJScrollPageView *scrollPageView = [[ZJScrollPageView alloc] initWithFrame:scrollPageViewFrame segmentStyle:style titles:self.myTitlesArray parentViewController:self delegate:self];
    scrollPageView.segmentView.isChannelTags = YES;
    
    self.scrollPageView = scrollPageView;
    
    scrollPageView.segmentView.coverLayer.lee_theme
    .LeeCustomConfig(ThemeChannelTagBackgroundColor, ^(id item, id value) {
        [item setBackgroundColor:value];
        [item setAlpha:0.45];
    });
    
    scrollPageView.segmentView.lee_theme
    .LeeCustomConfig(ThemeDiscoveryNavigationBarTitleColor, ^(id item, id value) {
        ((ZJScrollSegmentView *)item).clickTextNormalColorBlock = ^(ZJTitleView *titleView) {
            titleView.textColor = value;
        };
        ((ZJScrollSegmentView *)item).clickTextSelectColorBlock = ^(ZJTitleView *titleView) {
            titleView.textColor = value;
        };
    });
    
    scrollPageView.segmentView.textColorBlock = ^(ZJTitleView *oldTitleView, ZJTitleView *currentTitleView) {
        oldTitleView.label.lee_theme
        .LeeConfigTextColor(ThemeChannelTagTitleNormalColor);
        currentTitleView.label.lee_theme
        .LeeConfigTextColor(ThemeChannelTagTitleSelectColor);
    };
    
    
    scrollPageView.extraBtnOnClick = ^(UIButton *extraBtn){
        JstyleNewsVideoTagChooseViewController *jstyleNewsVideoTagCVC = [JstyleNewsVideoTagChooseViewController new];
        
        jstyleNewsVideoTagCVC.myChannelBlock = ^(NSArray *channelsArray) {
            self.myTitlesArray = [NSMutableArray arrayWithArray:channelsArray];
            [self.scrollPageView reloadWithNewTitles:self.myTitlesArray];
            
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                NSMutableArray *sortArray = [NSMutableArray array];
                for (NSString *title in channelsArray) {
                    NSDictionary *dict = [self.channelsDict objectForKey:title];
                    @try {
                        [sortArray addObject:dict];
                    } @catch (NSException *exception) {
                        [sortArray removeObject:dict];
                    } @finally {};
                }
                NSString *json = [sortArray mj_JSONString];
                [self postJstyleNewsMyChannelSortWithJsonStr:json];
            });
        };
        
        jstyleNewsVideoTagCVC.myChannelClicked = ^(NSString *channelName) {
            for (int index = 0; index < self.myTitlesArray.count; index ++) {
                NSString *title = self.myTitlesArray[index];
                if ([title isEqualToString:channelName]) {
                    [self.scrollPageView setSelectedIndex:index animated:YES];
                    break;
                }
            }
        };
        
        CATransition *animation = [CATransition animation];
        animation.duration = 0.4;
        animation.timingFunction = UIViewAnimationCurveEaseInOut;
        animation.type = kCATransitionMoveIn;
        animation.subtype = kCATransitionFromBottom;
        [self.view.window.layer addAnimation:animation forKey:nil];
        [self presentViewController:jstyleNewsVideoTagCVC animated:NO completion:nil];
    };
    [self.view addSubview:scrollPageView];
}

- (NSInteger)numberOfChildViewControllers {
    return self.myTitlesArray.count;
}

- (UIViewController<ZJScrollPageViewChildVcDelegate> *)childViewController:(UIViewController<ZJScrollPageViewChildVcDelegate> *)reuseViewController forIndex:(NSInteger)index {
    NSString *title = self.myTitlesArray[index];
    NSDictionary *dictionary = [self.channelsDict objectForKey:title];
    
    JstyleNewsVideoViewController *jstyleNewsVideoVC = [JstyleNewsVideoViewController new];
    jstyleNewsVideoVC.cid = dictionary[@"id"];
    if (index == 0) {
        jstyleNewsVideoVC.showBanner = YES;
    }else{
        jstyleNewsVideoVC.showBanner = NO;
    }
    return jstyleNewsVideoVC;
}

- (BOOL)shouldAutomaticallyForwardAppearanceMethods {
    return NO;
}

/**获取我的频道数据*/
- (void)loadJstyleNewsMyChannelDataSource:(BOOL)reload
{
    NSDictionary *parameters = @{@"type":@"1",
                                 @"category":@"2",
                                 @"uid":[[JstyleToolManager sharedManager] getUDID],
                                 @"userid":[[JstyleToolManager sharedManager] getUserId]
                                 };
    [[JstyleNewsNetworkManager shareManager] GETURL:CHANNEL_LIST_URL parameters:parameters success:^(id responseObject) {
        if ([responseObject[@"code"] integerValue] == 1) {
            [self.myTitlesArray removeAllObjects];
            [self.cacheDict setObject:responseObject forKey:@"mychannel"];
            [self insertSqlite:self.cacheDict];
            
            for (NSDictionary *dict in responseObject[@"data"]) {
                [self.channelsDict setValue:dict forKey:dict[@"head_name"]];
                [self.myTitlesArray addObject:dict[@"head_name"]];
            }
            if (reload && self.myTitlesArray.count && !self.cacheTitlesArray.count) {
                [self.scrollPageView reloadWithNewTitles:self.myTitlesArray];
            }
        }
        if (self.myTitlesArray.count) {
            for (ZJTitleView *titleView in self.scrollPageView.segmentView.titleViews) {
                titleView.label.lee_theme
                .LeeConfigTextColor(ThemeChannelTagTitleNormalColor);
            }
            [self.noSingleView removeFromSuperview];
            self.noSingleView = nil;
            [SVProgressHUD dismiss];
            
        }
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
        [self.noSingleView showNoConnectedLabelWithStatus:@"没有网络连接,请检查您的网络"];
    }];
}

/**获取推荐频道的数据*/
- (void)loadJstyleNewsTjChannelDataSource
{
    NSDictionary *parameters = @{@"type":@"2",
                                 @"category":@"2",
                                 @"uid":[[JstyleToolManager sharedManager] getUDID],
                                 @"userid":[[JstyleToolManager sharedManager] getUserId]
                                 };
    [[JstyleNewsNetworkManager shareManager] GETURL:CHANNEL_LIST_URL parameters:parameters success:^(id responseObject) {
        
        [self.tjTitlesArray removeAllObjects];
        [self.cacheDict setObject:responseObject forKey:@"tjchannel"];
        [self insertSqlite:self.cacheDict];
        
        if ([responseObject[@"data"] isKindOfClass:[NSArray class]]) {
            for (NSDictionary *dict in responseObject[@"data"]) {
                [self.channelsDict setValue:dict forKey:dict[@"head_name"]];
                [self.tjTitlesArray addObject:dict[@"head_name"]];
            }
        }
    } failure:nil];
}

/**传换过的频道顺序*/
- (void)postJstyleNewsMyChannelSortWithJsonStr:(NSString *)jsonStr
{
    NSDictionary *parameters = @{@"list":jsonStr,
                                 @"category":@"2",
                                 @"uid":[[JstyleToolManager sharedManager] getUDID],
                                 @"userid":[[JstyleToolManager sharedManager] getUserId]
                                 };
    [[JstyleNewsNetworkManager shareManager] POSTURL:CHANNEL_EDITSORT_URL parameters:parameters success:^(id responseObject) {
        if ([responseObject[@"code"] integerValue] == 1) {
            [self loadJstyleNewsMyChannelDataSource:NO];
            [self loadJstyleNewsTjChannelDataSource];
        }
    } failure:nil];
}

/**创建缓存表*/
- (void)creatTableSqlite
{
    // 获取路径
    NSString * documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *dbPath = [documentsPath stringByAppendingPathComponent:@"VideoChannels.sqlite"];
    
    // 初始化FMDB
    self.database = [FMDatabase databaseWithPath:dbPath];
    [self.database open];
    // executeUpdate:@"create table 表名 (列名 类型,..... )"
    
    FMResultSet * resultSet = [self.database executeQuery:@"select * from VideoChannels"];
    if ([resultSet next] == NO){
        [self.database executeUpdate:@"create table VideoChannels (VideoChannelsData blob)"];
    }
    [self.database close];
}

- (void)insertSqlite:(NSDictionary *)dictionary {
    
    [self.database open];
    
    [self.database executeUpdate:@"DELETE FROM VideoChannels"];
    
    NSMutableArray *array = [NSMutableArray array];
    [array addObject:dictionary];
    
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:array];
    
    FMResultSet *resultSet =  [self.database executeQuery:@"insert into VideoChannels(VideoChannelsData) values(?)" withArgumentsInArray:@[data]];
    [resultSet next];
    
    [self.database close];
}

/**取出缓存数据*/
- (void)getCacheDictionary
{
    NSString * documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *dbPath = [documentsPath stringByAppendingPathComponent:@"VideoChannels.sqlite"];
    self.database = [FMDatabase databaseWithPath:dbPath];
    [self.database open];
    FMResultSet * resultSet = [self.database executeQuery:@"select * from VideoChannels"];
    while ([resultSet next] == YES){
        NSData *data = [resultSet dataForColumn:@"VideoChannelsData"];
        self.cacheArray = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    }
    
    [self.database close];
    
    //获取总字典
    NSDictionary *dictionary = self.cacheArray[0];
    //
    NSDictionary *myChannelDict = dictionary[@"mychannel"];
    if ([myChannelDict[@"code"] integerValue] == 1) {
        for (NSDictionary *dict in myChannelDict[@"data"]) {
            [self.myTitlesArray addObject:dict[@"head_name"]];
            [self.channelsDict setValue:dict forKey:dict[@"head_name"]];
        }
        self.cacheTitlesArray = self.myTitlesArray;
        if (self.myTitlesArray.count) {
            [self.scrollPageView reloadWithNewTitles:self.myTitlesArray];
        }
    }
    if (self.myTitlesArray.count) {
        [self.reloadBtn removeFromSuperview];
    }else{
//        [self addReloadBtn];
        [self addNoSingleView];
    }
}

- (NSMutableArray *)myTitlesArray
{
    if (!_myTitlesArray) {
        _myTitlesArray = [NSMutableArray array];
    }
    return _myTitlesArray;
}

- (NSMutableArray *)tjTitlesArray
{
    if (!_tjTitlesArray) {
        _tjTitlesArray = [NSMutableArray array];
    }
    return _tjTitlesArray;
}

- (NSMutableDictionary *)cacheDict
{
    if (!_cacheDict) {
        _cacheDict = [NSMutableDictionary dictionary];
    }
    return _cacheDict;
}

- (NSMutableDictionary *)channelsDict
{
    if (!_channelsDict) {
        _channelsDict = [NSMutableDictionary dictionary];
    }
    return _channelsDict;
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

