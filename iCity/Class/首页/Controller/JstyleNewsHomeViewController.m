//
//  JstyleNewsHomeViewController.m
//  JstyleNews
//
//  Created by 数字跃动 on 2017/9/13.
//  Copyright © 2017年 JstyleNews. All rights reserved.
//

#import "JstyleNewsHomeViewController.h"
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
#import "JstylePartyDetailsViewController.h"
//#import "HomeRecommendSetTopCell.h"
#import "HotBooksCell.h"

@interface JstyleNewsHomeViewController ()<UITableViewDelegate, UITableViewDataSource, SDCycleScrollViewDelegate, VRPlayerViewDelegate, UIViewControllerPreviewingDelegate>{
    VRPlayerView *vrPlayer;
    NSIndexPath *currentIndexPath;
    
}

@property(nonatomic, strong) JstyleNewsOnePlusImageVideoViewCell *currentCell;

@property (nonatomic, strong) JstyleNewsBaseTableView *tableView;
@property (nonatomic, assign) BOOL isFirstRefresh;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSMutableArray *setTopArray;//置顶

@property (nonatomic, strong) NSMutableArray<JstyleNewsArticleDetailModel *> *detailDataArray;

@property (nonatomic, strong) NSMutableArray *bannerArray;
@property (nonatomic, strong) SDCycleScrollView *bannerView;

@property (nonatomic, strong) FMDatabase *database;
@property (nonatomic, strong) NSMutableArray *cacheBannerArray;//本地缓存轮播图
@property (nonatomic, strong) NSMutableArray *cacheSetTopArray;//本地缓存置顶
@property (nonatomic, strong) NSMutableArray *cacheListArray;//本地缓存列表第一页
@property (nonatomic, strong) NSMutableDictionary *cacheDict;

@property (nonatomic, strong) JstyleNewsHomePageModel *shareModel;

@property (nonatomic, strong) JstyleNewsNoSinglePlaceholderView *noSingleView;

@property (nonatomic, strong) WLNewDataCountTipLabel *tipLabel;

@end

static NSInteger page = 1;
static NSString *refresh = @"1";
@implementation JstyleNewsHomeViewController

- (WLNewDataCountTipLabel *)tipLabel {
    if (_tipLabel == nil) {
        _tipLabel = [WLNewDataCountTipLabel newDataCountTipLabelWithSuperView:self.view];
    }
    return _tipLabel;
}

- (void)dealloc
{
    [self releaseVRPlayer];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //    self.view.backgroundColor = kWhiteColor;
    self.isFirstRefresh = YES;
    [self addTableView];
    [self addReshAction];
    
    [self creatTableSqlite];
    @try {[self getCacheDictionary];}
    @catch (NSException *exception) {}
    @finally {[self.tableView.mj_header beginRefreshing];}
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeFontSize) name:KJstyleNewsChangeFontSizeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tabbarButtonClickDidRepeat) name:@"TabbarButtonClickDidRepeatNotification" object:nil];
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applyTheme) name:NightModeManagerNotification object:nil];
    [self addNoSingleView];
    
    
}


#pragma mark - 3DTouch预览
- (UIViewController *)previewingContext:(id<UIViewControllerPreviewing>)previewingContext viewControllerForLocation:(CGPoint)location {
    
    NSIndexPath *indexPath = [self.tableView indexPathForCell:(UITableViewCell* )[previewingContext sourceView]];
    
    JstyleNewsHomePageModel *model = [JstyleNewsHomePageModel new];
    if (indexPath.section == 0) {
        model = self.setTopArray[indexPath.row];
    }else{
        model = self.dataArray[indexPath.row];
    }
    
    if ([model isImageArticle].integerValue == 1) {
        JstylePictureTextViewController *pictureVC = [[JstylePictureTextViewController alloc] init];
        if (indexPath.row < self.dataArray.count) {
            pictureVC.rid = [model id];
            CGRect rect = CGRectMake(0, 0, self.view.frame.size.width,[self.tableView cellForRowAtIndexPath:indexPath].height);
            previewingContext.sourceRect = rect;
        }
        return pictureVC;
        
    } else {
        JstyleNewsArticleDetailViewController *detailVC = [[JstyleNewsArticleDetailViewController alloc] init];
        detailVC.preferredContentSize = CGSizeMake(0.0f,500.0f);
        if (indexPath.row < self.dataArray.count) {
            detailVC.rid = model.id;
            if (indexPath.section ==0) {
                detailVC.titleModel = self.setTopArray[indexPath.row];
            }else{
                detailVC.titleModel = self.detailDataArray[indexPath.row];
            }
            
            CGRect rect = CGRectMake(0, 0, self.view.frame.size.width,[self.tableView cellForRowAtIndexPath:indexPath].height);
            previewingContext.sourceRect = rect;
        }
        return detailVC;
    }
}

- (void)previewingContext:(id <UIViewControllerPreviewing>)previewingContext commitViewController:(UIViewController *)viewControllerToCommit {
    
    [self showViewController:viewControllerToCommit sender:self];
}

#pragma mark - 网络判断
- (void)addNoSingleView{
    
    if ([[JstyleToolManager sharedManager] getCurrentNetStatus] == NotReachable) {
        self.noSingleView = [[JstyleNewsNoSinglePlaceholderView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - YG_StatusAndNavightion_H - TabbarHeight)];
        [self.view addSubview:self.noSingleView];
        self.tableView.scrollEnabled = NO;
        __weak typeof(self)weakSelf = self;
        self.noSingleView.reloadBlock = ^{
            [SVProgressHUD showWithStatus:@"正在努力加载"];
            [weakSelf loadJstyleNewsMoreListData];
            [weakSelf getCacheDictionary];
        };
    }
}

- (void)changeFontSize
{
    [self.tableView reloadData];
}

- (void)tabbarButtonClickDidRepeat
{
    //判断window是否在窗口上
    if (self.view.window == nil) return;
    //判断当前的view是否与窗口重合  nil代表屏幕左上角
    if (![self.view hu_intersectsWithAnotherView:nil]) return;
    //刷新
    [self.tableView.mj_header beginRefreshing];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"HiddenNavigationBar" object:nil userInfo:@{@"contentOffset":[NSString stringWithFormat:@"%f",scrollView.contentOffset.y],@"height":[NSString stringWithFormat:@"%f",scrollView.frame.size.height],@"contentSizeHeight":[NSString stringWithFormat:@"%f",scrollView.contentSize.height]}];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.translucent = NO;
    [_bannerView adjustWhenControllerViewWillAppera];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self releaseVRPlayer];
}

- (void)zj_viewDidLoadForIndex:(NSInteger)index {
    
}

- (void)addReshAction
{
    __weak typeof(self)weakSelf = self;
    self.tableView.mj_header = [JstyleRefreshGiftHeader headerWithRefreshingBlock:^{
        page = 1;
        
        [weakSelf loadJstyleSetTopListData];
        
    }];
    
    self.tableView.mj_footer = [JstyleRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        page ++;
        //[weakSelf loadJstyleNewsHomeListData];
        [weakSelf loadJstyleNewsMoreListData];
    }];
}

- (void)addTableView
{
    _tableView = [[JstyleNewsBaseTableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - YG_StatusAndNavightion_H - TabbarHeight) style:(UITableViewStyleGrouped)];
    _tableView.separatorInset = UIEdgeInsetsMake(0, 10, 0, 10);
    
    //    _tableView.separatorColor = kSingleLineColor;
    //    _tableView.backgroundColor = kWhiteColor;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    self.tableView.tableFooterView = [UIView new];
    
    [_tableView registerNib:[UINib nibWithNibName:@"JstyleNewsOneImageArticleViewCell" bundle:nil] forCellReuseIdentifier:@"JstyleNewsOneImageArticleViewCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"JstyleNewsOnePlusImageArticleViewCell" bundle:nil] forCellReuseIdentifier:@"JstyleNewsOnePlusImageArticleViewCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"JstyleNewsThreeImageArticleViewCell" bundle:nil] forCellReuseIdentifier:@"JstyleNewsThreeImageArticleViewCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"JstyleNewsOnePlusImageVideoViewCell" bundle:nil] forCellReuseIdentifier:@"JstyleNewsOnePlusImageVideoViewCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"JstyleNewsAdvertisementViewCell" bundle:nil] forCellReuseIdentifier:@"JstyleNewsAdvertisementViewCell"];
    
    [self.view addSubview:_tableView];
    
}

#pragma mark -- tableView的代理方法

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section==1) {
        
        return nil;
    }else{
        static NSString *ID = @"BannerHeader";
        UITableViewHeaderFooterView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:ID];
        if(headerView == nil){
            headerView = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:ID];
        }
        if (self.bannerArray.count) {
            NSMutableArray *imageArray = [[NSMutableArray alloc] init];
            for (JstyleNewsHomePageModel *model in self.bannerArray) {
                [imageArray addObject:model.poster];
            }
            [_bannerView removeFromSuperview];
            _bannerView = nil;
            _bannerView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0,0,kScreenWidth,165*kScreenWidth/375.0) delegate:self placeholderImage:nil];
            _bannerView.imageURLStringsGroup = imageArray;
            
            if (_bannerView.imageURLStringsGroup.count < 2) {
                _bannerView.autoScroll = NO;
            }else{
                _bannerView.autoScroll = YES;
            }
            
            _bannerView.pageControlStyle = SDCycleScrollViewPageContolStyleClassic;
            _bannerView.bannerImageViewContentMode = UIViewContentModeScaleAspectFill;
            _bannerView.placeholderImage = SZ_Place_LIFE;
            _bannerView.autoScrollTimeInterval = 4.0f;
            _bannerView.currentPageDotColor = kPinkColor;
            _bannerView.pageDotColor = [kDarkOneColor colorWithAlphaComponent:0.3];
            _bannerView.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
            _bannerView.pageControlRightOffset = 0;
            _bannerView.pageControlBottomOffset = 0;
            [headerView addSubview:_bannerView];
        }
        headerView.contentView.backgroundColor = kWhiteColor;
        return headerView;
    }
    
}
    

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section==0) {
        if (self.bannerArray.count) return 165*kScreenWidth/375.0;
        return 0.01;
    } else {
        return 0.01;
    }
    
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section ==0) {
        return self.setTopArray.count;
    }else{
        return self.dataArray.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"cellID";
    if (indexPath.section==0&&self.setTopArray.count==0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
            
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    }
    if (indexPath.section==1&&self.dataArray.count==0) {
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    

    JstyleNewsHomePageModel *model = [JstyleNewsHomePageModel new];
    
    if (indexPath.section==0&&indexPath.row<self.setTopArray.count) {
         model = self.setTopArray[indexPath.row];
    }else if (indexPath.section==1&&indexPath.row<self.dataArray.count) {
        
        model = self.dataArray[indexPath.row];
    }else{
        NSLog(@"超了");
    }
//    if (indexPath.section == 1) {
//        NSLog(@"---%ld----%ld",(long)indexPath.section,(long)indexPath.row);
//        NSLog(@"type=%@--head_type=%@--\n-isImageArticle=%@--\n-title=%@---poster=%@",model.type,model.head_type,model.isImageArticle ,model.title,model.poster);
//    }
    
    switch ([model.type integerValue]) {
        case 1:{//
            if ([model.head_type integerValue] == 1 && [model.isImageArticle integerValue] == 1) {
                static NSString *ID = @"JstyleNewsOnePlusImageArticleViewCell";
                JstyleNewsOnePlusImageArticleViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
                if (!cell) {
                    cell = [[JstyleNewsOnePlusImageArticleViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
                }
                //是图集
                [cell setupPreviewingDelegateWithController:self];//设置3D Touch代理
               
                [cell setModel:model withIndex:indexPath];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                return cell;
            }else if ([model.head_type integerValue] == 1) {
                static NSString *ID = @"JstyleNewsOneImageArticleViewCell";
                JstyleNewsOneImageArticleViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
                if (!cell) {
                    cell = [[JstyleNewsOneImageArticleViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
                }
                
                [cell setupPreviewingDelegateWithController:self];
             
                [cell setModel:model withIndex:indexPath];

                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                return cell;
            }else {
                static NSString *ID = @"JstyleNewsThreeImageArticleViewCell";
                JstyleNewsThreeImageArticleViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
                if (!cell) {
                    cell = [[JstyleNewsThreeImageArticleViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
                }
                
                [cell setupPreviewingDelegateWithController:self];
                
                [cell setModel:model withIndex:indexPath];
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
                [self startPlayVideo:sender];
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
            
            if (indexPath.row < self.dataArray.count) {
                cell.model = model;
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            return cell;
        }
            break;
        case 3:{//banner_type 1.文章 2.视频(没用)     3.广搞 4.热门推荐图书 5.活动
            
            if ([model.banner_type integerValue]==4) {//热门推荐图书
                
                HotBooksCell * cell = [HotBooksCell initWithTableView:tableView];
                cell.model = model;
                return cell;
                
            } else {
                //活动 广告
                static NSString *ID = @"JstyleNewsAdvertisementViewCell";
                JstyleNewsAdvertisementViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
                if (!cell) {
                    cell = [[JstyleNewsAdvertisementViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
                }
                
                if (indexPath.row < self.dataArray.count) {
    
                    cell.model = model;
                }
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                return cell;

            }

            
        }
            break;
        default: {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
            if (!cell) {
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
            
        }
            break;
    }
   
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section==0) {
        if (!(indexPath.row <= self.setTopArray.count)) return 0;
    } else {
        if (!(indexPath.row <=self.dataArray.count)) return 0;
    }
    JstyleNewsHomePageModel *model = [JstyleNewsHomePageModel new];
    if (indexPath.section == 0) {
        model = self.setTopArray[indexPath.row];
    }else{
        model = self.dataArray[indexPath.row];

    }
    
    
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
                    return labelF.size.height+15+12+31;//OneImageArticleView
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self releaseVRPlayer];
//    NSLog(@"uid == %@",[[JstyleToolManager sharedManager] getUserId]);
    
    JstyleNewsHomePageModel *model = [JstyleNewsHomePageModel new];
    JstyleNewsArticleDetailModel *detailModel = [JstyleNewsArticleDetailModel new];
    
    if (indexPath.section==0) {
        if (indexPath.row >= self.setTopArray.count) return;
        model = self.setTopArray[indexPath.row];
        detailModel = self.setTopArray[indexPath.row];

    } else {
        
        if (indexPath.row >= self.dataArray.count) return;
        model = self.dataArray[indexPath.row];
        detailModel = self.detailDataArray[indexPath.row];

    }

    
    
    
    switch ([model.type integerValue]) {
        case 1:{
            if ([model.isImageArticle integerValue] == 1) {
                //图集（三图布局）
                JstylePictureTextViewController *jstyleNewsPictureTVC = [JstylePictureTextViewController new];
                jstyleNewsPictureTVC.rid = model.id;
                [self.navigationController pushViewController:jstyleNewsPictureTVC animated:YES];
            }else{
                //文章（三图布局）
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
                        jstyleNewsArticleDVC.rid = model.id;
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
                    JstyleNewsActivityWebViewController *jstyleNewsActivityWVC = [JstyleNewsActivityWebViewController new];
                    jstyleNewsActivityWVC.urlString = model.h5url;
                    jstyleNewsActivityWVC.isShare = model.isShare.integerValue;
                    [self.navigationController pushViewController:jstyleNewsActivityWVC animated:YES];
                }
                    break;
                case 4:{
                    //热门图书
          
                }
                    break;
                case 5:{
                    //活动详情
                    JstylePartyDetailsViewController *jstylePartyDetailsVC = [JstylePartyDetailsViewController new];
                    jstylePartyDetailsVC.partyId = model.rid;
                    [self.navigationController pushViewController:jstylePartyDetailsVC animated:YES];
                    
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

//自定义banner样式
- (Class)customCollectionViewCellClassForCycleScrollView:(SDCycleScrollView *)view
{
    return [JstyleNewsCustomBannerViewCell class];
}

- (void)setupCustomCell:(UICollectionViewCell *)cell forIndex:(NSInteger)index cycleScrollView:(SDCycleScrollView *)view
{
    if (index < self.bannerArray.count) {
        JstyleNewsHomePageModel *model = self.bannerArray[index];
        JstyleNewsCustomBannerViewCell *bannerCell = (JstyleNewsCustomBannerViewCell *)cell;
        [bannerCell.backImageView setImageWithURL:[NSURL URLWithString:model.poster] placeholder:SZ_Place_LIFE options:(YYWebImageOptionSetImageWithFadeAnimation) completion:nil];
        //bannerCell.nameLabel.text = [NSString stringWithFormat:@"%@", model.title];
    }
}

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    JstyleNewsHomePageModel *dataModel = self.bannerArray[index];
    switch ([dataModel.banner_type integerValue]) {
        case 1:{
            if ([dataModel.isImageArticle integerValue] == 1) {
                //图集
                JstylePictureTextViewController *jstyleNewsPictureTVC = [JstylePictureTextViewController new];
                jstyleNewsPictureTVC.rid = dataModel.rid;
                [self.navigationController pushViewController:jstyleNewsPictureTVC animated:YES];
            }else{
                //文章
                JstyleNewsArticleDetailViewController *jstyleNewsArticleDVC = [JstyleNewsArticleDetailViewController new];
                
                jstyleNewsArticleDVC.rid = dataModel.rid;
                JstyleNewsArticleDetailModel * model = [JstyleNewsArticleDetailModel new];
                model.title = dataModel.title;
                model.content = dataModel.content;
                model.author_img = dataModel.author_img;
                model.author_did = dataModel.author_did;
                model.author_name = dataModel.author_name;
                
                model.poster = dataModel.article_poster;
                model.ctime = dataModel.ctime;
                model.cname = dataModel.cname;
                model.isShowAuthor = dataModel.isShowAuthor;
                model.TOrFOriginal = dataModel.TOrFOriginal;
                jstyleNewsArticleDVC.titleModel = model;
                [self.navigationController pushViewController:jstyleNewsArticleDVC animated:YES];
            }
        }
            break;
        case 2:{
            //视频直播
            JstyleNewsVideoDetailViewController *jstyleNewsVideoDVC = [JstyleNewsVideoDetailViewController new];
            jstyleNewsVideoDVC.videoUrl = dataModel.url_sd;
            jstyleNewsVideoDVC.videoTitle = dataModel.title;
            jstyleNewsVideoDVC.vid = dataModel.rid;
            jstyleNewsVideoDVC.videoType = dataModel.videoType;
            [self.navigationController pushViewController:jstyleNewsVideoDVC animated:YES];
        }
            break;
        case 3:{
            //广告活动
            JstyleNewsActivityWebViewController *jstyleNewsActivityWVC = [JstyleNewsActivityWebViewController new];
            jstyleNewsActivityWVC.urlString = dataModel.h5url;
            jstyleNewsActivityWVC.isShare = dataModel.isShare.integerValue;
            [self.navigationController pushViewController:jstyleNewsActivityWVC animated:YES];
        }
            break;
        default:
            break;
    }
}

#pragma mark - 获取banner数据
- (void)loadJstyleNewsHomeBannerData
{
    NSDictionary *parameters = @{@"bcolumn":@"4"};
    [[JstyleNewsNetworkManager shareManager] GETURL:BANNER_LIST_URL parameters:parameters success:^(id responseObject) {
        if ([responseObject[@"code"] integerValue] == 1) {
            [self.bannerArray removeAllObjects];
            [self.cacheBannerArray removeAllObjects];
            
            [self.bannerArray addObjectsFromArray:[NSArray modelArrayWithClass:[JstyleNewsHomePageModel class] json:responseObject[@"data"]]];
            [self.cacheBannerArray addObjectsFromArray:responseObject[@"data"]];
            [self.cacheDict setObject:self.cacheBannerArray forKey:@"banner"];
            [self insertSqlite:self.cacheDict];
        }
        //获取普通数据
        [self loadJstyleNewsRefreshListData];
    } failure:^(NSError *error) {
        [self loadJstyleNewsRefreshListData];
    }];
}

/**获取数据 暂时已废*/
- (void)loadJstyleNewsHomeListData
{
    
    NSDictionary *parameters = @{@"page":[NSString stringWithFormat:@"%ld",(long)page],
                                 @"uid":[[JstyleToolManager sharedManager] getUserId],
                                 @"uuid":[[JstyleToolManager sharedManager] getUDID]
                                 };
    [[JstyleNewsNetworkManager shareManager] GETURL:HOME_PAGE_URL parameters:parameters success:^(id responseObject) {
        
        if ([responseObject[@"code"] integerValue] != 1) {
            if (self.dataArray.count) {
                [self.tableView.mj_header endRefreshing];
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }else{
                [self.tableView.mj_header endRefreshing];
                [self.tableView.mj_footer endRefreshing];
            }
            return;
        }
        
        if (page == 1) {
            [self.dataArray removeAllObjects];
            [self.cacheListArray removeAllObjects];
            [self.detailDataArray removeAllObjects];
        }
        
        [self.dataArray addObjectsFromArray:[NSArray modelArrayWithClass:[JstyleNewsHomePageModel class] json:responseObject[@"data"]]];
        [self.cacheListArray addObjectsFromArray:responseObject[@"data"]];
        [self.detailDataArray addObjectsFromArray:[NSArray modelArrayWithClass:[JstyleNewsArticleDetailModel class] json:responseObject[@"data"]]];
        
        [self.cacheDict setObject:self.cacheListArray forKey:@"list"];
        [self insertSqlite:self.cacheDict];
        
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    } failure:^(NSError *error) {
        [self. tableView reloadData];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
}

#pragma mark - 获取第一页普通数据
- (void)loadJstyleNewsRefreshListData
{
    JstyleNewsHomePageModel *model = self.dataArray.firstObject;
    NSDictionary *parameters = @{@"page":[NSString stringWithFormat:@"%ld",page],
                                 @"uid":[[JstyleToolManager sharedManager] getUserId],
                                 @"uuid":[[JstyleToolManager sharedManager] getUDID],
                                 @"refresh":(_isFirstRefresh?@"0":@"1"),
                                 @"last_time":[NSString stringWithFormat:@"%@", model.timestamp]
                                 };
    [[JstyleNewsNetworkManager shareManager] GETURL:HOME_TUIIJANPAGE_URL parameters:parameters success:^(id responseObject) {
        NSLog(@"%@",responseObject);
        if ([responseObject[@"code"] integerValue] != 1) {
            [self.tableView reloadData];
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
            [self.tipLabel showWithNoMoreData];
            return;
        }
        
        if (self.isFirstRefresh == YES) {
            [self.dataArray removeAllObjects];
            [self.cacheListArray removeAllObjects];
            [self.detailDataArray removeAllObjects];
            self.isFirstRefresh = NO;
        }
      
        
        NSArray *currentArray = [NSArray modelArrayWithClass:[JstyleNewsHomePageModel class] json:responseObject[@"data"]];
        [self.tipLabel showWithCount:currentArray.count];
        if (self.isFirstRefresh) {
            for (JstyleNewsHomePageModel *model in currentArray) {
                model.ctime = [NSDate currentTimeString];
            }
        }
        [self.dataArray insertObjects:currentArray atIndex:0];
        [self.detailDataArray insertObjects:[NSArray modelArrayWithClass:[JstyleNewsArticleDetailModel class] json:responseObject[@"data"]] atIndex:0];
        [self.cacheListArray insertObjects:responseObject[@"data"] atIndex:0];
        
        [self.cacheDict setObject:self.cacheListArray forKey:@"list"];
        [self insertSqlite:self.cacheDict];
        
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    } failure:^(NSError *error) {
        [self. tableView reloadData];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
}
#pragma mark - 下载更多数据
- (void)loadJstyleNewsMoreListData
{
    JstyleNewsHomePageModel *model = self.dataArray.lastObject;
    NSDictionary *parameters = @{@"page":[NSString stringWithFormat:@"%ld",page],
                                 @"uid":[[JstyleToolManager sharedManager] getUserId],
                                 @"uuid":[[JstyleToolManager sharedManager] getUDID],
                                 @"refresh":@"0",
                                 @"last_time":[NSString stringWithFormat:@"%@", model.timestamp]
                                 };
    [[JstyleNewsNetworkManager shareManager] GETURL:HOME_TUIIJANPAGE_URL parameters:parameters success:^(id responseObject) {
        
        if ([responseObject[@"code"] integerValue] != 1) {
            if (self.dataArray.count) {
                [self.tableView.mj_header endRefreshing];
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }else{
                [self.tableView.mj_header endRefreshing];
                [self.tableView.mj_footer endRefreshing];
            }
            return;
        }
        
        [self.dataArray addObjectsFromArray:[NSArray modelArrayWithClass:[JstyleNewsHomePageModel class] json:responseObject[@"data"]]];
        [self.cacheListArray addObjectsFromArray:responseObject[@"data"]];
        [self.detailDataArray addObjectsFromArray:[NSArray modelArrayWithClass:[JstyleNewsArticleDetailModel class] json:responseObject[@"data"]]];
        
        [self.cacheDict setObject:self.cacheListArray forKey:@"list"];
        [self insertSqlite:self.cacheDict];
        
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        
        [SVProgressHUD dismiss];
        [self.noSingleView removeFromSuperview];
        self.noSingleView = nil;
        self.tableView.scrollEnabled = YES;
        
    } failure:^(NSError *error) {
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        
        [SVProgressHUD dismiss];
        [self.noSingleView showNoConnectedLabelWithStatus:@"没有网络连接,请检查您的网络"];
    }];
}
#pragma mark 获取置顶数据
- (void)loadJstyleSetTopListData
{
    [self.setTopArray removeAllObjects];
    kweakSelf
    [[JstyleNewsNetworkManager shareManager] GETURL:HOME_TUIIJANTOP_URL parameters:nil success:^(id responseObject) {
        
        if ([responseObject[@"code"] integerValue] != 1) {
             [weakSelf loadJstyleNewsHomeBannerData];
            if (self.setTopArray.count) {
                [self.tableView.mj_header endRefreshing];
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }else{
                [self.tableView.mj_header endRefreshing];
                [self.tableView.mj_footer endRefreshing];
            }
            return;
        }
        [self.cacheSetTopArray removeAllObjects];
        
        [self.setTopArray addObjectsFromArray:[NSArray modelArrayWithClass:[JstyleNewsHomePageModel class] json:responseObject[@"data"]]];
        [self.cacheSetTopArray addObjectsFromArray:responseObject[@"data"]];
        [self.cacheDict setObject:self.cacheSetTopArray forKey:@"setTop"];
        [self insertSqlite:self.cacheDict];
        
        //获取轮播图数据
        [weakSelf loadJstyleNewsHomeBannerData];
        
    } failure:^(NSError *error) {
        
        [weakSelf loadJstyleNewsHomeBannerData];
        
    }];
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
    if (sender.tag >= self.dataArray.count) return;
    JstyleNewsHomePageModel *model = self.dataArray[sender.tag];
    self.shareModel = model;
    
    if (vrPlayer) {
        [self releaseVRPlayer];
    }
    
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

/**创建缓存表*/
- (void)creatTableSqlite
{
    // 获取路径
    NSString * documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *dbPath = [documentsPath stringByAppendingPathComponent:@"HomeNewsPage.sqlite"];
    
    // 初始化FMDB
    self.database = [FMDatabase databaseWithPath:dbPath];
    
    [self.database open];
    // executeUpdate:@"create table 表名 (列名 类型,..... )"
    FMResultSet * resultSet = [self.database executeQuery:@"select * from HomeNewsPage"];
    if ([resultSet next] == NO){
        [self.database executeUpdate:@"create table HomeNewsPage (HomeNewsData blob)"];
    }
    
    [self.database close];
}

- (void)insertSqlite:(NSDictionary *)sender {
    
    [self.database open];
    
    [self.database executeUpdate:@"DELETE FROM HomeNewsPage"];
    
    NSMutableArray *array = [NSMutableArray array];
    [array addObject:sender];
    
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:array];
    
    FMResultSet *resultSet =  [self.database executeQuery:@"insert into HomeNewsPage(HomeNewsData) values(?)" withArgumentsInArray:@[data]];
    [resultSet next];
    
    [self.database close];
}

/**取出缓存数据*/
- (void)getCacheDictionary
{
    NSString * documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *dbPath = [documentsPath stringByAppendingPathComponent:@"HomeNewsPage.sqlite"];
    self.database = [FMDatabase databaseWithPath:dbPath];
    [self.database open];
    FMResultSet * resultSet = [self.database executeQuery:@"select * from HomeNewsPage"];
    NSArray *cacheArray;
    while ([resultSet next] == YES){
        NSData *data = [resultSet dataForColumn:@"HomeNewsData"];
        cacheArray = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    }
    [self.database close];
    
    NSDictionary *dictionary = cacheArray[0];
    self.setTopArray = nil;
    self.bannerArray = nil;
    self.dataArray = nil;
    self.detailDataArray = nil;
    NSArray *setTopArray = dictionary[@"setTop"];
    NSArray *bannerArray = dictionary[@"banner"];
    NSArray *listArray = dictionary[@"list"];
    
    if (setTopArray.count) {
        [self.setTopArray addObjectsFromArray:[NSArray modelArrayWithClass:[JstyleNewsHomePageModel class] json:setTopArray]];
    }
    if (bannerArray.count) {
        [self.bannerArray addObjectsFromArray:[NSArray modelArrayWithClass:[JstyleNewsHomePageModel class] json:bannerArray]];
    }
    if (listArray.count) {
        [self.dataArray addObjectsFromArray:[NSArray modelArrayWithClass:[JstyleNewsHomePageModel class] json:listArray]];
        [self.detailDataArray addObjectsFromArray:[NSArray modelArrayWithClass:[JstyleNewsArticleDetailModel class] json:listArray]];
    }
    
    if (self.dataArray.count) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.noSingleView removeFromSuperview];
            self.noSingleView = nil;
            self.tableView.scrollEnabled = YES;
            [self.tableView reloadData];
        });
    }
    
    return;
}

- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (NSMutableArray *)setTopArray
{
    if (!_setTopArray) {
        _setTopArray = [NSMutableArray array];
    }
    return _setTopArray;
}

- (NSMutableArray<JstyleNewsArticleDetailModel *> *)detailDataArray {
    if (_detailDataArray == nil) {
        _detailDataArray = [NSMutableArray array];
    }
    return _detailDataArray;
}

- (NSMutableArray *)bannerArray
{
    if (!_bannerArray) {
        _bannerArray = [NSMutableArray array];
    }
    return _bannerArray;
}

- (NSMutableArray *)cacheBannerArray
{
    if (!_cacheBannerArray) {
        _cacheBannerArray = [NSMutableArray array];
    }
    return _cacheBannerArray;
}
//置顶
- (NSMutableArray *)cacheSetTopArray
{
    if (!_cacheSetTopArray) {
        _cacheSetTopArray = [NSMutableArray array];
    }
    return _cacheSetTopArray;
}

- (NSMutableArray *)cacheListArray
{
    if (!_cacheListArray) {
        _cacheListArray = [NSMutableArray array];
    }
    return _cacheListArray;
}

- (NSMutableDictionary *)cacheDict
{
    if (!_cacheDict) {
        _cacheDict = [NSMutableDictionary dictionary];
    }
    return _cacheDict;
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

