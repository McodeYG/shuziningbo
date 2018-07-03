//
//  JstyleEarningListViewController.m
//  Exquisite
//
//  Created by JingHongMuYun on 2018/3/6.
//  Copyright © 2018年 JstyleStar. All rights reserved.
//

#import "JstyleEarningListViewController.h"
#import "JstyleEarningListViewCell.h"

@interface JstyleEarningListViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation JstyleEarningListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kWhiteColor;
    [self setUpTableView];
    [self loadJstyleNewsEarningListData];
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
    [_tableView registerNib:[UINib nibWithNibName:@"JstyleEarningListViewCell" bundle:nil] forCellReuseIdentifier:@"JstyleEarningListViewCell"];
    
    [self.view addSubview:_tableView];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [self addHeaderView];
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
    static NSString *ID = @"JstyleEarningListViewCell";
    JstyleEarningListViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[JstyleEarningListViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
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
- (void)loadJstyleNewsEarningListData
{
    [[JstyleNewsNetworkManager shareManager] POSTURL:VIP_EARNING_LIST_URL parameters:nil success:^(id responseObject) {
        if ([responseObject[@"code"] integerValue] != 1) {
            return;
        }
        
        [self.dataArray removeAllObjects];
        [self.dataArray addObjectsFromArray:[NSArray modelArrayWithClass:[JstyleEarningListModel class] json:responseObject[@"data"]]];
        
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        
    }];
}

- (UIView *)addHeaderView
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 47)];
    headerView.backgroundColor = [kWhiteColor colorWithAlphaComponent:0.9];
    
    UILabel *firstLabel = [[UILabel alloc] init];
    firstLabel.text = @"排名";
    firstLabel.textColor = kDarkThreeColor;
    firstLabel.textAlignment = NSTextAlignmentCenter;
    firstLabel.font = JSFontWithWeight(12, UIFontWeightRegular);
    [headerView addSubview:firstLabel];
    firstLabel.sd_layout
    .leftSpaceToView(headerView, 15)
    .topEqualToView(headerView)
    .bottomEqualToView(headerView)
    .widthIs(25);
    
    UILabel *fourthLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth/2.0, headerView.height)];
    fourthLabel.text = @"总收入 (元)";
    fourthLabel.textColor = kDarkThreeColor;
    fourthLabel.textAlignment = NSTextAlignmentCenter;
    fourthLabel.font = JSFontWithWeight(12, UIFontWeightRegular);
    [headerView addSubview:fourthLabel];
    fourthLabel.sd_layout
    .rightSpaceToView(headerView, 10)
    .topEqualToView(headerView)
    .bottomEqualToView(headerView)
    .widthIs(80);
    
    UILabel *secondLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth/2.0, headerView.height)];
    secondLabel.text = @"用户昵称";
    secondLabel.textColor = kDarkThreeColor;
    secondLabel.textAlignment = NSTextAlignmentCenter;
    secondLabel.font = JSFontWithWeight(12, UIFontWeightRegular);
    [headerView addSubview:secondLabel];
    secondLabel.sd_layout
    .leftSpaceToView(firstLabel, 30)
    .topEqualToView(headerView)
    .bottomEqualToView(headerView)
    .widthIs((kScreenWidth - 190)/2.0);
    
    UILabel *thirdLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth/2.0, headerView.height)];
    thirdLabel.text = @"邀请人数";
    thirdLabel.textColor = kDarkThreeColor;
    thirdLabel.textAlignment = NSTextAlignmentCenter;
    thirdLabel.font = JSFontWithWeight(12, UIFontWeightRegular);
    [headerView addSubview:thirdLabel];
    thirdLabel.sd_layout
    .leftSpaceToView(secondLabel, 15)
    .rightSpaceToView(fourthLabel, 15)
    .topEqualToView(headerView)
    .bottomEqualToView(headerView);
    
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
