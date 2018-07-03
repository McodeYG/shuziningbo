//
//  JstyleNewsMyCollectionViewController.m
//  JstyleNews
//
//  Created by 数字跃动 on 2017/10/25.
//  Copyright © 2017年 JstyleNews. All rights reserved.
//

#import "JstyleNewsMyCollectionViewController.h"
#import "JstyleNewsMyCollentionArticleTableViewController.h"
#import "JstyleNewsMyCollectionVideoTableViewController.h"

#define kTableViewY (kTopMargin + segmentViewHeight)

@interface JstyleNewsMyCollectionViewController ()

@property (nonatomic, strong) JstyleNewsMyCollentionArticleTableViewController *articleTableVC;
@property (nonatomic, strong) JstyleNewsMyCollectionVideoTableViewController *videoTableVC;

@property (nonatomic, weak) UIButton *articleBtn;
@property (nonatomic, weak) UIButton *vedioBtn;

@end

static CGFloat segmentViewHeight = 40;

@implementation JstyleNewsMyCollectionViewController

- (JstyleNewsMyCollentionArticleTableViewController *)articleTableVC {
    if (_articleTableVC == nil) {
        _articleTableVC = [[JstyleNewsMyCollentionArticleTableViewController alloc] initWithStyle:UITableViewStylePlain];
        _articleTableVC.view.frame = CGRectMake(0, kTableViewY, kScreenWidth, kScreenHeight - kTableViewY);
    }
    return _articleTableVC;
}

- (JstyleNewsMyCollectionVideoTableViewController *)videoTableVC {
    if (_videoTableVC == nil) {
        _videoTableVC = [[JstyleNewsMyCollectionVideoTableViewController alloc] initWithStyle:UITableViewStylePlain];
        CGFloat y = SYSTEM_VERSION_LESS_THAN(@"11.0") ? (kTableViewY + YG_StatusAndNavightion_H) : kTableViewY;
        _videoTableVC.tableView.frame = CGRectMake(0, y, kScreenWidth, kScreenHeight - y);
    }
    return _videoTableVC;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupTableViews];
    [self setupNavigationBar];
    [self setupSegmentView];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)setupNavigationBar {
    self.navigationItem.title = @"我的收藏";
}

- (void)setupTableViews {
    
    [self addChildViewController:self.articleTableVC];
    [self.articleTableVC didMoveToParentViewController:self];
    [self.view addSubview:self.articleTableVC.tableView];
    self.articleTableVC.tableView.hidden = NO;
    
    [self addChildViewController:self.videoTableVC];
    [self.videoTableVC didMoveToParentViewController:self];
    [self.view addSubview:self.videoTableVC.tableView];
    self.videoTableVC.tableView.hidden = YES;
}

#pragma mark - SetupSegmentView
- (void)setupSegmentView {
    
    UIView *segmentView = [[UIView alloc] initWithFrame:CGRectMake(0, YG_StatusAndNavightion_H, kScreenWidth, segmentViewHeight)];
    segmentView.backgroundColor = ISNightMode?kDarkThreeColor:kWhiteColor;
    [self.view addSubview:segmentView];
    
    UIColor *normalColor = ISNightMode?kDarkFiveColor:[UIColor colorFromHex:0xB0AEBC];
    UIColor *selectedColor = ISNightMode?kDarkNineColor:kDarkZeroColor;
    
    UIButton *articleBtn = [UIButton buttonWithTitle:@"文章" normalTextColor:normalColor selectedTextColor:selectedColor titleFontSize:12 target:self action:@selector(articleBtnClick:)];
    self.articleBtn = articleBtn;
    articleBtn.titleLabel.font = [UIFont fontWithName:@"PingFang SC" size:15];
    [segmentView addSubview:articleBtn];
    [articleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.offset(0);
        make.width.offset(kScreenWidth/2 - 0.5);
    }];
    articleBtn.selected = YES;
    
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = [UIColor colorFromHex:0x69686D];
    [segmentView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(12);
        make.width.offset(1);
        make.center.offset(0);
    }];
    
    UIButton *vedioBtn = [UIButton buttonWithTitle:@"视频" normalTextColor:normalColor selectedTextColor:selectedColor titleFontSize:12 target:self action:@selector(vedioBtnClick:)];
    self.vedioBtn = vedioBtn;
    [segmentView addSubview:vedioBtn];
    [vedioBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.bottom.offset(0);
        make.width.offset(kScreenWidth/2 - 0.5);
    }];
    vedioBtn.selected = NO;
}

- (void)articleBtnClick:(UIButton *)button {
    
    self.articleBtn.selected = YES;
    self.vedioBtn.selected = NO;
    
    self.articleTableVC.tableView.hidden = NO;
    self.videoTableVC.tableView.hidden = YES;
    [self setupBtnFontSize];
}

- (void)vedioBtnClick:(UIButton *)button {
    
    self.articleBtn.selected = NO;
    self.vedioBtn.selected = YES;
    
    self.articleTableVC.tableView.hidden = YES;
    self.videoTableVC.tableView.hidden = NO;
    [self setupBtnFontSize];
}

- (void)setupBtnFontSize {
    if (self.articleBtn.isSelected) {
        self.articleBtn.titleLabel.font = [UIFont fontWithName:@"PingFang SC" size:15];
    } else {
        self.articleBtn.titleLabel.font = [UIFont fontWithName:@"PingFang SC" size:12];
    }
    if (self.vedioBtn.isSelected) {
        self.vedioBtn.titleLabel.font = [UIFont fontWithName:@"PingFang SC" size:15];
    } else {
        self.vedioBtn.titleLabel.font = [UIFont fontWithName:@"PingFang SC" size:12];
    }
}

-(UIStatusBarStyle)preferredStatusBarStyle {
    
    return ISNightMode?UIStatusBarStyleLightContent:UIStatusBarStyleDefault;
}

@end
