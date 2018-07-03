//
//  ICityReadingViewController.m
//  iCity
//
//  Created by 王磊 on 2018/4/22.
//  Copyright © 2018年 LongYuan. All rights reserved.
//

#import "ICityReadingViewController.h"
#import "ICityReadingChoicenessTableViewCell.h"
#import "ICityReadingTableViewHeaderView.h"
#import "ICityWeeklyReadTableViewCell.h"
//#import "ICityKnowledgeBaseTableViewCell.h"
#import "RepositoryCell.h"
#import "RepositoryDetailViewController.h"//知识库详情

#import "ICityWeeklyReadModel.h"
#import "JstyleNewsActivityWebViewController.h"
#import "ICityLifeBannerModel.h"
#import "JstylePictureTextViewController.h"
#import "JstyleNewsArticleDetailViewController.h"
#import "JstyleNewsVideoDetailViewController.h"
#import "ICityKnowledgeBaseModel.h"
#import "JstyleNewsJMAttentionMoreViewController.h"

static NSString *const ICityReadingChoicenessTableViewCellID = @"ICityReadingChoicenessTableViewCellID";
static NSString *const ICityWeeklyReadTableViewCellID = @"ICityWeeklyReadTableViewCellID";
//static NSString *const ICityKnowledgeBaseTableViewCellID = @"ICityKnowledgeBaseTableViewCellID";

@interface ICityReadingViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *readingChoicenessDataArray;//每日必读
@property (nonatomic, strong) NSArray *roomTopDataArray;//阅览室上边
@property (nonatomic, strong) NSArray *roomBottomDataArray;//阅览室下边

@property (nonatomic, strong) NSArray *knowledgeDataArray;//知识库

/**知识库数据数量*/
@property (nonatomic, assign) NSInteger cell_count;

@end

@implementation ICityReadingViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.translucent = NO;
    self.tableView.backgroundColor = kNightModeBackColor;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadData];
    
    [self setupUI];
}

- (void)setupUI {
    
    self.navigationItem.title = @"知识服务";

    [self setupTableView];
}

- (void)setupTableView {
    
    [self.view addSubview:self.tableView];
    __weak typeof(self) weakSelf = self;
    self.tableView.mj_header = [JstyleRefreshGiftHeader headerWithRefreshingBlock:^{
        [weakSelf loadData];
    }];
}

- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, SCREEN_H - TabbarHeight-YG_StatusAndNavightion_H) style:UITableViewStyleGrouped];//去掉分组悬停效果
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = kNightModeBackColor;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        [_tableView registerClass:[ICityReadingChoicenessTableViewCell class] forCellReuseIdentifier:ICityReadingChoicenessTableViewCellID];
        [_tableView registerClass:[ICityWeeklyReadTableViewCell class] forCellReuseIdentifier:ICityWeeklyReadTableViewCellID];
//        [_tableView registerClass:[ICityKnowledgeBaseTableViewCell class] forCellReuseIdentifier:ICityKnowledgeBaseTableViewCellID];
    }
    return _tableView;
}

#pragma mark - UITableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (indexPath.section) {
        case 0:
        {// -- 假轮播图
            ICityReadingChoicenessTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ICityReadingChoicenessTableViewCellID forIndexPath:indexPath];
            cell.readingChoicenessDataArray = self.readingChoicenessDataArray;
        
            __weak typeof(self) weakSelf = self;
            
            cell.readingBlock = ^(ICityLifeBannerModel *model) {
                
                switch ([model.banner_type integerValue]) {
                    case 1:{// -- 假轮播图
                        if ([model.isImageArticle integerValue] == 1) {
                            //图集
                            JstylePictureTextViewController *jstyleNewsPictureTVC = [JstylePictureTextViewController new];
                            jstyleNewsPictureTVC.rid = model.rid;
                            [weakSelf.navigationController pushViewController:jstyleNewsPictureTVC animated:YES];
                        }else{
                            //文章
                            JstyleNewsArticleDetailViewController *jstyleNewsArticleDVC = [JstyleNewsArticleDetailViewController new];
                            jstyleNewsArticleDVC.rid = model.rid;
                            JstyleNewsArticleDetailModel * titleModel = [JstyleNewsArticleDetailModel new];

                            titleModel.title = model.title;
                            titleModel.content = model.content;
                            titleModel.author_img = model.author_img;
                            titleModel.author_did = model.author_did;
                            titleModel.author_name = model.author_name;
                            //这个字段
                            titleModel.poster = model.article_poster;
                            
                            titleModel.ctime = model.ctime;
                            titleModel.cname = model.cname;
                            titleModel.isShowAuthor = model.isShowAuthor;
                            titleModel.TOrFOriginal = model.TOrFOriginal;
                            jstyleNewsArticleDVC.titleModel = titleModel;

//                            jstyleNewsArticleDVC.titleModel = (JstyleNewsArticleDetailModel *)model;
                            
                            [weakSelf.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
                            [weakSelf.navigationController pushViewController:jstyleNewsArticleDVC animated:YES];
                        }
                    }
                        
                        break;
                    case 2:{
                        //视频直播
                        JstyleNewsVideoDetailViewController *jstyleNewsVideoDVC = [JstyleNewsVideoDetailViewController new];
                        jstyleNewsVideoDVC.videoUrl = model.url_sd;
                        jstyleNewsVideoDVC.videoTitle = model.title;
                        jstyleNewsVideoDVC.vid = model.rid;
                        jstyleNewsVideoDVC.videoType = model.videoType;
                        [weakSelf.navigationController pushViewController:jstyleNewsVideoDVC animated:YES];
                    }
                        break;
                    case 3:{
                        //广告活动
                        JstyleNewsActivityWebViewController *jstyleNewsActivityWVC = [JstyleNewsActivityWebViewController new];
                        jstyleNewsActivityWVC.urlString = model.h5url;
                        jstyleNewsActivityWVC.isShare = model.isShare.integerValue;
                        [weakSelf.navigationController pushViewController:jstyleNewsActivityWVC animated:YES];
                    }
                        break;
                    default:
                        break;
                }
            };
            return cell;
        }
            break;
        case 1:
        {//阅览室cell
            ICityWeeklyReadTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ICityWeeklyReadTableViewCellID forIndexPath:indexPath];
            cell.topDataArray = self.roomTopDataArray;
            cell.bottomDataArray = self.roomBottomDataArray;
            __weak typeof(self) weakSelf = self;
            //阅览室上边
            
            cell.topReadCellBlock  = ^(NSIndexPath *indexPath) {
                JstyleNewsActivityWebViewController *webView = [[JstyleNewsActivityWebViewController alloc] init];
                webView.urlString = [weakSelf.roomTopDataArray[indexPath.item] h5_url];
                webView.navigationTitle = [weakSelf.roomTopDataArray[indexPath.item] bookname];
                webView.isShare = NO;
                [weakSelf.navigationController pushViewController:webView animated:YES];
            };//阅览室下边
            cell.bottomReadCellBlock  = ^(NSIndexPath *indexPath) {
                JstyleNewsActivityWebViewController *webView = [[JstyleNewsActivityWebViewController alloc] init];
                webView.urlString = [weakSelf.roomBottomDataArray[indexPath.item] h5_url];
                webView.navigationTitle = [weakSelf.roomBottomDataArray[indexPath.item] bookname];
                webView.isShare = NO;
                [weakSelf.navigationController pushViewController:webView animated:YES];
            };
            
            return cell;
        }
            break;
        case 2:
        {
            //新的知识库
            RepositoryCell * cell = [RepositoryCell initWithTableView:tableView];
            cell.collcetionCatagroyArray = self.knowledgeDataArray;
            kweakSelf
            [cell setRepositoryCellBlock:^(NSString *title, NSString *selectID) {
                
                RepositoryDetailViewController * vc = [[RepositoryDetailViewController alloc]init];
                vc.selectID = selectID;
                vc.field_type = @"2";
                vc.title = title;
                
                [weakSelf.navigationController pushViewController:vc animated:YES];
            }];
            
            [cell setRefreshCellHeightBlock:^(NSInteger cell_count) {
                if (weakSelf.cell_count != cell_count) {
                    weakSelf.cell_count = cell_count;
                    [weakSelf.tableView reloadSection:2 withRowAnimation:(UITableViewRowAnimationNone)];
                }
            }];
                        
            //旧的知识库
//            ICityKnowledgeBaseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ICityKnowledgeBaseTableViewCellID forIndexPath:indexPath];
//            cell.knowledgeDataArray = self.knowledgeDataArray;
//            __weak typeof(self) weakSelf = self;
//            cell.knowledgeSelectBlock = ^(NSString *selectID) {
//                JstyleNewsJMAttentionMoreViewController *attentionMoreVC = [JstyleNewsJMAttentionMoreViewController new];
//                attentionMoreVC.selectID = selectID;
//                [weakSelf.navigationController pushViewController:attentionMoreVC animated:YES];
//            };
            return cell;
        }
            break;
        default:
            return [[UITableViewCell alloc] init];
            break;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    switch (section) {
        case 0:
        {
            ICityReadingTableViewHeaderView *headerView = [[ICityReadingTableViewHeaderView alloc] initWithTitleName:@"每日必读" showMoreBtn:NO];
            
            return headerView;
        }
            break;
        case 1:
        {
            ICityReadingTableViewHeaderView *headerView = [[ICityReadingTableViewHeaderView alloc] initWithTitleName:@"阅览室" showMoreBtn:YES];
            
            __weak typeof(self) weakSelf = self;
            headerView.moreBtnBlock = ^{
                NSLog(@"更多阅览室");
                JstyleNewsActivityWebViewController *webView = [[JstyleNewsActivityWebViewController alloc] init];
                webView.urlString = @"http://dspc.dps.qikan.com/webapp";
                webView.isShare = NO;
                [weakSelf.navigationController pushViewController:webView animated:YES];
            };
            
            return headerView;
        }
            break;
        case 2:
        {
            ICityReadingTableViewHeaderView *headerView = [[ICityReadingTableViewHeaderView alloc] initWithTitleName:@"知识库" showMoreBtn:NO];
            
            __weak typeof(self) weakSelf = self;
            headerView.moreBtnBlock = ^{
                NSLog(@"更多知识库");
                JstyleNewsJMAttentionMoreViewController *personalVC = [JstyleNewsJMAttentionMoreViewController new];
                [weakSelf.navigationController pushViewController:personalVC animated:YES];
                
            };
            
            return headerView;
        }
            break;
        default:
            return nil;
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0:
            return (kScreenWidth - 40)*190.0/335.0+20;
            break;
        case 1:
            return (ReadImg_h+71)*2;
            break;
        case 2:
            if (_cell_count>0) {
                return 15+ _cell_count/3*100 * kScale + (IS_iPhoneX?20:0);
            }
            return 15+2*100 * kScale + (IS_iPhoneX?20:0);
            break;
        default:
            break;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView * footerView = [UIView new];
    footerView.backgroundColor = [UIColor clearColor];
    return footerView;
}


- (UIStatusBarStyle)preferredStatusBarStyle {
    return [ThemeTool isWhiteModel]?UIStatusBarStyleDefault:UIStatusBarStyleLightContent;
}

#pragma mark - LoadData

- (void)loadData {
    
    [self loadReadingChoicenessData];
    [self loadReadingRoomTopData];
    [self loadKnowledgeBaseData];
}

#pragma mark -- 每日必读轮播图
- (void)loadReadingChoicenessData {
    
    JstyleNewsNetworkManager *manager = [JstyleNewsNetworkManager shareManager];
    NSDictionary *paramaters = @{
                                 @"bcolumn":@"9"
                                 };
    
    [manager GETURL:BANNER_LIST_URL parameters:paramaters success:^(id responseObject) {
        
        if ([responseObject[@"code"] integerValue] == 1) {
            self.readingChoicenessDataArray = [NSArray modelArrayWithClass:[ICityLifeBannerModel class] json:responseObject[@"data"]];
        }
        [self.tableView reloadSection:0 withRowAnimation:UITableViewRowAnimationNone];
        [self.tableView.mj_header endRefreshing];
        
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
        [self.tableView.mj_header endRefreshing];
    }];
}
#pragma mark - 阅览室 数据加载  - 上
- (void)loadReadingRoomTopData {
    JstyleNewsNetworkManager *manager = [JstyleNewsNetworkManager shareManager];
    
    [manager GETURL:Read_ReadingRoom_URL parameters:nil success:^(id responseObject) {
        
        if ([responseObject[@"code"] integerValue] == 1) {
            self.roomTopDataArray = [NSArray modelArrayWithClass:[ICityWeeklyReadModel class] json:responseObject[@"data"][@"first"]];
            
            self.roomBottomDataArray =[NSArray modelArrayWithClass:[ICityWeeklyReadModel class] json:responseObject[@"data"][@"second"]];
        }
        [self.tableView reloadSection:1 withRowAnimation:UITableViewRowAnimationNone];
        [self.tableView.mj_header endRefreshing];
        
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
        [self.tableView.mj_header endRefreshing];
    }];
}

#pragma mark - 新知识库标题下载
- (void)loadKnowledgeBaseData {
    
    JstyleNewsNetworkManager *manager = [JstyleNewsNetworkManager shareManager];
    NSDictionary *paramaters = @{@"field_type":@"2",@"level":@"1" };
    [manager GETURL:Read_Headmedia_URL parameters:paramaters success:^(id responseObject) {

        if ([responseObject[@"code"] integerValue] == 1) {
            self.knowledgeDataArray = [NSArray modelArrayWithClass:[ICityKnowledgeBaseModel class] json:responseObject[@"data"]];
        }
        [self.tableView reloadSection:2 withRowAnimation:UITableViewRowAnimationNone];
        [self.tableView.mj_header endRefreshing];
        

    } failure:^(NSError *error) {
        NSLog(@"%@",error);
        [self.tableView.mj_header endRefreshing];
    }];
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
