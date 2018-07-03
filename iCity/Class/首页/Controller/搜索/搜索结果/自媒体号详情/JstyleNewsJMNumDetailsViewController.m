//
//  JstyleNewsJMNumDetailsViewController.m
//  JstyleNews
//
//  Created by JingHongMuYun on 2018/1/9.
//  Copyright © 2018年 JstyleNews. All rights reserved.
//
//自媒体主页

#import "JstyleNewsJMNumDetailsViewController.h"
#import "ZJScrollPageView.h"
#import "JstylePersonalMediaModel.h"
#import "JstyleNewsJmNumsDetailArticleViewController.h"
#import "JstyleNewsJmNumsDetailVideoViewController.h"
#import "JstyleNewsJmNumsDetailLiveViewController.h"
#import "JstyleNewsBaseAttentionButton.h"

@interface JstyleNewsJMNumDetailsViewController ()<ZJScrollPageViewDelegate>

@property (nonatomic, strong) JstylePersonalMediaIntroModel *model;
@property (strong, nonatomic) NSArray<NSString *> *titles;
@property (assign, nonatomic) NSInteger selectedIndex;
@property (strong, nonatomic) ZJScrollPageView *scrollPageView;

@property (strong, nonatomic) JstyleNewsBaseView *headView;
@property (assign, nonatomic) CGFloat headViewHeight;
@property (assign, nonatomic) BOOL isSelectedBtn;
@property (strong, nonatomic) YYAnimatedImageView *backImageView;
@property (strong, nonatomic) JstyleNewsBaseTitleLabel *nameLabel;
@property (strong, nonatomic) JstyleNewsBaseAttentionButton *subscribeBtn;
@property (strong, nonatomic) JstyleNewsBaseTitleLabel *introlLabel;
@property (strong, nonatomic) UIButton *triangleBtn;
@property (strong, nonatomic) UIView *columnView;
@property (nonatomic, copy) NSString *titleStr;

@property (nonatomic, copy) NSString *shareImgUrl;
@property (nonatomic, copy) NSString *shareUrl;
@property (nonatomic, copy) NSString *shareTitle;
@property (nonatomic, copy) NSString *shareDesc;

/**文章*/
@property (nonatomic, strong) JstyleNewsJmNumsDetailArticleViewController *articleVc;
@property (nonatomic, assign) NSUInteger articleCount;
/**视频*/
@property (nonatomic, strong) JstyleNewsJmNumsDetailVideoViewController *videoVc;
@property (nonatomic, assign) NSUInteger videoCount;

@end

@implementation JstyleNewsJMNumDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.headViewHeight = 150;
    self.view.backgroundColor = kNightModeBackColor;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
//    kweakSelf
    self.articleVc = [[JstyleNewsJmNumsDetailArticleViewController alloc] init];
//    [_articleVc setIndexBlock:^(NSUInteger dataCount) {
//        weakSelf.articleCount = dataCount;
//        [weakSelf refreshIndex];
//    }];
 
    self.videoVc = [[JstyleNewsJmNumsDetailVideoViewController alloc] init];
//    [_videoVc setIndexBlock:^(NSUInteger dataCount) {
//        weakSelf.videoCount = dataCount;
//        [weakSelf refreshIndexAfater];
//    }];
    
    
    [self addHeaderView];
    [self getShareData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [self getJstylePersonalMediaIntroDataSource];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
}
#pragma mark - 头部视图
- (void)addHeaderView
{
    UIButton *leftBtn = [[UIButton alloc] init];
    [leftBtn setImage:(ISNightMode?JSImage(@"返回白色"):JSImage(@"图文返回黑")) forState:(UIControlStateNormal)];
    [leftBtn addTarget:self action:@selector(leftBtnClicked:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:leftBtn];
    leftBtn.sd_layout
    .topSpaceToView(self.view, 30+(IS_iPhoneX?24:0))
    .leftSpaceToView(self.view, 7)
    .widthIs(25)
    .heightIs(25);
    
    UIButton *rightBtn = [[UIButton alloc] init];
    [rightBtn setImage:(ISNightMode?JSImage(@"图集分享白"):JSImage(@"图集分享黑")) forState:(UIControlStateNormal)];
    [rightBtn addTarget:self action:@selector(shareAction) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:rightBtn];
    rightBtn.sd_layout
    .topSpaceToView(self.view, 30+(IS_iPhoneX?24:0))
    .rightSpaceToView(self.view, 10)
    .widthIs(25)
    .heightIs(25);
    
    _headView = [[JstyleNewsBaseView alloc] initWithFrame:CGRectMake(0, YG_StatusAndNavightion_H, kScreenWidth, self.headViewHeight)];
    
    _backImageView = [[YYAnimatedImageView alloc] init];
    _backImageView.layer.cornerRadius = 30;
    _backImageView.layer.masksToBounds = YES;
    [_headView addSubview:_backImageView];
    _backImageView.sd_layout
    .leftSpaceToView(_headView, 15)
    .topSpaceToView(_headView, 15)
    .widthIs(60)
    .heightIs(60);
    
    _subscribeBtn = [[JstyleNewsBaseAttentionButton alloc] init];
    _subscribeBtn.layer.cornerRadius = 15;
    _subscribeBtn.layer.masksToBounds = YES;
    _subscribeBtn.titleLabel.font = JSFont(14);
    [_subscribeBtn addTarget:self action:@selector(addJstyleNewsSubscribeJmNumsData) forControlEvents:(UIControlEventTouchUpInside)];
    [_headView addSubview:_subscribeBtn];
    _subscribeBtn.sd_layout
    .rightSpaceToView(_headView, 15)
    .centerYEqualToView(_backImageView)
    .widthIs(70)
    .heightIs(30);
    
    _nameLabel = [[JstyleNewsBaseTitleLabel alloc] init];
    _nameLabel.font = JSFont(14);
    [_headView addSubview:_nameLabel];
    _nameLabel.sd_layout
    .leftSpaceToView(_backImageView, 15)
    .rightSpaceToView(_subscribeBtn, 15)
    .centerYEqualToView(_backImageView)
    .heightIs(14);
    
    _introlLabel = [[JstyleNewsBaseTitleLabel alloc] initWithFrame:CGRectMake(15, 100, kScreenWidth - 30, 35)];
    _introlLabel.font = JSFont(13);
    _introlLabel.numberOfLines = 0;
    [_headView addSubview:_introlLabel];
    
    _columnView = [[UIView alloc] init];
    _columnView.backgroundColor = ISNightMode?kDarkTwoColor:kBackGroundColor;
    [_headView addSubview:_columnView];
    _columnView.sd_layout
    .bottomEqualToView(_headView)
    .leftEqualToView(_headView)
    .rightEqualToView(_headView)
    .heightIs(10);
    
    _triangleBtn = [[UIButton alloc] init];
    [_triangleBtn setImage:JSImage(@"内容展开") forState:(UIControlStateNormal)];
    [_triangleBtn addTarget:self action:@selector(triangleBtnClicked:) forControlEvents:(UIControlEventTouchUpInside)];
    [_triangleBtn setEnlargeEdgeWithTop:10 right:10 bottom:10 left:10];
    [_headView addSubview:_triangleBtn];
    _triangleBtn.hidden = YES;
    _triangleBtn.sd_layout
    .centerXEqualToView(_headView)
    .bottomSpaceToView(_columnView, 15)
    .widthIs(16)
    .heightIs(8);
    
    [self.view addSubview:_headView];
}

- (void)triangleBtnClicked:(UIButton *)sender
{
    self.isSelectedBtn = !self.isSelectedBtn;
    self.model.isOpen = self.isSelectedBtn;
    [self setIntroWithModel:self.model];
}

- (void)addPagerView
{
    ZJSegmentStyle *style = [[ZJSegmentStyle alloc] init];
    style.titleFont = JSFont(14);
    style.selectedTitleFont = JSFont(14);
    style.autoAdjustTitlesWidth = YES;
    style.adjustCoverOrLineWidth = YES;
    style.normalTitleColor = ISNightMode?RGBACOLOR(159, 159, 159, 1):RGBACOLOR(176, 174, 188, 1);
    style.selectedTitleColor = ISNightMode?RGBACOLOR(85, 85, 85, 1):RGBACOLOR(0, 0, 0, 1);
    // 颜色渐变
    style.gradualChangeTitleColor = YES;
    style.scrollTitle = NO;
    style.showLine = YES;
    style.scrollLineColor = ISNightMode?RGBACOLOR(159, 159, 159, 1):kDarkTwoColor;
    style.animatedContentViewWhenTitleClicked = YES;
    
    ZJScrollPageView *scrollPageView = [[ZJScrollPageView alloc] initWithFrame:CGRectMake(0, self.headViewHeight + YG_StatusAndNavightion_H, kScreenWidth, kScreenHeight - self.headViewHeight - YG_StatusAndNavightion_H) segmentStyle:style titles:self.titles parentViewController:self delegate:self];
    scrollPageView.backgroundColor = ISNightMode?kNightModeBackColor:kWhiteColor;
    [scrollPageView setSelectedIndex:self.selectedIndex animated:NO];
    _scrollPageView = scrollPageView;
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 43.5, kScreenWidth, 0.5)];
    line.backgroundColor = kSingleLineColor;
    [_scrollPageView addSubview:line];
    
    [self.view addSubview:_scrollPageView];
}

#pragma ZJScrollPageViewDelegate 代理方法
- (NSInteger)numberOfChildViewControllers {
    return self.titles.count;
}

- (UIViewController<ZJScrollPageViewChildVcDelegate> *)childViewController:(UIViewController<ZJScrollPageViewChildVcDelegate> *)reuseViewController forIndex:(NSInteger)index {
    NSString *title = self.titles[index];
    if ([title containsString:@"文章"]) {
        
        self.articleVc.did = self.did;
        
        return self.articleVc;
    }else if([title containsString:@"视频"]) {
       
        self.videoVc.did = self.did;
        return self.videoVc;
    }else{//直播
        JstyleNewsJmNumsDetailLiveViewController *childVc = [[JstyleNewsJmNumsDetailLiveViewController alloc] init];
        childVc.did = self.did;
        return childVc;
    }
}

- (BOOL)shouldAutomaticallyForwardAppearanceMethods
{
    return NO;
}

/**获取自媒体详情信息*/
- (void)getJstylePersonalMediaIntroDataSource
{
    NSDictionary *parameters = @{@"platform_type":@"2",
                                 @"did":[NSString stringWithFormat:@"%@", self.did],
                                 @"uid":[[JstyleToolManager sharedManager] getUserId]};
    [[JstyleNewsNetworkManager shareManager] GETURL:MANAGER_DETAILINFO_URL parameters:parameters success:^(id responseObject) {
        
        NSLog(@"=====%@",responseObject);
        
        if ([responseObject[@"code"] integerValue] == 1) {
            self.model = [JstylePersonalMediaIntroModel new];
            [self.model setValuesForKeysWithDictionary:responseObject[@"data"]];
            [self setIntroWithModel:self.model];
            self.titleStr = self.model.pen_name;
            
            if ([responseObject[@"data"][@"relation"] count] == 3) {
                NSArray *array = responseObject[@"data"][@"relation"];
                NSDictionary *dict0 = array[0];
                NSDictionary *dict1 = array[1];
                NSDictionary *dict2 = array[2];
                self.titles = @[@"文章",@"视频",@"直播"];
                if([dict0[@"status"] integerValue] == 1){
                    self.selectedIndex = 0;
                }else if([dict1[@"status"] integerValue] == 1){
                    self.selectedIndex = 1;
                }else if([dict2[@"status"] integerValue] == 1){
                    self.selectedIndex = 2;
                }else{
                    self.selectedIndex = 0;
                }
            }else{
                NSArray *array = responseObject[@"data"][@"relation"];
                NSDictionary *dict = array[0];
                NSDictionary *dict1 = array[1];
                self.titles = @[@"文章",@"视频"];
                if([dict[@"status"] integerValue] == 1){
                    self.selectedIndex = 0;
                }else if([dict1[@"status"] integerValue] == 1){
                    self.selectedIndex = 1;
                }else{
                    self.selectedIndex = 0;
                }
               
            }
        }
        if (!self.scrollPageView) {
            [self addPagerView];
        }
    } failure:nil];
}

/**订阅iCity号*/
- (void)addJstyleNewsSubscribeJmNumsData
{
    if ([[JstyleToolManager sharedManager] isTourist]) {
        [[JstyleToolManager sharedManager] loginInViewController];
        return;
    }
    NSDictionary *parameters = @{@"platform_type":@"2",
                                 @"did":[NSString stringWithFormat:@"%@", self.did],
                                 @"uid":[[JstyleToolManager sharedManager] getUserId]};
    [[JstyleNewsNetworkManager shareManager] GETURL:MANAGER_SUBSCRIPTION_URL parameters:parameters success:^(id responseObject) {
        if ([responseObject[@"code"] integerValue] == 1) {
            NSString *followType = responseObject[@"data"][@"follow_type"];
            self.model.is_follow = followType;
            [[NSNotificationCenter defaultCenter] postNotificationName:@"AttentionRefresh" object:nil userInfo:@{@"followType":[NSString stringWithFormat:@"%@",followType],@"did":[NSString stringWithFormat:@"%@",self.did]}];
        }
        [self setIntroWithModel:self.model];
    } failure:nil];
}

/**分享数据*/
-(void)getShareData
{
    if (![self.did isNotBlank]) {
        
        NSLog(@"JstyleNewsJMNumDetailsViewController.did = %@",self.did);
        return;
    }
    NSDictionary *parameters = @{@"platform_type":@"2",
                                 @"id":self.did,
                                 @"type":@"4",
                                 @"uid":[[JstyleToolManager sharedManager] getUserId],
                                 @"uuid":[[JstyleToolManager sharedManager] getUDID]};
    
    [[JstyleNewsNetworkManager shareManager] POSTURL:COMMON_SHARE_URL parameters:parameters success:^(id responseObject) {
        if ([responseObject[@"code"] integerValue] == 1) {
            self.shareUrl = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"ashareurl"]];
            self.shareTitle = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"title"]];
            self.shareImgUrl = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"poster"]];
            self.shareDesc = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"describes"]];
        }
    } failure:nil];
}

- (void)setIntroWithModel:(JstylePersonalMediaIntroModel *)model
{
    [self.backImageView setImageWithURL:[NSURL URLWithString:model.head_img] options:(YYWebImageOptionSetImageWithFadeAnimation)];
    self.nameLabel.text = model.pen_name;
    self.introlLabel.attributedText = [model.instruction attributedStringWithlineSpace:3 textColor:kDarkTwoColor font:[UIFont systemFontOfSize:13]];
    
    if ([model.is_follow integerValue] == 1) {
        self.subscribeBtn.selected = YES;
    }else{
        self.subscribeBtn.selected = NO;
    }
    
    CGFloat introHeight = [model.instruction getAttributedStringRectWithSpace:3 withFont:13 withWidth:kScreenWidth - 30].size.height;
    if (introHeight < 35) {
        self.triangleBtn.hidden = YES;
    }else{
        self.triangleBtn.hidden = NO;
    }
    
    if (model.isOpen) {
        [_triangleBtn setImage:[UIImage imageNamed:@"内容闭合"] forState:(UIControlStateNormal)];
        [_triangleBtn setImage:[UIImage imageNamed:@"内容闭合"] forState:(UIControlStateHighlighted)];
        self.introlLabel.height = introHeight;
    } else {
        [_triangleBtn setImage:[UIImage imageNamed:@"内容展开"] forState:(UIControlStateNormal)];
        [_triangleBtn setImage:[UIImage imageNamed:@"内容展开"] forState:(UIControlStateHighlighted)];
        self.introlLabel.height = 35;
    }
    self.headViewHeight = 145 + self.introlLabel.height;
    self.headView.height = self.headViewHeight;
    
    _scrollPageView.frame = CGRectMake(0, self.headViewHeight + YG_StatusAndNavightion_H, kScreenWidth, kScreenHeight - self.headViewHeight - YG_StatusAndNavightion_H);
    _scrollPageView.contentView.height =  kScreenHeight - self.headViewHeight - YG_StatusAndNavightion_H - 44;
}

- (void)leftBtnClicked:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

/**友盟分享*/
- (void)shareAction
{
    [[JstyleToolManager sharedManager] shareActionWithShareTitle:self.shareTitle shareDesc:self.shareDesc shareImgUrl:self.shareImgUrl shareLinkUrl:self.shareUrl viewController:self];
}


//- (void)refreshIndex {
//
//    if (self.articleCount==0) {
//         self.selectedIndex = 1;
//        [self.scrollPageView setSelectedIndex:self.selectedIndex animated:NO];
//    }
//
//}
//
//- (void)refreshIndexAfater {
//    if(self.articleCount==0&& self.videoCount>0 ){
//        self.selectedIndex = 1;
//    }else{
//        self.selectedIndex = 0;
//        [self.scrollPageView setSelectedIndex:self.selectedIndex animated:YES];
//    }
//}

-(UIStatusBarStyle)preferredStatusBarStyle {
    
    return ISNightMode?UIStatusBarStyleLightContent:UIStatusBarStyleDefault;
}

@end

