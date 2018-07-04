//
//  JStyleJiFenDetailViewController.m
//  Exquisite
//
//  Created by 数字跃动 on 2017/2/28.
//  Copyright © 2017年 Jstyle. All rights reserved.
//

#import "JStyleJiFenDetailViewController.h"
#import "JstyleJiFenDetailViewCell.h"
#import "JMMyJiFenModel.h"
#import "JstyleJiFenRulesViewController.h"
@interface JStyleJiFenDetailViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong)  UITableView *jifenTableView;

@property (nonatomic, strong) NSMutableArray *dataArray;

@end

static NSUInteger page = 1;

@implementation JStyleJiFenDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"积分明细";
    self.view.backgroundColor = kWhiteColor;
//    [self addRightBarButtonItemWithTitle:@"积分规则" action:@selector(rightBarButtonAction)];
    
    [self addJiFenTableView];
    [self addReshAction];
    [self.jifenTableView.mj_header beginRefreshing];
}

- (void)addJiFenTableView
{
    _jifenTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - YG_SafeBottom_H) style:(UITableViewStylePlain)];
    _jifenTableView.showsVerticalScrollIndicator = NO;
    _jifenTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _jifenTableView.backgroundColor = kWhiteColor;
    _jifenTableView.delegate = self;
    _jifenTableView.dataSource = self;
    _jifenTableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    
    [_jifenTableView registerNib:[UINib nibWithNibName:@"JstyleJiFenDetailViewCell" bundle:nil] forCellReuseIdentifier:@"JstyleJiFenDetailViewCell"];
    
    [self.view addSubview:_jifenTableView];
}

/**
 * 添加刷新操作
 */
- (void)addReshAction
{
    __weak typeof(self) weakSelf = self;

    self.jifenTableView.mj_header = [JstyleRefreshNormalHeader headerWithRefreshingBlock:^{
        page = 1;
        [weakSelf getJstyleJiFenDataSource];
    }];
    
    self.jifenTableView.mj_footer = [JstyleRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        page ++;
        [weakSelf getJstyleJiFenDataSource];
    }];
}

#pragma mark - Table view data source
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *ID = @"JstyleJiFenDetailViewCell";
    JstyleJiFenDetailViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[JstyleJiFenDetailViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    
    JMMyJiFenModel *model = self.dataArray[indexPath.row];
    [cell setViewWithModel:model];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 62;
}

/**获取积分的数据*/
- (void)getJstyleJiFenDataSource
{
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:[[JstyleToolManager sharedManager] getUserId],@"uid",[NSString stringWithFormat:@"%ld",(long)page],@"page", nil];
    
    JstyleNewsNetworkManager *manager = [JstyleNewsNetworkManager shareManager];
    
    [manager GETURL:MY_JIFEN_URL parameters:parameters success:^(id responseObject) {
        if ([responseObject[@"code"] integerValue] != 1){
            [self.jifenTableView.mj_header endRefreshing];
            [self.jifenTableView.mj_footer endRefreshing];
            return;
        }
        
        if (page == 1) {
            self.dataArray = nil;
        }
        
        for (NSDictionary *dict in responseObject[@"data"][@"desc"]) {
            JMMyJiFenModel *model = [JMMyJiFenModel new];
            [model setValuesForKeysWithDictionary:dict];
            [self.dataArray addObject:model];
        }
        [self.jifenTableView reloadData];
        [self.jifenTableView.mj_header endRefreshing];
        [self.jifenTableView.mj_footer endRefreshing];
    } failure:^(NSError *error) {
        [self.jifenTableView.mj_header endRefreshing];
        [self.jifenTableView.mj_footer endRefreshing];
    }];
}

- (void)rightBarButtonAction
{
    JstyleJiFenRulesViewController *jiFenRules = [JstyleJiFenRulesViewController new];
    [self.navigationController pushViewController:jiFenRules animated:YES];
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
    [[SDImageCache sharedImageCache] clearMemory];
    [[YYWebImageManager sharedManager].cache.memoryCache removeAllObjects];
    // Dispose of any resources that can be recreated.
}

@end
