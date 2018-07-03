//
//  JstyleNewsJMAttentionMoreViewController.m
//  JstyleNews
//
//  Created by JingHongMuYun on 2018/4/2.
//  Copyright © 2018年 JstyleNews. All rights reserved.
//

#import "JstyleNewsJMAttentionMoreViewController.h"
#import "JstyleNewsJMAttentionLeftCateModel.h"
#import "SearchModel.h"
#import "JstyleNewsJMAttentionLeftTableView.h"
#import "JstyleNewsJMAttentionRightTableView.h"
#import "JstyleNewsJMAttentionSearchViewController.h"
#import "JstyleManagementAccoutStatusDaiShenHeViewController.h"
#import "JstyleManagementAccoutStatusViewController.h"
#import "JstyleManagementMyJstyleAccountViewController.h"
#import "JstyleAuthenticateAccountViewController.h"

@interface JstyleNewsJMAttentionMoreViewController ()<UITextFieldDelegate>

@property (nonatomic, strong) UITextField *searchTextField;

@property (nonatomic, strong) JstyleNewsJMAttentionLeftTableView *leftTableView;
@property (nonatomic, strong) JstyleNewsJMAttentionRightTableView *rightTableView;

@property (nonatomic, strong) NSMutableArray *leftArray;
@property (nonatomic, strong) NSMutableArray *rightArray;

@property (nonatomic, copy) NSString *field_id;

@end

@implementation JstyleNewsJMAttentionMoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"iCity号";//推荐关注、综合搜索更多媒体、新媒体《通用@"iCity号"》
    [self addRightBarButtonItemWithTitle:@"申请入驻" color:kLightBlueColor action:@selector(rightBarButtonAction)];
    [self addSearchBar];
    [self addTableViews];
    [self addReshAction];
    [self loadJstyleNewsLeftCateData];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.navigationController.navigationBar.translucent = NO;
    UIColor * textColor = ISNightMode?kDarkCCCColor:JSColor(@"#000000");
    
    NSDictionary *navbarTitleTextAttributes = @{ NSForegroundColorAttributeName:textColor,
                                                NSFontAttributeName:[UIFont systemFontOfSize:18] };
    
    [self.navigationController.navigationBar setTitleTextAttributes:navbarTitleTextAttributes];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:kNightModeBackColor] forBarMetrics:(UIBarMetricsDefault)];
    [self addLeftBarButtonWithImage:ISNightMode?JSImage(@"返回白色"):JSImage(@"图文返回黑") action:@selector(leftItemClick)];
    [self wr_setNavBarShadowImageHidden:YES];
    

}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];//kThemeeModeTitleColor
    NSDictionary *navbarTitleTextAttributes = @{NSForegroundColorAttributeName:kThemeeModeTitleColor,
                                                NSFontAttributeName:[UIFont systemFontOfSize:18]
                                                };
    [self.navigationController.navigationBar setTitleTextAttributes:navbarTitleTextAttributes];
    [self wr_setNavBarShadowImageHidden:NO];
   
}

- (void)addSearchBar
{
    _searchTextField = [[UITextField alloc] init];
    _searchTextField.backgroundColor = JSColor(@"F3F3F3");
    _searchTextField.layer.cornerRadius = 16;
    _searchTextField.layer.masksToBounds = YES;
    _searchTextField.font = JSFontWithWeight(13, UIFontWeightLight);
    _searchTextField.tintColor = kPinkColor;
    _searchTextField.attributedPlaceholder = [@"搜索iCity号" attributedColorStringWithTextColor:JSColor(@"#b6b6b6") font:JSFontWithWeight(13, UIFontWeightLight)];
    _searchTextField.leftView = [[UIView alloc] initWithFrame:CGRectMake(40, 0, _searchTextField.width - 40, 32)];
    _searchTextField.leftViewMode = UITextFieldViewModeAlways;
    _searchTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _searchTextField.returnKeyType = UIReturnKeySearch;
    _searchTextField.keyboardType = UIKeyboardTypeDefault;
    _searchTextField.delegate = self;
    [self.view addSubview:_searchTextField];
    _searchTextField.sd_layout
    .topSpaceToView(self.view, 15 )
    .leftSpaceToView(self.view, 15)
    .rightSpaceToView(self.view, 15)
    .heightIs(32);
    
    UIImageView *iconImageView = [[UIImageView alloc] init];
    iconImageView.contentMode = UIViewContentModeScaleAspectFit;
    iconImageView.image = JSImage(@"推荐-搜索放大镜_black");
    [_searchTextField addSubview:iconImageView];
    iconImageView.sd_layout
    .leftSpaceToView(_searchTextField, 15)
    .centerYEqualToView(_searchTextField)
    .widthIs(15)
    .heightIs(15);
}

- (void)addTableViews
{
    _leftTableView = [[JstyleNewsJMAttentionLeftTableView alloc] initWithFrame:CGRectMake(0, 60, 85, kScreenHeight - 60-YG_SafeBottom_H-YG_StatusAndNavightion_H)];
    __weak typeof(self)weakSelf = self;
    [_leftTableView setSelectedIndex:^(NSString *field_id) {
        weakSelf.field_id = field_id;
        page = 1;
        [weakSelf.rightArray removeAllObjects];
        [weakSelf loadJstyleNewsRightListData];
    }];
    [self.view addSubview:_leftTableView];
    
    _rightTableView = [[JstyleNewsJMAttentionRightTableView alloc] initWithFrame:CGRectMake(85, 60, kScreenWidth - 85, kScreenHeight - 60-YG_SafeBottom_H-YG_StatusAndNavightion_H)];
    [_rightTableView setScrollDidScrollBlock:^{
        [weakSelf.searchTextField resignFirstResponder];
    }];
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

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [_searchTextField resignFirstResponder];
    NSString *searchText = [_searchTextField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (searchText == nil || [searchText isEqualToString:@""]) {
        _searchTextField = nil;
        ZTShowAlertMessage(@"输入内容不能为空");
        return NO;
    }
    JstyleNewsJMAttentionSearchViewController *jstyleNewsJMAttentionSVC = [JstyleNewsJMAttentionSearchViewController new];
    jstyleNewsJMAttentionSVC.keyword = searchText;
    [self.navigationController pushViewController:jstyleNewsJMAttentionSVC animated:YES];
    return YES;
}
#pragma mark - 左侧数据
- (void)loadJstyleNewsLeftCateData
{
    [[JstyleNewsNetworkManager shareManager] GETURL:Read_Headmedia_URL parameters:@{@"field_type":@"1"} success:^(id responseObject) {
        if ([responseObject[@"code"] integerValue] == 1) {
            [self.leftArray addObjectsFromArray:[NSArray modelArrayWithClass:[JstyleNewsJMAttentionLeftCateModel class] json:responseObject[@"data"]]];
            [self reloadLeftTableView];
        }
    } failure:^(NSError *error) {
        
    }];
}
#pragma mark - 右侧数据
- (void)loadJstyleNewsRightListData
{
    NSDictionary *parameters = @{
                                 @"field_id":[NSString stringWithFormat:@"%@",self.field_id],
                                 @"uid":[JstyleToolManager sharedManager].getUserId,
                                 @"page":[NSString stringWithFormat:@"%ld",page],
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
        [self.rightArray addObjectsFromArray:[NSArray modelArrayWithClass:[SearchModel class] json:responseObject[@"data"]]];
        
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
    if (self.selectID) {
        _leftTableView.selectID = self.selectID;
    }
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [_leftTableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:(UITableViewScrollPositionNone)];
    if ([_leftTableView.delegate respondsToSelector:@selector(tableView:didSelectRowAtIndexPath:)]) {
        [_leftTableView.delegate tableView:_leftTableView didSelectRowAtIndexPath:indexPath];
    }
}

- (void)rightBarButtonAction
{
    if ([[JstyleToolManager sharedManager] isTourist]) {
        [[JstyleToolManager sharedManager] loginInViewController];
        return;
    }
    //判断是否注册过iCity号
    [self isRegisterJMAccount];
}

#pragma mark - 获取当前用户当前注册iCity号的状态
- (void)isRegisterJMAccount {
    
    JstyleNewsNetworkManager *manager = [JstyleNewsNetworkManager shareManager];
    
    NSDictionary *paramaters = @{@"uid":[[JstyleToolManager sharedManager] getUserId]};
    
    [manager GETURL:MANAGER_ISREGESTER_URL parameters:paramaters success:^(id responseObject) {
        NSDictionary *responseData = responseObject;
        
        if ([responseData[@"code"] integerValue] == 1) {
            
            NSDictionary *msg = responseData[@"data"];
            
            NSInteger type = [msg[@"status"] integerValue];
            [SVProgressHUD dismiss];
            
            switch (type) {
                case 0://待审核
                {
                    JstyleManagementAccoutStatusDaiShenHeViewController *jstyleManagementASVC = [JstyleManagementAccoutStatusDaiShenHeViewController new];
                    jstyleManagementASVC.statusString = @"您的账号正在审核，请耐心等待！";
                    [self.navigationController pushViewController:jstyleManagementASVC animated:YES];
                }
                    break;
                case 1://拒绝
                {
                    JstyleManagementAccoutStatusViewController *jstyleManagementASVC = [JstyleManagementAccoutStatusViewController new];
                    jstyleManagementASVC.statusString = msg[@"reason"];
                    [self.navigationController pushViewController:jstyleManagementASVC animated:YES];
                }
                    break;
                case 2://通过
                {
                    if ([msg[@"is_use"] integerValue] == 0) {//myg
                        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"您的账号已被禁用，请联系数字跃动，通过客服邮箱544758586@qq.com与我们联系。" message:nil preferredStyle:UIAlertControllerStyleAlert];
                        [alertController addAction:[UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                            
                        }]];
                        [self presentViewController:alertController animated:YES completion:nil];
                        
                    } else {
                        JstyleManagementMyJstyleAccountViewController *jstyleMMJAVC = [JstyleManagementMyJstyleAccountViewController new];
                        [self.navigationController pushViewController:jstyleMMJAVC animated:YES];
                    }
                }
                    break;
                case 3://未注册
                {
                    JstyleAuthenticateAccountViewController *authenticateAccountVC = [JstyleAuthenticateAccountViewController new];
                    [self.navigationController pushViewController:authenticateAccountVC animated:YES];
                }
                    break;
                default:
                    break;
            }
            
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
        [SVProgressHUD dismiss];
    }];
}

- (void)addRightBarButtonItemWithTitle:(NSString *)itemTitle color:(UIColor *)color action:(SEL)action
{
    UIButton *rightbBarButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 80, 44)];
    [rightbBarButton setTitle:itemTitle forState:(UIControlStateNormal)];
    [rightbBarButton setTitleColor:color forState:(UIControlStateNormal)];
    rightbBarButton.titleLabel.font = [UIFont systemFontOfSize:13];
    [rightbBarButton addTarget:self action:action forControlEvents:(UIControlEventTouchUpInside)];
    rightbBarButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [rightbBarButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 5 * kScreenWidth/375.0)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightbBarButton];
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

- (void)leftItemClick {
    [self.navigationController popViewControllerAnimated:YES];
}

-(UIStatusBarStyle)preferredStatusBarStyle {
    
     return ISNightMode?UIStatusBarStyleLightContent:UIStatusBarStyleDefault;
}

@end
