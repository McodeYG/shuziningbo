//
//  JstyleNewsVideoDetailViewController.m
//  JstyleNews
//
//  Created by JingHongMuYun on 2017/12/4.
//  Copyright © 2017年 JstyleNews. All rights reserved.
//

#import "JstyleNewsVideoDetailViewController.h"
#import "VRPlayerView.h"
#import "JstyleNewsVideoDetailIntroViewCell.h"
#import "JstyleNewsVideoDetailIntroNoJmsViewCell.h"
#import "JstyleNewsVideoDetailTuijianViewCell.h"
#import "JstyleNewsCommentPlaceHolderCell.h"
#import "JstyleNewsCommentViewCell.h"
#import "JstyleNewsCommentViewController.h"
#import "JstyleNewsCoverCommentViewController.h"
#import "JstyleNewsVideoDetailIntroModel.h"
#import "JstyleNewsJMNumDetailsViewController.h"
#import "JstyleNewsVideoFullScreenShareView.h"

@interface JstyleNewsVideoDetailViewController ()<UITableViewDelegate, UITableViewDataSource, VRPlayerViewDelegate, UIGestureRecognizerDelegate, UITextViewDelegate,CommentViewCellDelegate>

@property (nonatomic, strong) JstyleNewsBaseTableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, strong) NSMutableArray *commentArray;

@property (nonatomic, copy) NSString *commentCount;

@property (nonatomic, copy) NSString *contentId;

@property (nonatomic, strong) JstyleNewsVideoDetailIntroModel *model;

/**播放器*/
@property (nonatomic, strong)VRPlayerView *vrPlayer;
/**判断是否全屏*/
@property (nonatomic, assign) BOOL isFullScreen;
/**状态栏隐藏状态*/
@property (nonatomic, assign) BOOL statusBarHidden;

@property (nonatomic, strong) UIView *commentBar;
@property (nonatomic, strong) UITextView *commentTextView;
@property (nonatomic, strong) UILabel *placeHolder;
@property (nonatomic, strong) UIButton *sendButton;
@property (nonatomic, strong) UIView *toolBarHoldView;

/**底部评论点赞view*/
@property (nonatomic, strong) JstyleNewsBaseBottomView *bottomView;
@property (nonatomic, strong) UIButton *shouCangBtn;
@property (nonatomic, strong) UILabel *dianZanLabel;
@property (nonatomic, strong) UIButton *dianZanBtn;

@property (nonatomic, copy) NSString *shareImgUrl;
@property (nonatomic, copy) NSString *shareUrl;
@property (nonatomic, copy) NSString *shareTitle;
@property (nonatomic, copy) NSString *shareDesc;

@property (nonatomic, strong) JstyleNewsNoSinglePlaceholderView *noSingleView;

@end

@implementation JstyleNewsVideoDetailViewController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"JstyleLandscapeRight"];
    [self releaseWMPlayer];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.statusBarHidden = YES;
    [self setNeedsStatusBarAppearanceUpdate];

    [self addPlayerAndViews];
    [self setBottomViewAndButtons];
    [self addTableView];
    [self addCommentToolBar];
    [self addReshAction];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(videoDetailTuijianClicked:) name:@"VideoDetailTuijianClicked" object:nil];
    
    [self getShareData];
    
    [self addNoSingleView];
}

- (void)addNoSingleView{
    if ([[JstyleToolManager sharedManager] getCurrentNetStatus] == NotReachable) {
        self.noSingleView = [[JstyleNewsNoSinglePlaceholderView alloc] initWithFrame:CGRectMake(0, kScreenWidth*9/16, kScreenWidth, (kScreenHeight - kScreenWidth*9/16 - (IS_iPhoneX ? 58 : 48)))];
        [self.view addSubview:self.noSingleView];
        self.tableView.scrollEnabled = NO;
        __weak typeof(self)weakSelf = self;
        self.noSingleView.reloadBlock = ^{
            [SVProgressHUD showWithStatus:@"正在努力加载"];
            [weakSelf loadJstyleNewsVideoDataSource];
        };
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    [_vrPlayer play];
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    [self loadJstyleNewsVideoDataSource];
    [self getJstyleNewsVideoPraiseStatus];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
    [self.vrPlayer pause];
    self.navigationController.interactivePopGestureRecognizer.delegate = nil;
}

- (void)addReshAction
{
    __weak typeof(self)weakSelf = self;
    self.tableView.mj_header = [JstyleRefreshGiftHeader headerWithRefreshingBlock:^{
        weakSelf.model = nil;
        [weakSelf.dataArray removeAllObjects];
        [weakSelf loadJstyleNewsVideoDataSource];
    }];
}

- (void)addTableView
{
    _tableView = [[JstyleNewsBaseTableView alloc]initWithFrame:CGRectZero style:(UITableViewStyleGrouped)];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    _tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
//    _tableView.separatorColor = kSingleLineColor;
//    _tableView.backgroundColor = kWhiteColor;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    self.tableView.tableFooterView = [UIView new];
    
    [_tableView registerNib:[UINib nibWithNibName:@"JstyleNewsVideoDetailIntroViewCell" bundle:nil] forCellReuseIdentifier:@"JstyleNewsVideoDetailIntroViewCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"JstyleNewsVideoDetailIntroNoJmsViewCell" bundle:nil] forCellReuseIdentifier:@"JstyleNewsVideoDetailIntroNoJmsViewCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"JstyleNewsCommentViewCell" bundle:nil] forCellReuseIdentifier:@"JstyleNewsCommentViewCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"JstyleNewsCommentPlaceHolderCell" bundle:nil] forCellReuseIdentifier:@"JstyleNewsCommentPlaceHolderCell"];

    [self.view insertSubview:_tableView belowSubview:_vrPlayer];
    _tableView.sd_layout
    .topSpaceToView(self.view, kScreenWidth * 9 /16)
    .bottomSpaceToView(self.bottomView, 0)
    .leftEqualToView(self.view)
    .rightEqualToView(self.view);
}

#pragma mark -- tableView的代理方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case 1:
            if (!self.dataArray.count) {
        static NSString *ID = @"cellID";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
            return [self addHeaderViewWithTitle:@"相关推荐视频" columnHidden:YES];
            break;
        case 2:
            return [self addHeaderViewWithTitle:@"最新评论" columnHidden:NO];
            break;
        default:
            return nil;
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case 1:
            if (!self.dataArray.count) return 0.01;
            return 48;
            break;
        case 2:
            return 58;
            break;
        default:
            return 0.01;
            break;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section == 2 && [self.commentCount integerValue] > 2) return [self addFooterViewWithTitle:[NSString stringWithFormat:@"查看全部%@条评论",self.commentCount]];
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 2 && [self.commentCount integerValue] > 2) return 78;
    return 0.01;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            if (!self.model) return 0;
            return 1;
            break;
        case 1:
            if (!self.dataArray.count) return 0;
            return 1;
            break;
        case 2:
            if(!self.commentArray.count) return 1;
            return self.commentArray.count;
            break;
        default:
            return 0;
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:{
            if ([self.model.isShowAuthor integerValue] == 0) {//不显示自媒体信息
                static NSString *ID = @"JstyleNewsVideoDetailIntroNoJmsViewCell";
                JstyleNewsVideoDetailIntroNoJmsViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
                if (!cell) {
                    cell = [[JstyleNewsVideoDetailIntroNoJmsViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
                }
                if (self.model) {
//                    _vrPlayer.title = self.model.title;
                    cell.model = self.model;
                }
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                return cell;
            }//显示自媒体信息
            static NSString *ID = @"JstyleNewsVideoDetailIntroViewCell";
            JstyleNewsVideoDetailIntroViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
            if (!cell) {
                cell = [[JstyleNewsVideoDetailIntroViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
            }
            __weak typeof(self)weakSelf = self;
            cell.jmNumDetailBlock = ^(NSString *did) {
                JstyleNewsJMNumDetailsViewController *jstylePersonalMVC = [JstyleNewsJMNumDetailsViewController new];
                jstylePersonalMVC.did = did;
                [weakSelf.navigationController pushViewController:jstylePersonalMVC animated:YES];
            };
            cell.focusBlock = ^{
                if ([[JstyleToolManager sharedManager] isTourist]) {
                    [[JstyleToolManager sharedManager] loginInViewController];
                    return;
                }
                [weakSelf addJstyleNewsManagerSubscription];
            };
            if (self.model) {
                cell.model = self.model;
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
            break;
        case 1:{//推荐
            static NSString *ID = @"JstyleNewsVideoDetailTuijianViewCell";
            JstyleNewsVideoDetailTuijianViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
            if (!cell) {
                cell = [[JstyleNewsVideoDetailTuijianViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
            }
            
            [cell.videoCollectionView reloadDataWithDataArray:self.dataArray];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
            break;
        case 2:{//评论
            if (!self.commentArray.count) {
                static NSString *ID = @"JstyleNewsCommentPlaceHolderCell";
                JstyleNewsCommentPlaceHolderCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
                if (!cell) {
                    cell = [[JstyleNewsCommentPlaceHolderCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
                }
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                return cell;
            }else{
                static NSString *ID = @"JstyleNewsCommentViewCell";
                JstyleNewsCommentViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
                if (!cell) {
                    cell = [[JstyleNewsCommentViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
                }
                __weak typeof(self)weakSelf = self;
                cell.replyBtn.userInteractionEnabled = NO;
                cell.replyBlock = ^(NSString *userName, NSString *contentId) {
                    weakSelf.placeHolder.text = [NSString stringWithFormat:@"回复给%@:", userName];
                    [weakSelf.commentTextView becomeFirstResponder];
                    weakSelf.contentId = contentId;
                };
                cell.praiseBlock = ^(NSString *contentId, BOOL isSelected) {
                    [weakSelf addJstyleNewsVideoPraiseWithRid:contentId indexPath:indexPath];
                };
                
                if (indexPath.row < self.commentArray.count) {
                    cell.model = self.commentArray[indexPath.row];
                }
                cell.index = indexPath;
                cell.delegate = self;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                return cell;
            }
        }
            break;
        default:
            return nil;
            break;
    }
}
#pragma mark - 展开按钮
-(void)cell:(JstyleNewsCommentViewCell *)cell unflodBtnAction:(UIButton *)button {
    
    cell.model.isShowBtn = NO;
    
    [self.tableView reloadRowsAtIndexPaths:@[cell.index] withRowAnimation:(UITableViewRowAnimationFade)];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:{
            if ([self.model.isShowAuthor integerValue] == 0) {
                return [self.tableView cellHeightForIndexPath:indexPath model:self.model keyPath:@"model" cellClass:[JstyleNewsVideoDetailIntroNoJmsViewCell class] contentViewWidth:kScreenWidth];
            }
            return [self.tableView cellHeightForIndexPath:indexPath model:self.model keyPath:@"model" cellClass:[JstyleNewsVideoDetailIntroViewCell class] contentViewWidth:kScreenWidth];
        }
            break;
        case 1:
            if (!self.dataArray.count) return 0;
            return 160;
            break;
        case 2:
        {
            if (!self.commentArray.count) return 10;
            
            JstyleNewsCommentModel * model = self.commentArray[indexPath.row];
            NSString * comment = [NSString stringWithFormat:@"%@",model.content];
            
            CGFloat comH = [comment heightForFont:[UIFont systemFontOfSize:14] width:SCREEN_W-35-32];
            if (comH>70&&model.isShowBtn) {
                return 15+32+15+70+ 5+22+10;
            } else {
                return 15+32+15+comH+10;
            }
//            return [self.tableView cellHeightForIndexPath:indexPath model:self.commentArray[indexPath.row] keyPath:@"model" cellClass:[JstyleNewsCommentViewCell class] contentViewWidth:kScreenWidth];
        }
            break;
        default:
            return 0;
            break;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 2) {
        if (indexPath.row < self.commentArray.count) {
            JstyleNewsCommentModel *model = self.commentArray[indexPath.row];
            JstyleNewsCoverCommentViewController *jstyleNewsVideoCCVC = [JstyleNewsCoverCommentViewController new];
            jstyleNewsVideoCCVC.model = model;
            jstyleNewsVideoCCVC.vid = self.vid;
            jstyleNewsVideoCCVC.type = @"2";
            [self.navigationController pushViewController:jstyleNewsVideoCCVC animated:YES];
        }
    }
}

#pragma mark - 获取数据
- (void)loadJstyleNewsVideoDataSource
{
    
    NSDictionary *parameters = @{@"vid":self.vid,
                                 @"uid":[[JstyleToolManager sharedManager] getUserId],
                                 @"uuid":[[JstyleToolManager sharedManager] getUDID]
                                 };
    
    if ([[JstyleToolManager sharedManager] isTourist]) {
        parameters = @{@"vid":self.vid,
                       @"uuid":[[JstyleToolManager sharedManager] getUDID]
                       };
    }
    
    [[JstyleNewsNetworkManager shareManager] GETURL:VIDEO_DETAIL_URL parameters:parameters success:^(id responseObject) {
        
        if ([responseObject[@"code"] integerValue] != 1) {
            ZTShowAlertMessage(@"视频已被删除");
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];

            });
            return;
        }
        
        [self.commentArray removeAllObjects];
        [self.dataArray removeAllObjects];
        self.model = [JstyleNewsVideoDetailIntroModel modelWithDictionary:responseObject[@"data"][@"videodetail"]];
        self.model.isShowAuthor = responseObject[@"data"][@"isShowAuthor"];
        if ([self.videoname isNotBlank]) {
            self.model.videoname = self.videoname;
        }
        [self.dataArray addObjectsFromArray:[NSArray modelArrayWithClass:[JstyleNewsVideoDetailTuijianModel class] json:responseObject[@"data"][@"videoass"]]];
        [self.commentArray addObjectsFromArray:[NSArray modelArrayWithClass:[JstyleNewsCommentModel class] json:responseObject[@"data"][@"commentList"]]];
        
        self.commentCount = responseObject[@"data"][@"commentCount"];

        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        
        if (![self.videoUrl isNotBlank]) {//视频详情
            NSDictionary * dic = responseObject[@"data"][@"videodetail"];
            self.videoUrl = dic[@"url_sd"];
            self.videoType = dic[@"videoType"];
            
            [self addPlayerAndViews];
        }
        
        [self.noSingleView removeFromSuperview];
        self.tableView.scrollEnabled = YES;
        [SVProgressHUD dismiss];
        
    } failure:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        [SVProgressHUD dismiss];
        ZTShowAlertMessage(@"加载失败,请检查您的网络状态");
    }];
}

/**添加评论数据*/
- (void)addJstyleNewsVideoCommentData
{
    NSDictionary *parameters = @{@"uid":[[JstyleToolManager sharedManager] getUserId],
                                 @"type":@"2",
                                 @"hid":self.vid,
                                 @"content":self.commentTextView.text,
                                 @"pid":@""
                                 };
    [[JstyleNewsNetworkManager shareManager] POSTURL:ADD_COMMENT_URL parameters:parameters success:^(id responseObject) {
        
        if ([responseObject[@"code"] integerValue] == 1) {
            ZTShowAlertMessage(@"发布成功");
            self.commentTextView.text = @"";
            self.placeHolder.hidden = NO;
            [self loadJstyleNewsVideoDataSource];
        }
        
    } failure:^(NSError *error) {
        ZTShowAlertMessage(@"评论失败, 请稍后再试");
    }];
}

/**回复某条评论数据*/
- (void)addJstyleNewsVideoCommentWithPid:(NSString *)pid
{
    NSDictionary *parameters = @{@"uid":[[JstyleToolManager sharedManager] getUserId],
                                 @"type":@"2",
                                 @"hid":self.vid,
                                 @"content":self.commentTextView.text,
                                 @"pid":pid
                                 };
    [[JstyleNewsNetworkManager shareManager] POSTURL:ADD_COMMENT_URL parameters:parameters success:^(id responseObject) {
        
        if ([responseObject[@"code"] integerValue] == 1) {
            ZTShowAlertMessage(@"回复成功");
            self.commentTextView.text = @"";
            self.placeHolder.hidden = NO;
            [self loadJstyleNewsVideoDataSource];
        }
        
    } failure:^(NSError *error) {
        ZTShowAlertMessage(@"评论失败, 请稍后再试");
    }];
}

/**获取点赞、收藏状态*/
- (void)getJstyleNewsVideoPraiseStatus
{
    NSDictionary *parameters = @{@"platform_type":@"2",
                                 @"rid":[NSString stringWithFormat:@"%@",self.vid],
                                 @"type":@"2",
                                 @"uid":[[JstyleToolManager sharedManager] getUserId],
                                 @"uuid":[[JstyleToolManager sharedManager] getUDID]
                                 };
    [[JstyleNewsNetworkManager shareManager] GETURL:GET_PRAISESTATE_URL parameters:parameters success:^(id responseObject) {
        
        if ([responseObject[@"code"] integerValue] == 1) {
            NSString *numStr = responseObject[@"data"][@"praise_num"];
            if ([numStr integerValue] > 9999) {
                self.dianZanLabel.text = [NSString stringWithFormat:@"%.1f万  ",[numStr integerValue]/10000.0];
            }else{
                self.dianZanLabel.text = [NSString stringWithFormat:@"%@  ",numStr];
            }
            
            if ([responseObject[@"data"][@"praise_type"] integerValue] == 1) {
                [self.dianZanBtn setImage:JSImage(@"视频点赞红") forState:(UIControlStateNormal)];
            }else{
                [self.dianZanBtn setImage:JSImage(@"视频点赞线") forState:(UIControlStateNormal)];
            }
            
            if ([responseObject[@"data"][@"follow_type"] integerValue] == 1) {
                [self.shouCangBtn setImage:JSImage(@"视频收藏红") forState:(UIControlStateNormal)];
            }else{
                [self.shouCangBtn setImage:JSImage(@"视频收藏线") forState:(UIControlStateNormal)];
            }
        }
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        [self.tableView reloadData];
    }];
}

/**添加视频点赞、收藏*/
- (void)addJstyleNewsVideoPraise
{
    NSDictionary *parameters = @{@"platform_type":@"2",
                                 @"rid":[NSString stringWithFormat:@"%@",self.vid],
                                 @"type":@"2",
                                 @"uid":[[JstyleToolManager sharedManager] getUserId],
                                 @"uuid":[[JstyleToolManager sharedManager] getUDID]
                                 };
    [[JstyleNewsNetworkManager shareManager] GETURL:ADD_PRAISE_URL parameters:parameters success:^(id responseObject) {
        
        if ([responseObject[@"code"] integerValue] == 1) {
            UIImpactFeedbackGenerator *feedback = [[UIImpactFeedbackGenerator alloc] initWithStyle:UIImpactFeedbackStyleLight];
            [feedback impactOccurred];
            if ([responseObject[@"data"][@"praise_type"] integerValue] == 1) {
                //ZTShowAlertMessage(@"点赞成功");
                [self.dianZanBtn setImage:JSImage(@"视频点赞红") forState:(UIControlStateNormal)];
                [ThumbUpSpecialEffec addThumbUpSpecialEffecWithBigShineColor:RGBACOLOR(255, 95, 89, 1) smallShineColor:RGBACOLOR(216, 152, 148, 1) shineFillColor:RGBACOLOR(171, 171, 171, 1) button:self.dianZanBtn];
            }else{
                //ZTShowAlertMessage(@"取消点赞");
                [self.dianZanBtn setImage:JSImage(@"视频点赞线") forState:(UIControlStateNormal)];
            }
            
            NSString *numStr = responseObject[@"data"][@"praise_num"];
            
            if ([numStr integerValue] > 9999) {
                self.dianZanLabel.text = [NSString stringWithFormat:@"%.1f万  ",[numStr integerValue]/10000.0];
            }else{
                self.dianZanLabel.text = [NSString stringWithFormat:@"%@  ",numStr];
            }
        }else{
            ZTShowAlertMessage(responseObject[@"data"]);
        }
    } failure:nil];
}

//收藏视频
- (void)addJstyleNewsVideoCollection
{
    NSDictionary *parameters = @{@"platform_type":@"2",
                                 @"rid":[NSString stringWithFormat:@"%@",self.vid],
                                 @"type":@"2",
                                 @"uid":[[JstyleToolManager sharedManager] getUserId],
                                 @"uuid":[[JstyleToolManager sharedManager] getUDID]
                                 };
    [[JstyleNewsNetworkManager shareManager] GETURL:ADD_COLLECTION_URL parameters:parameters success:^(id responseObject) {
        if ([responseObject[@"code"] integerValue] == 1) {
            [self.shouCangBtn setImage:JSImage(@"视频收藏红") forState:(UIControlStateNormal)];
        }else{
            [self.shouCangBtn setImage:JSImage(@"视频收藏线") forState:(UIControlStateNormal)];
        }
    } failure:nil];
}

- (void)addJstyleNewsManagerSubscription
{
    if ([[JstyleToolManager sharedManager] isTourist]) {
        [[JstyleToolManager sharedManager] loginInViewController];
        return;
    }
    NSDictionary *parameters = @{@"platform_type":@"2",
                                 @"did":self.model.author_did,
                                 @"uid":[[JstyleToolManager sharedManager] getUserId]
                                 };
    [[JstyleNewsNetworkManager shareManager] GETURL:MANAGER_SUBSCRIPTION_URL parameters:parameters success:^(id responseObject) {
        if ([responseObject[@"code"] integerValue] == 1) {
            
            if (@available(iOS 10.0, *)) {
                UIImpactFeedbackGenerator *impactFeedback = [[UIImpactFeedbackGenerator alloc] initWithStyle:UIImpactFeedbackStyleLight];
                [impactFeedback impactOccurred];
            }
            
            
            NSString *followType = responseObject[@"data"][@"follow_type"];
            self.model.isShowAuthor = followType;
            [self.tableView reloadRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] withRowAnimation:(UITableViewRowAnimationNone)];
        }else{
            if ([responseObject[@"data"] isKindOfClass:[NSString class]]) {
                ZTShowAlertMessage(responseObject[@"data"]);
            }
        }
    } failure:nil];
}

/**添加评论点赞*/
- (void)addJstyleNewsVideoPraiseWithRid:(NSString *)rid indexPath:(NSIndexPath *)indexPath
{
    NSDictionary *parameters = @{@"platform_type":@"2",
                                 @"rid":rid,
                                 @"type":@"3",
                                 @"uid":[[JstyleToolManager sharedManager] getUserId],
                                 @"uuid":[[JstyleToolManager sharedManager] getUDID]
                                 };
    [[JstyleNewsNetworkManager shareManager] GETURL:ADD_PRAISE_URL parameters:parameters success:^(id responseObject) {
        
        if ([responseObject[@"code"] integerValue] == 1) {
            JstyleNewsCommentModel *model = self.commentArray[indexPath.row];
            model.is_praise = responseObject[@"data"][@"praise_type"];
            NSInteger praise = [model.praise_num integerValue];
            if ([model.is_praise integerValue] == 1) {
                praise +=1;
            } else {
                if (praise>0) {
                    praise-=1;
                }
            }
            model.praise_num = [NSString stringWithFormat:@"%ld",praise];
        
            JstyleNewsCommentViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
            cell.thumbNumLabel.text = [NSString stringWithFormat:@"%@",model.praise_num];
            if ([model.is_praise integerValue] == 1) {
                [cell.thumbBtn setImage:JSImage(@"点赞-面") forState:(UIControlStateNormal)];
                [ThumbUpSpecialEffec addThumbUpSpecialEffecWithBigShineColor:kLightBlueColor smallShineColor:kLightBlueColor shineFillColor:kLightBlueColor button:cell.thumbBtn];
            }else{
                [cell.thumbBtn setImage:JSImage(@"点赞-线") forState:(UIControlStateNormal)];
            }
        }
    } failure:nil];
}

/**分享数据*/
-(void)getShareData
{
    NSDictionary *parameters = @{@"platform_type":@"2",
                                 @"uid":[[JstyleToolManager sharedManager] getUserId],
                                 @"uuid":[[JstyleToolManager sharedManager] getUDID],
                                 @"id":self.vid,
                                 @"type":@"1"};
    [[JstyleNewsNetworkManager shareManager] POSTURL:COMMON_SHARE_URL parameters:parameters success:^(id responseObject) {
        if ([responseObject[@"code"] integerValue] == 1) {
            self.shareUrl = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"ashareurl"]];
            self.shareTitle = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"title"]];
            self.shareImgUrl = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"poster"]];
            self.shareDesc = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"describes"]];
        }
        
    } failure:^(NSError *error) {
        
    }];
}

- (void)addPlayerAndViews
{
    if (_vrPlayer) {
     
        [_vrPlayer removeFromSuperview];
    }
    self.isFullScreen = NO;
    if ([self.videoUrl containsString:@"rtmp://"]) {
        _vrPlayer = [[VRPlayerView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenWidth * 9 /16) withVrUrl:[NSURL URLWithString:self.videoUrl] withVrType:VrType_FFmpeg_Normal];
    }else{
        //myg是不是VR
        if ([self.videoType isEqualToString:@"1"]) {//是VR
//            NSLog(@"%@",self.videoUrl);
//            NSURL * url = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"aodaliya" ofType:@"mp4"]];
            NSURL * url = [NSURL URLWithString:self.videoUrl];
            _vrPlayer = [[VRPlayerView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenWidth * 9 /16) withVrUrl:url withVrType:VrType_AVPlayer_VR];//

            _vrPlayer.boxButton.hidden = NO;
        } else {
            _vrPlayer = [[VRPlayerView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenWidth * 9 /16) withVrUrl:[NSURL URLWithString:self.videoUrl] withVrType:VrType_AVPlayer_Normal];
            _vrPlayer.boxButton.hidden = YES;

        }
    }
    if (IS_iPhoneX) {
        _vrPlayer.backBtn.sd_layout
        .topSpaceToView(_vrPlayer.bottomView, 35)
        .leftSpaceToView(_vrPlayer.bottomView, 10)
        .widthIs(30)
        .heightIs(30);
        
        _vrPlayer.moreBtn.sd_layout
        .topSpaceToView(_vrPlayer.bottomView, 35)
        .rightSpaceToView(_vrPlayer.bottomView, 10)
        .widthIs(30)
        .heightIs(30);
        
        _vrPlayer.liveTitleLabel.sd_layout
        .centerYEqualToView(_vrPlayer.backBtn)
        .leftSpaceToView(_vrPlayer.backBtn, 10)
        .rightSpaceToView(_vrPlayer.moreBtn, 10)
        .heightIs(20);
    }
    _vrPlayer.title = self.videoTitle;
    _vrPlayer.delegate = self;
    _vrPlayer.bottomView.hidden = YES;
    
    [self.view addSubview:_vrPlayer];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(videoAndLiveEnterBackground) name:@"VideoAndLiveEnterBackground" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(videoAndLiveEnterForeground) name:@"VideoAndLiveEnterForeground" object:nil];
    
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
}


/**
 * 添加评论输入框
 */
- (void)addCommentToolBar
{
    _commentBar = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight - 124, kScreenWidth, 124)];
    _commentBar.backgroundColor = [UIColor whiteColor];
    _commentTextView = [[UITextView alloc] initWithFrame:CGRectMake(15, 15, kScreenWidth - 30, 60)];
    _commentTextView.tintColor = kNormalRedColor;
    _commentTextView.returnKeyType = UIReturnKeyDefault;
    _commentTextView.keyboardAppearance = ISNightMode?UIKeyboardAppearanceDark:UIKeyboardAppearanceDefault;
    _commentTextView.font = [UIFont systemFontOfSize:14];
    _commentTextView.textColor = kDarkTwoColor;
    _commentTextView.delegate = self;
    [_commentBar addSubview:_commentTextView];
    
    _placeHolder = [[UILabel alloc]initWithFrame:CGRectMake(7, 10, _commentTextView.width - 10, 14)];
    _placeHolder.text = @"说点什么...";
    _placeHolder.textColor = kDarkNineColor;
    _placeHolder.font = [UIFont systemFontOfSize:14];
    [_commentTextView addSubview:_placeHolder];
    
    _sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _sendButton.frame = CGRectMake(kScreenWidth - 80, 85, 70, 30);
    [_sendButton setTitle:@"发送" forState:UIControlStateNormal];
    [_sendButton setTitleColor:kWhiteColor forState:UIControlStateNormal];
    _sendButton.tintColor = [UIColor whiteColor];
    _sendButton.backgroundColor = kPinkColor;
    _sendButton.titleLabel.font = JSFont(14);
    _sendButton.layer.cornerRadius = 15;
    _sendButton.layer.masksToBounds = YES;
    [_sendButton addTarget:self action:@selector(sendButtonClicked:) forControlEvents:(UIControlEventTouchUpInside)];
    [_commentBar addSubview:_sendButton];
    
    _sendButton.lee_theme
    .LeeCustomConfig(ThemeMainBtnTitleOrBorderColor, ^(id item, id value) {
        [item layer].backgroundColor = [value CGColor];
    });
    
    _toolBarHoldView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    _toolBarHoldView.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.3];
    
    [_toolBarHoldView addSubview:_commentBar];
    [self.view addSubview:_toolBarHoldView];
    _toolBarHoldView.hidden = YES;
    [self registKeyboardNotifications];
}

/**textView的代理方法*/
- (void)textViewDidChange:(UITextView *)textView
{
    if (self.commentTextView.text.length) {
        self.placeHolder.hidden = YES;
    }else{
        self.placeHolder.hidden = NO;
    }
}

- (void)registKeyboardNotifications
{
    //增加监听，当键盘出现或改变时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    //增加监听，当键退出时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

//当键盘出现或改变时调用
- (void)keyboardWillShow:(NSNotification *)notification
{
    _toolBarHoldView.hidden = NO;
    //获取键盘的高度
    NSDictionary *userInfo = [notification userInfo];
    NSValue *value = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect rect = [value CGRectValue];
    _commentBar.y = rect.origin.y - _commentBar.height;
}

//当键退出时调用
- (void)keyboardWillHide:(NSNotification *)notification
{
    //获取键盘的高度
    NSDictionary *userInfo = [notification userInfo];
    NSValue *value = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect rect = [value CGRectValue];
    _commentBar.y = rect.origin.y - _commentBar.height;
    _toolBarHoldView.hidden = YES;
}

/**
 * 添加底部按钮
 */
- (void)setBottomViewAndButtons
{
    CGFloat bottomViewHeight = IS_iPhoneX ? 78 : 48;
    _bottomView = [[JstyleNewsBaseBottomView alloc]init];
    [self.view insertSubview:_bottomView belowSubview:_vrPlayer];
    _bottomView.sd_layout
    .leftEqualToView(self.view)
    .rightEqualToView(self.view)
    .bottomEqualToView(self.view)
    .heightIs(bottomViewHeight);
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 0.5)];
    lineView.backgroundColor = kSingleLineColor;
    [_bottomView addSubview:lineView];
    
    UIButton *pingJiaBtn = [[UIButton alloc]init];
    [pingJiaBtn setImage:JSImage(@"视频评论框") forState:UIControlStateNormal];
    [pingJiaBtn addTarget:self action:@selector(pingJiaBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_bottomView addSubview:pingJiaBtn];
    pingJiaBtn.sd_layout
    .leftSpaceToView(_bottomView, 15)
    .topSpaceToView(_bottomView, 9)
    .widthIs(188*kScreenWidth/375.0)
    .heightIs(30);
    
    UIButton *shareBtn = [[UIButton alloc]init];
    [shareBtn setImage:JSImage(@"视频分享") forState:UIControlStateNormal];
    [shareBtn addTarget:self action:@selector(shareBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_bottomView addSubview:shareBtn];
    shareBtn.sd_layout
    .rightSpaceToView(_bottomView, 15)
    .topSpaceToView(_bottomView, 15)
    .widthIs(18)
    .heightIs(20);
    
    _shouCangBtn = [[UIButton alloc]init];
    [_shouCangBtn setImage:JSImage(@"视频收藏线") forState:UIControlStateNormal];
    [_shouCangBtn addTarget:self action:@selector(shouCangBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_bottomView addSubview:_shouCangBtn];
    _shouCangBtn.sd_layout
    .rightSpaceToView(shareBtn, 25)
    .topSpaceToView(_bottomView, 12)
    .widthIs(20)
    .heightIs(20);
    
    _dianZanBtn = [[UIButton alloc]init];
    [self.dianZanBtn setImage:JSImage(@"视频点赞线") forState:(UIControlStateNormal)];
    [_dianZanBtn addTarget:self action:@selector(dianZanBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_bottomView addSubview:_dianZanBtn];
    _dianZanBtn.sd_layout
    .rightSpaceToView(_shouCangBtn, 25)
    .topSpaceToView(_bottomView, 12)
    .widthIs(20)
    .heightIs(20);
    
//    _dianZanLabel = [[UILabel alloc]init];
//    _dianZanLabel.backgroundColor = [UIColor redColor];
//    _dianZanLabel.clipsToBounds = YES;
//    _dianZanLabel.layer.cornerRadius = 5;
//    _dianZanLabel.adjustsFontSizeToFitWidth = YES;
//    _dianZanLabel.textColor = kWhiteColor;
//    _dianZanLabel.font = [UIFont systemFontOfSize:8];
//    _dianZanLabel.textAlignment = NSTextAlignmentCenter;
//    [_bottomView addSubview:_dianZanLabel];
//    _dianZanLabel.sd_layout
//    .leftSpaceToView(_dianZanBtn, - 5)
//    .bottomSpaceToView(_dianZanBtn, - 5)
//    .heightIs(10);
//    [_dianZanLabel setSingleLineAutoResizeWithMaxWidth:30];
}

- (void)shareBtnClicked:(UIButton *)sender
{
    [[JstyleToolManager sharedManager] shareVideoWithShareTitle:self.shareTitle shareDesc:self.shareDesc shareUrl:self.shareUrl shareImgUrl:self.shareImgUrl viewController:self];
}

- (void)shouCangBtnClicked:(UIButton *)sender
{
    if ([[JstyleToolManager sharedManager] getCurrentNetStatus] == NotReachable) {
        ZTShowAlertMessage(@"当前无网络,请检查网络");
        return;
    }
    [self addJstyleNewsVideoCollection];
}

- (void)dianZanBtnClicked:(UIButton *)sender
{
    if ([[JstyleToolManager sharedManager] getCurrentNetStatus] == NotReachable) {
        ZTShowAlertMessage(@"当前无网络,请检查网络");
        return;
    }
    [self addJstyleNewsVideoPraise];
}

#pragma mark -- 底部评价等按钮点击事件
- (void)pingJiaBtnClicked:(UIButton *)sender
{
    if ([[JstyleToolManager sharedManager] getCurrentNetStatus] == NotReachable) {
        ZTShowAlertMessage(@"当前无网络,请检查网络");
        return;
    }
    _toolBarHoldView.hidden = NO;
    [self.commentTextView becomeFirstResponder];
}

- (void)sendButtonClicked:(UIButton *)sender
{
    if ([[JstyleToolManager sharedManager] isTourist]) {
        [[JstyleToolManager sharedManager] loginInViewController];
        return;
    }
    
    NSString *comment = [self.commentTextView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    self.commentTextView.text = comment;
    if (comment == nil || [comment isEqualToString:@""]) {
        ZTShowAlertMessage(@"评论内容不能为空");
        return;
    }
    if (comment.length>2000) {
        ZTShowAlertMessage(@"字数限制最多2000字，请调整后再发。");
        return;
    }
    if ([NSString stringContainsEmoji:comment]) {
        ZTShowAlertMessage(@"评论内容不能含有表情等特殊字符");
        return;
    }
    if (self.contentId) {
        [self addJstyleNewsVideoCommentWithPid:self.contentId];
    }else{
        [self addJstyleNewsVideoCommentData];
    }
    [_commentTextView resignFirstResponder];
    _placeHolder.text = @"说点什么...";
    _toolBarHoldView.hidden = YES;
    self.contentId = nil;
}

#pragma mark -- WMPlayer的代理方法
- (void)vrPlayerView:(VRPlayerView *)vrPlayerView statusBarHidden:(BOOL)statusBarHidden
{
    self.statusBarHidden = statusBarHidden;
    [self setNeedsStatusBarAppearanceUpdate];
}

- (void)vrPlayerView:(VRPlayerView *)vrPlayerView backBtnClicked:(BOOL)backBtnSelected
{
    if (backBtnSelected) {
        [_vrPlayer.fullScreenBtn sendActionsForControlEvents:(UIControlEventTouchUpInside)];
    }else{
        [self releaseWMPlayer];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)vrPlayerView:(VRPlayerView *)vrPlayerView moreBtn:(UIButton *)moreBtn
{
    [self.vrPlayer.playPauseBtn sendActionsForControlEvents:(UIControlEventTouchUpInside)];
    JstyleNewsVideoFullScreenShareView *jstyleShareView = [[JstyleNewsVideoFullScreenShareView alloc] initWithFrame:CGRectMake(0, kScreenWidth, kScreenHeight, kScreenWidth) shareTitle:self.shareTitle shareDesc:self.shareDesc shareUrl:self.shareUrl shareImgUrl:self.shareImgUrl viewController:self];
    [UIView animateWithDuration:0.25 animations:^{
        jstyleShareView.y = 0;
    }];
    __weak JstyleNewsVideoFullScreenShareView *weakShareView = jstyleShareView;
    __weak UIButton *playPauseBtn = self.vrPlayer.playPauseBtn;
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

- (void)vrPlayerView:(VRPlayerView *)vrPlayerView clickedFullScreen:(UIButton *)fullScreen
{
    self.isFullScreen = !self.isFullScreen;
    [UIApplication sharedApplication].statusBarHidden = self.isFullScreen;
    if (self.isFullScreen) {
        [self fullScreenAction];
    }else{
        [self smallScreenAction];
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [_commentTextView resignFirstResponder];
    _placeHolder.text = @"说点什么...";
    _toolBarHoldView.hidden = YES;
    self.contentId = nil;
}

//全屏
- (void)fullScreenAction
{
    [[NSUserDefaults standardUserDefaults] setObject:@"JstyleLandscapeRight" forKey:@"JstyleLandscapeRight"];
    _vrPlayer.bottomView.hidden = NO;
    
//    SEL selector = NSSelectorFromString(@"setOrientation:");
//    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
//    [invocation setSelector:selector];
//    [invocation setTarget:[UIDevice currentDevice]];
//    int val = UIInterfaceOrientationLandscapeRight;//这里可以改变旋转的方向
//    [invocation setArgument:&val atIndex:2];
//    [invocation invoke];
//
//    _vrPlayer.frame = CGRectMake(0, 0, kScreenHeight, kScreenWidth);
//    _vrPlayer.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    
    if (IS_iPhoneX) {
        _vrPlayer.backBtn.sd_layout
        .topSpaceToView(_vrPlayer.bottomView, 20)
        .leftSpaceToView(_vrPlayer.bottomView, 10)
        .widthIs(30)
        .heightIs(30);

        _vrPlayer.moreBtn.sd_layout
        .topSpaceToView(_vrPlayer.bottomView, 20)
        .rightSpaceToView(_vrPlayer.bottomView, 10)
        .widthIs(30)
        .heightIs(30);

        _vrPlayer.liveTitleLabel.sd_layout
        .centerYEqualToView(_vrPlayer.backBtn)
        .leftSpaceToView(_vrPlayer.backBtn, 10)
        .rightSpaceToView(_vrPlayer.moreBtn, 10)
        .heightIs(20);
    }
    
    [_vrPlayer removeFromSuperview];
    SEL selector = NSSelectorFromString(@"setOrientation:");
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
    [invocation setSelector:selector];
    [invocation setTarget:[UIDevice currentDevice]];
    int val = UIInterfaceOrientationLandscapeRight;//这里可以改变旋转的方向
    [invocation setArgument:&val atIndex:2];
    [invocation invoke];
    if (ISNightMode) {
        [[UIApplication sharedApplication].keyWindow insertSubview:_vrPlayer belowSubview:[NightModeManager defaultManager].nightView];
    }else{
        [[UIApplication sharedApplication].keyWindow addSubview:_vrPlayer];
    }
    _vrPlayer.frame = CGRectMake(0, 0, kScreenHeight, kScreenWidth);
}

//小屏
- (void)smallScreenAction
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"JstyleLandscapeRight"];
    _vrPlayer.bottomView.hidden = NO;
    
//    SEL selector = NSSelectorFromString(@"setOrientation:");
//    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
//    [invocation setSelector:selector];
//    [invocation setTarget:[UIDevice currentDevice]];
//    int val = UIInterfaceOrientationPortrait;//这里可以改变旋转的方向
//    [invocation setArgument:&val atIndex:2];
//    [invocation invoke];
//
//    _vrPlayer.frame = CGRectMake(0, 0, kScreenWidth, kScreenWidth * 9 /16);
//    _vrPlayer.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    
    if (IS_iPhoneX) {
        _vrPlayer.backBtn.sd_layout
        .topSpaceToView(_vrPlayer.bottomView, 35)
        .leftSpaceToView(_vrPlayer.bottomView, 10)
        .widthIs(30)
        .heightIs(30);

        _vrPlayer.moreBtn.sd_layout
        .topSpaceToView(_vrPlayer.bottomView, 35)
        .rightSpaceToView(_vrPlayer.bottomView, 10)
        .widthIs(30)
        .heightIs(30);

        _vrPlayer.liveTitleLabel.sd_layout
        .centerYEqualToView(_vrPlayer.backBtn)
        .leftSpaceToView(_vrPlayer.backBtn, 10)
        .rightSpaceToView(_vrPlayer.moreBtn, 10)
        .heightIs(20);
    }
    
    [_vrPlayer removeFromSuperview];
    SEL selector = NSSelectorFromString(@"setOrientation:");
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
    [invocation setSelector:selector];
    [invocation setTarget:[UIDevice currentDevice]];
    int val = UIInterfaceOrientationPortrait;
    [invocation setArgument:&val atIndex:2];
    [invocation invoke];
    
    [self.view addSubview:_vrPlayer];
    [self.view bringSubviewToFront:_vrPlayer];
    _vrPlayer.frame = CGRectMake(0, 0, kScreenWidth, kScreenWidth * 9 /16);
}

- (void)videoAndLiveEnterBackground
{
    [_vrPlayer pause];
}

- (void)videoAndLiveEnterForeground
{
    [_vrPlayer play];
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    return gestureRecognizer != self.navigationController.interactivePopGestureRecognizer;
}

- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (NSMutableArray *)commentArray
{
    if (!_commentArray) {
        _commentArray = [NSMutableArray array];
    }
    return _commentArray;
}

- (UIView *)addHeaderViewWithTitle:(NSString *)title columnHidden:(BOOL)columnHidden
{
    JstyleNewsBaseView *headerView = [[JstyleNewsBaseView alloc] init];
    UIView *singleLine = [[UIView alloc] init];
    singleLine.backgroundColor = ISNightMode?kNightModeBackColor:kSingleLineColor;
    [headerView addSubview:singleLine];
    singleLine.sd_layout
    .topEqualToView(headerView)
    .leftEqualToView(headerView)
    .rightEqualToView(headerView)
    .heightIs(0.5);
    
    UIView *bottomLine = [[UIView alloc] init];
    bottomLine.backgroundColor = ISNightMode?kNightModeBackColor:kSingleLineColor;
    [headerView addSubview:bottomLine];
    bottomLine.sd_layout
    .bottomEqualToView(headerView).offset(1)
    .leftEqualToView(headerView)
    .rightEqualToView(headerView)
    .heightIs(0.5);
    
    UIView *columnView = [[UIView alloc] init];
    columnView.backgroundColor = ISNightMode?kDarkTwoColor:kBackGroundColor;
    [headerView addSubview:columnView];
    columnView.sd_layout
    .topEqualToView(singleLine)
    .leftEqualToView(headerView)
    .rightEqualToView(headerView)
    .heightIs(9.5);
    
    UIView *squareView = [[UIView alloc] init];
    squareView.backgroundColor = ISNightMode?kDarkFiveColor:kDarkOneColor;
    [headerView addSubview:squareView];
    if (columnHidden) {
        columnView.hidden = YES;
        bottomLine.hidden = YES;
        squareView.sd_layout
        .topSpaceToView(headerView, 21)
        .leftSpaceToView(headerView, 15)
        .widthIs(6)
        .heightIs(6);
    }else{
        columnView.hidden = NO;
        bottomLine.hidden = NO;
        squareView.sd_layout
        .topSpaceToView(columnView, 21)
        .leftSpaceToView(headerView, 15)
        .widthIs(6)
        .heightIs(6);
    }
    
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.font = JSFont(18);
    nameLabel.text = title;
    nameLabel.textColor = ISNightMode?kDarkFiveColor:kDarkOneColor;
    [headerView addSubview:nameLabel];
    nameLabel.sd_layout
    .centerYEqualToView(squareView)
    .leftSpaceToView(squareView, 10)
    .rightSpaceToView(headerView, 10)
    .heightIs(14);
    
    return headerView;
}

- (UIView *)addFooterViewWithTitle:(NSString *)title
{
    UIView *footerView = [[UIView alloc] init];
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.font = JSFont(11);
    nameLabel.textColor = kLightLineColor;
    nameLabel.text = title;
    [footerView addSubview:nameLabel];
    nameLabel.sd_layout
    .centerYEqualToView(footerView)
    .centerXEqualToView(footerView).offset(-10)
    .heightIs(11);
    [nameLabel setSingleLineAutoResizeWithMaxWidth:200];
    
    UIImageView *moreImageView = [[UIImageView alloc] init];
    moreImageView.image = JSImage(@"评论向下");
    [footerView addSubview:moreImageView];
    moreImageView.sd_layout
    .centerYEqualToView(footerView)
    .leftSpaceToView(nameLabel, 5)
    .widthIs(10)
    .heightIs(5);
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(footerTapAction)];
    [footerView addGestureRecognizer:tap];
    
    return footerView;
}

- (void)footerTapAction
{
    JstyleNewsCommentViewController *jstyleNewsVideoCVC = [JstyleNewsCommentViewController new];
    jstyleNewsVideoCVC.type = @"2";
    jstyleNewsVideoCVC.vid = self.vid;
    [self.navigationController pushViewController:jstyleNewsVideoCVC animated:YES];
}

/**
 *  释放WMPlayer
 */
-(void)releaseWMPlayer{
    [_vrPlayer pause];
    [_vrPlayer releseTimer];
    [_vrPlayer removeFromSuperview];
    _vrPlayer.player = nil;
    _vrPlayer = nil;
}

- (void)videoDetailTuijianClicked:(NSNotification *)notification
{
    NSDictionary *userInfo = notification.userInfo;
    self.videoUrl = userInfo[@"videoUrl"];
    self.videoTitle = userInfo[@"videoTitle"];
    self.vid = userInfo[@"vid"];
    [self releaseWMPlayer];
    [self addPlayerAndViews];
    [self loadJstyleNewsVideoDataSource];
    [self getJstyleNewsVideoPraiseStatus];//点赞收藏状态
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait | UIInterfaceOrientationMaskLandscape;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
    return UIInterfaceOrientationPortrait | UIInterfaceOrientationLandscapeRight;
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (BOOL)prefersStatusBarHidden
{
    return self.isFullScreen?YES:self.statusBarHidden;
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
