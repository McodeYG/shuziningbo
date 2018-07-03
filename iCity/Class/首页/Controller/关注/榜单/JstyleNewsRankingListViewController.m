//
//  JstyleNewsJMNumsRankingListViewController.m
//  JstyleNews
//
//  Created by JingHongMuYun on 2018/4/24.
//  Copyright © 2018年 JstyleNews. All rights reserved.
//

#import "JstyleNewsRankingListViewController.h"
#import "JstyleNewsRankingListLeftTableView.h"
#import "JstyleNewsRankingListRightTableView.h"
#import "JstyleNewsJMAttentionLeftCateModel.h"
#import "JstyleNewsRankingListAlertView.h"

@interface JstyleNewsRankingListViewController ()

@property (nonatomic, strong) JstyleNewsRankingListLeftTableView *leftTableView;
@property (nonatomic, strong) JstyleNewsRankingListRightTableView *rightTableView;

@property (nonatomic, strong) NSMutableArray *leftArray;
@property (nonatomic, strong) NSMutableArray *rightArray;

@property (nonatomic, strong) UILabel *leftLabel;
@property (nonatomic, strong) UILabel *rightLabel;

@property (nonatomic, strong) JstyleNewsRankingListAlertView *alertView;

@property (nonatomic, copy) NSString *field_id;

@end

@implementation JstyleNewsRankingListViewController

- (void)dealloc
{
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"平台总排行榜";
    [self addHeaderViews];
    [self addTableViews];
    [self addReshAction];
    [self loadJstyleNewsLeftCateData];
}

- (void)addTableViews
{
    _leftTableView = [[JstyleNewsRankingListLeftTableView alloc] initWithFrame:CGRectMake(0, 62 + YG_StatusAndNavightion_H, 70, kScreenHeight - 62 - YG_StatusAndNavightion_H)];
    __weak typeof(self)weakSelf = self;
    [_leftTableView setSelectedIndex:^(NSString *field_id) {
        weakSelf.field_id = field_id;
        page = 1;
        [weakSelf.rightArray removeAllObjects];
        [weakSelf loadJstyleNewsRightListData];
    }];
    [self.view addSubview:_leftTableView];
    
    _rightTableView = [[JstyleNewsRankingListRightTableView alloc] initWithFrame:CGRectMake(70, 62 + YG_StatusAndNavightion_H, kScreenWidth - 70, kScreenHeight - 62 - YG_StatusAndNavightion_H)];
    [self.view addSubview:_rightTableView];
}

static NSInteger page = 1;
- (void)addReshAction
{
    __weak typeof(self)weakSelf = self;
    _rightTableView.mj_header = [JstyleRefreshGiftHeader headerWithRefreshingBlock:^{
        page = 1;
        [weakSelf loadJstyleNewsRightListData];
    }];
    
    _rightTableView.mj_footer = [JstyleRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        if (weakSelf.rightArray.count) {
            page ++;
        }
        [weakSelf loadJstyleNewsRightListData];
    }];
}

- (void)loadJstyleNewsLeftCateData
{
    [[JstyleNewsNetworkManager shareManager] GETURL:Read_Mediafield_URL parameters:nil success:^(id responseObject) {
        if ([responseObject[@"code"] integerValue] == 1) {
            [self.leftArray addObjectsFromArray:[NSArray modelArrayWithClass:[JstyleNewsJMAttentionLeftCateModel class] json:responseObject[@"data"]]];
            [self reloadLeftTableView];
        }
    } failure:^(NSError *error) {
        
    }];
}

- (void)loadJstyleNewsRightListData
{
    NSDictionary *parameters = @{@"field_id":[NSString stringWithFormat:@"%@",self.field_id],
                                 @"uid":[JstyleToolManager sharedManager].getUserId,
                                 @"page":[NSString stringWithFormat:@"%ld",page]
                                 };
    [[JstyleNewsNetworkManager shareManager] GETURL:JMNUM_RIGHT_CATE_URL parameters:parameters success:^(id responseObject) {
        if ([responseObject[@"code"] integerValue] != 1) {
            [self.rightTableView reloadDataWithDataArray:self.rightArray];
            [self.rightTableView.mj_header endRefreshing];
            [self.rightTableView.mj_footer endRefreshing];
            return;
        }
        
        if (page == 1) {
            [self.rightArray removeAllObjects];
        }
        //[self.rightArray addObjectsFromArray:[NSArray modelArrayWithClass:[SearchModel class] json:responseObject[@"data"]]];
        
        [self.rightTableView reloadDataWithDataArray:self.rightArray];
        [self.rightTableView.mj_header endRefreshing];
        [self.rightTableView.mj_footer endRefreshing];
    } failure:^(NSError *error) {
        [self.rightTableView reloadDataWithDataArray:self.rightArray];
        [self.rightTableView.mj_header endRefreshing];
        [self.rightTableView.mj_footer endRefreshing];
    }];
}

- (void)reloadLeftTableView
{
    [_leftTableView reloadDataWithDataArray:self.leftArray];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [_leftTableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:(UITableViewScrollPositionNone)];
    if ([_leftTableView.delegate respondsToSelector:@selector(tableView:didSelectRowAtIndexPath:)]) {
        [_leftTableView.delegate tableView:_leftTableView didSelectRowAtIndexPath:indexPath];
    }
}

- (void)addHeaderViews
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, YG_StatusAndNavightion_H, kScreenWidth, 62)];
    headerView.backgroundColor = kWhiteColor;
    [self.view addSubview:headerView];
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = kSingleLineColor;
    [headerView addSubview:lineView];
    lineView.sd_layout
    .centerXEqualToView(headerView)
    .topSpaceToView(headerView, 22)
    .bottomSpaceToView(headerView, 22)
    .widthIs(0.5);
    
    UIButton *leftBtn = [[UIButton alloc] init];
    leftBtn.backgroundColor = kWhiteColor;
    [leftBtn addTarget:self action:@selector(leftBtnClicked:) forControlEvents:(UIControlEventTouchUpInside)];
    [headerView addSubview:leftBtn];
    leftBtn.sd_layout
    .leftSpaceToView(headerView, 0)
    .rightSpaceToView(lineView, 0)
    .topSpaceToView(headerView, 0)
    .bottomSpaceToView(headerView, 0);
    
    UIButton *rightBtn = [[UIButton alloc] init];
    rightBtn.backgroundColor = kWhiteColor;
    [rightBtn addTarget:self action:@selector(rightBtnClicked:) forControlEvents:(UIControlEventTouchUpInside)];
    [headerView addSubview:rightBtn];
    rightBtn.sd_layout
    .leftSpaceToView(lineView, 0)
    .rightSpaceToView(headerView, 0)
    .topSpaceToView(headerView, 0)
    .bottomSpaceToView(headerView, 0);
    
    _leftLabel = [[UILabel alloc] init];
    _leftLabel.text = @"月度榜单";
    _leftLabel.font = JSFont(15);
    _leftLabel.textColor = kDarkNineColor;
    _leftLabel.textAlignment = NSTextAlignmentCenter;
    [leftBtn addSubview:_leftLabel];
    _leftLabel.sd_layout
    .topSpaceToView(leftBtn, 0)
    .bottomSpaceToView(leftBtn, 0)
    .centerXEqualToView(leftBtn);
    [_leftLabel setSingleLineAutoResizeWithMaxWidth:150];
    
    UIImageView *leftImageView1 = [[UIImageView alloc] init];
    leftImageView1.contentMode = UIViewContentModeScaleAspectFit;
    leftImageView1.image = JSImage(@"月度榜单");
    [leftBtn addSubview:leftImageView1];
    leftImageView1.sd_layout
    .rightSpaceToView(_leftLabel, 5)
    .centerYEqualToView(leftBtn)
    .widthIs(15)
    .heightIs(15);
    
    UIImageView *leftImageView2 = [[UIImageView alloc] init];
    leftImageView2.contentMode = UIViewContentModeScaleAspectFit;
    leftImageView2.image = JSImage(@"榜单向下");
    [leftBtn addSubview:leftImageView2];
    leftImageView2.sd_layout
    .leftSpaceToView(_leftLabel, 5)
    .centerYEqualToView(leftBtn)
    .widthIs(9)
    .heightIs(4.5);
    
    _rightLabel = [[UILabel alloc] init];
    _rightLabel.text = @"年度榜单";
    _rightLabel.font = JSFont(15);
    _rightLabel.textColor = kDarkNineColor;
    _rightLabel.textAlignment = NSTextAlignmentCenter;
    [rightBtn addSubview:_rightLabel];
    _rightLabel.sd_layout
    .topSpaceToView(rightBtn, 0)
    .bottomSpaceToView(rightBtn, 0)
    .centerXEqualToView(rightBtn);
    [_rightLabel setSingleLineAutoResizeWithMaxWidth:150];
    
    UIImageView *rightImageView1 = [[UIImageView alloc] init];
    rightImageView1.contentMode = UIViewContentModeScaleAspectFit;
    rightImageView1.image = JSImage(@"年度榜单");
    [rightBtn addSubview:rightImageView1];
    rightImageView1.sd_layout
    .rightSpaceToView(_rightLabel, 5)
    .centerYEqualToView(rightBtn)
    .widthIs(15)
    .heightIs(15);
    
    UIImageView *rightImageView2 = [[UIImageView alloc] init];
    rightImageView2.contentMode = UIViewContentModeScaleAspectFit;
    rightImageView2.image = JSImage(@"榜单向下");
    [rightBtn addSubview:rightImageView2];
    rightImageView2.sd_layout
    .leftSpaceToView(_rightLabel, 5)
    .centerYEqualToView(rightBtn)
    .widthIs(9)
    .heightIs(4.5);
}

- (void)leftBtnClicked:(UIButton *)sender
{
    _rightLabel.text = @"年度榜单";
    [_alertView removeFromSuperview];
    _alertView = [[JstyleNewsRankingListAlertView alloc] initWithFrame:[UIApplication sharedApplication].keyWindow.bounds dataArray:@[@"2018年1月", @"2018年2月", @"2018年3月"]];
    _alertView.backgroundColor = [kDarkZeroColor colorWithAlphaComponent:0.6];
    __weak typeof(self)weakSelf = self;
    _alertView.chooseBlock = ^(NSString *chooseStr) {
        weakSelf.leftLabel.text = chooseStr;
    };
    [[UIApplication sharedApplication].keyWindow addSubview:_alertView];
}

- (void)rightBtnClicked:(UIButton *)sender
{
    _leftLabel.text = @"月度榜单";
    [_alertView removeFromSuperview];
    _alertView = [[JstyleNewsRankingListAlertView alloc] initWithFrame:[UIApplication sharedApplication].keyWindow.bounds dataArray:@[@"2016年", @"2017年", @"2018年"]];
    _alertView.backgroundColor = [kDarkZeroColor colorWithAlphaComponent:0.6];
    __weak typeof(self)weakSelf = self;
    _alertView.chooseBlock = ^(NSString *chooseStr) {
        weakSelf.rightLabel.text = chooseStr;
    };
    [[UIApplication sharedApplication].keyWindow addSubview:_alertView];
}

- (NSMutableArray *)leftArray
{
    if (!_leftArray) {
        _leftArray = [NSMutableArray array];
    }
    return _leftArray;
}

- (NSMutableArray *)rightArray
{
    if (!_rightArray) {
        _rightArray = [NSMutableArray array];
    }
    return _rightArray;
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
