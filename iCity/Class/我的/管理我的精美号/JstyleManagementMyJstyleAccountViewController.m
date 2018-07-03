//
//  JstyleManagementMyJstyleAccountViewController.m
//  Exquisite
//
//  Created by 数字跃动 on 2017/9/25.
//  Copyright © 2017年 Jstyle. All rights reserved.
//

#import "JstyleManagementMyJstyleAccountViewController.h"
#import "JstyleManagementNavigationBottomMenuView.h"
#import "JstyleManagementButton.h"
#import "JstyleManagementWenZhangTableViewController.h"
#import "JstyleManagementTwoSelectedButton.h"
#import "JstyleManagementShiPinTableViewController.h"
#import "JstyleManagementZhiBoTableViewController.h"
#import "JstyleManagementPingLunTableViewController.h"
#import "JstyleManagementWoDeTableViewController.h"
#import "JstyleManagementNavigationBottomMenuModel.h"

#define kListMenuBtnHeight 50

typedef enum : NSUInteger {
    JstyleManagementYiFaBuListViewTypeWenZhang,
    JstyleManagementYiFaBuListViewTypeShiPin,
    JstyleManagementYiFaBuListViewTypeZhiBo
} JstyleManagementYiFaBuListViewType;

@interface JstyleManagementMyJstyleAccountViewController ()<UIScrollViewDelegate>

@property (nonatomic, strong) NSArray<JstyleManagementButton *> *fiveBtnArray;

@property (nonatomic, strong) UIView *navigationBottomView;
@property (nonatomic, strong) UIView *fiveButtonView;

@property (nonatomic, strong) JstyleManagementButton *wenZhangBtn;
@property (nonatomic, strong) JstyleManagementButton *shiPinBtn;
@property (nonatomic, strong) JstyleManagementButton *zhiBoBtn;
@property (nonatomic, strong) JstyleManagementButton *pingLunBtn;
@property (nonatomic, strong) JstyleManagementButton *woDeBtn;

@property (nonatomic, strong) UIScrollView *sliderView;
@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) UIView *twoSelectedView;
@property (nonatomic, strong) JstyleManagementTwoSelectedButton *yuanChuangWenZhangBtn;
@property (nonatomic, strong) JstyleManagementTwoSelectedButton *yiFaBuBtn;
@property (nonatomic, strong) JstyleManagementTwoSelectedButton *shiPinYiFaBuBtn;
@property (nonatomic, strong) JstyleManagementTwoSelectedButton *zhiBoYiFaBuBtn;

@property (nonatomic, strong) UIView *yuanChuangListView;
@property (nonatomic, strong) UIView *yiFaBuListView;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) JstyleManagementWenZhangTableViewController *wenZhangTableVC;
@property (nonatomic, strong) JstyleManagementShiPinTableViewController *shiPinTableVC;
@property (nonatomic, strong) JstyleManagementZhiBoTableViewController *zhiBoTableVC;
@property (nonatomic, strong) JstyleManagementPingLunTableViewController *pingLunTableVC;
@property (nonatomic, strong) JstyleManagementWoDeTableViewController *woDeTableVC;

@property (nonatomic, strong) NSArray *bottomMenuDataArray;

@property (nonatomic, weak) JstyleManagementNavigationBottomMenuView *zongYueDuShuView;
@property (nonatomic, weak) JstyleManagementNavigationBottomMenuView *zongFenSiShuView;
@property (nonatomic, weak) JstyleManagementNavigationBottomMenuView *zongWenZhangShuView;
@property (nonatomic, weak) JstyleManagementNavigationBottomMenuView *zongShiPinShuView;
@property (nonatomic, weak) JstyleManagementNavigationBottomMenuView *zongZhiBoShuView;

@property (nonatomic, assign) CGFloat sliderOffsetX;

@end

@implementation JstyleManagementMyJstyleAccountViewController

- (JstyleManagementWenZhangTableViewController *)wenZhangTableVC {
    if (_wenZhangTableVC == nil) {
        _wenZhangTableVC = [JstyleManagementWenZhangTableViewController new];
    }
    return _wenZhangTableVC;
}

- (JstyleManagementShiPinTableViewController *)shiPinTableVC {
    if (_shiPinTableVC == nil) {
        _shiPinTableVC = [JstyleManagementShiPinTableViewController new];
    }
    return _shiPinTableVC;
}

- (JstyleManagementZhiBoTableViewController *)zhiBoTableVC {
    if (_zhiBoTableVC == nil) {
        _zhiBoTableVC = [JstyleManagementZhiBoTableViewController new];
    }
    return _zhiBoTableVC;
}

- (JstyleManagementPingLunTableViewController *)pingLunTableVC {
    if (_pingLunTableVC == nil) {
        _pingLunTableVC = [JstyleManagementPingLunTableViewController new];
    }
    return _pingLunTableVC;
}

- (JstyleManagementWoDeTableViewController *)woDeTableVC {
    if (_woDeTableVC == nil) {
        _woDeTableVC = [JstyleManagementWoDeTableViewController new];
    }
    return _woDeTableVC;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"iCity号";//管理我的
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removeListView) name:@"ManagementMyJstyleAccountRemoveListViewNotification" object:nil];
    //加载头部5个数字
    [self LoadCountData];
    [self setupNavigation];
    [self setupUI];
}



- (void)setupNavigation {
    
    self.navigationController.navigationBar.hidden = YES;
    
    [self addNavigationBarView];
}

- (void)addNavigationBarView
{
    UIImageView *navigationBarView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, YG_StatusAndNavightion_H)];
    navigationBarView.userInteractionEnabled = YES;
    UIImage *bgImage = [JSImage(@"我的-管理我的iCity号头部背景上-红色") resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0) resizingMode:UIImageResizingModeStretch];
    [navigationBarView setImage:bgImage];
    navigationBarView.lee_theme
    .LeeCustomConfig(ThemeManagementNavigationBarBottomImage, ^(id item, id value) {
        UIImage *bgImage = [value resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0) resizingMode:UIImageResizingModeStretch];
        [navigationBarView setImage:bgImage];
    });
    [self.view addSubview:navigationBarView];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake((kScreenWidth - 80)/2, StatusBarHeight, 80, NavigationBarHeight)];
    titleLabel.text = @"iCity号";
    titleLabel.textColor = kWhiteColor;
    titleLabel.font = JSFontWithWeight(16, UIFontWeightRegular);
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.lee_theme
    .LeeConfigTextColor(ThemeDiscoveryNavigationBarTitleColor);
    [navigationBarView addSubview:titleLabel];
    
    UIButton *leftBtn = [[UIButton alloc] init];
    [leftBtn setImage:([[NightModeManager defaultManager] isNightMode]?JSImage(@"图文返回黑"):JSImage(@"返回白色")) forState:(UIControlStateNormal)];
    [leftBtn addTarget:self action:@selector(backItemClick) forControlEvents:(UIControlEventTouchUpInside)];
    [navigationBarView addSubview:leftBtn];
    leftBtn.sd_layout
    .topSpaceToView(navigationBarView, 30 + (IS_iPhoneX?26:0))
    .leftSpaceToView(navigationBarView, 7)
    .widthIs(25)
    .heightIs(25);
    
    leftBtn.lee_theme
    .LeeCustomConfig(ThemeManagementNavigationBarLeftItem, ^(id item, id value) {
        [item setImage:value forState:(UIControlStateNormal)];
    });
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setupNavigation];
    
    _sliderView.contentOffset = CGPointMake(_sliderOffsetX, 0);
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    self.navigationController.navigationBar.hidden = NO;
    _sliderOffsetX = _sliderView.contentOffset.x;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return [[LEETheme currentThemeTag] isEqualToString:ThemeName_White] ? UIStatusBarStyleDefault : UIStatusBarStyleLightContent;
}

- (void)setupUI {
    // 阅读总数,粉丝数等5个按钮
    [self setupNavigationTitleBottomView];
    // 文章,视频,直播等5个按钮
    [self setupFiveButtonView];
    // 滑动条
    [self setupSliderView];
    // 滑动列表视图
    [self setupScrollView];
}

// TODO: 布局阅读总数,粉丝数等5个按钮
- (void)setupNavigationTitleBottomView {
    
    _navigationBottomView = [[UIView alloc] initWithFrame:CGRectMake(0, YG_StatusAndNavightion_H, kScreenWidth, 53)];
    [self.view addSubview:_navigationBottomView];
    
    UIImageView *navigationBottomBackImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"我的-管理我的iCity号头部背景下-红色"]];
    [_navigationBottomView addSubview:navigationBottomBackImage];
    [navigationBottomBackImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.offset(0);
    }];
    
    navigationBottomBackImage.lee_theme
    .LeeConfigImage(ThemeManagementNavigationBarBottomImage);
    
    //总阅读数
    JstyleManagementNavigationBottomMenuView *zongYueDuShuView = [JstyleManagementNavigationBottomMenuView new];
    self.zongYueDuShuView = zongYueDuShuView;
    zongYueDuShuView.titleLabel.text = @"总阅读数";
    [_navigationBottomView addSubview:zongYueDuShuView];
    [zongYueDuShuView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.offset(0);
        make.height.equalTo(self.navigationBottomView);
        make.width.offset(kScreenWidth / 5);
    }];
    
    //粉丝数
    JstyleManagementNavigationBottomMenuView *zongFenSiShuView = [JstyleManagementNavigationBottomMenuView new];
    _zongFenSiShuView = zongFenSiShuView;
    zongFenSiShuView.titleLabel.text = @"粉丝数";
    [_navigationBottomView addSubview:zongFenSiShuView];
    [zongFenSiShuView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(zongYueDuShuView.mas_right);
        make.centerY.offset(0);
        make.height.equalTo(self.navigationBottomView);
        make.width.offset(kScreenWidth / 5);
    }];
    
    //文章数
    JstyleManagementNavigationBottomMenuView *zongWenZhangShuView = [JstyleManagementNavigationBottomMenuView new];
    _zongWenZhangShuView = zongWenZhangShuView;
    zongWenZhangShuView.titleLabel.text = @"文章数";
    [_navigationBottomView addSubview:zongWenZhangShuView];
    [zongWenZhangShuView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(zongFenSiShuView.mas_right);
        make.centerY.offset(0);
        make.height.equalTo(self.navigationBottomView);
        make.width.offset(kScreenWidth / 5);
    }];
    
    //视频数
    JstyleManagementNavigationBottomMenuView *zongShiPinShuView = [JstyleManagementNavigationBottomMenuView new];
    _zongShiPinShuView = zongShiPinShuView;
    zongShiPinShuView.titleLabel.text = @"视频数";
    [_navigationBottomView addSubview:zongShiPinShuView];
    [zongShiPinShuView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(zongWenZhangShuView.mas_right);
        make.centerY.offset(0);
        make.height.equalTo(self.navigationBottomView);
        make.width.offset(kScreenWidth / 5);
    }];
    
    //直播数
    JstyleManagementNavigationBottomMenuView *zongZhiBoShuView = [JstyleManagementNavigationBottomMenuView new];
    _zongZhiBoShuView = zongZhiBoShuView;
    zongZhiBoShuView.titleLabel.text = @"直播数";
    [_navigationBottomView addSubview:zongZhiBoShuView];
    [zongZhiBoShuView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(zongShiPinShuView.mas_right);
        make.centerY.offset(0);
        make.height.equalTo(self.navigationBottomView);
        make.width.offset(kScreenWidth / 5);
    }];
    
}

// TODO: 布局文章,视频,直播等5个按钮
- (void)setupFiveButtonView {
    
    UIView *fiveButtonView = [[UIView alloc] init];
    _fiveButtonView = fiveButtonView;
    [self.view addSubview:fiveButtonView];
    [fiveButtonView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navigationBottomView.mas_bottom);
        make.left.right.offset(0);
        make.height.offset(85);
    }];
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = JSColor(@"#979797");
    lineView.alpha = 0.15;
    [fiveButtonView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.offset(0);
        make.height.offset(0.5);
    }];
    lineView.hidden = ![[LEETheme currentThemeTag] isEqualToString:ThemeName_White];
    
    JstyleManagementButton *wenzhangBtn = [self creatMenuButtonWithImageName:@"文章" tag:JstyleManagementMyJstyleAccountButtonTagWenZhang];
    self.wenZhangBtn = wenzhangBtn;
    wenzhangBtn.lee_theme.LeeConfigButtonImage(ThemeManagementArticleButtonImage, UIControlStateSelected);
    
    JstyleManagementButton *shiPinBtn = [self creatMenuButtonWithImageName:@"视频" tag:JstyleManagementMyJstyleAccountButtonTagShiPin];
    self.shiPinBtn = shiPinBtn;
    shiPinBtn.lee_theme.LeeConfigButtonImage(ThemeManagementVideoButtonImage, UIControlStateSelected);
    
    JstyleManagementButton *zhiBoBtn = [self creatMenuButtonWithImageName:@"直播" tag:JstyleManagementMyJstyleAccountButtonTagZhiBo];
    self.zhiBoBtn = zhiBoBtn;
    zhiBoBtn.lee_theme.LeeConfigButtonImage(ThemeManagementLiveButtonImage, UIControlStateSelected);
    
    JstyleManagementButton *pingLunBtn = [self creatMenuButtonWithImageName:@"评论" tag:JstyleManagementMyJstyleAccountButtonTagPingLun];
    self.pingLunBtn = pingLunBtn;
    pingLunBtn.lee_theme.LeeConfigButtonImage(ThemeManagementCommentButtonImage, UIControlStateSelected);
    
    JstyleManagementButton *woDeBtn = [self creatMenuButtonWithImageName:@"我的" tag:JstyleManagementMyJstyleAccountButtonTagWoDe];
    self.woDeBtn = woDeBtn;
    woDeBtn.lee_theme.LeeConfigButtonImage(ThemeManagementMineButtonImage, UIControlStateSelected);
    
    wenzhangBtn.selected = YES;
    
    [fiveButtonView addSubview:wenzhangBtn];
    [fiveButtonView addSubview:shiPinBtn];
    [fiveButtonView addSubview:zhiBoBtn];
    [fiveButtonView addSubview:pingLunBtn];
    [fiveButtonView addSubview:woDeBtn];
    
    NSArray *btnArray = @[wenzhangBtn,shiPinBtn,zhiBoBtn,pingLunBtn,woDeBtn];
    self.fiveBtnArray = btnArray;
    
    [btnArray mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.offset(0);
        make.width.offset(kScreenWidth / 5);
        make.top.bottom.offset(0);
    }];
    
    [wenzhangBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(0);
    }];
    [shiPinBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(wenzhangBtn.mas_right);
    }];
    [zhiBoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(shiPinBtn.mas_right);
    }];
    [pingLunBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(zhiBoBtn.mas_right);
    }];
    [woDeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(pingLunBtn.mas_right);
    }];
}

// TODO: 滑动条
- (void)setupSliderView {
    
    UIView *line1 = [[UIView alloc] init];
    line1.backgroundColor = kLightLineColor;
    line1.alpha = 0.15;
    [self.view addSubview:line1];
    [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.height.offset(0.5);
        make.top.equalTo(self.fiveButtonView.mas_bottom).offset(1);
    }];
    
    _sliderView = [[UIScrollView alloc] init];
    _sliderView.contentSize = CGSizeMake(kScreenWidth, 1);
    [self.view addSubview:_sliderView];
    [_sliderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.height.offset(1);
        make.top.equalTo(self.fiveButtonView.mas_bottom);
    }];
    
    UIView *slider = [[UIView alloc] init];
    slider.backgroundColor = [UIColor colorFromHex:0xEA2332];
    [_sliderView addSubview:slider];
    [slider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(kScreenWidth / 5);
        make.height.offset(1);
        make.left.top.bottom.offset(0);
        make.right.offset(-kScreenWidth / 5 * 4);
    }];
    slider.lee_theme
    .LeeCustomConfig(ThemeMainBtnTitleOrBorderColor, ^(id item, id value) {
        if ([[LEETheme currentThemeTag] isEqualToString:ThemeName_Black]) {
            [item setBackgroundColor:JSColor(@"#FF5A5F")];
        } else {
            [item setBackgroundColor:value];
        }
    });
}

// TODO: 原创文章,已发布2个按钮
- (UIView *)setupTwoSelectedView {
    
    UIView *twoSelectedView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 46)];
    self.twoSelectedView = twoSelectedView;
    [_scrollView addSubview:twoSelectedView];
    
    JstyleManagementTwoSelectedButton *yuanChuangWenZhangBtn = [JstyleManagementTwoSelectedButton buttonWithType:UIButtonTypeCustom];
    self.yuanChuangWenZhangBtn = yuanChuangWenZhangBtn;
    [yuanChuangWenZhangBtn setTitle:@"原创文章" forState:UIControlStateNormal];
    yuanChuangWenZhangBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [yuanChuangWenZhangBtn setTitleColor:(ISNightMode?kDarkFiveColor:kDarkNineColor) forState:UIControlStateNormal];
    [yuanChuangWenZhangBtn setTitleColor:kDarkTwoColor forState:UIControlStateHighlighted];
    [yuanChuangWenZhangBtn setTitleColor:(ISNightMode?kDarkNineColor:kDarkTwoColor) forState:UIControlStateSelected];
    [yuanChuangWenZhangBtn setImage:[UIImage imageNamed:@"发布"] forState:UIControlStateNormal];
    [yuanChuangWenZhangBtn setImage:[UIImage imageNamed:@"发布2"] forState:UIControlStateSelected];
    [yuanChuangWenZhangBtn addTarget:self action:@selector(yuanChuangWenZhangBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [twoSelectedView addSubview:yuanChuangWenZhangBtn];
    [yuanChuangWenZhangBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(kScreenWidth / 2);
        make.top.bottom.offset(0);
        make.left.offset(0);
    }];
    yuanChuangWenZhangBtn.selected = YES;
    
    JstyleManagementTwoSelectedButton *yiFaBuBtn = [JstyleManagementTwoSelectedButton buttonWithType:UIButtonTypeCustom];
    self.yiFaBuBtn = yiFaBuBtn;
    [yiFaBuBtn setTitle:@"已发布" forState:UIControlStateNormal];
    yiFaBuBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [yiFaBuBtn setTitleColor:ISNightMode?kDarkFiveColor:kDarkNineColor forState:UIControlStateNormal];
    [yiFaBuBtn setTitleColor:kDarkTwoColor forState:UIControlStateHighlighted];
    [yiFaBuBtn setTitleColor:ISNightMode?kDarkNineColor:kDarkTwoColor forState:UIControlStateSelected];
    [yiFaBuBtn setImage:[UIImage imageNamed:@"发布"] forState:UIControlStateNormal];
    [yiFaBuBtn setImage:[UIImage imageNamed:@"发布2"] forState:UIControlStateSelected];
    [yiFaBuBtn addTarget:self action:@selector(yiFaBuBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [twoSelectedView addSubview:yiFaBuBtn];
    [yiFaBuBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(kScreenWidth / 2);
        make.top.bottom.offset(0);
        make.right.offset(0);
    }];
    yiFaBuBtn.selected = NO;
    
    UIView *line2 = [[UIView alloc] init];
    line2.backgroundColor = kLightLineColor;
    line2.alpha = 0.25;
    [twoSelectedView addSubview:line2];
    [line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.height.offset(0.5);
        make.bottom.offset(0);
    }];
    
    return twoSelectedView;
}

// TODO: 原创文章下弹小菜单
- (void)setupYuanChuangWenZhangListMenu {
    
    [self.yuanChuangWenZhangBtn setImage:[UIImage imageNamed:@"发布3"] forState:UIControlStateSelected];
    
    //原创 聚合选择list
    self.yuanChuangListView = [[UIView alloc] init];
    _yuanChuangListView.backgroundColor = kWhiteColor;
    [self.view addSubview:_yuanChuangListView];
    [_yuanChuangListView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.twoSelectedView.mas_bottom).offset(0);
        make.left.right.offset(0);
        make.height.offset(kListMenuBtnHeight*2 + 0.5);
    }];
    
    UIButton *listYuanChuangBtn = [self creatListViewBtnWithTitle:@"原创" action:@selector(listYuanChuangBtnClick) superView:_yuanChuangListView];
    [listYuanChuangBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.offset(0);
        make.height.offset(kListMenuBtnHeight);
    }];
    
    [self creatLineUnder:listYuanChuangBtn];
    
    UIButton *listJuHeBtn = [self creatListViewBtnWithTitle:@"聚合" action:@selector(listJuHeBtnClick) superView:_yuanChuangListView];
    [listJuHeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.top.equalTo(listYuanChuangBtn.mas_bottom);
        make.height.offset(kListMenuBtnHeight);
    }];
    
    UIView *alphaView = [[UIView alloc] init];
    alphaView.backgroundColor = [UIColor clearColor];
    [UIView animateWithDuration:0.25 animations:^{
        alphaView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.7];
    }];
    [_yuanChuangListView addSubview:alphaView];
    [alphaView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.top.equalTo(self.yuanChuangListView.mas_bottom);
        make.bottom.equalTo(self.view);
    }];
    
}

- (UIButton *)creatListViewBtnWithTitle:(NSString *)title action:(SEL)action superView:(UIView *)superView{
    UIButton *listBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [listBtn setTitle:title forState:UIControlStateNormal];
    listBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [listBtn setTitleColor:ISNightMode?kDarkNineColor:kDarkTwoColor forState:UIControlStateNormal];
    [listBtn setTitleColor:[UIColor colorFromHex:0xEA2332] forState:UIControlStateHighlighted];
    [listBtn addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    [superView addSubview:listBtn];
    return listBtn;
}

- (void)yuanChuangWenZhangBtnClick:(UIButton *)button {
    button.selected = YES;
    self.yiFaBuBtn.selected = NO;
    
    if (self.yuanChuangListView != nil) {
        [self removeListView];
        return;
    }
    [self removeListView];
    //下弹菜单
    [self setupYuanChuangWenZhangListMenu];
}

// TODO: 已发布下弹小菜单
- (void)setupYiFaBuListMenuWithType:(JstyleManagementYiFaBuListViewType)type {
    
    [self.yiFaBuBtn setImage:[UIImage imageNamed:@"发布3"] forState:UIControlStateSelected];
    
    self.yiFaBuListView = [[UIView alloc] init];
    _yiFaBuListView.backgroundColor = ISNightMode?kNightModeBackColor:kWhiteColor;
    [self.view addSubview:_yiFaBuListView];
    [_yiFaBuListView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.top.equalTo(self.twoSelectedView.mas_bottom);
        make.height.offset(kListMenuBtnHeight*4 + 0.5*3);
    }];
    
    UIButton *listYiFaBuBtn = [self creatListViewBtnWithTitle:@"已发布" action:@selector(listYiFaBuBtnClick:) superView:_yiFaBuListView];
    [listYiFaBuBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.offset(0);
        make.height.offset(kListMenuBtnHeight);
    }];
    
    [self creatLineUnder:listYiFaBuBtn];
    
    UIButton *listWeiTongGuoBtn = [self creatListViewBtnWithTitle:@"未通过" action:@selector(listWeiTongGuoBtnClick:) superView:_yiFaBuListView];
    
    [listWeiTongGuoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(listYiFaBuBtn.mas_bottom);
        make.left.right.offset(0);
        make.height.offset(kListMenuBtnHeight);
    }];
    
    [self creatLineUnder:listWeiTongGuoBtn];
    
    UIButton *listCaoGaoBtn = [self creatListViewBtnWithTitle:@"草稿" action:@selector(listlistCaoGaoBtnClick:) superView:_yiFaBuListView];
    
    [listCaoGaoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(listWeiTongGuoBtn.mas_bottom);
        make.left.right.offset(0);
        make.height.offset(kListMenuBtnHeight);
    }];
    
    [self creatLineUnder:listCaoGaoBtn];
    
    UIButton *listDaiShenHeBtn = [self creatListViewBtnWithTitle:@"待审核" action:@selector(listDaiShenHeBtnClick:) superView:_yiFaBuListView];
    
    [listDaiShenHeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(listCaoGaoBtn.mas_bottom);
        make.left.right.offset(0);
        make.height.offset(kListMenuBtnHeight);
    }];
    
    UIView *alphaView = [[UIView alloc] init];
    alphaView.backgroundColor = [UIColor clearColor];
    [UIView animateWithDuration:0.25 animations:^{
        alphaView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.7];
    }];
    [_yiFaBuListView addSubview:alphaView];
    [alphaView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.top.equalTo(self.yiFaBuListView.mas_bottom);
        make.bottom.equalTo(self.view);
    }];
    
    switch (type) {
        case JstyleManagementYiFaBuListViewTypeWenZhang:
            [self.yiFaBuBtn setImage:[UIImage imageNamed:@"发布3"] forState:UIControlStateSelected];
            listYiFaBuBtn.tag = JstyleManagementYiFaBuListViewTypeWenZhang;
            listWeiTongGuoBtn.tag = JstyleManagementYiFaBuListViewTypeWenZhang;
            listCaoGaoBtn.tag = JstyleManagementYiFaBuListViewTypeWenZhang;
            listDaiShenHeBtn.tag = JstyleManagementYiFaBuListViewTypeWenZhang;
            break;
        case JstyleManagementYiFaBuListViewTypeShiPin:
            [self.shiPinYiFaBuBtn setImage:[UIImage imageNamed:@"发布3"] forState:UIControlStateSelected];
            listYiFaBuBtn.tag = JstyleManagementYiFaBuListViewTypeShiPin;
            listWeiTongGuoBtn.tag = JstyleManagementYiFaBuListViewTypeShiPin;
            listCaoGaoBtn.tag = JstyleManagementYiFaBuListViewTypeShiPin;
            listDaiShenHeBtn.tag = JstyleManagementYiFaBuListViewTypeShiPin;
            break;
        case JstyleManagementYiFaBuListViewTypeZhiBo:
            [self.zhiBoYiFaBuBtn setImage:[UIImage imageNamed:@"发布3"] forState:UIControlStateSelected];
            listYiFaBuBtn.tag = JstyleManagementYiFaBuListViewTypeZhiBo;
            listWeiTongGuoBtn.tag = JstyleManagementYiFaBuListViewTypeZhiBo;
            listCaoGaoBtn.tag = JstyleManagementYiFaBuListViewTypeZhiBo;
            listDaiShenHeBtn.tag = JstyleManagementYiFaBuListViewTypeZhiBo;
            break;
        default:
            break;
    }
    
}

//在某个View下面创建分割线
- (void)creatLineUnder:(UIView *)view {
    UIView *listLine = [[UIView alloc] init];
    listLine.backgroundColor = kLightLineColor;
    listLine.alpha = 0.25;
    [view.superview addSubview:listLine];
    [listLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.top.equalTo(view.mas_bottom);
        make.height.offset(0.2);
    }];
}

- (void)listYiFaBuBtnClick:(UIButton *)button {
    
    [self removeListView];
    
    switch (button.tag) {
        case JstyleManagementYiFaBuListViewTypeWenZhang:
        {
            [self.yiFaBuBtn setTitle:@"已发布" forState:UIControlStateNormal];
            if (self.wenZhangTableVC.wenZhangBlock) {
                self.wenZhangTableVC.statusType = JstyleManagementWenZhangTableViewControllerStatusTypeYiFaBu;
                self.wenZhangTableVC.wenZhangBlock(self.wenZhangTableVC.tOrFOriginalType, JstyleManagementWenZhangTableViewControllerStatusTypeYiFaBu);
            }
        }
            break;
        case JstyleManagementYiFaBuListViewTypeShiPin:
        {
            [self.shiPinYiFaBuBtn setTitle:@"已发布" forState:UIControlStateNormal];
            if (self.shiPinTableVC.shiPinBlock) {
                self.shiPinTableVC.statusType = JstyleManagementShiPinTableViewControllerStatusTypeYiFaBu;
                self.shiPinTableVC.shiPinBlock(JstyleManagementShiPinTableViewControllerStatusTypeYiFaBu);
            }
        }
            break;
        case JstyleManagementYiFaBuListViewTypeZhiBo:
        {
            [self.zhiBoYiFaBuBtn setTitle:@"已发布" forState:UIControlStateNormal];
            if (self.zhiBoTableVC.zhiBoBlock) {
                self.zhiBoTableVC.statusType = JstyleManagementZhiBoTableViewControllerStatusTypeYiFaBu;
                self.zhiBoTableVC.zhiBoBlock(JstyleManagementZhiBoTableViewControllerStatusTypeYiFaBu);
            }
        }
            break;
        default:
            break;
    }
    
}

- (void)listWeiTongGuoBtnClick:(UIButton *)button {
    
    [self removeListView];
    switch (button.tag) {
        case JstyleManagementYiFaBuListViewTypeWenZhang:
        {
            [self.yiFaBuBtn setTitle:@"未通过" forState:UIControlStateNormal];
            if (self.wenZhangTableVC.wenZhangBlock) {
                self.wenZhangTableVC.statusType = JstyleManagementWenZhangTableViewControllerStatusTypeWeiTongGuo;
                self.wenZhangTableVC.wenZhangBlock(self.wenZhangTableVC.tOrFOriginalType, JstyleManagementWenZhangTableViewControllerStatusTypeWeiTongGuo);
            }
        }
            break;
        case JstyleManagementYiFaBuListViewTypeShiPin:
        {
            [self.shiPinYiFaBuBtn setTitle:@"未通过" forState:UIControlStateNormal];
            if (self.shiPinTableVC.shiPinBlock) {
                self.shiPinTableVC.statusType = JstyleManagementShiPinTableViewControllerStatusTypeWeiTongGuo;
                self.shiPinTableVC.shiPinBlock(JstyleManagementShiPinTableViewControllerStatusTypeWeiTongGuo);
            }
        }
            break;
        case JstyleManagementYiFaBuListViewTypeZhiBo:
        {
            [self.zhiBoYiFaBuBtn setTitle:@"未通过" forState:UIControlStateNormal];
            if (self.zhiBoTableVC.zhiBoBlock) {
                self.zhiBoTableVC.statusType = JstyleManagementZhiBoTableViewControllerStatusTypeWeiTongGuo;
                self.zhiBoTableVC.zhiBoBlock(JstyleManagementZhiBoTableViewControllerStatusTypeWeiTongGuo);
            }
        }
            break;
        default:
            break;
    }
    
}

- (void)listlistCaoGaoBtnClick:(UIButton *)button {
    
    [self removeListView];
    switch (button.tag) {
        case JstyleManagementYiFaBuListViewTypeWenZhang:
        {
            [self.yiFaBuBtn setTitle:@"草稿" forState:UIControlStateNormal];
            if (self.wenZhangTableVC.wenZhangBlock) {
                self.wenZhangTableVC.statusType = JstyleManagementWenZhangTableViewControllerStatusTypeCaoGao;
                self.wenZhangTableVC.wenZhangBlock(self.wenZhangTableVC.tOrFOriginalType, JstyleManagementWenZhangTableViewControllerStatusTypeCaoGao);
            }
        }
            break;
        case JstyleManagementYiFaBuListViewTypeShiPin:
        {
            [self.shiPinYiFaBuBtn setTitle:@"草稿" forState:UIControlStateNormal];
            if (self.shiPinTableVC.shiPinBlock) {
                self.shiPinTableVC.statusType = JstyleManagementShiPinTableViewControllerStatusTypeCaoGao;
                self.shiPinTableVC.shiPinBlock(JstyleManagementShiPinTableViewControllerStatusTypeCaoGao);
            }
        }
            break;
        case JstyleManagementYiFaBuListViewTypeZhiBo:
        {
            [self.zhiBoYiFaBuBtn setTitle:@"草稿" forState:UIControlStateNormal];
            if (self.zhiBoTableVC.zhiBoBlock) {
                self.zhiBoTableVC.statusType = JstyleManagementZhiBoTableViewControllerStatusTypeCaoGao;
                self.zhiBoTableVC.zhiBoBlock(JstyleManagementZhiBoTableViewControllerStatusTypeCaoGao);
            }
        }
            break;
        default:
            break;
    }
    
}

- (void)listDaiShenHeBtnClick:(UIButton *)button {
    
    [self removeListView];
    switch (button.tag) {
        case JstyleManagementYiFaBuListViewTypeWenZhang:
        {
            [self.yiFaBuBtn setTitle:@"待审核" forState:UIControlStateNormal];
            if (self.wenZhangTableVC.wenZhangBlock) {
                self.wenZhangTableVC.statusType = JstyleManagementWenZhangTableViewControllerStatusTypeDaiShenHe;
                self.wenZhangTableVC.wenZhangBlock(self.wenZhangTableVC.tOrFOriginalType, JstyleManagementWenZhangTableViewControllerStatusTypeDaiShenHe);
            }
        }
            break;
        case JstyleManagementYiFaBuListViewTypeShiPin:
        {
            [self.shiPinYiFaBuBtn setTitle:@"待审核" forState:UIControlStateNormal];
            if (self.shiPinTableVC.shiPinBlock) {
                self.shiPinTableVC.statusType = JstyleManagementShiPinTableViewControllerStatusTypeYiFaBu;
                self.shiPinTableVC.shiPinBlock(JstyleManagementShiPinTableViewControllerStatusTypeYiFaBu);
            }
        }
            break;
        case JstyleManagementYiFaBuListViewTypeZhiBo:
        {
            [self.zhiBoYiFaBuBtn setTitle:@"待审核" forState:UIControlStateNormal];
            if (self.zhiBoTableVC.zhiBoBlock) {
                self.zhiBoTableVC.statusType = JstyleManagementZhiBoTableViewControllerStatusTypeDaiShenHe;
                self.zhiBoTableVC.zhiBoBlock(JstyleManagementZhiBoTableViewControllerStatusTypeDaiShenHe);
            }
        }
            break;
        default:
            break;
    }
    
}

// TODO: 文章已发布按钮点击
- (void)yiFaBuBtnClick:(UIButton *)button {
    button.selected = YES;
    self.yuanChuangWenZhangBtn.selected = NO;
    if (self.yiFaBuListView != nil) {
        [self removeListView];
        return;
    }
    [self removeListView];
    [self setupYiFaBuListMenuWithType:JstyleManagementYiFaBuListViewTypeWenZhang];
}

// TODO: 视频已发布按钮点击
- (void)shiPinYiFaBuBtnClick:(UIButton *)button {
    if (self.yiFaBuListView != nil) {
        [self removeListView];
        return;
    }
    [self setupYiFaBuListMenuWithType:JstyleManagementYiFaBuListViewTypeShiPin];
    
}

// TODO: 直播已发布按钮点击
- (void)zhiBoYiFaBuBtnClick:(UIButton *)button {
    if (self.yiFaBuListView != nil) {
        [self removeListView];
        return;
    }
    [self setupYiFaBuListMenuWithType:JstyleManagementYiFaBuListViewTypeZhiBo];
}


- (void)listYuanChuangBtnClick {
    NSLog(@"listYuanChuangBtnClick");
    [self removeListView];
    [self.yuanChuangWenZhangBtn setTitle:@"原创文章" forState:UIControlStateNormal];
    if (self.wenZhangTableVC.wenZhangBlock) {
        self.wenZhangTableVC.tOrFOriginalType = JstyleManagementWenZhangTableViewControllerTOrFOriginalTypeYuanChuang;
        self.wenZhangTableVC.wenZhangBlock(JstyleManagementWenZhangTableViewControllerTOrFOriginalTypeYuanChuang, self.wenZhangTableVC.statusType);
    }
    
}

- (void)listJuHeBtnClick {
    NSLog(@"listJuHeBtnClick");
    [self removeListView];
    [self.yuanChuangWenZhangBtn setTitle:@"聚合文章" forState:UIControlStateNormal];
    if (self.wenZhangTableVC.wenZhangBlock) {
        self.wenZhangTableVC.tOrFOriginalType = JstyleManagementWenZhangTableViewControllerTOrFOriginalTypeJuHe;
        self.wenZhangTableVC.wenZhangBlock(JstyleManagementWenZhangTableViewControllerTOrFOriginalTypeJuHe, self.wenZhangTableVC.statusType);
    }
}

- (void)removeListView {
    [self.yuanChuangWenZhangBtn setImage:[UIImage imageNamed:@"发布2"] forState:UIControlStateSelected];
    [self.yiFaBuBtn setImage:[UIImage imageNamed:@"发布2"] forState:UIControlStateSelected];
    [self.shiPinYiFaBuBtn setImage:[UIImage imageNamed:@"发布2"] forState:UIControlStateSelected];
    [self.zhiBoYiFaBuBtn setImage:[UIImage imageNamed:@"发布2"] forState:UIControlStateSelected];
    
    [self.yuanChuangListView removeFromSuperview];
    self.yuanChuangListView = nil;
    [self.yiFaBuListView removeFromSuperview];
    self.yiFaBuListView = nil;
}

// TODO: 滑动列表视图
- (void)setupScrollView {
    
    _scrollView = [[UIScrollView alloc] init];
    _scrollView.pagingEnabled = YES;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.bounces = NO;
    _scrollView.delegate = self;
    _scrollView.contentSize = CGSizeMake(kScreenWidth * 5, 0);
    [self.view addSubview:_scrollView];
    [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.sliderView.mas_bottom).offset(1);
        make.left.right.bottom.offset(0);
    }];
    
    [self setupTwoSelectedView];
    
    [_scrollView layoutIfNeeded];
    CGFloat tableViewHeight = _scrollView.size.height - 46;
    
    //文章tableview
    [self addChildViewController:self.wenZhangTableVC];
    [_wenZhangTableVC didMoveToParentViewController:self];
    [_scrollView addSubview:_wenZhangTableVC.tableView];
    self.wenZhangTableVC.tableView.frame = CGRectMake(0, 46, kScreenWidth, tableViewHeight);
    
    //视频tableview
    [self setupShiPinOneSelectedView];
    [self addChildViewController:self.shiPinTableVC];
    [_shiPinTableVC didMoveToParentViewController:self];
    [_scrollView addSubview:_shiPinTableVC.tableView];
    self.shiPinTableVC.tableView.frame = CGRectMake(kScreenWidth, 46, kScreenWidth, tableViewHeight);
    
    //直播tableView
    [self setupZhiBoOneSelectedView];
    [self addChildViewController:self.zhiBoTableVC];
    [self.zhiBoTableVC didMoveToParentViewController:self];
    [_scrollView addSubview:_zhiBoTableVC.tableView];
    self.zhiBoTableVC.tableView.frame = CGRectMake(kScreenWidth * 2, 46, kScreenWidth, tableViewHeight);
    
    //评论tableView
    [self addChildViewController:self.pingLunTableVC];
    [self.pingLunTableVC didMoveToParentViewController:self];
    [_scrollView addSubview:self.pingLunTableVC.tableView];
    self.pingLunTableVC.tableView.frame = CGRectMake(kScreenWidth * 3, 0, kScreenWidth, tableViewHeight+46);
    
    //我的tableView
    [self addChildViewController:self.woDeTableVC];
    [self.woDeTableVC didMoveToParentViewController:self];
    [_scrollView addSubview:self.woDeTableVC.tableView];
    self.woDeTableVC.tableView.frame = CGRectMake(kScreenWidth * 4, 0, kScreenWidth, tableViewHeight+46);
}

- (void)setupShiPinOneSelectedView {
    
    UIView *shiPinOneSelectedView = [[UIView alloc] initWithFrame:CGRectMake(kScreenWidth, 0, kScreenWidth, 46)];
    [_scrollView addSubview:shiPinOneSelectedView];
    
    JstyleManagementTwoSelectedButton *shiPinYiFaBuBtn = [JstyleManagementTwoSelectedButton buttonWithType:UIButtonTypeCustom];
    self.shiPinYiFaBuBtn = shiPinYiFaBuBtn;
    [shiPinYiFaBuBtn setTitle:@"已发布" forState:UIControlStateNormal];
    shiPinYiFaBuBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [shiPinYiFaBuBtn setTitleColor:ISNightMode?kDarkFiveColor:kDarkNineColor forState:UIControlStateNormal];
    [shiPinYiFaBuBtn setTitleColor:kDarkTwoColor forState:UIControlStateHighlighted];
    [shiPinYiFaBuBtn setTitleColor:ISNightMode?kDarkNineColor:kDarkTwoColor forState:UIControlStateSelected];
    [shiPinYiFaBuBtn setImage:[UIImage imageNamed:@"发布"] forState:UIControlStateNormal];
    [shiPinYiFaBuBtn setImage:[UIImage imageNamed:@"发布2"] forState:UIControlStateSelected];
    [shiPinYiFaBuBtn addTarget:self action:@selector(shiPinYiFaBuBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [shiPinOneSelectedView addSubview:shiPinYiFaBuBtn];
    [shiPinYiFaBuBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(kScreenWidth);
        make.top.bottom.offset(0);
        make.left.offset(0);
    }];
    shiPinYiFaBuBtn.selected = YES;
    
    UIView *line2 = [[UIView alloc] init];
    line2.backgroundColor = kLightLineColor;
    line2.alpha = 0.25;
    [shiPinOneSelectedView addSubview:line2];
    [line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.height.offset(0.5);
        make.bottom.offset(0);
    }];
}

- (void)setupZhiBoOneSelectedView {
    
    UIView *zhiBoOneSelectedView = [[UIView alloc] initWithFrame:CGRectMake(kScreenWidth * 2, 0, kScreenWidth, 46)];
    [_scrollView addSubview:zhiBoOneSelectedView];
    
    JstyleManagementTwoSelectedButton *zhiBoYiFaBuBtn = [JstyleManagementTwoSelectedButton buttonWithType:UIButtonTypeCustom];
    self.zhiBoYiFaBuBtn = zhiBoYiFaBuBtn;
    [zhiBoYiFaBuBtn setTitle:@"已发布" forState:UIControlStateNormal];
    zhiBoYiFaBuBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [zhiBoYiFaBuBtn setTitleColor:ISNightMode?kDarkFiveColor:kDarkNineColor forState:UIControlStateNormal];
    [zhiBoYiFaBuBtn setTitleColor:kDarkTwoColor forState:UIControlStateHighlighted];
    [zhiBoYiFaBuBtn setTitleColor:ISNightMode?kDarkNineColor:kDarkTwoColor forState:UIControlStateSelected];
    [zhiBoYiFaBuBtn setImage:[UIImage imageNamed:@"发布"] forState:UIControlStateNormal];
    [zhiBoYiFaBuBtn setImage:[UIImage imageNamed:@"发布2"] forState:UIControlStateSelected];
    [zhiBoYiFaBuBtn addTarget:self action:@selector(zhiBoYiFaBuBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [zhiBoOneSelectedView addSubview:zhiBoYiFaBuBtn];
    [zhiBoYiFaBuBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(kScreenWidth);
        make.top.bottom.offset(0);
        make.left.offset(0);
    }];
    zhiBoYiFaBuBtn.selected = YES;
    
    UIView *line2 = [[UIView alloc] init];
    line2.backgroundColor = kLightLineColor;
    line2.alpha = 0.25;
    [zhiBoOneSelectedView addSubview:line2];
    [line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.height.offset(0.5);
        make.bottom.offset(0);
    }];
}

- (JstyleManagementButton *)creatMenuButtonWithImageName:(NSString *)imageName tag:(JstyleManagementMyJstyleAccountButtonTag)tag {
    JstyleManagementButton *button = [JstyleManagementButton new];
    [button setTitle:imageName forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:12];
    [button setTitleColor:kDarkThreeColor forState:UIControlStateNormal];
    [button setTitleColor:[UIColor colorFromHex:0xEA2332] forState:UIControlStateSelected];
    [button setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@1",imageName]] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@2",imageName]] forState:UIControlStateSelected];
    [button addTarget:self action:@selector(menuButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    button.tag = tag;
    
    button.lee_theme
    .LeeCustomConfig(ThemeMainBtnTitleOrBorderColor, ^(id item, id value) {
        if ([[LEETheme currentThemeTag] isEqualToString:ThemeName_Black]) {
            [item setTitleColor:JSColor(@"#FF5A5F") forState:UIControlStateSelected];
        } else {
            [item setTitleColor:value forState:UIControlStateSelected];
        }
    });
    
    return button;
}

- (void)menuButtonClick:(JstyleManagementButton *)button {
    
    for (JstyleManagementButton *managementButton in self.fiveBtnArray) {
        if (button == managementButton) {
            button.selected = YES;
        } else {
            managementButton.selected = NO;
        }
    }
    
    [self removeListView];
    
    switch (button.tag) {
        case JstyleManagementMyJstyleAccountButtonTagWenZhang:
        {
            [UIView animateWithDuration:0.25 animations:^{
                self.sliderView.contentOffset = CGPointMake(0, 0);
                self.scrollView.contentOffset = CGPointMake(0, 0);
            }];
            break;
        }
        case JstyleManagementMyJstyleAccountButtonTagShiPin:
        {
            [UIView animateWithDuration:0.25 animations:^{
                self.sliderView.contentOffset = CGPointMake(-kScreenWidth/5, 0);
                self.scrollView.contentOffset = CGPointMake(kScreenWidth, 0);
            }];
            break;
        }
        case JstyleManagementMyJstyleAccountButtonTagZhiBo:
        {
            [UIView animateWithDuration:0.25 animations:^{
                self.sliderView.contentOffset = CGPointMake(-kScreenWidth/5 * 2, 0);
                self.scrollView.contentOffset = CGPointMake(kScreenWidth * 2, 0);
            }];
            break;
        }
        case JstyleManagementMyJstyleAccountButtonTagPingLun:
        {
            [UIView animateWithDuration:0.25 animations:^{
                self.sliderView.contentOffset = CGPointMake(-kScreenWidth/5 * 3, 0);
                self.scrollView.contentOffset = CGPointMake(kScreenWidth * 3, 0);
            }];
            break;
        }
        case JstyleManagementMyJstyleAccountButtonTagWoDe:
        {
            [UIView animateWithDuration:0.25 animations:^{
                self.sliderView.contentOffset = CGPointMake(-kScreenWidth/5 * 4, 0);
                self.scrollView.contentOffset = CGPointMake(kScreenWidth * 4, 0);
            }];
            break;
        }
        default:
            break;
    }
}

- (void)backItemClick {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 总阅读数Api
- (void)LoadCountData {
    
    
    JstyleNewsNetworkManager *manager = [JstyleNewsNetworkManager shareManager];
    
    NSMutableDictionary *paramaters = [NSMutableDictionary dictionary];
    [paramaters setObject:[[JstyleToolManager sharedManager] getUniqueId] forKey:@"uniqueid"];

    [manager GET:MANAGER_COUNTNUM_URL parameters:paramaters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *responseData = responseObject;
        if ([responseData[@"code"] isEqualToString:@"1"]) {
            if (responseData[@"data"]) {
                self.bottomMenuDataArray = [NSArray modelArrayWithClass:[JstyleManagementNavigationBottomMenuModel class] json:responseData[@"data"]];
            }
            
            self.zongYueDuShuView.countLabel.text = [self.bottomMenuDataArray[0] num];
            self.zongYueDuShuView.titleLabel.text = [self.bottomMenuDataArray[0] name];
            
            self.zongFenSiShuView.countLabel.text = [self.bottomMenuDataArray[1] num];
            self.zongFenSiShuView.titleLabel.text = [self.bottomMenuDataArray[1] name];
            
            self.zongWenZhangShuView.countLabel.text = [self.bottomMenuDataArray[2] num];
            self.zongWenZhangShuView.titleLabel.text = [self.bottomMenuDataArray[2] name];
            
            self.zongShiPinShuView.titleLabel.text = [self.bottomMenuDataArray[3] name];
            
            self.zongZhiBoShuView.countLabel.text = [self.bottomMenuDataArray[4] num];
            self.zongZhiBoShuView.titleLabel.text = [self.bottomMenuDataArray[4] name];
            
        } else if ([responseData[@"code"] isEqualToString:@"2"]){
            
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
        [SVProgressHUD dismiss];
    }];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    _sliderView.contentOffset = CGPointMake(-scrollView.contentOffset.x/5, 0);
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self removeListView];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSInteger page = scrollView.contentOffset.x / kScreenWidth;
    
    switch (page) {
        case 0:
            self.wenZhangBtn.selected = YES;
            self.shiPinBtn.selected = NO;
            self.zhiBoBtn.selected = NO;
            self.pingLunBtn.selected = NO;
            self.woDeBtn.selected = NO;
            break;
        case 1:
            self.wenZhangBtn.selected = NO;
            self.shiPinBtn.selected = YES;
            self.zhiBoBtn.selected = NO;
            self.pingLunBtn.selected = NO;
            self.woDeBtn.selected = NO;
            break;
        case 2:
            self.wenZhangBtn.selected = NO;
            self.shiPinBtn.selected = NO;
            self.zhiBoBtn.selected = YES;
            self.pingLunBtn.selected = NO;
            self.woDeBtn.selected = NO;
            break;
        case 3:
            self.wenZhangBtn.selected = NO;
            self.shiPinBtn.selected = NO;
            self.zhiBoBtn.selected = NO;
            self.pingLunBtn.selected = YES;
            self.woDeBtn.selected = NO;
            break;
        case 4:
            self.wenZhangBtn.selected = NO;
            self.shiPinBtn.selected = NO;
            self.zhiBoBtn.selected = NO;
            self.pingLunBtn.selected = NO;
            self.woDeBtn.selected = YES;
            break;
        default:
            break;
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    [[SDImageCache sharedImageCache] clearMemory];
    [[YYWebImageManager sharedManager].cache.memoryCache removeAllObjects];
}

@end
