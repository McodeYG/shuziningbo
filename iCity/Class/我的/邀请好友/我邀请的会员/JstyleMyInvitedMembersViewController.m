//
//  JstyleMyInvitedMembersViewController.m
//  Exquisite
//
//  Created by JingHongMuYun on 2018/3/6.
//  Copyright © 2018年 JstyleStar. All rights reserved.
//

#import "JstyleMyInvitedMembersViewController.h"
#import "JstyleMyInvitedMembersViewCell.h"

@interface JstyleMyInvitedMembersViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation JstyleMyInvitedMembersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kWhiteColor;
    [self setUpTableView];
    [self addRefreshAction];
    [self loadJstyleNewsInvitedMembersData];
}

-(void)setUpTableView
{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - YG_StatusAndNavightion_H - 44) style:(UITableViewStylePlain)];
    _tableView.backgroundColor = kWhiteColor;
    _tableView.separatorColor = kSingleLineColor;
    _tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [UIView new];
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    [_tableView registerNib:[UINib nibWithNibName:@"JstyleMyInvitedMembersViewCell" bundle:nil] forCellReuseIdentifier:@"JstyleMyInvitedMembersViewCell"];
    
    [self.view addSubview:_tableView];
}

static NSInteger page = 1;
- (void)addRefreshAction
{
    __block typeof(self)weakSelf = self;
    self.tableView.mj_footer = [JstyleRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        if (weakSelf.dataArray.count) {
           page ++;
        }
        [weakSelf loadJstyleNewsInvitedMembersData];
    }];
    self.tableView.mj_footer.automaticallyHidden = NO;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [self addHeaderViewWithLeftTitle:@"昵称" rightTitle:@"收入"];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 47;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"JstyleMyInvitedMembersViewCell";
    JstyleMyInvitedMembersViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[JstyleMyInvitedMembersViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    
    if (indexPath.row < self.dataArray.count) {
        cell.model = self.dataArray[indexPath.row];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 47;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

#pragma mark - 获取数据
- (void)loadJstyleNewsInvitedMembersData
{
    NSDictionary *parameters = @{@"uid":[[JstyleToolManager sharedManager] getUserId],
                                 @"page":[NSString stringWithFormat:@"%ld",page]};
    [[JstyleNewsNetworkManager shareManager] POSTURL:VIP_INVITE_MEMBERS_URL parameters:parameters success:^(id responseObject) {
        if ([responseObject[@"code"] integerValue] != 1) {
            if (self.dataArray.count) {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }else{
                [self.tableView.mj_footer endRefreshing];
            }
            return;
        }
        
        if (page == 1) {
            [self.dataArray removeAllObjects];
        }
        [self.dataArray addObjectsFromArray:[NSArray modelArrayWithClass:[JstyleMyInvitedMembersModel class] json:responseObject[@"data"]]];
        
        [self.tableView reloadData];
        [self.tableView.mj_footer endRefreshing];
    } failure:^(NSError *error) {
        [self.tableView.mj_footer endRefreshing];
    }];
}

- (UIView *)addHeaderViewWithLeftTitle:(NSString *)leftTitle rightTitle:(NSString *)rightTitle
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 47)];
    headerView.backgroundColor = [kWhiteColor colorWithAlphaComponent:0.9];
    
    UILabel *leftLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth/2.0, headerView.height)];
    leftLabel.text = leftTitle;
    leftLabel.textColor = kDarkThreeColor;
    leftLabel.textAlignment = NSTextAlignmentCenter;
    leftLabel.font = JSFontWithWeight(12, UIFontWeightRegular);
    [headerView addSubview:leftLabel];
    
    UILabel *rightLabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth/2.0, 0, kScreenWidth/2.0, headerView.height)];
    rightLabel.text = rightTitle;
    rightLabel.textColor = kDarkThreeColor;
    rightLabel.textAlignment = NSTextAlignmentCenter;
    rightLabel.font = JSFontWithWeight(12, UIFontWeightRegular);
    [headerView addSubview:rightLabel];
    
    UIView *lineView1 = [[UIView alloc] init];
    lineView1.backgroundColor = kSingleLineColor;
    [headerView addSubview:lineView1];
    lineView1.sd_layout
    .leftEqualToView(headerView)
    .rightEqualToView(headerView)
    .topEqualToView(headerView)
    .heightIs(0.5);
    
    UIView *lineView2 = [[UIView alloc] init];
    lineView2.backgroundColor = kSingleLineColor;
    [headerView addSubview:lineView2];
    lineView2.sd_layout
    .leftEqualToView(headerView)
    .rightEqualToView(headerView)
    .bottomEqualToView(headerView)
    .heightIs(0.5);
    
    return headerView;
}

- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
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
