//
//  JstyleNewsMyMessageViewController.m
//  JstyleNews
//
//  Created by 数字跃动 on 2017/10/25.
//  Copyright © 2017年 JstyleNews. All rights reserved.
//

#import "JstyleNewsMyMessageViewController.h"
#import "JstyleNewsMyMessageTableViewController.h"
#import "JstyleNewsMyNoticeTableViewController.h"

//#define kTableViewY (kTopMargin + segmentViewHeight)
#define kTableViewY (segmentViewHeight)

@interface JstyleNewsMyMessageViewController ()

@property (nonatomic, weak) UIButton *messageBtn;
@property (nonatomic, weak) UIButton *noticeBtn;

@property (nonatomic, strong) JstyleNewsMyMessageTableViewController *messageTableVC;
@property (nonatomic, strong) JstyleNewsMyNoticeTableViewController *noticeTableVC;

@end

static CGFloat segmentViewHeight = 40;

@implementation JstyleNewsMyMessageViewController

- (JstyleNewsMyMessageTableViewController *)messageTableVC {
    if (_messageTableVC == nil) {
        _messageTableVC = [JstyleNewsMyMessageTableViewController new];
        _messageTableVC.tableView.frame = CGRectMake(0, kTableViewY, kScreenWidth, kScreenHeight - kTableViewY);
    }
    return _messageTableVC;
}

- (JstyleNewsMyNoticeTableViewController *)noticeTableVC {
    if (_noticeTableVC == nil) {
        _noticeTableVC = [JstyleNewsMyNoticeTableViewController new];
        CGFloat y = SYSTEM_VERSION_LESS_THAN(@"11.0") ? (kTableViewY + YG_StatusAndNavightion_H) : kTableViewY;
        _noticeTableVC.tableView.frame = CGRectMake(0, y, kScreenWidth, kScreenHeight - y);
    }
    return _noticeTableVC;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupTableViews];
    [self setupNavigationBar];
    [self setupSegmentView];
    
    if (_isNeedToShowNotifications) {
        [self.noticeBtn sendActionsForControlEvents:UIControlEventTouchUpInside];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:kNightModeBackColor] forBarMetrics:(UIBarMetricsDefault)];
}

#pragma mark - SetupSegmentView
- (void)setupSegmentView {
    
    UIView *segmentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, segmentViewHeight)];
    segmentView.backgroundColor = ISNightMode?kDarkThreeColor:kWhiteColor;
    [self.view addSubview:segmentView];
    
    UIColor *normalColor = ISNightMode?kDarkFiveColor:[UIColor colorFromHex:0xB0AEBC];
    UIColor *selectedColor = ISNightMode?kDarkNineColor:kDarkZeroColor;
    
    UIButton *messageBtn = [UIButton buttonWithTitle:@"消息" normalTextColor:normalColor selectedTextColor:selectedColor titleFontSize:12 target:self action:@selector(messageBtnClick:)];
    self.messageBtn = messageBtn;
    messageBtn.titleLabel.font = [UIFont fontWithName:@"PingFang SC" size:15];
    [segmentView addSubview:messageBtn];
    [messageBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.offset(0);
        make.width.offset(kScreenWidth/2 - 0.5);
    }];
    messageBtn.selected = YES;
    
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = [UIColor colorFromHex:0x69686D];
    [segmentView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(12);
        make.width.offset(1);
        make.center.offset(0);
    }];
    
    UIButton *noticeBtn = [UIButton buttonWithTitle:@"通知" normalTextColor:normalColor selectedTextColor:selectedColor titleFontSize:12 target:self action:@selector(noticeBtnClick:)];
    self.noticeBtn = noticeBtn;
    [segmentView addSubview:noticeBtn];
    [noticeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.bottom.offset(0);
        make.width.offset(kScreenWidth/2 - 0.5);
    }];
    noticeBtn.selected = NO;
    
}

- (void)messageBtnClick:(UIButton *)button {
    self.messageBtn.selected = YES;
    self.noticeBtn.selected = NO;
    
    self.messageTableVC.tableView.hidden = NO;
    self.noticeTableVC.tableView.hidden = YES;
    [self setupBtnFontSize];
}

- (void)noticeBtnClick:(UIButton *)button {
    self.messageBtn.selected = NO;
    self.noticeBtn.selected = YES;
    
    self.messageTableVC.tableView.hidden = YES;
    self.noticeTableVC.tableView.hidden = NO;
    [self setupBtnFontSize];
}

- (void)setupBtnFontSize {
    if (self.messageBtn.isSelected) {
        self.messageBtn.titleLabel.font = [UIFont fontWithName:@"PingFang SC" size:15];
    } else {
        self.messageBtn.titleLabel.font = [UIFont fontWithName:@"PingFang SC" size:12];
    }
    if (self.noticeBtn.isSelected) {
        self.noticeBtn.titleLabel.font = [UIFont fontWithName:@"PingFang SC" size:15];
    } else {
        self.noticeBtn.titleLabel.font = [UIFont fontWithName:@"PingFang SC" size:12];
    }
}

- (void)setupNavigationBar {
    self.navigationItem.title = @"消息通知";
}

- (void)setupTableViews {
    
    [self addChildViewController:self.messageTableVC];
    [self.view addSubview:self.messageTableVC.tableView];
    [self.messageTableVC didMoveToParentViewController:self];
    
    [self addChildViewController:self.noticeTableVC];
    [self.view addSubview:self.noticeTableVC.tableView];
    [self.noticeTableVC didMoveToParentViewController:self];
    
    self.messageTableVC.tableView.hidden = NO;
    self.noticeTableVC.tableView.hidden = YES;
}

- (void)leftBarButtonItemClick {
    [self.navigationController popViewControllerAnimated:YES];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return ISNightMode?UIStatusBarStyleLightContent:UIStatusBarStyleDefault;
}

@end
