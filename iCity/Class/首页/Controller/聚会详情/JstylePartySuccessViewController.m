//
//  JstylePartySuccessViewController.m
//  Exquisite
//
//  Created by 赵涛 on 2017/7/7.
//  Copyright © 2017年 Jstyle. All rights reserved.
//

#import "JstylePartySuccessViewController.h"
#import "JstylePartySuccessViewFirstCell.h"
#import "JstylePartySuccessViewCell.h"
#import "JstylePartyHomeViewCell.h"
#import "JstylePartyDetailsViewController.h"
#import "ActionSheetView.h"

#define kImageArray         @[@"报名时间",@"报名位置",@"报名价格"]

@interface JstylePartySuccessViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSDictionary *partyDict;

@property (nonatomic, strong) NSMutableArray *inforArray;

@property (nonatomic, strong) NSMutableArray *partyArray;

@property (nonatomic, copy) NSString *shareImgUrl;
@property (nonatomic, copy) NSString *shareUrl;
@property (nonatomic, copy) NSString *describes;
@property (nonatomic, copy) NSString *shareName;

@end

@implementation JstylePartySuccessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = kBackGroundColor;
    self.extendedLayoutIncludesOpaqueBars = YES;
    self.title = @"报名成功";
    [self addLeftBarButtonWithImage:[UIImage imageNamed:@"return"] action:@selector(leftBarButtonAction)];
    [self addRightBarButtonWithFirstImage:[UIImage imageNamed:@"分享黑色"] action:@selector(rightBarButtonAction)];
    [self addTableView];
    [self addReshAction];
    [self.tableView.mj_header beginRefreshing];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
}

- (void)addTableView
{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) style:(UITableViewStyleGrouped)];
    _tableView.backgroundColor = kBackGroundColor;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    
    [_tableView registerNib:[UINib nibWithNibName:@"JstylePartySuccessViewCell" bundle:nil] forCellReuseIdentifier:@"JstylePartySuccessViewCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"JstylePartyHomeViewCell" bundle:nil] forCellReuseIdentifier:@"JstylePartyHomeViewCell"];
    
    [self.view addSubview:_tableView];
}

/**
 * 添加刷新操作
 */
static NSInteger page = 1;
- (void)addReshAction
{
    self.tableView.mj_header = [JstyleRefreshGiftHeader headerWithRefreshingBlock:^{
        page = 1;
        [self getPartyListDataSource];
    }];
    
    JstyleRefreshAutoNormalFooter *footer = [JstyleRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        page ++;
        [self getPartyListDataSource];
    }];
    self.tableView.mj_footer = footer;
}

#pragma mark -- tableView的代理方法

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return 1;
            break;
        case 1:
            return self.inforArray.count;
            break;
        case 2:
            return self.partyArray.count;
            break;
        default:
            return 0;
            break;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 2) {
        if (self.partyArray.count) {
            UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 35)];
            headerView.backgroundColor = kWhiteColor;
            UILabel *headerLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 15, kScreenWidth - 30, 20)];
            headerLabel.text = @"其他精彩活动";
            headerLabel.textColor = kDarkTwoColor;
            headerLabel.font = [UIFont systemFontOfSize:15];
            [headerView addSubview:headerLabel];
            return headerView;
        }else{
            return nil;
        }
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 2)
    if (self.partyArray.count) return 35;
    return 0.01;
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 1) return 10;
    return 0.01;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:{
            static NSString *ID = @"JstylePartySuccessViewFirstCell";
            JstylePartySuccessViewFirstCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
            if (!cell) {
                cell = [[JstylePartySuccessViewFirstCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
            }
            
            cell.nameLabel.attributedText = [self.partyDict[@"name"] attributedStringWithlineSpace:3 textColor:kDarkTwoColor font:[UIFont boldSystemFontOfSize:15]];
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
            break;
        case 1:{
            static NSString *ID = @"JstylePartySuccessViewCell";
            JstylePartySuccessViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
            if (!cell) {
                cell = [[JstylePartySuccessViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
            }
            
            cell.iconImageView.image = [UIImage imageNamed:kImageArray[indexPath.row]];
            cell.model = self.inforArray[indexPath.row];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
            break;
        case 2:{
            static NSString *ID = @"JstylePartyHomeViewCell";
            JstylePartyHomeViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
            if (!cell) {
                cell = [[JstylePartyHomeViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
            }
            
            cell.model = self.partyArray[indexPath.row];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
            break;
        default:
            return nil;
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
            if (self.partyDict[@"name"])
                return [self.partyDict[@"name"] getAttributedStringRectWithSpace:3 withFont:15 withWidth:kScreenWidth - 30].size.height + 30;
            return 0;
            break;
        case 1:{
            return [self.tableView cellHeightForIndexPath:indexPath model:self.inforArray[indexPath.row] keyPath:@"model" cellClass:[JstylePartySuccessViewCell class] contentViewWidth:kScreenWidth];
        }
            break;
        case 2:
            return 80/375.0*kScreenWidth + 70;
            break;
        default:
            return 0;
            break;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    JstylePartyHomeModel *model = self.partyArray[indexPath.row];
    JstylePartyDetailsViewController *jstylePartyDetailsVC = [JstylePartyDetailsViewController new];
    jstylePartyDetailsVC.partyId = model.ID;
    [self.navigationController pushViewController:jstylePartyDetailsVC animated:YES];
}

#pragma mark - 获取数据
- (void)getPartyListDataSource
{
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:[[JstyleToolManager sharedManager] getUserId],@"uid",self.partyId,@"id",[NSString stringWithFormat:@"%ld",(long)page],@"page", nil];
    JstyleNewsNetworkManager *manager = [JstyleNewsNetworkManager shareManager];;
    
    // post请求
    [manager GETURL:JSTYLE_SIGNUP_SUCCESS_URL parameters:parameters success:^(id responseObject) {
        if ([responseObject[@"code"] integerValue] != 1) {
            if (page != 1) {
                [self.tableView.mj_header endRefreshing];
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }else{
                [self.tableView.mj_header endRefreshing];
                [self.tableView.mj_footer endRefreshing];
            }
            return ;
        }
        
        if (page == 1) {
            self.partyArray = nil;
            [self.tableView.mj_footer resetNoMoreData];
        }
        self.partyDict = responseObject[@"data"];
        self.shareImgUrl = self.partyDict[@"image"];
        self.shareName = self.partyDict[@"name"];
        self.describes = self.partyDict[@"describes"];
        self.shareUrl = self.partyDict[@"shareurl"];
        //信息数组
        if (!self.inforArray.count) {
            JstylePartySuccessInfoModel *model1 = [JstylePartySuccessInfoModel new];
            model1.name = self.partyDict[@"start_time"];
            [self.inforArray addObject:model1];
            
            JstylePartySuccessInfoModel *model2 = [JstylePartySuccessInfoModel new];
            model2.name = self.partyDict[@"address"];
            [self.inforArray addObject:model2];
            
            JstylePartySuccessInfoModel *model3 = [JstylePartySuccessInfoModel new];
            model3.name = self.partyDict[@"sale_price"];
            model3.type = @"3";
            [self.inforArray addObject:model3];
        }
        /**聚会数组*/
        for (NSDictionary *dict in responseObject[@"data"][@"relparty"]) {
            JstylePartyHomeModel *model = [JstylePartyHomeModel new];
            [model setValuesForKeysWithDictionary:dict];
            [self.partyArray addObject:model];
        }
        
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    } failure:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
}

- (void)leftBarButtonAction
{
   [self.navigationController popViewControllerAnimated:YES];
}

- (void)rightBarButtonAction
{
    [[JstyleToolManager sharedManager] shareActionWithShareTitle:self.shareName shareDesc:self.describes shareImgUrl:self.shareImgUrl shareLinkUrl:self.shareUrl viewController:self];
}

- (int)getTotalCharacterFromString:(NSString*)string {
    int strlength = 0;
    
    char* p = (char*)[string cStringUsingEncoding:NSUnicodeStringEncoding];
    
    for (int i=0 ; i< [string lengthOfBytesUsingEncoding:NSUnicodeStringEncoding] ;i++) {
        
        if (*p) {
            p++;
            strlength++;
        }else {
            p++;
        }
    }
    return (strlength+1)/2;
}

- (NSMutableArray *)inforArray
{
    if (!_inforArray) {
        _inforArray = [NSMutableArray array];
    }
    return _inforArray;
}

- (NSMutableArray *)partyArray
{
    if (!_partyArray) {
        _partyArray = [NSMutableArray array];
    }
    return _partyArray;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    [[SDImageCache sharedImageCache] clearMemory];
    [[YYWebImageManager sharedManager].cache.memoryCache removeAllObjects];
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
