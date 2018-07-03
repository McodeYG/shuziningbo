//
//  JstyleNewsTagsVideoViewController.m
//  JstyleNews
//
//  Created by JingHongMuYun on 2017/12/14.
//  Copyright © 2017年 JstyleNews. All rights reserved.
//

#import "JstyleNewsTagsVideoViewController.h"
#import "JstyleNewsVideoHomeViewCell.h"
#import "JstyleNewsVideoHomeAdvertisementCell.h"
#import "JstyleNewsVideoDetailViewController.h"
#import "JstyleNewsActivityWebViewController.h"
#import "VRPlayerView.h"
#import "JstyleNewsVideoFullScreenShareView.h"
#import "JstyleNewsArticleDetailViewController.h"
#import "JstylePictureTextViewController.h"

@interface JstyleNewsTagsVideoViewController ()<UITableViewDelegate, UITableViewDataSource, VRPlayerViewDelegate>{
    VRPlayerView *vrPlayer;
    NSIndexPath *currentIndexPath;
}

@property(nonatomic, retain) JstyleNewsVideoHomeViewCell *currentCell;

@property (nonatomic, strong) JstyleNewsBaseTableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, strong) JstyleNewsVideoHomeModel *shareModel;

@end

static NSInteger page = 1;
@implementation JstyleNewsTagsVideoViewController

- (void)dealloc
{
    [self releaseVRPlayer];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.translucent = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = [NSString stringWithFormat:@"#%@", self.keyword];
//    self.view.backgroundColor = kWhiteColor;
    [self addTableView];
    [self addReshAction];
    [self.tableView.mj_header beginRefreshing];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self releaseVRPlayer];
}

- (void)addReshAction
{
    __weak typeof(self)weakSelf = self;
    self.tableView.mj_header = [JstyleRefreshGiftHeader headerWithRefreshingBlock:^{
        page = 1;
        [weakSelf.dataArray removeAllObjects];
        [weakSelf loadJstyleNewsVideoDataSource];
    }];
    
    self.tableView.mj_footer = [JstyleRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        page ++;
        [weakSelf loadJstyleNewsVideoDataSource];
    }];
}

- (void)addTableView
{
    _tableView = [[JstyleNewsBaseTableView alloc]initWithFrame:CGRectZero style:(UITableViewStylePlain)];
    _tableView.separatorInset = UIEdgeInsetsMake(0, 15, 0, 15);
//    _tableView.separatorColor = kSingleLineColor;
//    _tableView.backgroundColor = kWhiteColor;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    self.tableView.tableFooterView = [UIView new];
    
    [_tableView registerNib:[UINib nibWithNibName:@"JstyleNewsVideoHomeViewCell" bundle:nil] forCellReuseIdentifier:@"JstyleNewsVideoHomeViewCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"JstyleNewsVideoHomeAdvertisementCell" bundle:nil] forCellReuseIdentifier:@"JstyleNewsVideoHomeAdvertisementCell"];
    
    [self.view addSubview:_tableView];
    _tableView.sd_layout
    .topEqualToView(self.view)
    .bottomEqualToView(self.view)
    .leftEqualToView(self.view)
    .rightEqualToView(self.view);
}

#pragma mark -- tableView的代理方法
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    JstyleNewsVideoHomeModel *model = self.dataArray[indexPath.row];
    switch ([model.type integerValue]) {
        case 2:{
            static NSString *ID = @"JstyleNewsVideoHomeViewCell";
            JstyleNewsVideoHomeViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
            if (!cell) {
                cell = [[JstyleNewsVideoHomeViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
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
            
            if (self.dataArray.count) {
                cell.model = self.dataArray[indexPath.row];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
            break;
        case 3:{
            static NSString *ID = @"JstyleNewsVideoHomeAdvertisementCell";
            JstyleNewsVideoHomeAdvertisementCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
            if (!cell) {
                cell = [[JstyleNewsVideoHomeAdvertisementCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
            }
            
            if (self.dataArray.count) {
                cell.model = self.dataArray[indexPath.row];
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    JstyleNewsVideoHomeModel *model = self.dataArray[indexPath.row];
    switch ([model.type integerValue]) {
        case 2:{
            return [self.tableView cellHeightForIndexPath:indexPath model:self.dataArray[indexPath.row] keyPath:@"model" cellClass:[JstyleNewsVideoHomeViewCell class] contentViewWidth:kScreenWidth];
        }
            break;
        case 3:
            return [self.tableView cellHeightForIndexPath:indexPath model:self.dataArray[indexPath.row] keyPath:@"model" cellClass:[JstyleNewsVideoHomeAdvertisementCell class] contentViewWidth:kScreenWidth];
            break;
        default:
            return 0;
            break;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self releaseVRPlayer];
    if (indexPath.row >= self.dataArray.count) return;
    JstyleNewsVideoHomeModel *model = self.dataArray[indexPath.row];
    if ([model.type integerValue] == 2) {
        JstyleNewsVideoDetailViewController *jstyleNewsVideoDVC = [JstyleNewsVideoDetailViewController new];
        jstyleNewsVideoDVC.videoUrl = model.url_sd;
        jstyleNewsVideoDVC.videoTitle = model.title;
        jstyleNewsVideoDVC.vid = model.sendId;
        jstyleNewsVideoDVC.videoType = model.videoType;
        [self.navigationController pushViewController:jstyleNewsVideoDVC animated:YES];
    }else if ([model.type integerValue] == 3) {
        //广告活动
        switch ([model.banner_type integerValue]) {
            case 1:
                //文章
                if ([model.isImageArticle integerValue] == 1) {
                    //图集
                    JstylePictureTextViewController *jstyleNewsPictureTVC = [JstylePictureTextViewController new];
                    jstyleNewsPictureTVC.rid = model.sendId;
                    [self.navigationController pushViewController:jstyleNewsPictureTVC animated:YES];
                }else{
                    //文章
                    JstyleNewsArticleDetailViewController *jstyleNewsArticleDVC = [JstyleNewsArticleDetailViewController new];
                    jstyleNewsArticleDVC.rid = model.sendId;
                    [self.navigationController pushViewController:jstyleNewsArticleDVC animated:YES];
                }
                break;
            case 2:{
                //视频直播
                JstyleNewsVideoDetailViewController *jstyleNewsVideoDVC = [JstyleNewsVideoDetailViewController new];
                jstyleNewsVideoDVC.videoUrl = model.url_sd;
                jstyleNewsVideoDVC.videoTitle = model.title;
                jstyleNewsVideoDVC.vid = model.sendId;
                jstyleNewsVideoDVC.videoType = model.videoType;
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
            default:
                break;
        }
    }
}

#pragma mark - 获取数据
- (void)loadJstyleNewsVideoDataSource
{
    NSDictionary *parameters = @{@"page":[NSString stringWithFormat:@"%ld",page],
                                 @"keywords":self.keyword
                                 };
    [[JstyleNewsNetworkManager shareManager] GETURL:HOME_PAGE_VIDEO_URL parameters:parameters success:^(id responseObject) {
        
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
        
        [self.dataArray addObjectsFromArray:[NSArray modelArrayWithClass:[JstyleNewsVideoHomeModel class] json:responseObject[@"data"]]];
        
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    } failure:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
}

#pragma mark 视频列表播放的相关代码
//把播放器vrPlayer对象放到cell上，同时更新约束
- (void)toCell{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"JstyleLandscapeRight"];
    JstyleNewsVideoHomeViewCell *currentCell = (JstyleNewsVideoHomeViewCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:currentIndexPath.row inSection:0]];
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
    self.currentCell = (JstyleNewsVideoHomeViewCell *)cellView;
    if (sender.tag >= self.dataArray.count) return;
    JstyleNewsVideoHomeModel *model = self.dataArray[sender.tag];
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
    vrPlayer.bottomView.hidden = NO;
    
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

- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}


- (UIStatusBarStyle)preferredStatusBarStyle {
    
    return  ISNightMode?UIStatusBarStyleLightContent:UIStatusBarStyleDefault;
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

