//
//  JstyleMyEarningsViewController.m
//  Exquisite
//
//  Created by JingHongMuYun on 2018/3/6.
//  Copyright © 2018年 JstyleStar. All rights reserved.
//

#import "JstyleMyEarningsViewController.h"
#import "JstyleMyEarningsHeaderViewCell.h"
#import "JstyleMyEarningsZhifubaoViewCell.h"
#import "JstyleMyEarningsServiceTermsCell.h"
#import "JstyleBillingDetailsViewController.h"
#import "JstyleMyEarningsBindMobileViewController.h"
#import "JstyleMyEarningsBindIDViewController.h"
#import "JstyleCashWithdrawalsViewController.h"

@interface JstyleMyEarningsViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, assign) BOOL isSelectedPay;

@property (nonatomic, copy) NSString *totalIncome;

@property (nonatomic, copy) NSString *cashIncome;

@property (nonatomic, copy) NSString *is_bind_phone;

@property (nonatomic, copy) NSString *is_bind_ID;

@end

@implementation JstyleMyEarningsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UILabel *titleLabel = [UILabel new];
    titleLabel.text = @"我的收益";
    titleLabel.textColor = kWhiteColor;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = JSFont(18);
    self.navigationItem.titleView = titleLabel;
    self.view.backgroundColor = kWhiteColor;
    [self addLeftBarButtonWithImage:JSImage(@"返回白色") action:@selector(leftBarButtonAction)];
    [self addRightBarButtonItemWithTitle:@"账单明细" action:@selector(rightBarButtonAction)];
    [self setUpTableView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:(UIBarMetricsDefault)];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    [self loadJstyleDetailData];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:(UIBarMetricsDefault)];
    [self.navigationController.navigationBar setShadowImage:nil];
}

-(void)setUpTableView
{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, - YG_StatusAndNavightion_H, kScreenWidth, kScreenHeight + YG_StatusAndNavightion_H) style:(UITableViewStyleGrouped)];
    _tableView.backgroundColor = JSColor(@"#F7F7F7");
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.bounces = NO;
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    [_tableView registerNib:[UINib nibWithNibName:@"JstyleMyEarningsHeaderViewCell" bundle:nil] forCellReuseIdentifier:@"JstyleMyEarningsHeaderViewCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"JstyleMyEarningsZhifubaoViewCell" bundle:nil] forCellReuseIdentifier:@"JstyleMyEarningsZhifubaoViewCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"JstyleMyEarningsServiceTermsCell" bundle:nil] forCellReuseIdentifier:@"JstyleMyEarningsServiceTermsCell"];
    
    [self.view addSubview:_tableView];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 15;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:{
            static NSString *ID = @"JstyleMyEarningsHeaderViewCell";
            JstyleMyEarningsHeaderViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
            if (!cell) {
                cell = [[JstyleMyEarningsHeaderViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
            }
            
            cell.totalIncomeLabel.text = self.totalIncome;
            cell.cashIncomeLabel.text = self.cashIncome;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
            break;
        case 1:{
            static NSString *ID = @"JstyleMyEarningsZhifubaoViewCell";
            JstyleMyEarningsZhifubaoViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
            if (!cell) {
                cell = [[JstyleMyEarningsZhifubaoViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
            }
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
            break;
        case 2:{
            static NSString *ID = @"JstyleMyEarningsServiceTermsCell";
            JstyleMyEarningsServiceTermsCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
            if (!cell) {
                cell = [[JstyleMyEarningsServiceTermsCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
            }
            
            __block typeof(self)weakSelf = self;
            cell.selectBlock = ^(BOOL selected) {
                weakSelf.isSelectedPay = selected;
            };
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
            return 180;
            break;
        case 1:
            return 60;
            break;
        case 2:return 40;
            break;
        default:
            return 0.01;
            break;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        if (self.isSelectedPay) {
            if ([self.cashIncome floatValue] >= 1.0) {
                if ([self.is_bind_ID integerValue] == 1) {
                    JstyleCashWithdrawalsViewController *jstyleCashWVC = [JstyleCashWithdrawalsViewController new];
                    [self.navigationController pushViewController:jstyleCashWVC animated:YES];
                }else if([self.is_bind_phone integerValue] == 1){
                    JstyleMyEarningsBindIDViewController *jstyleMyEarningBVC = [JstyleMyEarningsBindIDViewController new];
                    [self.navigationController pushViewController:jstyleMyEarningBVC animated:YES];
                }else{
                    JstyleMyEarningsBindMobileViewController *jstyleMyEarningBMVC = [JstyleMyEarningsBindMobileViewController new];
                    [self.navigationController pushViewController:jstyleMyEarningBMVC animated:YES];
                }
            }else{
                ZTShowAlertMessage(@"提现金额不足");
            }
        }else{
            ZTShowAlertMessage(@"请阅读并同意相关条款");
        }
    }
}

#pragma mark - 获取数据
- (void)loadJstyleDetailData
{
    NSDictionary *parameters = @{@"uid":[[JstyleToolManager sharedManager] getUserId]};
    [[JstyleNewsNetworkManager shareManager] POSTURL:VIP_IS_BINDED_URL parameters:parameters success:^(id responseObject) {
        if ([responseObject[@"code"] integerValue] != 1) {
            return;
        }
        self.totalIncome = [[responseObject objectForKey:@"data"] objectForKey:@"all_price"];
        self.cashIncome = [[responseObject objectForKey:@"data"] objectForKey:@"now_price"];
        self.is_bind_phone = [[responseObject objectForKey:@"data"] objectForKey:@"is_bind_phone"];
        self.is_bind_ID = [[responseObject objectForKey:@"data"] objectForKey:@"is_bind_info"];
        
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        
    }];
}

- (void)leftBarButtonAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)rightBarButtonAction
{
    JstyleBillingDetailsViewController *jstyleBillingDVC = [JstyleBillingDetailsViewController new];
    [self.navigationController pushViewController:jstyleBillingDVC animated:YES];
}

- (void)addRightBarButtonItemWithTitle:(NSString *)itemTitle action:(SEL)action
{
    
    UIButton *rightbBarButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 88, 44)];
    [rightbBarButton setTitle:itemTitle forState:(UIControlStateNormal)];
    [rightbBarButton setTitleColor:kWhiteColor forState:(UIControlStateNormal)];
    rightbBarButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [rightbBarButton addTarget:self action:action forControlEvents:(UIControlEventTouchUpInside)];
    rightbBarButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [rightbBarButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 5 * kScreenWidth/375.0)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightbBarButton];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
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


