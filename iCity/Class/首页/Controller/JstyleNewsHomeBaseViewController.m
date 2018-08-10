//
//  JstyleNewsHomeBaseViewController.m
//  JstyleNews
//
//  Created by 数字宁波 on 2017/10/24.
//  Copyright © 2017年 JstyleNews. All rights reserved.
//

#import "JstyleNewsHomeBaseViewController.h"
#import "JstyleNewsJMAttentionViewController.h"
#import "JstyleNewsHomeViewController.h"
#import "JstyleNewsFeaturedVideoViewController.h"
#import "JstyleNewsFeaturedPictureViewController.h"
#import "JstyleNewsHomeCateViewController.h"
#import "JstyleNewsHomeTagChooseViewController.h"
#import "JstyleNewsSearchViewController.h"
#import "ZJScrollPageView.h"
#import "JstyleNewsDailySingInModel.h"
#import "JstyleNewsDailySingInTypeOneView.h"
#import "JstyleNewsDailySingInTypeTwoView.h"
#import "JstyleNewsMyMessageViewController.h"

@interface JstyleNewsHomeBaseViewController ()<ZJScrollPageViewDelegate>

@property (nonatomic, weak) ZJScrollPageView *scrollPageView;

@property (nonatomic, strong) UIView *holdView;
@property (nonatomic, strong) UIImageView *holdBackImg;
@property (nonatomic, strong) UIImageView *logoImageView;
@property (nonatomic, assign) CGFloat lastcontentOffset;

@property (nonatomic, copy) NSMutableDictionary *channelsDict;

@property (nonatomic, strong) NSMutableArray *myTitlesArray;

@property (nonatomic, strong) NSMutableArray *tjTitlesArray;//推荐

@property (nonatomic, strong) FMDatabase *database;

@property (nonatomic, strong) NSArray *cacheArray;

@property (nonatomic, strong) NSMutableDictionary *cacheDict;

@property (nonatomic, strong) NSArray *cacheTitlesArray;

@property (nonatomic, strong) UIButton *reloadBtn;

@property (nonatomic, strong) JstyleNewsNoSinglePlaceholderView *noSingleView;

@property (nonatomic, strong) UIButton *customsServiceBtn;
@property (nonatomic, strong) JstyleNewsDailySingInModel *dailySingInModel;

@property (nonatomic, assign) BOOL isLoginSuccess;

/**消息铃铛*/
@property (nonatomic, strong) UIButton *messageButton;
/**搜索放大镜*/
@property (nonatomic, strong) UIImageView *searchImgView;
/**搜索两个字*/
@property (nonatomic, strong) UILabel *searchLabel;

///每日一签
@property (nonatomic, strong) UIView *backView;
@property (nonatomic, copy) NSString *pictureUrlString;
@property (nonatomic, copy) NSString *shareTitle;
@property (nonatomic, copy) NSString *describes;

@end

@implementation JstyleNewsHomeBaseViewController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kWhiteColor;
//     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applyTheme) name:NightModeManagerNotification object:nil];
    [self addPageView];
    [self creatTableSqlite];
    [self getCacheDictionary];
    [self loadJstyleNewsMyChannelDataSource:YES];
    [self loadJstyleNewsTjChannelDataSource];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginSuccess) name:@"DIDLogIn" object:nil];
    
    [[NightModeManager defaultManager] showNightView];
    
    [self getDayQianDaoDataSource];
}

- (void)loginSuccess
{
    self.isLoginSuccess = YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    //换肤
    NSString *currentThemeName  = [ThemeTool themeString];
    self.holdBackImg.image =[UIImage imageNamed:[NSString stringWithFormat:@"bg_%@",currentThemeName]];

    NSString * logoName = [NSString stringWithFormat:@"logo_small%@",[ThemeTool blackOrWhite]];
    self.logoImageView.image = JSImage(logoName);
    NSString * imgName = [NSString stringWithFormat:@"推荐-消息铃铛%@",[ThemeTool blackOrWhite]];
    [self.messageButton setImage:JSImage(imgName) forState:UIControlStateNormal];
    NSString * searchName = [NSString stringWithFormat:@"推荐-搜索放大镜%@",[ThemeTool blackOrWhite]];
    self.searchImgView.image = JSImage(searchName);
    
    self.searchLabel.textColor = [ThemeTool isWhiteModel]?kDarkThreeColor:[UIColor whiteColor];

}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    self.navigationController.navigationBar.hidden = NO;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return [ThemeTool isWhiteModel] ? UIStatusBarStyleDefault : UIStatusBarStyleLightContent;
}

- (void)addNoSingleView{
    
    if ([[JstyleToolManager sharedManager] getCurrentNetStatus] == NotReachable) {
        self.noSingleView = [[JstyleNewsNoSinglePlaceholderView alloc] initWithFrame:CGRectMake(0, YG_StatusAndNavightion_H + 44, kScreenWidth, kScreenHeight - YG_StatusAndNavightion_H - TabbarHeight - (YG_StatusAndNavightion_H + 44))];
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

#pragma mark - ZJPageView
- (void)addPageView {
    //顶部导航相关伪代码
    self.holdView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, YG_StatusAndNavightion_H)];
    self.holdBackImg = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, YG_StatusAndNavightion_H)];
    NSString *currentThemeName  = [ThemeTool themeString];
    self.holdBackImg.image =[UIImage imageNamed:[NSString stringWithFormat:@"bg_%@",currentThemeName]];
    [self.holdView addSubview:self.holdBackImg];
    [self.view addSubview:_holdView];
    

    NSString * logoName = [NSString stringWithFormat:@"logo_small%@",[ThemeTool blackOrWhite]];
    self.logoImageView = [[UIImageView alloc] initWithImage:JSImage(logoName)];

    [self.holdView addSubview:self.logoImageView];
    [self.logoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(10);
        make.bottom.offset(-12);
    }];
    
    UIView *searchView = [[UIView alloc] init];
    searchView.backgroundColor = [UIColor colorWithRGB:0xDEDEDE alpha:0.2];
//    searchView.lee_theme
//    .LeeConfigBackgroundColor(@"homeSearchBar");
    
    searchView.layer.cornerRadius = 30/2.0;
    [self.holdView addSubview:searchView];
    [searchView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.logoImageView.mas_right).offset(8);
        make.centerY.equalTo(self.logoImageView);
        make.right.offset(-35);
        make.height.offset(30);
    }];
    
    UITapGestureRecognizer *searchTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(searchButtonAction)];
    [searchView addGestureRecognizer:searchTapGesture];
    
    NSString * bigName = [NSString stringWithFormat:@"推荐-搜索放大镜%@",[ThemeTool blackOrWhite]];
    self.searchImgView = [[UIImageView alloc] initWithImage:JSImage(bigName)];
    [searchView addSubview:self.searchImgView];
    [self.searchImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.offset(0);
        make.left.offset(15);
    }];
    self.searchLabel = [[UILabel alloc]init];
    self.searchLabel.font = [UIFont systemFontOfSize:15];
    self.searchLabel.text = @"搜索";
     [searchView addSubview:self.searchLabel];
    [self.searchLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.searchImgView.mas_right).offset(12);
        make.centerY.mas_equalTo(self.searchImgView);
    }];
    
    self.messageButton = [UIButton buttonWithType:UIButtonTypeCustom];
    NSString * imgName = [NSString stringWithFormat:@"推荐-消息铃铛%@",[ThemeTool blackOrWhite]];
    [self.messageButton setImage:JSImage(imgName) forState:UIControlStateNormal];
    [self.messageButton sizeToFit];
    [self.messageButton addTarget:self action:@selector(messageButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.holdView addSubview:self.messageButton];
    [self.messageButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(searchView);
        make.right.offset(-10);
    }];
    
    
    
    //以下为分页控制器
    //必要的设置, 如果没有设置可能导致内容显示不正常
    self.automaticallyAdjustsScrollViewInsets = NO;
    ZJSegmentStyle *style = [[ZJSegmentStyle alloc] init];
    //显示遮盖
    style.showCover = NO;
    style.showLine = YES;
    style.scrollLineColor = kDarkTwoColor;
    style.adjustCoverOrLineWidth = YES;
    style.segmentViewBounces = NO;
    style.normalTitleColor = kDarkSixColor;
    style.selectedTitleColor = kDarkTwoColor;
    style.titleFont = JSFontWithWeight(17, UIFontWeightRegular);
    style.selectedTitleFont = JSFontWithWeight(17, UIFontWeightHeavy);
    // 颜色渐变
    style.gradualChangeTitleColor = YES;
    // 显示附加的按钮
    style.showExtraButton = YES;
    // 设置附加按钮的背景图片
    style.extraBtnBackgroundImageName = @"推荐-频道加号";
    style.segmentHeight = 40;
    style.autoAdjustTitlesWidth = YES;
    
    //    style.segmentViewComponent = SegmentViewComponentShowCover |  SegmentViewComponentShowExtraButton | SegmentViewComponentGraduallyChangeTitleColor;
    // 当标题宽度总和小于ZJScrollPageView的宽度的时候, 标题会自适应宽度
    
    // 初始化
    CGRect scrollPageViewFrame = CGRectMake(0, YG_StatusAndNavightion_H, kScreenWidth, kScreenHeight);
    
    ZJScrollPageView *scrollPageView = [[ZJScrollPageView alloc] initWithFrame:scrollPageViewFrame segmentStyle:style titles:@[] parentViewController:self delegate:self];
    scrollPageView.backgroundColor = [UIColor whiteColor];
    self.scrollPageView = scrollPageView;
    __weak typeof (self) weakself = self;
    self.scrollPageView.extraBtnOnClick = ^(UIButton *extraBtn){
        JstyleNewsHomeTagChooseViewController *jstyleNewsHomeTagCVC = [JstyleNewsHomeTagChooseViewController new];
        jstyleNewsHomeTagCVC.myChannelBlock = ^(NSArray *channelsArray) {

            weakself.scrollPageView.segmentView.segmentStyle.normalTitleColor = kDarkSixColor;
            weakself.myTitlesArray = [NSMutableArray arrayWithArray:channelsArray];
            [weakself.scrollPageView reloadWithNewTitles:weakself.myTitlesArray];
            [weakself.scrollPageView setSelectedIndex:1 animated:NO];

            
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
        
        jstyleNewsHomeTagCVC.myChannelClicked = ^(NSString *channelName) {
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
        [self presentViewController:jstyleNewsHomeTagCVC animated:NO completion:nil];
    };
    [self.view addSubview:self.scrollPageView];
}

- (void)customsServiceBtnClick {
    
    NSDictionary *dic = [[NSUserDefaults standardUserDefaults] objectForKey:@"JstyleNewsDailySingInModelDict"];
    
    if (self.dailySingInModel == nil) {
        [SVProgressHUD show];
        JstyleNewsNetworkManager *manager = [JstyleNewsNetworkManager shareManager];
        NSDictionary *paramaters = @{
                                     @"uid":[[JstyleToolManager sharedManager] getUserId],
                                     @"uuid":[[JstyleToolManager sharedManager] getUDID]
                                     };
        [manager GETURL:DAILY_SING_IN parameters:paramaters success:^(id responseObject) {
            
            self.dailySingInModel = [JstyleNewsDailySingInModel modelWithJSON:dic];
            if ([responseObject[@"code"] isEqualToString:@"1"]) {
                JstyleNewsDailySingInModel *model = [JstyleNewsDailySingInModel modelWithJSON:responseObject[@"data"]];
                self.dailySingInModel = model;
                
                [SVProgressHUD dismiss];
            } else {
                
                self.dailySingInModel = [NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"DailySingInData"]];
                [SVProgressHUD dismiss];
            }
            
        } failure:^(NSError *error) {
            [SVProgressHUD dismiss];
        }];
        return;
    }
}

- (NSInteger)numberOfChildViewControllers {
    return self.myTitlesArray.count;
}

- (UIViewController<ZJScrollPageViewChildVcDelegate> *)childViewController:(UIViewController<ZJScrollPageViewChildVcDelegate> *)reuseViewController forIndex:(NSInteger)index {
    if (index > self.myTitlesArray.count) {
        return nil;
    }
    NSString *title = self.myTitlesArray[index];
    NSDictionary *dictionary = [self.channelsDict objectForKey:title];
    switch ([dictionary[@"id"] integerValue]) {
        case -1:{
            JstyleNewsHomeViewController *jstyleNewsHomeVC = [JstyleNewsHomeViewController new];
            return jstyleNewsHomeVC;
        }
            break;
        case -2:{
            JstyleNewsFeaturedVideoViewController *jstyleNewsFeaturedVideoVC = [JstyleNewsFeaturedVideoViewController new];
            return jstyleNewsFeaturedVideoVC;
        }
            break;
        case -3:{
            JstyleNewsFeaturedPictureViewController *jstyleNewsFeaturedPictureVC = [JstyleNewsFeaturedPictureViewController new];
            return jstyleNewsFeaturedPictureVC;
        }
            break;
        case -4:{
            JstyleNewsJMAttentionViewController *jstyleNewsJMAVC = [JstyleNewsJMAttentionViewController new];
            return jstyleNewsJMAVC;
        }
            break;
        default:{
            JstyleNewsHomeCateViewController *jstyleNewsHomeCateVC = [JstyleNewsHomeCateViewController new];
            jstyleNewsHomeCateVC.cid = dictionary[@"id"];
            return jstyleNewsHomeCateVC;
        }
            break;
    }
}

#pragma mark - 搜索
- (void)searchButtonAction {
    JstyleNewsSearchViewController *jstyleNewsSearchVC = [JstyleNewsSearchViewController new];
    [self.navigationController pushViewController:jstyleNewsSearchVC animated:YES];
}

#pragma mark - 消息
- (void)messageButtonClick {
    JstyleNewsMyMessageViewController *messageVC = [JstyleNewsMyMessageViewController new];
    [self.navigationController pushViewController:messageVC animated:YES];
}

- (BOOL)shouldAutomaticallyForwardAppearanceMethods {
    return NO;
}

/**获取我的频道数据*/
- (void)loadJstyleNewsMyChannelDataSource:(BOOL)reload
{
    NSDictionary *parameters = @{@"type":@"1",
                                 @"category":@"1",
                                 @"uid":[[JstyleToolManager sharedManager] getUDID],
                                 @"userid":[[JstyleToolManager sharedManager] getUserId]};
    [[JstyleNewsNetworkManager shareManager] GETURL:CHANNEL_LIST_URL parameters:parameters success:^(id responseObject) {
        if ([responseObject[@"code"] integerValue] == 1) {
            [self.myTitlesArray removeAllObjects];
            [self.cacheDict setObject:responseObject forKey:@"mychannel"];
            [self insertSqlite:self.cacheDict];
            NSDictionary *attentionDict = @{@"head_name":@"关注",
                                            @"id":@"-4",
                                            @"torder":@"",
                                            @"uid":@"",
                                            @"userid":@""};
            [self.channelsDict setValue:attentionDict forKey:@"关注"];
            [self.myTitlesArray addObject:@"关注"];
            for (NSDictionary *dict in responseObject[@"data"]) {
                [self.channelsDict setValue:dict forKey:dict[@"head_name"]];
                [self.myTitlesArray addObject:dict[@"head_name"]];
            }
            if (reload && self.myTitlesArray.count && !self.cacheTitlesArray.count) {
                [self.scrollPageView reloadWithNewTitles:self.myTitlesArray];
                [self.scrollPageView setSelectedIndex:1 animated:NO];
            }

        }
        
#pragma mark 栏目字体颜色
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
                                 @"category":@"1",
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
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

/**传换过的频道顺序*/
- (void)postJstyleNewsMyChannelSortWithJsonStr:(NSString *)jsonStr
{
    NSDictionary *parameters = @{@"list":jsonStr,
                                 @"category":@"1",
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
    NSString *dbPath = [documentsPath stringByAppendingPathComponent:@"HomeChannels.sqlite"];
    
    // 初始化FMDB
    self.database = [FMDatabase databaseWithPath:dbPath];
    [self.database open];
    // executeUpdate:@"create table 表名 (列名 类型,..... )"
    
    FMResultSet * resultSet = [self.database executeQuery:@"select * from HomeChannels"];
    if ([resultSet next] == NO){
        [self.database executeUpdate:@"create table HomeChannels (homeChannelsData blob)"];
    }
    [self.database close];
}

- (void)insertSqlite:(NSDictionary *)dictionary {
    
    [self.database open];
    
    [self.database executeUpdate:@"DELETE FROM HomeChannels"];
    
    NSMutableArray *array = [NSMutableArray array];
    [array addObject:dictionary];

    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:array];

    FMResultSet *resultSet =  [self.database executeQuery:@"insert into HomeChannels(homeChannelsData) values(?)" withArgumentsInArray:@[data]];
    [resultSet next];
    
    [self.database close];
}

/**取出缓存数据*/
- (void)getCacheDictionary
{
    NSString * documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *dbPath = [documentsPath stringByAppendingPathComponent:@"HomeChannels.sqlite"];
    self.database = [FMDatabase databaseWithPath:dbPath];
    [self.database open];
    FMResultSet * resultSet = [self.database executeQuery:@"select * from HomeChannels"];
    while ([resultSet next] == YES){
        NSData *data = [resultSet dataForColumn:@"homeChannelsData"];
        self.cacheArray = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    }
    
    [self.database close];
    
    //获取总字典
    NSDictionary *dictionary = self.cacheArray[0];
    //
    NSDictionary *myChannelDict = dictionary[@"mychannel"];
    if ([myChannelDict[@"code"] integerValue] == 1) {
        NSDictionary *attentionDict = @{@"head_name":@"关注",
                                        @"id":@"-4",
                                        @"torder":@"",
                                        @"uid":@"",
                                        @"userid":@""};
        [self.channelsDict setValue:attentionDict forKey:@"关注"];
        [self.myTitlesArray addObject:@"关注"];
        for (NSDictionary *dict in myChannelDict[@"data"]) {
            [self.myTitlesArray addObject:dict[@"head_name"]];
            [self.channelsDict setValue:dict forKey:dict[@"head_name"]];
        }
        self.cacheTitlesArray = self.myTitlesArray;
        if (self.myTitlesArray.count) {
            [self.scrollPageView reloadWithNewTitles:self.myTitlesArray];
            [self.scrollPageView setSelectedIndex:1 animated:NO];
        }
    }
    if (self.myTitlesArray.count) {
        [self.reloadBtn removeFromSuperview];
    }else{
        [self addNoSingleView];
    }
}

- (void)getDayQianDaoDataSource {
    JstyleNewsNetworkManager *manager = [JstyleNewsNetworkManager shareManager];
    
    [manager GETURL:ICity_COUPON_DAYQIANDAO_URL parameters:nil success:^(id responseObject) {
        if ([responseObject[@"code"] integerValue] == 1) {
            NSString *dateTime = [[NSUserDefaults standardUserDefaults] objectForKey:@"daytime"];
            if (![dateTime isEqualToString:responseObject[@"data"][@"now_time"]]) {
                [[NSUserDefaults standardUserDefaults] setObject:responseObject[@"data"][@"now_time"] forKey:@"daytime"];
                self.pictureUrlString = responseObject[@"data"][@"image"];
                self.shareTitle = responseObject[@"data"][@"title"];
                self.describes = responseObject[@"data"][@"describes"];
                
                if ([responseObject[@"data"][@"type"] integerValue] == 1) {
                    //图片签到
                    [[YYWebImageManager sharedManager] requestImageWithURL:[NSURL URLWithString:self.pictureUrlString] options:(YYWebImageOptionSetImageWithFadeAnimation) progress:nil transform:nil completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
                        
                        __weak __typeof(self) weakself= self;
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [weakself dayQianDaoViewWithImage:image];

                        });
                    }];
                }
            }
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

- (void)dayQianDaoViewWithImage:(UIImage *)image
{

    UIWindow * window = [UIApplication sharedApplication].keyWindow;
    window.backgroundColor = [UIColor clearColor];
    
    _backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    _backView.backgroundColor = [kDarkOneColor colorWithAlphaComponent:0.8];
    
    UIImageView *imageView = [[UIImageView alloc]init];
    imageView.image = image;
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.clipsToBounds = YES;
    imageView.userInteractionEnabled = YES;
    
    UIButton *bottomBtn = [[UIButton alloc]init];
    [bottomBtn setBackgroundColor:[UIColor colorFromHexString:@"#D49008"]];//金色
    [bottomBtn setTitleColor:kWhiteColor forState:(UIControlStateNormal)];
    [bottomBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [bottomBtn setTitle:@"立即分享" forState:UIControlStateNormal];
    bottomBtn.layer.masksToBounds = YES;
    bottomBtn.layer.cornerRadius = 16;
    [bottomBtn addTarget:self action:@selector(sharePicture) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *closeBtn = [[UIButton alloc]init];
    [closeBtn setImage:[UIImage imageNamed:@"daysign关闭"] forState:(UIControlStateNormal)];
    [closeBtn addTarget:self action:@selector(closeBtnClicked:) forControlEvents:(UIControlEventTouchUpInside)];
    
    [window addSubview:_backView];
    [_backView addSubview:bottomBtn];
    [_backView addSubview:imageView];
    [_backView addSubview:closeBtn];
    
    bottomBtn.sd_layout
    .bottomSpaceToView(_backView, 70 *kScreenWidth/375.0)
    .widthIs(120)
    .heightIs(32)
    .centerXIs(kScreenWidth/2);
    
    imageView.sd_layout
    .topSpaceToView(_backView, 122*kScreenWidth/375.0)
    .bottomSpaceToView(bottomBtn, 40)
    .leftSpaceToView(_backView, 43*kScreenWidth/375.0)
    .rightSpaceToView(_backView, 43*kScreenWidth/375.0);
    
    closeBtn.sd_layout
    .bottomSpaceToView(imageView, 25)
    .rightSpaceToView(_backView, 30)
    .widthIs(30)
    .heightIs(30);
}
#pragma mark - 每日一签关闭
- (void)closeBtnClicked:(UIButton *)sender {
    [_backView removeFromSuperview];
    _backView = nil;
}

#pragma mark - 每日一签立即分享
- (void)sharePicture {
//    if ([[JstyleToolManager sharedManager] isTourist]) {
//        [_backView removeFromSuperview];
//        [[JstyleToolManager sharedManager] loginInViewController];
//        return;
//    }
    [_backView removeFromSuperview];
    _backView = nil;
    [[JstyleToolManager sharedManager] sharePictureWithShareTitle:self.shareTitle shareDesc:self.describes shareUrl:self.pictureUrlString shareImgUrl:self.pictureUrlString viewController:self];
//    [[JstyleToolManager sharedManager] sharePictureWithShareTitle:nil shareDesc:nil shareUrl:nil shareImgUrl:self.pictureUrlString viewController:self];
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

- (void)applyTheme {
    
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
