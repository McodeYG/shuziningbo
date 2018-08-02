//
//  ICityCultureViewController.m
//  iCity
//
//  Created by 王磊 on 2018/4/22.
//  Copyright © 2018年 LongYuan. All rights reserved.
//

#import "ICityCultureViewController.h"
#import "ICityReadingTableViewHeaderView.h"
#import "ICityCultureMenuHeaderView.h"
#import "JstyleNewsActivityWebViewController.h"
#import "ICityHotProgramTableViewCell.h"
//#import "ICityTVTableViewController.h"
#import "ICityTVMenuViewController.h"
#import "RepositoryDetailViewController.h"

#import "ICityBoardcastTableViewController.h"
#import "VierticalScrollView.h"
#import "ICityCallBoardTableViewCell.h"
#import "ICityCultureModel.h"
#import "ICityCitiesCultureTableViewCell.h"
#import "JstyleNewsJMAttentionMoreViewController.h"
#import "ICityKnowledgeBaseModel.h"
#import "ICityCultureReuseModel.h"
#import "ICityPopularActivitiesTableViewCell.h"
#import "ICityCultureMapTableViewCell.h"
#import "ICityTouristAttractionsTableViewCell.h"
//#import "ICityCultureListReuseTableViewController.h"
#import "CultureListReuseController.h"//列表页

#import "ICityCultureDetailViewController.h"
#import "ICityHotProgramModel.h"
#import "JstyleNewsVideoDetailViewController.h"
#import "JstylePartyDetailsViewController.h"
#import "JstyleNewsArticleDetailViewController.h"
//#import "NewspaperController.h"
#import "NewspaperMenuController.h"
#import "NewMediaController.h"


static NSString * const ICityHotProgramTableViewCellID = @"ICityHotProgramTableViewCellID";
static NSString * const ICityCallBoardTableViewCellID = @"ICityCallBoardTableViewCellID";
static NSString * const ICityCitiesCultureTableViewCellID = @"ICityCitiesCultureTableViewCellID";
static NSString * const ICityPopularActivitiesTableViewCellID = @"ICityPopularActivitiesTableViewCellID";
static NSString * const ICityCultureMapTableViewCellID = @"ICityCultureMapTableViewCellID";
static NSString * const ICityTouristAttractionsTableViewCellID = @"ICityTouristAttractionsTableViewCellID";


@interface ICityCultureViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, assign) VierticalScrollView *scroView;
/**直播预告的数组*/
@property (nonatomic, strong) NSMutableArray *trailerArray;
/**直播预告时间的数组*/
@property (nonatomic, strong) NSMutableArray *trailerTimeArray;
/**直播预告ID的数组*/
@property (nonatomic, strong) NSMutableArray *trailerIDArray;
/**直播是否已经点击预告*/
@property (nonatomic, strong) NSMutableArray *remandArray;
/**直播数据源数组*/
@property (nonatomic, strong) NSMutableArray *modelArray;

/**顶部四个按钮*/
@property (nonatomic, strong) ICityCultureMenuHeaderView *headerView;
//顶部四个按钮
@property (nonatomic, strong) NSArray *topFourArray;

@property (nonatomic, strong) NSArray *hotProgramArray;
@property (nonatomic, strong) NSArray *citiesCultureArray;
@property (nonatomic, strong) NSArray *popularActivitiesData;
@property (nonatomic, strong) NSArray *cultureMapArray;
@property (nonatomic, strong) NSArray *touristAttractionsArray;

@end

@implementation ICityCultureViewController

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, SCREEN_H - YG_StatusAndNavightion_H - TabbarHeight) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = kNightModeBackColor;
        _tableView.estimatedSectionHeaderHeight = 108;
        _tableView.estimatedSectionFooterHeight = 7;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        
        __weak typeof(self) weakSelf = self;
        _tableView.mj_header = [JstyleRefreshGiftHeader headerWithRefreshingBlock:^{
            [weakSelf loadData];
        }];
        [_tableView registerClass:[ICityHotProgramTableViewCell class] forCellReuseIdentifier:ICityHotProgramTableViewCellID];
        [_tableView registerClass:[ICityCallBoardTableViewCell class] forCellReuseIdentifier:ICityCallBoardTableViewCellID];
        [_tableView registerClass:[ICityCitiesCultureTableViewCell class] forCellReuseIdentifier:ICityCitiesCultureTableViewCellID];
        [_tableView registerClass:[ICityPopularActivitiesTableViewCell class] forCellReuseIdentifier:ICityPopularActivitiesTableViewCellID];
        [_tableView registerClass:[ICityCultureMapTableViewCell class] forCellReuseIdentifier:ICityCultureMapTableViewCellID];
        [_tableView registerClass:[ICityTouristAttractionsTableViewCell class] forCellReuseIdentifier:ICityTouristAttractionsTableViewCellID];
        
    }
    return _tableView;
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.translucent = NO;
    _tableView.backgroundColor = kNightModeBackColor;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self creatMyHeaderView];
    [self loadData];
    
    self.navigationItem.title = @"文化服务";
    [self.view addSubview:self.tableView];
}

#pragma mark - 创建顶部四个按钮视图
- (void) creatMyHeaderView{
    self.headerView = [[ICityCultureMenuHeaderView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 98 *kScreenWidth)];
    __weak typeof(self) weakSelf = self;
    self.headerView.menuButtonClickBlock = ^(NSString *title, NSString *html) {
        if ([title isEqualToString:@"电视"]) {
            //                    ICityTVTableViewController *TVVC = [[ICityTVTableViewController alloc] init];
            //                    [weakSelf.navigationController pushViewController:TVVC animated:YES];
            ICityTVMenuViewController * tvc = [[ICityTVMenuViewController alloc] init];
            [weakSelf.navigationController pushViewController:tvc animated:YES];
        } else if ([title isEqualToString:@"广播"]) {
            ICityBoardcastTableViewController *broadCastVC = [[ICityBoardcastTableViewController alloc] init];
            [weakSelf.navigationController pushViewController:broadCastVC animated:YES];
        } else if ([title isEqualToString:@"报纸"]){
            //                    NewspaperController *vc = [[NewspaperController alloc] init];
            NewspaperMenuController * vc = [[NewspaperMenuController alloc]init];
            [weakSelf.navigationController pushViewController:vc animated:YES];
        } else {//跳转新媒体
            
            //                    NewMediaController *VC = [[NewMediaController alloc] init];
            //                    [weakSelf.navigationController pushViewController:VC animated:YES];
            JstyleNewsJMAttentionMoreViewController *TVVC = [[JstyleNewsJMAttentionMoreViewController alloc] init];
            [weakSelf.navigationController pushViewController:TVVC animated:YES];
        }
    };
    
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (indexPath.section) {
        case 0://热门节目
        {
            ICityHotProgramTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ICityHotProgramTableViewCellID forIndexPath:indexPath];
            cell.hotProgramArray = self.hotProgramArray;
            __weak typeof(self) weakSelf = self;
            cell.hotProgramClickBlock = ^(NSString *vid, NSString *url) {
                JstyleNewsVideoDetailViewController *videoVC = [JstyleNewsVideoDetailViewController new];
                videoVC.vid = vid;
                videoVC.videoUrl = url;
//                videoVC.videoType = model.videoType;
                [weakSelf.navigationController pushViewController:videoVC animated:YES];
            };
            return cell;
        }
            break;
//        case 1://公告牌
//        {
//            ICityCallBoardTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ICityCallBoardTableViewCellID forIndexPath:indexPath];
//            if (self.trailerArray.count) {
//                [self.scroView removeFromSuperview];
//                VierticalScrollView *scroView = [VierticalScrollView initWithTitleArray:self.trailerArray times:self.trailerTimeArray isRemandArr:self.remandArray AndFrame:CGRectMake(0, 0, kScreenWidth - 110, cell.height)];
//                self.scroView = scroView;
//
//                __weak typeof(self) weakSelf = self;
//                scroView.yuGaoBlock = ^(NSInteger index) {
//
//                    NSString *string;
//                    if (weakSelf.trailerArray.count){
//                        string = weakSelf.trailerArray[0];
//                    }
//
//                    if (weakSelf.trailerArray.count && ![string containsString:@"暂无预告"]) {
//                        NSLog(@"点击公告 index = %zd",index);
//
//                        if (index <= weakSelf.modelArray.count&&index>0) {
//
//                            ICityCallBoardModel * model = weakSelf.modelArray[index-1];
//                            if ([model.type integerValue]==1) {//文章
//                                JstyleNewsArticleDetailViewController *articleVC = [JstyleNewsArticleDetailViewController new];
//                                articleVC.rid = model.rid;
//                                [self.navigationController pushViewController:articleVC animated:YES];
//                            } else if ([model.type integerValue]==2) {//视频
//                                JstyleNewsVideoDetailViewController *videoVC = [JstyleNewsVideoDetailViewController new];
//                                videoVC.vid = model.rid;
//                                videoVC.videoTitle = model.rtitle;
////                                videoVC.videoUrl = model.url_sd;
//                                [weakSelf.navigationController pushViewController:videoVC animated:YES];
//                            } else if ([model.type integerValue]==3) {//活动
//                                //跳聚会
//                                JstylePartyDetailsViewController *partyVC = [JstylePartyDetailsViewController new];
//                                partyVC.partyId = model.rid;
//                                [weakSelf.navigationController pushViewController:partyVC animated:YES];
//                            } else {
//                                NSLog(@"||model.type = %@",model.type);
//                            }
//
//                        }
//                    }
//                };
//                [cell.callBoardHoldView addSubview:scroView];
//            }
//            return cell;
//        }
//            break;
        case 1://城市百科Cell
        {
            ICityCitiesCultureTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ICityCitiesCultureTableViewCellID forIndexPath:indexPath];
            if (self.citiesCultureArray) {
                cell.citiesCultureDataArray = self.citiesCultureArray;
            }
            __weak typeof(self) weakSelf = self;
            cell.citiesCultureSelectBlock = ^(NSString *selectID, NSString *title) {
                if ([selectID isNotBlank]) {
                    RepositoryDetailViewController *vc = [RepositoryDetailViewController new];
                    vc.selectID = selectID;
                    vc.title = title;
                    vc.field_type = @"3";
                    [weakSelf.navigationController pushViewController:vc animated:YES];
                }
               
            };
            
            return cell;
        }
            break;
        case 2://文化活动
        {
            ICityPopularActivitiesTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ICityPopularActivitiesTableViewCellID forIndexPath:indexPath];
            cell.dataArray = self.popularActivitiesData;
            __weak typeof(self) weakSelf = self;
            cell.reuseSelectBlock = ^(NSString *selectID) {
                //文化活动 - 跳聚会
                JstylePartyDetailsViewController *partyVC = [JstylePartyDetailsViewController new];
                partyVC.partyId = selectID;
                [weakSelf.navigationController pushViewController:partyVC animated:YES];
            };
            return cell;
        }
            break;
        case 3://文化地图
        {
            ICityCultureMapTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ICityCultureMapTableViewCellID forIndexPath:indexPath];
            cell.dataArray = self.cultureMapArray;
            __weak typeof(self) weakSelf = self;
            cell.reuseSelectBlock = ^(NSString *selectID, ICityCultureModel *model) {
                ICityCultureDetailViewController *articleVC = [ICityCultureDetailViewController new];
                articleVC.rid = selectID;
                articleVC.titleModel = (JstyleNewsArticleDetailModel *)model;
                [weakSelf.navigationController pushViewController:articleVC animated:YES];
            };
            return cell;
        }
            break;
        case 4://旅游景点
        {
            ICityTouristAttractionsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ICityTouristAttractionsTableViewCellID forIndexPath:indexPath];
            cell.dataArray = self.touristAttractionsArray;
            __weak typeof(self) weakSelf = self;
            cell.reuseSelectBlock = ^(NSString *selectID, ICityCultureModel *model) {
                ICityCultureDetailViewController *articleVC = [ICityCultureDetailViewController new];
                articleVC.rid = selectID;
                articleVC.titleModel = (JstyleNewsArticleDetailModel *)model;
                [weakSelf.navigationController pushViewController:articleVC animated:YES];
            };
            return cell;
        }
            break;
        default:
            return [UITableViewCell new];
            break;
    }
    return [UITableViewCell new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
//    if (indexPath.section == 0) {
//        return 294;
//    } else if (indexPath.section == 1) {
//        return 67;//有公告时候
//    } else if (indexPath.section == 2) {
//        return 175;
//    } else {
//        return (((kScreenWidth - 10*4)/3.0)* 149.0 / 112.0 + 60);
//    }
    
    if (indexPath.section == 0) {
        return 280*kScale;
    } else if (indexPath.section == 1) {
        if (self.citiesCultureArray.count>3) {
            return 175*kScale;
        } else {
            return 105*kScale;
        };
        
    } else {
        return (((kScreenWidth - 10*4)/3.0)* 149.0 / 112.0 + 60);
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    switch (section) {
        case 0:
        {
            if (self.topFourArray.count>0) {
                return self.headerView;
            }else{
                UIView * headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 20)];
                headView.backgroundColor = [UIColor clearColor];
                return headView;
            }
        }
            break;
//        case 1:
//        {
//            return nil;
//        }
//            break;
        case 1:
        {
            ICityReadingTableViewHeaderView *headerView = [[ICityReadingTableViewHeaderView alloc] initWithTitleName:@"城市名片" showMoreBtn:NO];
            headerView.line.hidden = YES;
            __weak typeof(self) weakSelf = self;
            headerView.moreBtnBlock = ^{//
                JstyleNewsJMAttentionMoreViewController *attentionVC = [JstyleNewsJMAttentionMoreViewController new];
                [weakSelf.navigationController pushViewController:attentionVC animated:YES];
            };
            return headerView;
        }
            break;
        case 2:
        {
            ICityReadingTableViewHeaderView *headerView = [[ICityReadingTableViewHeaderView alloc] initWithTitleName:@"文化活动" showMoreBtn:YES];
            __weak typeof(self) weakSelf = self;
            headerView.moreBtnBlock = ^{//文化活动更多
                CultureListReuseController *vc = [CultureListReuseController new];
                vc.navigationTitle = @"文化活动";
                vc.dataURL = Culture_More_Activities_URL;
                [weakSelf.navigationController pushViewController:vc animated:YES];
            };
            return headerView;
        }
            break;
        case 3:
        {
            ICityReadingTableViewHeaderView *headerView = [[ICityReadingTableViewHeaderView alloc] initWithTitleName:@"文化地图" showMoreBtn:YES];//文化地图更多
            __weak typeof(self) weakSelf = self;
            headerView.moreBtnBlock = ^{
                CultureListReuseController *vc = [CultureListReuseController new];
                vc.navigationTitle = @"文化地图";
                vc.dataURL = [Read_Knowledge_URL stringByAppendingString:@"?tag=3"];
                [weakSelf.navigationController pushViewController:vc animated:YES];
            };
            return headerView;
        }
            break;
        case 4:
        {
            ICityReadingTableViewHeaderView *headerView = [[ICityReadingTableViewHeaderView alloc] initWithTitleName:@"旅游景点" showMoreBtn:YES];//旅游景点更多
            __weak typeof(self) weakSelf = self;
            headerView.moreBtnBlock = ^{
                CultureListReuseController *vc = [CultureListReuseController new];
                vc.navigationTitle = @"旅游景点";
                vc.dataURL = [Read_Knowledge_URL stringByAppendingString:@"?tag=4"];
                [weakSelf.navigationController pushViewController:vc animated:YES];
            };
            return headerView;
        }
            break;
        default:
            return nil;
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        if (self.topFourArray.count>0) {
            return 98+10;
        }else{
            return 20;
        }
    }else
        //if (section == 1) {
//        return 50;
//    } else
    {
        return 50;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
//    if (section == 0 || section == 1) {
//        return 8;
//    } else {
//        return 2;
//    }
    if (section==0) {
        return 0.01;
    }else  if (section==1) {
        return 0.1;
    }else{
        return 2;
    }
}

- (UIStatusBarStyle)preferredStatusBarStyle {

    return [ThemeTool isWhiteModel]?UIStatusBarStyleDefault:UIStatusBarStyleLightContent;
}

#pragma mark - 下载数据
- (void)loadData {
    [self loadTopIcon];
    [self loadHotProgramData];
    [self loadJstyleLiveHomeDataSource];
    [self loadCitiesCultureData];
    [self loadPopularActivitiesData];
    [self loadCultureMapData];
    [self loadTouristAttractionsData];
    
}
#pragma mark - 顶部四个按钮
- (void)loadTopIcon {

    JstyleNewsNetworkManager *manager = [JstyleNewsNetworkManager shareManager];
    NSDictionary * para = @{@"type":@"3"};
    //参数：type: 1.电视；2.报纸; 3.文化页四个icon；4.文化活动类型; 5.文化地图类型；6.旅游景点类型
    [manager GETURL:Culture_TV_Menu_URL parameters:para success:^(id responseObject) {
    
        if ([responseObject[@"code"] isEqualToString:@"1"]) {
            self.headerView.hidden = NO;
        }else {
            self.headerView.hidden = YES;
        }
        self.topFourArray = [NSArray modelArrayWithClass:[ICityLifeMenuModel class] json:responseObject[@"data"]];
        self.headerView.menuArray = self.topFourArray;
        [self.tableView reloadSection:0 withRowAnimation:UITableViewRowAnimationNone];
        [self.tableView.mj_header endRefreshing];
    } failure:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
    }];
}

///热门节目
- (void)loadHotProgramData {
    
    JstyleNewsNetworkManager *manager = [JstyleNewsNetworkManager shareManager];
    
    [manager GETURL:Culture_Hot_Program_URL parameters:nil success:^(id responseObject) {
        if ([responseObject[@"code"] isEqualToString:@"1"]) {
            self.hotProgramArray = [NSArray modelArrayWithClass:[ICityHotProgramModel class] json:responseObject[@"data"]];
            [self.tableView reloadSection:0 withRowAnimation:UITableViewRowAnimationNone];
        }
        [self.tableView.mj_header endRefreshing];
    } failure:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
    }];
}

///获取公告数据
- (void)loadJstyleLiveHomeDataSource {
    
//    JstyleNewsNetworkManager *manager = [JstyleNewsNetworkManager shareManager];
//
//    [manager GETURL:Culture_Callboard_URL parameters:nil success:^(id responseObject) {
//
//        if ([responseObject[@"code"] isEqualToString:@"1"]) {
//
//            self.trailerArray = nil;
//            self.trailerTimeArray = nil;
//            self.remandArray = nil;
//            self.trailerIDArray = nil;
//            [self.modelArray removeAllObjects];
//
//            /**预告直播Trailer内容数组*/
//            for (NSDictionary *trailerdict in responseObject[@"data"]) {
//                ICityCallBoardModel *model = [ICityCallBoardModel modelWithJSON:trailerdict];
//
//                [self.trailerArray addObject:model.rtitle];
//                [self.trailerTimeArray addObject:model.ctime];
//                [self.remandArray addObject:model.poster];
//                [self.trailerIDArray addObject:model.rid];
//
//
//                [self.modelArray addObject:model];
//            }
//        }
//
//        [self.tableView reloadSection:1 withRowAnimation:UITableViewRowAnimationNone];
//        [self.tableView.mj_header endRefreshing];
//
//    } failure:^(NSError *error) {
//        NSLog(@"%@",error);
//        [self.tableView.mj_header endRefreshing];
//    }];
}

#pragma mark -  获取城市百科
- (void)loadCitiesCultureData {
    JstyleNewsNetworkManager *manager = [JstyleNewsNetworkManager shareManager];
    NSDictionary *paramaters = @{
                                 @"field_type":@"3",
                                 @"level":@"2"
                                 };
    [manager GETURL:Read_Headmedia_URL parameters:paramaters success:^(id responseObject) {
        
        if ([responseObject[@"code"] integerValue] == 1) {
            self.citiesCultureArray = [NSArray modelArrayWithClass:[ICityKnowledgeBaseModel class] json:responseObject[@"data"]];
        }
//公告删了        [self.tableView reloadSection:2 withRowAnimation:UITableViewRowAnimationNone];
        [self.tableView reloadSection:1 withRowAnimation:UITableViewRowAnimationNone];

        [self.tableView.mj_header endRefreshing];
        
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
        [self.tableView.mj_header endRefreshing];
    }];
}

///获取文化活动数据
- (void)loadPopularActivitiesData {
    
    JstyleNewsNetworkManager *manager = [JstyleNewsNetworkManager shareManager];
    
    [manager GETURL:Culture_Popular_Activities_URL parameters:nil success:^(id responseObject) {
        
        if ([responseObject[@"code"] integerValue] == 1) {
            self.popularActivitiesData = [NSArray modelArrayWithClass:[ICityCultureReuseModel class] json:responseObject[@"data"][@"partylist"]];
        }
// 公告删了       [self.tableView reloadSection:3 withRowAnimation:UITableViewRowAnimationNone];
        [self.tableView reloadSection:2 withRowAnimation:UITableViewRowAnimationNone];
        [self.tableView.mj_header endRefreshing];
        
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
        [self.tableView.mj_header endRefreshing];
    }];
}

#pragma mark -  获取文化地图数据
- (void)loadCultureMapData {
    JstyleNewsNetworkManager *manager = [JstyleNewsNetworkManager shareManager];
    NSDictionary *paramaters = @{
                                 @"tag":@"3"
                                 };
    [manager GETURL:Read_Knowledge_URL parameters:paramaters success:^(id responseObject) {
        
        if ([responseObject[@"code"] integerValue] == 1) {
            self.cultureMapArray = [NSArray modelArrayWithClass:[ICityCultureReuseModel class] json:responseObject[@"data"]];
        }
        [self.tableView reloadSection:3 withRowAnimation:UITableViewRowAnimationNone];//公告删了
        [self.tableView.mj_header endRefreshing];
        
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
        [self.tableView.mj_header endRefreshing];
    }];
}

#pragma mark -  获取旅游景点数据
- (void)loadTouristAttractionsData {
    JstyleNewsNetworkManager *manager = [JstyleNewsNetworkManager shareManager];
    NSDictionary *paramaters = @{
                                 @"tag":@"4"
                                 };
    [manager GETURL:Read_Knowledge_URL parameters:paramaters success:^(id responseObject) {
        
        if ([responseObject[@"code"] integerValue] == 1) {
            self.touristAttractionsArray = [NSArray modelArrayWithClass:[ICityCultureReuseModel class] json:responseObject[@"data"]];
        }
        [self.tableView reloadSection:4 withRowAnimation:UITableViewRowAnimationNone];//公告删了
        [self.tableView.mj_header endRefreshing];
        
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
        [self.tableView.mj_header endRefreshing];
    }];
}


#pragma mark - LazyInit

- (NSMutableArray *)trailerArray {
    if (!_trailerArray) {
        _trailerArray = [NSMutableArray array];
    }
    return _trailerArray;
}

- (NSMutableArray *)trailerTimeArray {
    if (!_trailerTimeArray) {
        _trailerTimeArray = [NSMutableArray array];
    }
    return _trailerTimeArray;
}

- (NSMutableArray *)remandArray {
    if (!_remandArray) {
        _remandArray = [NSMutableArray array];
    }
    return _remandArray;
}

- (NSMutableArray *)trailerIDArray {
    if (!_trailerIDArray) {
        _trailerIDArray = [NSMutableArray array];
    }
    return _trailerIDArray;
}

- (NSMutableArray *)modelArray {
    if (!_modelArray) {
        _modelArray = [NSMutableArray array];
    }
    return _modelArray;
}


@end
