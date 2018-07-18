//
//  ICityCultureListReuseTableViewController.m
//  iCity
//
//  Created by 王磊 on 2018/5/3.
//  Copyright © 2018年 LongYuan. All rights reserved.
//
// 更多文化活动----更多文化地图

#import "ICityCultureListReuseTableViewController.h"
#import "ICityCultureListReuseTableViewCell.h"
#import "ICityCultureReuseModel.h"
#import "JstylePartyDetailsViewController.h"//文化活动
#import "ICityCultureDetailViewController.h"//文化地图
#import "MoreListView.h"

static NSInteger page = 1;
static NSString * const ICityCultureListReuseTableViewCellID = @"ICityCultureListReuseTableViewCellID";

@interface ICityCultureListReuseTableViewController ()

@property (nonatomic, strong) NSArray *tagsArray;

@property (nonatomic, strong) NSMutableArray *dataArray;

/**tags*/
@property (nonatomic, strong) MoreListView * tagsView;

@end

@implementation ICityCultureListReuseTableViewController

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = (self.navigationTitle == nil ? @"" : self.navigationTitle);
    
    self.tableView.backgroundColor = kWhiteColor;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.estimatedSectionFooterHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    [self.tableView registerClass:[ICityCultureListReuseTableViewCell class] forCellReuseIdentifier:ICityCultureListReuseTableViewCellID];
    
    __weak typeof(self) weakSelf = self;
    self.tableView.mj_header = [JstyleRefreshGiftHeader headerWithRefreshingBlock:^{
        page = 1;
        [weakSelf.dataArray removeAllObjects];
        [weakSelf loadData];
        
    }];
    
    self.tableView.mj_footer = [JstyleRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        page++;
        [weakSelf loadData];
    }];
    
    [self.tableView.mj_header beginRefreshing];
    
    [self creatMytagsView];
}

- (void)creatMytagsView {
    self.tagsView = [[MoreListView alloc]initWithFrame:CGRectMake(0, YG_StatusAndNavightion_H, SCREEN_W, SCREEN_H)];
    self.tagsView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tagsView];
    [self loadMoretagsData];
}
-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    UIColor * textColor = ISNightMode?kDarkCCCColor:JSColor(@"#000000");
    
    NSDictionary *titleColor = @{ NSForegroundColorAttributeName:textColor,
                                                 NSFontAttributeName:[UIFont systemFontOfSize:18] };
    
    [self.navigationController.navigationBar setTitleTextAttributes:titleColor];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:kNightModeBackColor] forBarMetrics:(UIBarMetricsDefault)];
    [self addLeftBarButtonWithImage:ISNightMode?JSImage(@"返回白色"):JSImage(@"图文返回黑") action:@selector(leftItemClick)];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ICityCultureListReuseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ICityCultureListReuseTableViewCellID forIndexPath:indexPath];
    cell.model = self.dataArray[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return (112.0*kScale*(149.0/112.0) + 20);
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    if ([self.navigationTitle isEqualToString:@"文化活动"]) {
        JstylePartyDetailsViewController *partyVC = [JstylePartyDetailsViewController new];
        ICityCultureMorePopularActivitiesModel * model = self.dataArray[indexPath.row];
        partyVC.partyId = model.id;
        [self.navigationController pushViewController:partyVC animated:YES];
    }else{
        //更多  旅游景点 文化地图
        ICityCultureDetailViewController *cultureDetailVC = [ICityCultureDetailViewController new];
        cultureDetailVC.rid = [self.dataArray[indexPath.row] field_id];
        ICityCultureMoreMapModel * model = self.dataArray[indexPath.row];
        JstyleNewsArticleDetailModel * titleModel = [JstyleNewsArticleDetailModel new];
        titleModel.author_name = model.author_name;
        titleModel.poster = model.poster;
        titleModel.title = model.title;
        titleModel.author_did = model.author_did;
        titleModel.TOrFOriginal = model.TOrFOriginal;
        titleModel.author_img = model.author_img;
        titleModel.cname = model.cname;
        titleModel.ctime = model.ctime;
        titleModel.id = model.id;
        titleModel.isShowAuthor = model.isShowAuthor;
        titleModel.content = model.content;
        
        cultureDetailVC.titleModel = titleModel;
        
        [self.navigationController pushViewController:cultureDetailVC animated:YES];
    }
    
}

#pragma mark - 下载更多 类型 标签数据
- (void)loadMoretagsData {
    NSString * type = @"4";//4.文化活动类型; 5.文化地图类型；6.旅游景点类型
    if ([self.navigationTitle isEqualToString:@"文化活动"]) {
        type = @"4";
    } else if ([self.navigationTitle isEqualToString:@"文化地图"]) {
        type = @"5";
    } else {//旅游景点
        type = @"6";
    }
    
    JstyleNewsNetworkManager *manager = [JstyleNewsNetworkManager shareManager];
    NSDictionary * para = @{@"type":type};
    [manager GETURL:Culture_TV_Menu_URL parameters:para success:^(id responseObject) {
        
        if ([responseObject[@"code"] isEqualToString:@"1"]) {
            
            self.tagsArray = [NSArray modelArrayWithClass:[ICityLifeMenuModel class] json:responseObject[@"data"]];
            [self.tagsView setTagWithTagArray:self.tagsArray andSelectIndex:0];
            
        }else {
            
        }
        [self.tableView.mj_header endRefreshing];
    } failure:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
    }];
    
}
#pragma mark - 下载列表数据

- (void)loadData {
    
    JstyleNewsNetworkManager *manager = [JstyleNewsNetworkManager shareManager];
    
    NSDictionary *paramaters = @{
                                 @"page":[NSString stringWithFormat:@"%zd",page]
                                 };
    
    [manager GETURL:self.dataURL parameters:paramaters success:^(id responseObject) {
        
        NSLog(@"%@",self.dataURL);

        if ([responseObject[@"code"] isEqualToString:@"1"]) {
            
            NSArray *currentData;
            if ([self.navigationTitle isEqualToString:@"文化活动"]) {
                currentData = [NSArray modelArrayWithClass:[ICityCultureMorePopularActivitiesModel class] json:responseObject[@"data"]];
            } else {
                //文化地图 、旅游景点
                currentData = [NSArray modelArrayWithClass:[ICityCultureMoreMapModel class] json:responseObject[@"data"]];
            }
            
            [self.dataArray addObjectsFromArray:currentData];
            
            
            [self.tableView reloadData];
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
            
        } else {
            
            [self.tableView reloadData];
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }
        
    } failure:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
}

- (void)leftItemClick {
    [self.navigationController popViewControllerAnimated:YES];
}

-(UIStatusBarStyle)preferredStatusBarStyle {
    
    return ISNightMode?UIStatusBarStyleLightContent:UIStatusBarStyleDefault;
}


@end
