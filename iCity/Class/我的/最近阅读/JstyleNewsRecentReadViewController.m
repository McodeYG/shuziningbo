//
//  JstyleNewsRecentReadViewController.m
//  JstyleNews
//
//  Created by 数字跃动 on 2017/12/5.
//  Copyright © 2017年 JstyleNews. All rights reserved.
//

#import "JstyleNewsRecentReadViewController.h"
#import "JstyleNewsRecentReadArticleTableViewController.h"
#import "JstyleNewsRecentReadVideoTableViewController.h"

#define kTableViewY (segmentViewHeight)

@interface JstyleNewsRecentReadViewController ()

@property (nonatomic, strong) JstyleNewsRecentReadArticleTableViewController *articleTableVC;
@property (nonatomic, strong) JstyleNewsRecentReadVideoTableViewController *videoTableVC;

@property (nonatomic, weak) UIButton *articleBtn;
@property (nonatomic, weak) UIButton *videoBtn;

@end

static CGFloat segmentViewHeight = 40;

@implementation JstyleNewsRecentReadViewController

- (JstyleNewsRecentReadArticleTableViewController *)articleTableVC {
    if (_articleTableVC == nil) {
        _articleTableVC = [JstyleNewsRecentReadArticleTableViewController new];
    }
    return _articleTableVC;
}

- (JstyleNewsRecentReadVideoTableViewController *)videoTableVC {
    if (_videoTableVC == nil) {
        _videoTableVC = [JstyleNewsRecentReadVideoTableViewController new];
    }
    return _videoTableVC;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"最近阅读";
    [self setupTableViews];
    [self setupSegmentView];
}

- (void)leftBarButtonItemClick {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setupTableViews {
    
    [self addChildViewController:self.articleTableVC];
    self.articleTableVC.tableView.frame = CGRectMake(0, kTableViewY, kScreenWidth, kScreenHeight - kTableViewY);
    [self.view addSubview:self.articleTableVC.tableView];
    [self.articleTableVC didMoveToParentViewController:self];
    self.articleTableVC.tableView.hidden = NO;
    
    [self addChildViewController:self.videoTableVC];
    CGFloat y = SYSTEM_VERSION_LESS_THAN(@"11.0") ? (kTableViewY + YG_StatusAndNavightion_H) : kTableViewY;
    self.videoTableVC.tableView.frame = CGRectMake(0, y, kScreenWidth, kScreenHeight - y);
    [self.view addSubview:self.videoTableVC.tableView];
    [self.videoTableVC didMoveToParentViewController:self];
    self.videoTableVC.tableView.hidden = YES;
}

#pragma mark - SetupSegmentView
- (void)setupSegmentView {
    
    UIView *segmentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, segmentViewHeight)];
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
    
    UIButton *videoBtn = [UIButton buttonWithTitle:@"视频" normalTextColor:normalColor selectedTextColor:selectedColor titleFontSize:12 target:self action:@selector(videoBtnClick:)];
    self.videoBtn = videoBtn;
    [segmentView addSubview:videoBtn];
    [videoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.bottom.offset(0);
        make.width.offset(kScreenWidth/2 - 0.5);
    }];
    videoBtn.selected = NO;
}

- (void)articleBtnClick:(UIButton *)button {
    
    self.articleBtn.selected = YES;
    self.videoBtn.selected = NO;
    
    self.articleTableVC.tableView.hidden = NO;
    self.videoTableVC.tableView.hidden = YES;
    [self setupBtnFontSize];
}

- (void)videoBtnClick:(UIButton *)button {
    
    self.articleBtn.selected = NO;
    self.videoBtn.selected = YES;
    
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
    if (self.videoBtn.isSelected) {
        self.videoBtn.titleLabel.font = [UIFont fontWithName:@"PingFang SC" size:15];
    } else {
        self.videoBtn.titleLabel.font = [UIFont fontWithName:@"PingFang SC" size:12];
    }
}




@end
