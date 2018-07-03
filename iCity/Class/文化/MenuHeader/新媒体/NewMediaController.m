//
//  NewMediaController.m
//  iCity
//
//  Created by mayonggang on 2018/6/15.
//  Copyright © 2018年 LongYuan. All rights reserved.
//

#import "NewMediaController.h"
#import "NewMediaCell.h"
#import "JstyleNewsActivityWebViewController.h"

//
#import "JstyleNewsCustomBannerViewCell.h"
#import "JstyleNewsOneImageArticleViewCell.h"
#import "JstyleNewsOnePlusImageArticleViewCell.h"
#import "JstyleNewsThreeImageArticleViewCell.h"
#import "JstyleNewsOnePlusImageVideoViewCell.h"
#import "JstyleNewsAdvertisementViewCell.h"
#import "VRPlayerView.h"
#import "JstyleNewsArticleDetailViewController.h"
#import "JstylePictureTextViewController.h"
#import "JstyleNewsVideoDetailViewController.h"
#import "JstyleNewsActivityWebViewController.h"
#import "JstyleNewsArticleDetailModel.h"
#import "JstyleNewsVideoFullScreenShareView.h"
#import "JstyleNewsJMAttentionMoreViewController.h"
#import "JstylePartyDetailsViewController.h"



static NSInteger page = 1;
@interface NewMediaController ()<VRPlayerViewDelegate, UIViewControllerPreviewingDelegate,UITableViewDataSource,UITableViewDelegate>
{
    VRPlayerView *vrPlayer;
    NSIndexPath *currentIndexPath;
}

@property(nonatomic, strong) JstyleNewsOnePlusImageVideoViewCell *currentCell;

@property (nonatomic, strong) NSMutableArray *topArray;
@property (nonatomic, strong) NSMutableArray *bottomArray;
//
@property (nonatomic, strong) NSMutableArray<JstyleNewsArticleDetailModel *> *detailDataArray;
@property (nonatomic, strong) JstyleNewsHomePageModel *shareModel;

@property (nonatomic, strong) UITableView * tableView;

@end

@implementation NewMediaController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupTableView];//布局 加载数据
    
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.tableView.backgroundColor = kNightModeBackColor;
    
    NSDictionary *navbarTitleTextAttributes = @{
                                                NSForegroundColorAttributeName:kNightModeTitleColor,
                                                NSFontAttributeName:[UIFont systemFontOfSize:18]
                                                };
    [self.navigationController.navigationBar setTitleTextAttributes:navbarTitleTextAttributes];
    //导航栏
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:kNightModeBackColor] forBarMetrics:UIBarMetricsDefault];
}

- (NSMutableArray *)topArray {
    if (!_topArray) {
        _topArray = [NSMutableArray array];
    }
    return _topArray;
}
- (NSMutableArray *)bottomArray {
    if (!_bottomArray) {
        _bottomArray = [NSMutableArray array];
    }
    return _bottomArray;
}
- (NSMutableArray<JstyleNewsArticleDetailModel *> *)detailDataArray {
    if (!_detailDataArray) {
        _detailDataArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _detailDataArray;
}


- (void)setupTableView {
    
    self.title = @"新媒体";
    self.view.backgroundColor = kNightModeBackColor;
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_W, SCREEN_H-YG_StatusAndNavightion_H-YG_SafeBottom_H) style:UITableViewStyleGrouped];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    self.tableView.tableFooterView = [UIView new];
    
//    self.tableView.separatorInset = UIEdgeInsetsMake(0, 10, 0, 10);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    
    [self.tableView registerNib:[UINib nibWithNibName:@"JstyleNewsOneImageArticleViewCell" bundle:nil] forCellReuseIdentifier:@"JstyleNewsOneImageArticleViewCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"JstyleNewsOnePlusImageArticleViewCell" bundle:nil] forCellReuseIdentifier:@"JstyleNewsOnePlusImageArticleViewCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"JstyleNewsThreeImageArticleViewCell" bundle:nil] forCellReuseIdentifier:@"JstyleNewsThreeImageArticleViewCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"JstyleNewsOnePlusImageVideoViewCell" bundle:nil] forCellReuseIdentifier:@"JstyleNewsOnePlusImageVideoViewCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"JstyleNewsAdvertisementViewCell" bundle:nil] forCellReuseIdentifier:@"JstyleNewsAdvertisementViewCell"];
    
    __weak typeof(self) weakSelf = self;
    self.tableView.mj_header = [JstyleRefreshGiftHeader headerWithRefreshingBlock:^{
        page = 1;
        
        [weakSelf loadTopData];
        [weakSelf loadbotomData];
    }];
    self.tableView.mj_footer = [JstyleRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        page++;
        [weakSelf loadbotomData];
    }];
    
    [self.tableView.mj_header beginRefreshing];
}


#pragma mark - Table view data source

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 57;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section==0) {
        return 7;
    } else {
        return 0.01;
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSString * night = ISNightMode?@"_night":@"";
    if (section==0) {
        
        return [self addHeaderViewWithTitle:@"推荐媒体" moreBtnTitle:@"更多" img:[NSString stringWithFormat:@"media_icon_media%@",night]];
    } else {
        return [self addHeaderViewWithTitle:@"热门内容" moreBtnTitle:@"" img:[NSString stringWithFormat:@"media_icon_hot%@",night]];
    }
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    UIView *foot = [UIView new];
    foot.backgroundColor = kNightModeLineColor;
    return foot;
}




- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section==0) {
        return (self.topArray.count?1:0);
    } else {
        return self.bottomArray.count;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section ==0) {
        NewMediaCell *cell = [NewMediaCell initWithTableView:tableView];
        if (indexPath.row<self.topArray.count) {
//            cell.model = self.dataArray[indexPath.row];
        
            [cell.collectionView reloadDataWithDataArray:self.topArray];
        }
        
        return cell;
    }else{
        if (!self.bottomArray.count) {
            static NSString *ID = @"cellID";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
            if (!cell) {
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
   
            JstyleNewsHomePageModel *model = self.bottomArray[indexPath.row];
            switch ([model.type integerValue]) {
                case 1:{
                    if ([model.head_type integerValue] == 1 && [model.isImageArticle integerValue] == 1) {
                        static NSString *ID = @"JstyleNewsOnePlusImageArticleViewCell";
                        JstyleNewsOnePlusImageArticleViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
                        if (!cell) {
                            cell = [[JstyleNewsOnePlusImageArticleViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
                        }
                        
                        [cell setupPreviewingDelegateWithController:self];
                        
                        if (indexPath.row < self.bottomArray.count) {
                            cell.model = model;
                        }
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                        
                        return cell;
                    }else if ([model.head_type integerValue] == 1) {
                        static NSString *ID = @"JstyleNewsOneImageArticleViewCell";
                        JstyleNewsOneImageArticleViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
                        if (!cell) {
                            cell = [[JstyleNewsOneImageArticleViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
                        }
                        
                        [cell setupPreviewingDelegateWithController:self];
                        
                        if (indexPath.row < self.bottomArray.count) {
                            cell.model = model;
                        }
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                        
                        return cell;
                    }else{
                        static NSString *ID = @"JstyleNewsThreeImageArticleViewCell";
                        JstyleNewsThreeImageArticleViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
                        if (!cell) {
                            cell = [[JstyleNewsThreeImageArticleViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
                        }
                        
                        [cell setupPreviewingDelegateWithController:self];
                        
                        if (indexPath.row < self.bottomArray.count) {
                            cell.model = model;
                        }
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                        
                        return cell;
                    }
                }
                    break;
                case 2:{
                    static NSString *ID = @"JstyleNewsOnePlusImageVideoViewCell";
                    JstyleNewsOnePlusImageVideoViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
                    if (!cell) {
                        cell = [[JstyleNewsOnePlusImageVideoViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
                    }
                    
                    cell.videoPlayBtn.tag = indexPath.row;
                    cell.startPlayVideoBlock = ^(UIButton *sender) {
//                        [self startPlayVideo:sender];
                    };
                    cell.videoShareBlock = ^(NSString *shareImgUrl, NSString *shareUrl, NSString *shareTitle, NSString *shareDesc) {
                        [[JstyleToolManager sharedManager] shareVideoWithShareTitle:shareTitle shareDesc:shareDesc shareUrl:shareUrl shareImgUrl:shareImgUrl viewController:self];
                    };
                    
                    if (vrPlayer && vrPlayer.superview) {
                        NSArray *indexpaths = [tableView indexPathsForVisibleRows];
                        if (![indexpaths containsObject:currentIndexPath] && currentIndexPath != nil) {//复用
                            if (![[UIApplication sharedApplication].keyWindow.subviews containsObject:vrPlayer]) {
                                [self releaseVRPlayer];
                            }
                        }
                    }
                    
                    if (indexPath.row < self.bottomArray.count) {
                        cell.model = model;
                    }
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    
                    return cell;
                }
                    break;
                
                default:
                    return nil;
                    break;
            }
    }
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section==0) {
        CGFloat header_W    = 90/2;
        return 7+(15+header_W+10+17)*2+22;

    }else{
        if (indexPath.row>=self.bottomArray.count) {
            return 0;
        }
        JstyleNewsHomePageModel * model = self.bottomArray[indexPath.row];
        
        switch ([model.type integerValue]) {
            case 1:{
                if ([model.head_type integerValue] == 1 && [model.isImageArticle integerValue] == 1) {
                    return [self.tableView cellHeightForIndexPath:indexPath model:model keyPath:@"model" cellClass:[JstyleNewsOnePlusImageArticleViewCell class] contentViewWidth:kScreenWidth];
                }else if ([model.head_type integerValue] == 1) {
                    
                    if ([model.poster isNotBlank]) {
                        return ArticleImg_H + 31;//OneImageArticleView
                    } else {//无图情况
                        
                        CGRect labelF  = [[NSString stringWithFormat:@"%@",model.title] getAttributedStringRectWithSpace:3
                                                                                                                withFont:JSTitleFontNumber
                                                                                                               withWidth:SCREEN_W-20];
                        return labelF.size.height+15+12+31;
                    }
                }else{
                    return [self.tableView cellHeightForIndexPath:indexPath model:model keyPath:@"model" cellClass:[JstyleNewsThreeImageArticleViewCell class] contentViewWidth:kScreenWidth];
                }
            }
                break;
            case 2:{
                return [self.tableView cellHeightForIndexPath:indexPath model:model keyPath:@"model" cellClass:[JstyleNewsOnePlusImageVideoViewCell class] contentViewWidth:kScreenWidth];
            }
                break;
            case 3:{
                if ([model.banner_type integerValue]==4) {
                    
                    CGFloat img_W = (SCREEN_W-20-20)/3;
                    CGFloat img_H = img_W/112*149;
                    CGFloat text_H = [model.title getAttributedStringHeightWithSpace:3 withFont:JSTitleFont withWidth:SCREEN_W];
                    
                    return img_H+text_H+35;
                }
                return [self.tableView cellHeightForIndexPath:indexPath model:model keyPath:@"model" cellClass:[JstyleNewsAdvertisementViewCell class] contentViewWidth:kScreenWidth];
            }
                break;
            default:
                return 0;
                break;
        }
    }
   
}

#pragma mark - 添加头部视图
- (UIView *)addHeaderViewWithTitle:(NSString *)title moreBtnTitle:(NSString *)moreBtnTitle img:(NSString *)img
{
    UIView *headerView = [[UIView alloc] init];
    headerView.backgroundColor = kNightModeBackColor;
    
    
    UIImageView *icon = [[UIImageView alloc] init];
    icon.image = [UIImage imageNamed:img];
    [headerView addSubview:icon];
    if ([title isEqualToString:@"推荐媒体"]) {
        icon.sd_layout
        .topSpaceToView(headerView, 19)
        .leftSpaceToView(headerView, 15)
        .widthIs(18)
        .heightIs(18);
    } else {
        icon.sd_layout
        .centerYEqualToView(headerView)
        .leftSpaceToView(headerView, 15)
        .widthIs(16)
        .heightIs(18);
    }
    
    
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.font = JSFontWithWeight(18, UIFontWeightMedium);
    nameLabel.text = title;
    nameLabel.textColor = ISNightMode?kDarkNineColor:kDarkTwoColor;
    [headerView addSubview:nameLabel];
    nameLabel.sd_layout
    .centerYEqualToView(icon)
    .leftSpaceToView(icon, 7)
    .widthIs(150)
    .heightIs(20);
    
    
    UIButton *checkMoreBtn = [[UIButton alloc] init];
    checkMoreBtn.titleLabel.font = JSFont(13);
    [checkMoreBtn setTitle:moreBtnTitle forState:(UIControlStateNormal)];
    [checkMoreBtn setTitleColor:kDarkNineColor forState:(UIControlStateNormal)];
    [checkMoreBtn setContentHorizontalAlignment:(UIControlContentHorizontalAlignmentRight)];
    [checkMoreBtn addTarget:self action:@selector(checkMoreBtnClicked:) forControlEvents:(UIControlEventTouchUpInside)];
    [checkMoreBtn setEnlargeEdgeWithTop:10 right:10 bottom:10 left:10];
    [headerView addSubview:checkMoreBtn];
    checkMoreBtn.sd_layout
    .centerYEqualToView(icon)
    .rightSpaceToView(headerView, 15)
    .widthIs(150)
    .heightIs(18);
    
    if (moreBtnTitle.length>0) {
        checkMoreBtn.hidden = NO;
    } else {
        checkMoreBtn.hidden = YES;
    }
    
    
    return headerView;
}
#pragma mark - 更多推荐媒体
- (void)checkMoreBtnClicked:(UIButton *)sender
{
    JstyleNewsJMAttentionMoreViewController *jstyleNewsJMAttentionMVC = [JstyleNewsJMAttentionMoreViewController new];
    [self.navigationController pushViewController:jstyleNewsJMAttentionMVC animated:YES];
}






#pragma mark - 下载头部数据
- (void)loadTopData {
    
//    新媒体上 面的自媒体列表：
//    iCity_interface/headmedia/medialist.htm
//    参数： field_id = -1
//    tag = 1
//    uid
    
    JstyleNewsNetworkManager *manger = [JstyleNewsNetworkManager shareManager];
    NSDictionary *paramaters;
    if ([[JstyleToolManager sharedManager] isTourist]) {
        paramaters = @{
                       @"field_id":@"-1",
                       @"tag":@"1",
                       };
    } else {
        paramaters = @{
                       @"field_id":@"-1",
                       @"tag":@"1",
                       @"uid":[[JstyleToolManager sharedManager] getUserId]
                       };
    }
    NSLog(@"%@",paramaters);
    
    [manger GETURL:Culture_NewMediaHead_URL parameters:paramaters success:^(id responseObject) {
        
        if (page==1) {
            [self.topArray removeAllObjects];
        }
        if ([responseObject[@"code"] isEqualToString:@"1"]) {
            
            NSArray *currentData = [NSArray modelArrayWithClass:[NewspaperModel class] json:responseObject[@"data"]];
            
            [self.topArray addObjectsFromArray:currentData];
            
            [self.tableView reloadData];
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
            
        } else {
            
            [self.tableView reloadData];
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }
        
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
}

#pragma mark - 下载底部数据
- (void)loadbotomData {

    JstyleNewsNetworkManager *manger = [JstyleNewsNetworkManager shareManager];
    NSDictionary *paramaters;
    if ([[JstyleToolManager sharedManager] isTourist]) {
        paramaters = @{
                      @"page":[NSString stringWithFormat:@"%d",(int)page]
                       };
    } else {
        paramaters = @{
                       @"page":[NSString stringWithFormat:@"%d",(int)page],
                       @"uid":[[JstyleToolManager sharedManager] getUserId]
                       };
    }
    
    [manger GETURL:Read_NewMedia_URL parameters:paramaters success:^(id responseObject) {
        
        if (page==1) {
            [self.bottomArray removeAllObjects];
            [self.detailDataArray removeAllObjects];
        }
        if ([responseObject[@"code"] isEqualToString:@"1"]) {
            
            NSArray *currentData = [NSArray modelArrayWithClass:[JstyleNewsHomePageModel class] json:responseObject[@"data"]];
            
            [self.bottomArray addObjectsFromArray:currentData];
            [self.detailDataArray addObjectsFromArray:[NSArray modelArrayWithClass:[JstyleNewsArticleDetailModel class] json:responseObject[@"data"]]];
            [self.tableView reloadData];
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
            
        } else {
            
            [self.tableView reloadData];
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }
        
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
}



-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self releaseVRPlayer];
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self releaseVRPlayer];
    if (indexPath.section==0) {
        return;

    }else{
        if (indexPath.row >= self.bottomArray.count) return;

        JstyleNewsHomePageModel *model = self.bottomArray[indexPath.row];
        JstyleNewsArticleDetailModel *detailModel = self.detailDataArray[indexPath.row];
        switch ([model.type integerValue]) {
            case 1:{
                if ([model.isImageArticle integerValue] == 1) {
                    //图集
                    JstylePictureTextViewController *jstyleNewsPictureTVC = [JstylePictureTextViewController new];
                    jstyleNewsPictureTVC.rid = model.id;
                    [self.navigationController pushViewController:jstyleNewsPictureTVC animated:YES];
                }else{
                    //文章
                    JstyleNewsArticleDetailViewController *jstyleNewsArticleDVC = [JstyleNewsArticleDetailViewController new];
                    jstyleNewsArticleDVC.rid = detailModel.id;
                    jstyleNewsArticleDVC.titleModel = detailModel;
                    [self.navigationController pushViewController:jstyleNewsArticleDVC animated:YES];
                }
            }
                break;
            case 2:{
                //视频直播
                JstyleNewsVideoDetailViewController *jstyleNewsVideoDVC = [JstyleNewsVideoDetailViewController new];
                jstyleNewsVideoDVC.videoUrl = model.url_sd;
                jstyleNewsVideoDVC.videoTitle = model.title;
                jstyleNewsVideoDVC.vid = model.id;
                jstyleNewsVideoDVC.videoType = model.videoType;
                [self.navigationController pushViewController:jstyleNewsVideoDVC animated:YES];
            }
                break;
            case 3:{
                //广告活动
                switch ([model.banner_type integerValue]) {
                    case 1:
                        //文章
                        if ([model.isImageArticle integerValue] == 1) {
                            //图集
                            JstylePictureTextViewController *jstyleNewsPictureTVC = [JstylePictureTextViewController new];
                            jstyleNewsPictureTVC.rid = model.id;
                            [self.navigationController pushViewController:jstyleNewsPictureTVC animated:YES];
                        }else{
                            //文章
                            JstyleNewsArticleDetailViewController *jstyleNewsArticleDVC = [JstyleNewsArticleDetailViewController new];
                            jstyleNewsArticleDVC.rid = detailModel.id;
                            jstyleNewsArticleDVC.titleModel = detailModel;
                            [self.navigationController pushViewController:jstyleNewsArticleDVC animated:YES];
                        }
                        break;
                    case 2:{
                        //视频直播
                        JstyleNewsVideoDetailViewController *jstyleNewsVideoDVC = [JstyleNewsVideoDetailViewController new];
                        jstyleNewsVideoDVC.videoUrl = model.url_sd;
                        jstyleNewsVideoDVC.videoTitle = model.title;
                        jstyleNewsVideoDVC.vid = model.id;
                        [self.navigationController pushViewController:jstyleNewsVideoDVC animated:YES];
                    }
                        break;
                    case 3:{
                        //h5
                        //活动详情
                        JstylePartyDetailsViewController *jstylePartyDetailsVC = [JstylePartyDetailsViewController new];
                        jstylePartyDetailsVC.partyId = model.rid;
                        [self.navigationController pushViewController:jstylePartyDetailsVC animated:YES];
                    }
                        break;
                    case 4:{
                        //热门图书

                    }
                        break;
                    case 5:{
                        //活动详情
                        JstyleNewsActivityWebViewController *jstyleNewsActivityWVC = [JstyleNewsActivityWebViewController new];
                        jstyleNewsActivityWVC.urlString = model.h5url;
                        jstyleNewsActivityWVC.isShare = model.isShare.integerValue;
                        [self.navigationController pushViewController:jstyleNewsActivityWVC animated:YES];

                    }
                        break;
                    default:
                        break;
                }
            }
                break;
            default:
                break;
        }
    }

}

#pragma mark 视频列表播放的相关代码
//把播放器vrPlayer对象放到cell上，同时更新约束
- (void)toCell{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"JstyleLandscapeRight"];
    JstyleNewsOnePlusImageVideoViewCell *currentCell = (JstyleNewsOnePlusImageVideoViewCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:currentIndexPath.row inSection:0]];
    [vrPlayer removeFromSuperview];
    
    SEL selector = NSSelectorFromString(@"setOrientation:");
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
    [invocation setSelector:selector];
    [invocation setTarget:[UIDevice currentDevice]];
    int val = UIInterfaceOrientationPortrait;
    [invocation setArgument:&val atIndex:2];
    [invocation invoke];
    
    [currentCell.contentView addSubview:vrPlayer];
    [currentCell.contentView bringSubviewToFront:vrPlayer];
    vrPlayer.sd_layout
    .leftEqualToView(currentCell.backImageView)
    .rightEqualToView(currentCell.backImageView)
    .topEqualToView(currentCell.backImageView)
    .bottomEqualToView(currentCell.backImageView);
}

- (void)toFullScreenWithInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
    [[NSUserDefaults standardUserDefaults] setObject:@"JstyleLandscapeRight" forKey:@"JstyleLandscapeRight"];
    [vrPlayer removeFromSuperview];
    if(interfaceOrientation == UIInterfaceOrientationLandscapeRight){
        SEL selector = NSSelectorFromString(@"setOrientation:");
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
        [invocation setSelector:selector];
        [invocation setTarget:[UIDevice currentDevice]];
        int val = UIInterfaceOrientationLandscapeRight;//这里可以改变旋转的方向
        [invocation setArgument:&val atIndex:2];
        [invocation invoke];
    }
    [[UIApplication sharedApplication].keyWindow addSubview:vrPlayer];
    vrPlayer.sd_resetNewLayout
    .leftEqualToView([UIApplication sharedApplication].keyWindow)
    .rightEqualToView([UIApplication sharedApplication].keyWindow)
    .topEqualToView([UIApplication sharedApplication].keyWindow)
    .bottomEqualToView([UIApplication sharedApplication].keyWindow);
}




-(void)startPlayVideo:(UIButton *)sender{
    currentIndexPath = [NSIndexPath indexPathForRow:sender.tag inSection:0];

    UIView *cellView = [sender superview];
    while (![cellView isKindOfClass:[UITableViewCell class]])
    {
        cellView =  [cellView superview];
    }
    self.currentCell = (JstyleNewsOnePlusImageVideoViewCell *)cellView;
    if (sender.tag >= self.bottomArray.count) return;
    JstyleNewsHomePageModel *model = self.bottomArray[sender.tag];
    self.shareModel = model;

    if (vrPlayer) {
        [self releaseVRPlayer];
    }
    //VR视频相关处理
    if ([self.currentCell.model.videoType isEqualToString:@"1"]) {//是VR
        vrPlayer = [[VRPlayerView alloc]initWithFrame:self.currentCell.backImageView.bounds withVrUrl:[NSURL URLWithString:model.url_sd] withVrType:(VrType_AVPlayer_VR)];
        vrPlayer.boxButton.hidden = NO;
        
    }else{
        vrPlayer = [[VRPlayerView alloc]initWithFrame:self.currentCell.backImageView.bounds withVrUrl:[NSURL URLWithString:model.url_sd] withVrType:(VrType_AVPlayer_Normal)];
        vrPlayer.boxButton.hidden = YES;
    }

    vrPlayer.backBtn.hidden = YES;
    vrPlayer.netBackBtn.hidden = YES;
    vrPlayer.delegate = self;
    vrPlayer.bottomView.hidden = YES;

    [self.currentCell.contentView addSubview:vrPlayer];
    [self.currentCell.contentView bringSubviewToFront:vrPlayer];
    vrPlayer.sd_layout
    .leftEqualToView(self.currentCell.backImageView)
    .rightEqualToView(self.currentCell.backImageView)
    .topEqualToView(self.currentCell.backImageView)
    .bottomEqualToView(self.currentCell.backImageView);
}



/**
 *  释放vrPlayer
 */
-(void)releaseVRPlayer{
    [vrPlayer pause];
    [vrPlayer releseTimer];
    [vrPlayer removeFromSuperview];
    vrPlayer.player = nil;
    vrPlayer = nil;
}

- (void)vrPlayerView:(VRPlayerView *)vrPlayerView backBtnClicked:(BOOL)backBtnSelected
{
    if (backBtnSelected) {
        [vrPlayer.fullScreenBtn sendActionsForControlEvents:(UIControlEventTouchUpInside)];
    }
}

- (void)vrPlayerView:(VRPlayerView *)vrPlayerView moreBtn:(UIButton *)moreBtn
{
    [vrPlayer.playPauseBtn sendActionsForControlEvents:(UIControlEventTouchUpInside)];
    JstyleNewsVideoFullScreenShareView *jstyleShareView = [[JstyleNewsVideoFullScreenShareView alloc] initWithFrame:CGRectMake(0, kScreenWidth, kScreenHeight, kScreenWidth) shareTitle:self.shareModel.title shareDesc:self.shareModel.describes shareUrl:self.shareModel.ashareurl shareImgUrl:self.shareModel.poster viewController:self];
    [UIView animateWithDuration:0.25 animations:^{
        jstyleShareView.y = 0;
    }];
    __weak JstyleNewsVideoFullScreenShareView *weakShareView = jstyleShareView;
    __weak UIButton *playPauseBtn = vrPlayer.playPauseBtn;
    jstyleShareView.closeBlock = ^{
        [UIView animateWithDuration:0.25 animations:^{
            weakShareView.y = kScreenWidth;
        } completion:^(BOOL finished) {
            [weakShareView removeFromSuperview];
            [playPauseBtn sendActionsForControlEvents:(UIControlEventTouchUpInside)];
        }];
    };
    [[UIApplication sharedApplication].keyWindow addSubview:jstyleShareView];
}

-(void)vrPlayerView:(VRPlayerView *)vrPlayerView clickedFullScreen:(UIButton *)fullScreen{
    if (fullScreen.isSelected) {
        vrPlayer.backBtn.hidden = NO;
        [self toFullScreenWithInterfaceOrientation:UIInterfaceOrientationLandscapeRight];
    }else{
        vrPlayer.backBtn.hidden = YES;
        [self toCell];
    }
}




- (void)previewingContext:(id <UIViewControllerPreviewing>)previewingContext commitViewController:(UIViewController *)viewControllerToCommit {
    
    [self showViewController:viewControllerToCommit sender:self];
}

-(UIStatusBarStyle)preferredStatusBarStyle {
    
    return ISNightMode?UIStatusBarStyleLightContent:UIStatusBarStyleDefault;
}

@end
