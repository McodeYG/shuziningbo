//
//  JstyleManagementAccountInfoViewController.m
//  Exquisite
//
//  Created by 数字宁波 on 2017/10/16.
//  Copyright © 2017年 Jstyle. All rights reserved.
//

#import "JstyleManagementAccountInfoViewController.h"
#import "JstyleManagementAccountInfoViewCell.h"
#import "JstyleManagementAccountImageViewCell.h"

#define kHeaderArray       @[@"媒体信息", @"运营者信息", @"企业信息"]
@interface JstyleManagementAccountInfoViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) JstyleNewsBaseTableView *tableView;
/**媒体数组*/
@property (nonatomic, strong) NSArray *mediaArray;
/**运营者数组*/
@property (nonatomic, strong) NSArray *operatorArray;
/**企业数组*/
@property (nonatomic, strong) NSArray *enterpriseArray;

@end

@implementation JstyleManagementAccountInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"iCity号";//管理我的
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self setUpViews];
    [self addReshAction];
    [self.tableView.mj_header beginRefreshing];
}

- (void)addReshAction
{
    __weak typeof(self)weakSelf = self;
    self.tableView.mj_header = [JstyleRefreshGiftHeader headerWithRefreshingBlock:^{
        [weakSelf getJstyleAccountInfoDataSource];
    }];
}

- (void)setUpViews
{
    _tableView = [[JstyleNewsBaseTableView alloc]initWithFrame:CGRectZero style:(UITableViewStyleGrouped)];
    _tableView.separatorInset = UIEdgeInsetsMake(0, 15, 0, 0);
    _tableView.delegate = self;
    _tableView.dataSource = self;
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    
    [_tableView registerNib:[UINib nibWithNibName:@"JstyleManagementAccountInfoViewCell" bundle:nil] forCellReuseIdentifier:@"JstyleManagementAccountInfoViewCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"JstyleManagementAccountImageViewCell" bundle:nil] forCellReuseIdentifier:@"JstyleManagementAccountImageViewCell"];
    
    [self.view addSubview:_tableView];
    _tableView.sd_layout
    .topEqualToView(self.view)
    .bottomSpaceToView(self.view, YG_SafeBottom_H)
    .leftEqualToView(self.view)
    .rightEqualToView(self.view);
}

#pragma mark -- tableView的代理方法

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] init];
    headerView.backgroundColor = ISNightMode?kDarkThreeColor:JSColor(@"#F3F4F6");
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, kScreenWidth - 40, 35)];
    nameLabel.text = kHeaderArray[section];
    nameLabel.textColor = ISNightMode?kDarkNineColor:kDarkFiveColor;
    nameLabel.font = [UIFont systemFontOfSize:12];
    [headerView addSubview:nameLabel];
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 35;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSString *name = @"";
    if (self.enterpriseArray.count) {
        JstyleManagementAccountInfoModel *model = self.enterpriseArray[0];
        name = model.detail;
    }
    if (name == nil || [name isEqualToString:@""]) return 2;
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return self.mediaArray.count;
            break;
        case 1:
            return self.operatorArray.count;
            break;
        case 2:
            return self.enterpriseArray.count;
            break;
        default:
            return 0;
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:{
            if (indexPath.row == 4) {
                static NSString *ID = @"JstyleManagementAccountImageViewCell";
                JstyleManagementAccountImageViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
                if (!cell) {
                    cell = [[JstyleManagementAccountImageViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
                }
                
                cell.model = self.mediaArray[indexPath.row];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                return cell;
            }else{
                static NSString *ID = @"JstyleManagementAccountInfoViewCell";
                JstyleManagementAccountInfoViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
                if (!cell) {
                    cell = [[JstyleManagementAccountInfoViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
                }
                
                cell.model = self.mediaArray[indexPath.row];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                return cell;
            }
        }
            break;
        case 1:{
            if (indexPath.row == 2) {
                static NSString *ID = @"JstyleManagementAccountImageViewCell";
                JstyleManagementAccountImageViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
                if (!cell) {
                    cell = [[JstyleManagementAccountImageViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
                }
                
                cell.model = self.operatorArray[indexPath.row];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                return cell;
            }else{
                static NSString *ID = @"JstyleManagementAccountInfoViewCell";
                JstyleManagementAccountInfoViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
                if (!cell) {
                    cell = [[JstyleManagementAccountInfoViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
                }
                
                cell.model = self.operatorArray[indexPath.row];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                return cell;
            }
        }
            break;
        case 2:{
            if (indexPath.row == 1) {
                static NSString *ID = @"JstyleManagementAccountImageViewCell";
                JstyleManagementAccountImageViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
                if (!cell) {
                    cell = [[JstyleManagementAccountImageViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
                }
                
                cell.model = self.enterpriseArray[indexPath.row];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                return cell;
            }else{
                static NSString *ID = @"JstyleManagementAccountInfoViewCell";
                JstyleManagementAccountInfoViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
                if (!cell) {
                    cell = [[JstyleManagementAccountInfoViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
                }
                
                cell.model = self.enterpriseArray[indexPath.row];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                return cell;
            }
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
        case 0:{
            if (indexPath.row == 4) return 76;
            return [self.tableView cellHeightForIndexPath:indexPath model:self.mediaArray[indexPath.row] keyPath:@"model" cellClass:[JstyleManagementAccountInfoViewCell class] contentViewWidth:kScreenWidth];
        }
            break;
        case 1:{
            if (indexPath.row == 2) return 76;
            return [self.tableView cellHeightForIndexPath:indexPath model:self.operatorArray[indexPath.row] keyPath:@"model" cellClass:[JstyleManagementAccountInfoViewCell class] contentViewWidth:kScreenWidth];
        }
            break;
        case 2:{
            if (indexPath.row == 1) return 76;
            return [self.tableView cellHeightForIndexPath:indexPath model:self.enterpriseArray[indexPath.row] keyPath:@"model" cellClass:[JstyleManagementAccountInfoViewCell class] contentViewWidth:kScreenWidth];
        }
            break;
        default:
            return 45;
            break;
    }
}

#pragma mark - 获取数据
- (void)getJstyleAccountInfoDataSource
{
    
    // 初始化Manager
    JstyleNewsNetworkManager *manager = [JstyleNewsNetworkManager shareManager];
    
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:[[JstyleToolManager sharedManager] getUniqueId],@"uniqueid", nil];
    
    [manager GET:MANAGER_ACCOUNT_INFO_URL parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dictionary = responseObject;
        
        if ([dictionary[@"code"] integerValue] == 1) {
            //媒体信息
            JstyleManagementAccountInfoModel *model1 = [JstyleManagementAccountInfoModel new];
            model1.name = @"媒体类型";
            model1.detail = dictionary[@"data"][@"type"];
            
            JstyleManagementAccountInfoModel *model2 = [JstyleManagementAccountInfoModel new];
            model2.name = @"媒体名称";
            model2.detail = dictionary[@"data"][@"pen_name"];
            
            JstyleManagementAccountInfoModel *model3 = [JstyleManagementAccountInfoModel new];
            model3.name = @"媒体领域";
            model3.detail = dictionary[@"data"][@"field_name"];
            
            JstyleManagementAccountInfoModel *model4 = [JstyleManagementAccountInfoModel new];
            model4.name = @"媒体简介";
            model4.detail = dictionary[@"data"][@"instruction"];
            
            JstyleManagementAccountInfoModel *model5 = [JstyleManagementAccountInfoModel new];
            model5.name = @"媒体头像";
            model5.detail = dictionary[@"data"][@"head_img"];
            
            self.mediaArray = @[model1, model2, model3, model4, model5];
    
            //运营者信息
            JstyleManagementAccountInfoModel *model6 = [JstyleManagementAccountInfoModel new];
            model6.name = @"姓名";
            model6.detail = dictionary[@"data"][@"operate_name"];
            
            JstyleManagementAccountInfoModel *model7 = [JstyleManagementAccountInfoModel new];
            model7.name = @"证件号";
            model7.detail = dictionary[@"data"][@"idcard"];
            
            JstyleManagementAccountInfoModel *model8 = [JstyleManagementAccountInfoModel new];
            model8.name = @"证件照";
            model8.detail = dictionary[@"data"][@"idphoto"];
            
            JstyleManagementAccountInfoModel *model9 = [JstyleManagementAccountInfoModel new];
            model9.name = @"联系电话";
            model9.detail = dictionary[@"data"][@"operate_phone"];
            
            JstyleManagementAccountInfoModel *model10 = [JstyleManagementAccountInfoModel new];
            model10.name = @"联系邮箱";
            model10.detail = dictionary[@"data"][@"operate_email"];
            
            JstyleManagementAccountInfoModel *model11 = [JstyleManagementAccountInfoModel new];
            model11.name = @"运营所在地";
            model11.detail = dictionary[@"data"][@"fullName"];
            
            self.operatorArray = @[model6, model7, model8, model9, model10, model11];
            
            //企业信息
            JstyleManagementAccountInfoModel *model12 = [JstyleManagementAccountInfoModel new];
            model12.name = @"企业名称";
            model12.detail = dictionary[@"data"][@"organization_name"];
            
            JstyleManagementAccountInfoModel *model13 = [JstyleManagementAccountInfoModel new];
            model13.name = @"组织机构代吗";
            model13.detail = dictionary[@"data"][@"organization_img"];
            
            self.enterpriseArray = @[model12, model13];
        }
        
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self.tableView.mj_header endRefreshing];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    [[SDImageCache sharedImageCache] clearMemory];
    [[YYWebImageManager sharedManager].cache.memoryCache removeAllObjects];
    
}

@end
