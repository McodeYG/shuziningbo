
//
//  JstyleInviteFriendsViewController.m
//  Exquisite
//
//  Created by JingHongMuYun on 2018/3/6.
//  Copyright © 2018年 JstyleStar. All rights reserved.
//

#import "JstyleInviteFriendsViewController.h"
#import "WMPageController.h"
#import "MainTouchTableTableView.h"
#import "ParentClassScrollViewController.h"
#import "JstyleEarningListViewController.h"
#import "JstyleMyInvitedMembersViewController.h"
#import "JstyleRewardRulesView.h"
#import "JstyleNotVipAlertView.h"

@interface JstyleInviteFriendsViewController ()<UITableViewDelegate, UITableViewDataSource, scrollDelegate, WMPageControllerDelegate>

@property(nonatomic, strong) MainTouchTableTableView *mainTableView;
@property(nonatomic, strong) UIScrollView * parentScrollView;

@property(nonatomic, strong) UIImageView *headImageView;
@property(nonatomic, strong) UIButton * rulesBtn;
@property(nonatomic, strong) UIButton *invitationBtn;
@property(nonatomic, assign) CGFloat headViewHeight;
@property(nonatomic, strong) JstyleRewardRulesView *rewardRulesView;
@property(nonatomic, strong) JstyleNotVipAlertView *notVipAlertView;

@property (nonatomic, copy) NSString *shareImgUrl;
@property (nonatomic, copy) NSString *shareUrl;
@property (nonatomic, copy) NSString *shareTitle;
@property (nonatomic, copy) NSString *shareDesc;

@end

@implementation JstyleInviteFriendsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"邀请好友";
    self.view.backgroundColor = kWhiteColor;
    [self getShareData];
    _headViewHeight = 280 * kScreenWidth/375.0;
    [self.view addSubview:self.mainTableView];
    [self.mainTableView addSubview:self.headImageView];
    if (@available(iOS 11.0, *)) {
        self.mainTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
}

#pragma scrollDelegate
-(void)scrollViewLeaveAtTheTop:(UIScrollView *)scrollView
{
    self.parentScrollView = scrollView;
    //离开顶部 主View 可以滑动
    self.parentScrollView.scrollEnabled = NO;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    //获取滚动视图y值的偏移量
    CGFloat tabOffsetY = [_mainTableView rectForSection:0].origin.y;
    CGFloat offsetY = scrollView.contentOffset.y;
    
    if (offsetY >= tabOffsetY) {
        scrollView.contentOffset = CGPointMake(0, tabOffsetY);
        self.parentScrollView.scrollEnabled = YES;
    }else{
    }
    
    
    /**
     * 处理头部视图
     */
    CGFloat yOffset  = scrollView.contentOffset.y;
    if(yOffset < - _headViewHeight) {
        CGRect f = self.headImageView.frame;
        f.origin.y = yOffset ;
        f.size.height =  -yOffset;
        f.origin.y = yOffset;
        
        //改变头部视图的fram
//        self.headImageView.frame = f;
//        CGRect avatarF = CGRectMake(f.size.width/2-40, (f.size.height-_headViewHeight)+56, 80, 80);
//        _avatarImage.frame = avatarF;
//        _countentLabel.frame = CGRectMake((f.size.width-Main_Screen_Width)/2+40, (f.size.height-_headViewHeight)+172, Main_Screen_Width-80, 36);
    }
}

#pragma mark --tableDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return kScreenHeight - YG_StatusAndNavightion_H;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    /* 添加pageView
     * 这里可以任意替换你喜欢的pageView
     *作者这里使用一款github较多人使用的 WMPageController 地址https://github.com/wangmchn/WMPageController
     */
    [cell.contentView addSubview:self.setPageViewControllers];
    return cell;
}


#pragma mark -- setter/getter

-(UIView *)setPageViewControllers
{
    WMPageController *pageController = [self p_defaultController];
    pageController.title = @"Line";
    pageController.menuViewStyle = WMMenuViewStyleLine;
    pageController.titleSizeSelected = 15;
    pageController.progressHeight = 1;
    
    [self addChildViewController:pageController];
    [pageController didMoveToParentViewController:self];
    return pageController.view;
}

- (WMPageController *)p_defaultController {
    JstyleEarningListViewController *earningListVC = [JstyleEarningListViewController new];
    earningListVC.delegate = self;
    JstyleMyInvitedMembersViewController *myInvitedMembersVC = [JstyleMyInvitedMembersViewController new];
    myInvitedMembersVC.delegate = self;
    
    NSArray *viewControllers = @[earningListVC, myInvitedMembersVC];
    
    NSArray *titles = @[@"收益总榜", @"我邀请的会员"];
    WMPageController *pageVC = [[WMPageController alloc] initWithViewControllerClasses:viewControllers andTheirTitles:titles];
    [pageVC setViewFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - YG_StatusAndNavightion_H)];
    pageVC.delegate = self;
    pageVC.menuItemWidth = 100;
    pageVC.itemsMargins = @[@20, @80, @20];
    pageVC.menuHeight = 44;
    pageVC.postNotification = YES;
    pageVC.menuBGColor = kWhiteColor;
    pageVC.titleColorNormal = kDarkNineColor;
    pageVC.titleColorSelected = kDarkTwoColor;
    pageVC.progressColor = JSColor(@"#B0A377");
    pageVC.itemsWidths = @[@70, @100];
    pageVC.bounces = NO;
    return pageVC;
}

- (void)pageController:(WMPageController *)pageController willEnterViewController:(__kindof UIViewController *)viewController withInfo:(NSDictionary *)info {
    NSLog(@"%@",viewController);
}

-(UIImageView *)headImageView
{
    if (_headImageView == nil)
    {
        _headImageView= [[UIImageView alloc]initWithFrame:CGRectMake(0, - _headViewHeight ,kScreenWidth, _headViewHeight)];
        _headImageView.image = JSImage(@"邀请好友背景");
        _headImageView.userInteractionEnabled = YES;
        _headImageView.backgroundColor = kSingleLineColor;
        
        _rulesBtn = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth - 90, 15, 80, 15)];
        [_headImageView addSubview:_rulesBtn];
        [_rulesBtn setTitle:@"奖励规则" forState:(UIControlStateNormal)];
        _rulesBtn.titleLabel.font = JSFont(12);
        [_rulesBtn setImage:JSImage(@"奖励规则白色箭头") forState:(UIControlStateNormal)];
        [_rulesBtn setTitleColor:JSColor(@"#FFFFFF") forState:(UIControlStateNormal)];
        [_rulesBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 70, 0, 0)];
        [_rulesBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 8)];
        [_rulesBtn addTarget:self action:@selector(rulesBtnClicked:) forControlEvents:(UIControlEventTouchUpInside)];
        
        _invitationBtn = [[UIButton alloc] initWithFrame:CGRectMake(15, _headViewHeight - 55, kScreenWidth - 30, 40)];
        _invitationBtn.backgroundColor = JSColor(@"#E1D1AF");
        _invitationBtn.layer.cornerRadius = 20;
        _invitationBtn.layer.masksToBounds = YES;
        _invitationBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        _invitationBtn.titleLabel.font = JSFontWithWeight(17, UIFontWeightBold);
        [_invitationBtn setTitle:@"立即邀请" forState:(UIControlStateNormal)];
        [_invitationBtn setTitleColor:kDarkTwoColor forState:(UIControlStateNormal)];
         [_invitationBtn addTarget:self action:@selector(invitationBtnClicked:) forControlEvents:(UIControlEventTouchUpInside)];
        [_headImageView addSubview:_invitationBtn];
    }
    return _headImageView;
}


- (MainTouchTableTableView *)mainTableView
{
    if (_mainTableView == nil){
        _mainTableView = [[MainTouchTableTableView alloc]initWithFrame:CGRectMake(0, YG_StatusAndNavightion_H, kScreenWidth, kScreenHeight - YG_StatusAndNavightion_H)];
        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
        _mainTableView.showsVerticalScrollIndicator = NO;
        _mainTableView.contentInset = UIEdgeInsetsMake(_headViewHeight, 0, 0, 0);
        _mainTableView.backgroundColor = [UIColor clearColor];
//        _mainTableView.bounces = NO;
    }
    return _mainTableView;
}

- (void)rulesBtnClicked:(UIButton *)sender
{
    [_rewardRulesView removeFromSuperview];
    _rewardRulesView = [[JstyleRewardRulesView alloc] initWithFrame:self.view.bounds];
    _rewardRulesView.backgroundColor = [kDarkOneColor colorWithAlphaComponent:0.8];
    [self.view addSubview:_rewardRulesView];
}

- (void)invitationBtnClicked:(UIButton *)sender
{
    NSString *vip = [[NSUserDefaults standardUserDefaults] objectForKey:@"isbetauser"];
    if (vip.integerValue == 2) {
        [_notVipAlertView removeFromSuperview];
        _notVipAlertView = [[JstyleNotVipAlertView alloc] initWithFrame:self.view.bounds];
        _notVipAlertView.backgroundColor = [kDarkOneColor colorWithAlphaComponent:0.8];
        [self.view addSubview:_notVipAlertView];
        return;
    }
    [[JstyleToolManager sharedManager] shareActionWithShareTitle:self.shareTitle shareDesc:self.shareDesc shareImgUrl:self.shareImgUrl shareLinkUrl:self.shareUrl viewController:self];
}

/**分享数据*/
-(void)getShareData
{
    NSDictionary *parameters = @{@"uid":[[JstyleToolManager sharedManager] getUserId],
                                 @"type":@"12"};
    [[JstyleNewsNetworkManager shareManager] POSTURL:COMMON_SHARE_URL parameters:parameters success:^(id responseObject) {
        if ([responseObject[@"code"] integerValue] == 1) {
            self.shareUrl = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"ashareurl"]];
            self.shareTitle = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"title"]];
            self.shareImgUrl = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"poster"]];
            self.shareDesc = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"describes"]];
        }
        
    } failure:nil];
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
