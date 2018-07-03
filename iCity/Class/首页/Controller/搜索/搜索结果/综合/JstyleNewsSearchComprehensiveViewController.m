//
//  JstyleNewsSearchComprehensiveViewController.m
//  JstyleNews
//
//  Created by JingHongMuYun on 2017/12/1.
//  Copyright © 2017年 JstyleNews. All rights reserved.
//

#import "JstyleNewsSearchComprehensiveViewController.h"
#import "JstyleNewsPlaceholderView.h"


#import "JstyleNewsSearchJmNumsViewCell.h"
#import "JstyleNewsJMNumDetailsViewController.h"
#import "JstyleNewsArticleDetailViewController.h"
#import "JstylePictureTextViewController.h"
#import "JstyleNewsVideoDetailViewController.h"
#import "JstyleNewsJMAttentionListModel.h"
//
#import "SearchImageArticleCell.h"
#import "SearchTextArticleCell.h"//一张图片的文章
#import "SearchVideoCell.h"//视频
#import "SearchAboutPersonCell.h"//相关人物
#import "BaiduEncyclopediaCell.h"//百度百科
#import "SearchAboutSearchCell.h"//相关搜索
#import "SearchPicturesCell.h"//图集
#import "SearchAllCityUserCell.h"//iCity号

#import "NSString+attributedString.h"

#import "JstyleNewsActivityWebViewController.h"
#import "JstyleNewsJMAttentionMoreViewController.h"


@interface JstyleNewsSearchComprehensiveViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) JstyleNewsBaseTableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataArray;//数据
@property (nonatomic, strong) NSMutableArray *iCtityArray;//icity号

@property (nonatomic, strong) JstyleNewsPlaceholderView *placeholderView;

@end

static NSInteger page = 1;
@implementation JstyleNewsSearchComprehensiveViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(attentionRefresh:) name:@"AttentionRefresh" object:nil];
   
    [self addTableView];
    [self addReshAction];
    [self.tableView.mj_header beginRefreshing];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)zj_viewDidLoadForIndex:(NSInteger)index {
    
}

- (void)addReshAction
{
    __weak typeof(self)weakSelf = self;
    self.tableView.mj_header = [JstyleRefreshGiftHeader headerWithRefreshingBlock:^{
        page = 1;

        [weakSelf loadJstyleNewsSearchComprehensiveData];
    }];
    
    self.tableView.mj_footer = [JstyleRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        page ++;
        [weakSelf loadJstyleNewsSearchComprehensiveData];
    }];
}

- (void)addTableView
{
    _tableView = [[JstyleNewsBaseTableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) style:(UITableViewStylePlain)];
    _tableView.separatorInset = UIEdgeInsetsMake(0, 15, 0, 15);
    _tableView.delegate = self;
    _tableView.dataSource = self;
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    self.tableView.tableFooterView = [UIView new];
    

    [_tableView registerNib:[UINib nibWithNibName:@"JstyleNewsSearchJmNumsViewCell" bundle:nil] forCellReuseIdentifier:@"JstyleNewsSearchJmNumsViewCell"];
    
    [self.view addSubview:_tableView];
    _tableView.sd_layout
    .topEqualToView(self.view)
    .bottomEqualToView(self.view)
    .leftEqualToView(self.view)
    .rightEqualToView(self.view);
}

#pragma mark -- tableView的代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    SearchModel *model = [[SearchModel alloc]init];
    if (indexPath.row<self.dataArray.count) {
        model = self.dataArray[indexPath.row];
    }
    
    //1.文章；2.图集；3.视频；4.直播；5.百度百科;6.相关搜索；7.相关人物 8.自媒体号//head_type : 1.一图；2.三图
    switch ([model.type integerValue]) {
        case 1:{
            if ([model.head_type integerValue]==1) {
                
                SearchTextArticleCell * cell = [SearchTextArticleCell initWithTableView:tableView];
                if (indexPath.row < self.dataArray.count) {
                    cell.model = model;
                }
                return cell;
                
            }else{//三图
                SearchImageArticleCell * cell = [SearchImageArticleCell initWithTableView:tableView];
                if (indexPath.row < self.dataArray.count) {
                    cell.model = model;
                }
                return cell;
            }
            
        }
            break;
        case 2:{//图集
            SearchPicturesCell * cell = [SearchPicturesCell initWithTableView:tableView];
            if (indexPath.row < self.dataArray.count) {
                cell.model = model;
            }
            return cell;
        }
            break;
        case 5:{//百度百科
            
            BaiduEncyclopediaCell * cell = [BaiduEncyclopediaCell initWithTableView:tableView];
            if (indexPath.row < self.dataArray.count) {
                cell.model = model;
            }
            return cell;
        }
            break;
        case 6:{//相关搜索
            SearchAboutSearchCell * cell = [SearchAboutSearchCell initWithTableView:tableView];
            if (indexPath.row < self.dataArray.count) {
                cell.model = model;
                [cell.collectionView reloadDataWithDataArray:model.searchRsResult];
            }
            return cell;
        }
            break;
            
        case 7:{//相关人物
            
            SearchAboutPersonCell * cell = [SearchAboutPersonCell initWithTableView:tableView];
            if (indexPath.row<self.dataArray.count) {
                cell.model = model;
                [cell.collectionView reloadDataWithDataArray:model.searchRsResult];
            }
            return cell;
        }
            break;
        case 8:{//iCity号
            
            SearchAllCityUserCell * cell = [SearchAllCityUserCell initWithTableView:tableView];
            if (indexPath.row<self.dataArray.count&&self.iCtityArray.count>0) {
                
                [cell.tuiJianCollectionView reloadDataWithDataArray:self.iCtityArray];
            }
            return cell;
        }
            break;
            
        default:{//视频
            
            SearchVideoCell * cell = [SearchVideoCell initWithTableView:tableView];
            if (indexPath.row < self.dataArray.count) {
                cell.model = model;
            }
            return cell;
        }
            break;
    }
    

    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SearchModel * model = self.dataArray[indexPath.row];
    
    if ([model.type integerValue]==5) {//百度百科
        return 15+ArticleImg_W+15;
    } else if ([model.type integerValue]==6) {//相关搜索
        NSInteger count = model.searchRsResult.count;
        int num = (int)count/2;
        return 41*num +12;
    }else if ([model.type integerValue]==7) {//相关人物
        return 15+25+10+106+8+15+15;
    }else if ([model.type integerValue]==8) {//iCity号
        return 50+200+45;
    }else {
        
        if ([model.head_type integerValue]==2) {//三图
            
            CGRect frame = [model.head_type getAttributedStringRectWithSpace:3
                                                                    withFont:18
                                                                   withWidth:(SCREEN_W-20)];
            CGFloat img_W = ArticleImg_W;
            CGFloat img_H = img_W/16*10;
            
            return 10+frame.size.height+10+img_H+42;
            
        } else {//1图
            return 30+ArticleImg_H;
        }
        
    }
        
        
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    if (indexPath.row >= self.dataArray.count) return;
    SearchModel *model = self.dataArray[indexPath.row];
    switch ([model.type integerValue]) {
        case 1:{
            //文章
            JstyleNewsArticleDetailViewController *jstyleNewsArticleDVC = [JstyleNewsArticleDetailViewController new];
            jstyleNewsArticleDVC.rid = model.sendId;
            if (![model.TOrFOriginal isNotBlank]) {
                model.TOrFOriginal = model.torFOriginal;
            }
            jstyleNewsArticleDVC.titleModel = (JstyleNewsArticleDetailModel*)model;
            
            [self.navigationController pushViewController:jstyleNewsArticleDVC animated:YES];
            
        }
            break;
        case 2:{
            //图集
            JstylePictureTextViewController *jstyleNewsPictureTVC = [JstylePictureTextViewController new];
            jstyleNewsPictureTVC.rid = model.sendId;
            [self.navigationController pushViewController:jstyleNewsPictureTVC animated:YES];
        }
            break;
        case 3:{
            //视频直播
            JstyleNewsVideoDetailViewController *jstyleNewsVideoDVC = [JstyleNewsVideoDetailViewController new];
            jstyleNewsVideoDVC.videoUrl = model.url_sd;
            jstyleNewsVideoDVC.videoTitle = model.title;
            jstyleNewsVideoDVC.videoType = model.videoType;
            jstyleNewsVideoDVC.vid = model.sendId;
            [self.navigationController pushViewController:jstyleNewsVideoDVC animated:YES];
        }
            break;
        case 4:{
            //视频直播
            JstyleNewsVideoDetailViewController *jstyleNewsVideoDVC = [JstyleNewsVideoDetailViewController new];
            jstyleNewsVideoDVC.videoUrl = model.url_sd;
            jstyleNewsVideoDVC.videoTitle = model.title;
            jstyleNewsVideoDVC.videoType = model.videoType;
            jstyleNewsVideoDVC.vid = model.sendId;
            [self.navigationController pushViewController:jstyleNewsVideoDVC animated:YES];
        }
            break;
        case 5:{//百度百科
            JstyleNewsActivityWebViewController *webVC = [JstyleNewsActivityWebViewController new];
            webVC.urlString = model.h5_url;
            webVC.navigationTitle = model.name;
            [self.navigationController pushViewController:webVC animated:YES];
        }
            break;
        case 8:{
            JstyleNewsJMNumDetailsViewController *jstyleNewsJmNumsDVC = [JstyleNewsJMNumDetailsViewController new];
            jstyleNewsJmNumsDVC.did = model.did;
            [self.navigationController pushViewController:jstyleNewsJmNumsDVC animated:YES];
        }
        default:
            break;
    }
}

#pragma mark - 获取数据
- (void)loadJstyleNewsSearchComprehensiveData
{
    
    NSDictionary *parameters = @{@"page":[NSString stringWithFormat:@"%d",(int)page],
                                 @"key":self.keyword,
                                 @"uid":[[JstyleToolManager sharedManager] getUserId],
                                 @"uuid":[[JstyleToolManager sharedManager] getUDID],
                                 @"type":@"1"};
    //综合搜索
    [[JstyleNewsNetworkManager shareManager] GETURL:SEARCH_RESULT_URL parameters:parameters success:^(id responseObject) {
        
        if ([responseObject[@"code"] integerValue] != 1) {//请求失败
            if (self.dataArray.count) {
                [self.tableView.mj_header endRefreshing];
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }else{
                [self.tableView.mj_header endRefreshing];
                [self.tableView.mj_footer endRefreshing];
            }
            [self addPlaceholderView];
            return;
        }
        if (page == 1) {
            [self.dataArray removeAllObjects];
            [self.iCtityArray removeAllObjects];
        }
        
        [self.dataArray addObjectsFromArray:[NSArray modelArrayWithClass:[SearchModel class] json:responseObject[@"data"][@"resultList"]]];
        
        if (page == 1) {
            
            for (SearchModel *model in self.dataArray) {
                if ([model.type integerValue]==8) {
                    self.iCtityArray = [NSMutableArray arrayWithArray:model.authorList];
                }
            }
        }
  
        
        [self addPlaceholderView];
        
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    } failure:^(NSError *error) {
        [self addPlaceholderView];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
}

- (void)addPlaceholderView{
    [_placeholderView removeFromSuperview];
    _placeholderView = [[JstyleNewsPlaceholderView alloc] initWithFrame:[UIScreen mainScreen].bounds placeholderImage:[UIImage imageNamed:@"文章空白"] placeholderText:@"暂时没有搜索到内容哦~"];
    
    if (!self.dataArray.count) {
        [self.placeholderView removeFromSuperview];
        [self.tableView addSubview:self.placeholderView];
    }else{
        [self.placeholderView removeFromSuperview];
    }
}

/**关注iCity号*/
- (void)addJstyleNewsJmNumsFocusOnWithDid:(NSString *)did indexPath:(NSIndexPath *)indexPath
{
    
    if ([[JstyleToolManager sharedManager] isTourist]) {
        [[JstyleToolManager sharedManager] loginInViewController];
        return;
    }
    NSDictionary *parameters = @{@"platform_type":@"2",
                                 @"did":did,
                                 @"uid":[[JstyleToolManager sharedManager] getUserId],
                                 };
    [[JstyleNewsNetworkManager shareManager] GETURL:MANAGER_SUBSCRIPTION_URL parameters:parameters success:^(id responseObject) {
        if ([responseObject[@"code"] integerValue] == 1) {
            NSString *followType = responseObject[@"data"][@"follow_type"];
            JstyleNewsJMAttentionListModel *model = self.iCtityArray[indexPath.row];
            model.isFollow = followType;
            [self.tableView reloadRowAtIndexPath:indexPath withRowAnimation:(UITableViewRowAnimationNone)];
        }
        
        [self.tableView reloadData];
    } failure:nil];
}

- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (NSMutableArray *)iCtityArray
{
    if (!_iCtityArray) {
        _iCtityArray = [NSMutableArray array];
    }
    return _iCtityArray;
}


#pragma mark - 刷新关注
- (void)attentionRefresh:(NSNotification *)notification
{
    NSDictionary *userInfo = notification.userInfo;
    [self reloadDataWithDid:userInfo[@"did"] followType:userInfo[@"followType"]];
}

- (void)reloadDataWithDid:(NSString *)did followType:(NSString *)followType
{

    for (SearchAboutPersonModel *model in self.iCtityArray) {
        if ([model.did isEqualToString:did]) {
            model.isFollow = followType;
        }
    }
    [self.tableView reloadData];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    
    return ISNightMode?UIStatusBarStyleLightContent:UIStatusBarStyleDefault;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

