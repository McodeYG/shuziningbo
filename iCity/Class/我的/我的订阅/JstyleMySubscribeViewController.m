//
//  JstyleMySubscribeViewController.m
//  Exquisite
//
//  Created by 数字宁波 on 2017/8/15.
//  Copyright © 2017年 Jstyle. All rights reserved.
//

#import "JstyleMySubscribeViewController.h"
#import "JstylePersonalMediaHorizontalViewCell.h"
#import "JstyleMySubscribeTableViewCell.h"
#import "JstyleNewsJMNumDetailsViewController.h"
#import "JstylePersonalMediaViewController.h"
#import "JstylePlaceholderView.h"
#import "JstyleNewsJMAttentionMoreViewController.h"

@interface JstyleMySubscribeViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) JstyleNewsBaseTableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, strong) UIView *placeholderView;

@end

static NSInteger page = 1;
static NSString *JstylePersonalMediaHorizontalViewCellID = @"JstylePersonalMediaHorizontalViewCellID";
static NSString *JstyleMySubscribeTableViewCellID = @"JstyleMySubscribeTableViewCellID";
@implementation JstyleMySubscribeViewController

- (void)placeholderViewClick {
    JstylePersonalMediaViewController *personalMediaVC = [JstylePersonalMediaViewController new];
    [self.navigationController pushViewController:personalMediaVC animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"我的关注";
    self.extendedLayoutIncludesOpaqueBars = YES;
    [self addTableView];
    [self addReshAction];
    [self getPersonalMediaListDataSource];
 
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self.tableView.mj_header beginRefreshing];
   
    UIColor * textColor = ISNightMode?kDarkCCCColor:JSColor(@"#000000");

    NSDictionary *navbarTitleTextAttributes = @{NSForegroundColorAttributeName:textColor,
                                                NSFontAttributeName:[UIFont systemFontOfSize:18]  };
    [self.navigationController.navigationBar setTitleTextAttributes:navbarTitleTextAttributes];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:kNightModeBackColor] forBarMetrics:UIBarMetricsDefault];
}

- (void)addTableView {
    
    _tableView = [[JstyleNewsBaseTableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - YG_SafeBottom_H) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    if (@available(iOS 11.0, *)) {
        _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        _tableView.contentInset = UIEdgeInsetsMake(YG_StatusAndNavightion_H, 0, 0, 0);
        _tableView.scrollIndicatorInsets = _tableView.contentInset;
    }
    [_tableView registerNib:[UINib nibWithNibName:@"JstylePersonalMediaHorizontalViewCell" bundle:nil] forCellReuseIdentifier:JstylePersonalMediaHorizontalViewCellID];
    [_tableView registerNib:[UINib nibWithNibName:@"JstyleMySubscribeTableViewCell" bundle:nil] forCellReuseIdentifier:JstyleMySubscribeTableViewCellID];
    
    [self.view addSubview:_tableView];
}

- (void)addReshAction
{
    __weak typeof(self) weakSelf = self;
    self.tableView.mj_header = [JstyleRefreshGiftHeader headerWithRefreshingBlock:^{
        page = 1;
        [weakSelf.dataArray removeAllObjects];
        [weakSelf getPersonalMediaListDataSource];
    }];
    
    self.tableView.mj_footer = [JstyleRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        page ++;
        [weakSelf getPersonalMediaListDataSource];
    }];
}
#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) return 1;
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        JstyleMySubscribeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:JstyleMySubscribeTableViewCellID forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    JstylePersonalMediaHorizontalViewCell *cell = [tableView dequeueReusableCellWithIdentifier:JstylePersonalMediaHorizontalViewCellID forIndexPath:indexPath];
    if (indexPath.row < self.dataArray.count) {
        cell.model = self.dataArray[indexPath.row];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        return 58;
    }
    return 95;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        JstyleNewsJMAttentionMoreViewController *jstyleNewsJMAMVC  = [JstyleNewsJMAttentionMoreViewController new];
        [self.navigationController pushViewController:jstyleNewsJMAMVC animated:YES];
    }else{
        JstylePersonalMediaListModel *model = self.dataArray[indexPath.row];
        JstyleNewsJMNumDetailsViewController *jstylePersonalMediaVC = [JstyleNewsJMNumDetailsViewController new];
        jstylePersonalMediaVC.did = model.did;
        [self.navigationController pushViewController:jstylePersonalMediaVC animated:YES];
    }
}

#pragma mark - 获取数据
- (void)getPersonalMediaListDataSource
{
    [self.placeholderView removeFromSuperview];
    self.placeholderView = nil;
    NSDictionary *parameters = @{@"platform_type":@"2",
                                 @"uid":[[JstyleToolManager sharedManager] getUserId],
                                 @"page":[NSString stringWithFormat:@"%ld",(long)page]
                                 };
    
    [[JstyleNewsNetworkManager shareManager] GETURL:PERSONAL_MY_MEDIA_DY_URL parameters:parameters progress:nil success:^(id responseObject) {
        
        [SVProgressHUD dismiss];
        
        if ([responseObject[@"code"] integerValue] != 1) {
            if (!self.dataArray.count) {
                if (self.placeholderView != nil) {
                    [self.tableView.mj_header endRefreshing];
                    [self.tableView.mj_footer endRefreshing];
                    return ;
                }
                
                //添加占位图
                [self addPlaceholder];
                [self.tableView.mj_header endRefreshing];
                [self.tableView.mj_footer endRefreshing];
            } else {
                [self.placeholderView removeFromSuperview];
                self.placeholderView = nil;
                if (page != 1) {
                    [self.tableView.mj_header endRefreshing];
                    [self.tableView.mj_footer endRefreshingWithNoMoreData];
                }else{
                    [self.tableView.mj_header endRefreshing];
                    [self.tableView.mj_footer endRefreshing];
                }
            }
            return ;
        }
        
        [self.dataArray addObjectsFromArray:[NSArray modelArrayWithClass:[JstylePersonalMediaListModel class] json:responseObject[@"data"]]];
      
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
        
        if (!self.dataArray.count) {
            if (self.placeholderView != nil) {
                return ;
            }
            //添加占位图
            [self addPlaceholder];
            [self.tableView.mj_footer endRefreshing];
            
        } else if (self.dataArray.count < 10) {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
            [self.placeholderView removeFromSuperview];
            self.placeholderView = nil;
        } else {
            [self.tableView.mj_footer endRefreshing];
            [self.placeholderView removeFromSuperview];
            self.placeholderView = nil;
        }
    } failure:^(NSError *error) {
        [self addPlaceholder];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        [SVProgressHUD dismiss];
    }];
}

- (void)addPlaceholder {
    _placeholderView = [[UIView alloc] initWithFrame:CGRectMake(0, 58, kScreenWidth, kScreenHeight-58)];
    _placeholderView.backgroundColor = ISNightMode?kNightModeBackColor:JSColor(@"#F9F9F9");
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"文章空白"]];
    [_placeholderView addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.offset(-100);
        make.centerX.offset(0);
    }];
    
    UILabel *placeholderLabel = [UILabel labelWithColor:ISNightMode?kDarkNineColor:kDarkSixColor fontSize:14 text:@"寻找我感兴趣的iCity号"];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(placeholderViewClick)];
    [placeholderLabel addGestureRecognizer:tap];
    placeholderLabel.userInteractionEnabled = YES;
    [placeholderLabel sizeToFit];
    [_placeholderView addSubview:placeholderLabel];
    [placeholderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.offset(0);
        make.top.equalTo(imageView.mas_bottom).offset(30);
    }];
    [self.tableView addSubview:_placeholderView];
}

- (void)tapAction{
    JstylePersonalMediaViewController *jstylePersonalMVC  = [JstylePersonalMediaViewController new];
    [self.navigationController pushViewController:jstylePersonalMVC animated:YES];
}

- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

-(UIStatusBarStyle)preferredStatusBarStyle {
    
    return ISNightMode?UIStatusBarStyleLightContent:UIStatusBarStyleDefault;
}

@end
