//
//  JstylePictureTextViewController.m
//  Exquisite
//
//  Created by 数字宁波 on 2017/4/26.
//  Copyright © 2017年 Jstyle. All rights reserved.
//

#import "JstylePictureTextViewController.h"
#import "JstyleNewsNavigationController.h"
#import "PictureCollectionViewCell.h"
#import "PictureScrollView.h"
#import "PictureModel.h"
#import "DDPhotoDescView.h"
#import "JstyleNewsCommentViewController.h"
#import "JstyleNewsJMNumDetailsViewController.h"
#import "WRCustomNavigationBar.h"

@interface JstylePictureTextViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;//菊花转

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, strong) DDPhotoDescView *photoDescView;

@property (nonatomic, assign) NSInteger currentIndex;

@property (nonatomic, assign) BOOL isDisappear;

@property (nonatomic, strong) UIView *bottomView;

@property (nonatomic, strong) UILabel *pageLabel;

@property (nonatomic, strong) UIButton *downLoadBtn;

@property (nonatomic, strong) UIView *bottomHoldView;
@property (nonatomic, strong) UIButton *shouCangBtn;
@property (nonatomic, strong) UIButton *dianZanBtn;
@property (nonatomic, strong) UIButton *commentBtn;
@property (nonatomic, strong) UILabel *commentLabel;

@property (nonatomic, copy) NSString *shareImgUrl;
@property (nonatomic, copy) NSString *shareUrl;
@property (nonatomic, copy) NSString *shareTitle;
@property (nonatomic, copy) NSString *shareDesc;

@property (nonatomic, strong) UIView *commentBar;
@property (nonatomic, strong) UITextField *commentTextField;
@property (nonatomic, strong) UIButton *sendButton;
@property (nonatomic, strong) UIView *holdView;
@property (nonatomic, strong) NSMutableArray *commentArray;
@property (nonatomic, strong) UIView *toolBarHoldView;
//自定义导航栏
@property (nonatomic, strong) UIView *customNavBarView;
@property (nonatomic, strong) UIButton *headerBtn;

@end

@implementation JstylePictureTextViewController

- (void)dealloc
{
    
}

- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = kWhiteColor;
    
    [self addRightTwoBarsWithFirstImage:JSImage(@"图集分享白") firstAction:@selector(firstBarButtonAction) secondImage:[UIImage imageNamed:@"图集下载白"] secondAction:@selector(secondBarButtonAction)];
    
    [self addCollectionView];
    [self addBottomView];
    [self addToolBarView];
    [self addCommentToolBar];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self getShareData];
        [self loadJstylePictureArticleDataSource];
        [self getJstyleNewsArticlePraiseStatus];
    });
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    [self.view bringSubviewToFront: self.customNavBarView];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.activityIndicator stopAnimating];
    [self.activityIndicator removeFromSuperview];
}

- (UIView *)customNavBarView {
    
    if (!_customNavBarView) {
        _customNavBarView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_W, YG_StatusAndNavightion_H)];
        _customNavBarView.backgroundColor = [UIColor clearColor];
        
        [self.view addSubview:_customNavBarView];
    }
    return _customNavBarView;
}



- (NSArray<id<UIPreviewActionItem>> *)previewActionItems {
    
    UIPreviewAction *action1 = [UIPreviewAction actionWithTitle:@"收藏" style:UIPreviewActionStyleDefault handler:^(UIPreviewAction * _Nonnull action, UIViewController * _Nonnull previewViewController) {
        
        [self.shouCangBtn sendActionsForControlEvents:UIControlEventTouchUpInside];
    }];
    
    UIPreviewAction *action2 = [UIPreviewAction actionWithTitle:@"点赞" style:UIPreviewActionStyleDefault handler:^(UIPreviewAction * _Nonnull action, UIViewController * _Nonnull previewViewController) {
        
        [self.dianZanBtn sendActionsForControlEvents:UIControlEventTouchUpInside];
    }];
    
    return @[action1,action2];
}

- (void)addCommentToolBar
{
    _commentBar = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight, kScreenWidth, 50)];
    _commentBar.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_commentBar];
    
    UIView *singleLine = [[UIView alloc] init];
    singleLine.backgroundColor = JSColor(@"#C8C7CC");
    [_commentBar addSubview:singleLine];
    singleLine.sd_layout
    .leftEqualToView(_commentBar)
    .rightEqualToView(_commentBar)
    .topEqualToView(_commentBar)
    .heightIs(0.5);
    
    _sendButton = [[UIButton alloc] init];
    [_sendButton setTitle:@"发送" forState:UIControlStateNormal];
    [_sendButton setTitleColor:kWhiteColor forState:UIControlStateNormal];
    _sendButton.tintColor = [UIColor whiteColor];
    _sendButton.backgroundColor = kPinkColor;
    _sendButton.titleLabel.font = JSFont(14);
    _sendButton.layer.cornerRadius = 15;
    _sendButton.layer.masksToBounds = YES;
    [_sendButton addTarget:self action:@selector(chatSendButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [_commentBar addSubview:_sendButton];
    _sendButton.sd_layout
    .rightSpaceToView(_commentBar, 15)
    .centerYEqualToView(_commentBar)
    .widthIs(70)
    .heightIs(30);
    _sendButton.lee_theme
    .LeeCustomConfig(ThemeMainBtnTitleOrBorderColor, ^(id item, id value) {
        [item layer].backgroundColor = [value CGColor];
    });
    
    _commentTextField = [[UITextField alloc] init];
    _commentTextField.tintColor = kNormalRedColor;
    _commentTextField.lee_theme
    .LeeConfigTintColor(ThemeMainBtnTitleOrBorderColor);
    _commentTextField.returnKeyType = UIReturnKeyDefault;
    _commentTextField.keyboardAppearance = ISNightMode?UIKeyboardAppearanceDark:UIKeyboardAppearanceDefault;
    _commentTextField.font = [UIFont systemFontOfSize:14];
    _commentTextField.textColor = kDarkTwoColor;
    _commentTextField.placeholder = @"添加评论...";
    [_commentBar addSubview:_commentTextField];
    _commentTextField.sd_layout
    .leftSpaceToView(_commentBar, 15)
    .rightSpaceToView(_sendButton, 15)
    .topEqualToView(_commentBar)
    .heightIs(50);
    
    [self registKeyboardNotifications];
    _toolBarHoldView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    _toolBarHoldView.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.3];
    
    [_toolBarHoldView addSubview:_commentBar];
    [self.view addSubview:_toolBarHoldView];
    _toolBarHoldView.hidden = YES;
}

#pragma mark - 添加底部工具栏
- (void)addToolBarView
{
    _bottomHoldView = [[UIView alloc]initWithFrame:CGRectMake(0, kScreenHeight - 80, kScreenWidth, 80)];
    [self.view addSubview:_bottomHoldView];
    
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.colors = @[(__bridge id)[UIColor blackColor].CGColor, (__bridge id)[UIColor clearColor].CGColor];
    gradientLayer.locations = @[@0.5];
    gradientLayer.startPoint = CGPointMake(0.0, 1.0);
    gradientLayer.endPoint = CGPointMake(0.0, 0.0);
    gradientLayer.frame = _bottomHoldView.bounds;
    [_bottomHoldView.layer addSublayer:gradientLayer];

    
//    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 0.3)];
//    lineView.backgroundColor = [kWhiteColor colorWithAlphaComponent:0.2];
//    [_bottomHoldView addSubview:lineView];
    
    UIButton *pingJiaBtn = [[UIButton alloc]init];
    [pingJiaBtn setImage:[UIImage imageNamed:@"图文评论框"] forState:UIControlStateNormal];
    [pingJiaBtn setImage:[UIImage imageNamed:@"图文评论框"] forState:UIControlStateHighlighted];
    [pingJiaBtn addTarget:self action:@selector(addCommentAction) forControlEvents:UIControlEventTouchUpInside];
    [_bottomHoldView addSubview:pingJiaBtn];
    pingJiaBtn.sd_layout
    .leftSpaceToView(_bottomHoldView, 15)
    .topSpaceToView(_bottomHoldView, 40)
    .widthIs(200*kScreenWidth/375.0)
    .heightIs(30);
    
    _shouCangBtn = [[UIButton alloc]init];
    [_shouCangBtn setImage:[UIImage imageNamed:@"图文收藏白"] forState:UIControlStateNormal];
    [_shouCangBtn addTarget:self action:@selector(addCollectionAction) forControlEvents:UIControlEventTouchUpInside];
    [_bottomHoldView addSubview:_shouCangBtn];
    _shouCangBtn.sd_layout
    .rightSpaceToView(_bottomHoldView, 15)
    .centerYEqualToView(pingJiaBtn).offset(-1)
    .widthIs(20)
    .heightIs(20);
    
    self.dianZanBtn = [[UIButton alloc]init];
    [self.dianZanBtn setImage:JSImage(@"图文点赞") forState:(UIControlStateNormal)];
    [self.dianZanBtn addTarget:self action:@selector(addJstyleNewsArticlePraise:) forControlEvents:UIControlEventTouchUpInside];
    [_bottomHoldView addSubview:self.dianZanBtn];
    self.dianZanBtn.sd_layout
    .rightSpaceToView(_shouCangBtn, 15)
    .centerYEqualToView(pingJiaBtn)
    .widthIs(20)
    .heightIs(20);
    
    _commentBtn = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.dianZanBtn.frame) - 60, 15  + 30, 20, 20)];
    [_commentBtn setImage:[UIImage imageNamed:@"图文评论"] forState:UIControlStateNormal];
    [_commentBtn addTarget:self action:@selector(presentCommentVCAction) forControlEvents:UIControlEventTouchUpInside];
    [_bottomHoldView addSubview:_commentBtn];
    _commentBtn.sd_layout
    .rightSpaceToView(self.dianZanBtn, 15)
    .centerYEqualToView(pingJiaBtn)
    .widthIs(20)
    .heightIs(20);
    
    _commentLabel = [[UILabel alloc]init];
    _commentLabel.backgroundColor = [UIColor redColor];
    _commentLabel.clipsToBounds=YES;
    _commentLabel.layer.cornerRadius = 5;
    _commentLabel.adjustsFontSizeToFitWidth = YES;
    _commentLabel.textColor = [UIColor whiteColor];
    _commentLabel.font = [UIFont systemFontOfSize:8];
    _commentLabel.textAlignment = NSTextAlignmentCenter;
    
    [_bottomHoldView addSubview:_commentLabel];
    _commentLabel.sd_layout
    .rightEqualToView(_commentBtn).offset(5)
    .topEqualToView(_commentBtn).offset(-5)
    .heightIs(10);
    [_commentLabel setSingleLineAutoResizeWithMaxWidth:50];
}

- (void)addBottomView{
    self.bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, kScreenHeight, kScreenWidth, 60)];
    self.bottomView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    
    _pageLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, 150, 60)];
    _pageLabel.textAlignment = NSTextAlignmentLeft;
    _pageLabel.textColor = kWhiteColor;
    _pageLabel.font = JSFont(16);
    _pageLabel.text = [[NSString stringWithFormat:@"%ld ∕ ",self.currentIndex + 1] stringByAppendingString:[NSString stringWithFormat:@"%lu",(unsigned long)self.dataArray.count]];
    
    _downLoadBtn = [[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth - 45, 10, 40, 40)];
    _downLoadBtn.userInteractionEnabled = YES;
    [_downLoadBtn setImage:[UIImage imageNamed:@"图文下载"] forState:(UIControlStateNormal)];
    [_downLoadBtn addTarget:self action:@selector(secondBarButtonAction) forControlEvents:(UIControlEventTouchUpInside)];
    
    [self.bottomView addSubview:_pageLabel];
    [self.bottomView addSubview:_downLoadBtn];
    [self.view addSubview:self.bottomView];
}

- (void)chatSendButtonAction:(UIButton *)button
{
    if ([[JstyleToolManager sharedManager] isTourist]) {
        [[JstyleToolManager sharedManager] loginInViewController];
        return;
    }
    if (!(self.commentTextField.text == nil || [self.commentTextField.text isEqualToString:@""])) {
        [self addJstyleArticleCommentDataSource];
    }
    [_commentTextField resignFirstResponder];
    _toolBarHoldView.hidden = YES;
}

- (void)descriptionHidden
{
    if (_isDisappear) {
        self.photoDescView.hidden = YES;
        _bottomHoldView.hidden = YES;
        self.bottomView.y = kScreenHeight - 60;
    }else{
        self.bottomView.y = kScreenHeight;
        self.photoDescView.hidden = NO;
        _bottomHoldView.hidden = NO;
    }
}

- (void)addCollectionView
{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.minimumLineSpacing = 0;
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    _collectionView.backgroundColor = [UIColor blackColor];
    _collectionView.pagingEnabled = YES;
    _collectionView.bounces = NO;
    _collectionView.showsHorizontalScrollIndicator = NO;
    _collectionView.showsVerticalScrollIndicator = NO;
    [_collectionView registerNib:[UINib nibWithNibName:@"PictureCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"PictureCollectionViewCell"];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    if (@available(iOS 11.0, *)) {
        _collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        _collectionView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _collectionView.scrollIndicatorInsets = _collectionView.contentInset;
    }
    [self.view addSubview:_collectionView];
    _collectionView.sd_layout
    .topEqualToView(self.view)
    .bottomSpaceToView(self.view, 0)
    .leftEqualToView(self.view)
    .rightEqualToView(self.view);
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PictureCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PictureCollectionViewCell" forIndexPath:indexPath];
    
    __weak typeof (self)weakSelf = self;
    cell.sigleTap = ^(){
        weakSelf.isDisappear = !weakSelf.isDisappear;
        [weakSelf descriptionHidden];
    };
    cell.model = self.dataArray[indexPath.row];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView
  didEndDisplayingCell:(nonnull UICollectionViewCell *)cell
    forItemAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    PictureScrollView *photoSV = (PictureScrollView *)[cell.contentView viewWithTag:100];
    [photoSV setZoomScale:1.0 animated:YES];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(kScreenWidth, kScreenHeight);
}

#pragma mark -- UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    int itemIndex = (scrollView.contentOffset.x + self.collectionView.width * 0.5) / self.collectionView.width;
    if (!self.dataArray.count) return;
    self.currentIndex = itemIndex % self.dataArray.count;
    
    PictureModel *model = self.dataArray[self.currentIndex];
    [self.photoDescView removeFromSuperview];
    self.photoDescView = [[DDPhotoDescView alloc] initWithTitle:model.title
                                                       desc:model.text
                                                      index:self.currentIndex
                                                 totalCount:self.dataArray.count];
    _pageLabel.text = [[NSString stringWithFormat:@"%ld ∕ ",self.currentIndex + 1] stringByAppendingString:[NSString stringWithFormat:@"%lu",(unsigned long)self.dataArray.count]];
    [self.view insertSubview:self.photoDescView belowSubview:self.bottomView];
    if (_isDisappear) {
        self.photoDescView.hidden = YES;
    }
}

- (void)leftBarButtonAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)presentCommentVCAction{
    JstyleNewsCommentViewController *jstyleNewsCommentVC = [JstyleNewsCommentViewController new];
    jstyleNewsCommentVC.vid = self.rid;
    jstyleNewsCommentVC.type = @"1";
    [self.navigationController pushViewController:jstyleNewsCommentVC animated:YES];
}

- (void)addCollectionAction
{
//    if ([[JstyleToolManager sharedManager] isTourist]) {
//        [[JstyleToolManager sharedManager] loginInViewController];
//        return;
//    }
    [self addJstyleNewsArticleCollection];
}

/**
 * 评论事件
 */
- (void)addCommentAction
{
    _toolBarHoldView.hidden = NO;
    [self.commentTextField becomeFirstResponder];
}

- (void)firstBarButtonAction
{
    [[JstyleToolManager sharedManager] shareActionWithShareTitle:self.shareTitle shareDesc:self.shareDesc shareImgUrl:self.shareImgUrl shareLinkUrl:self.shareUrl viewController:self];
}

- (void)secondBarButtonAction
{
    ZTAlertView *alertView = [[ZTAlertView alloc]initWithTitle:@"提示" message:@"保存图片" sureBtn:@"确认" cancleBtn:@"取消"];
    alertView.resultIndex = ^(NSInteger index){
        if (index == 1) {
            PictureModel *model = self.dataArray[self.currentIndex];
            UIImageView *imageView = [UIImageView new];
            [imageView setImageWithURL:[NSURL URLWithString:model.image] placeholder:SZ_Place_S_N options:(YYWebImageOptionSetImageWithFadeAnimation) completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
                [self saveImageToPhotos:image];
            }];
        }
    };
    [alertView show];
}

//获取图片文章的数据
- (void)loadJstylePictureArticleDataSource
{
 
    [self.activityIndicator removeFromSuperview];
    
    self.activityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:(UIActivityIndicatorViewStyleWhiteLarge)];
    self.activityIndicator.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    [self.view addSubview:self.activityIndicator];
    [self.activityIndicator startAnimating];
    
    NSString * uid = [[JstyleToolManager sharedManager] getUserId];
    if ([uid isEmptyEstring]) {
        uid = @" ";
    }
    
    NSDictionary *parameters = @{@"uid":[[JstyleToolManager sharedManager] getUserId],
                                 @"rid":[NSString stringWithFormat:@"%@",self.rid]};
//    NSLog(@"url = %@?rid=%@&uid=%@\n\n\n\n\n\n\n\n\n\n\n\n\n",PICTURE_ARTICLE_URL,[NSString stringWithFormat:@"%@",self.rid],[[JstyleToolManager sharedManager] getUserId]);
    [[JstyleNewsNetworkManager shareManager] GETURL:PICTURE_ARTICLE_URL parameters:parameters success:^(id responseObject) {
        
        [self.activityIndicator stopAnimating];
        
        if ([responseObject[@"code"] integerValue] == 1) {
            for (NSDictionary *dict in responseObject[@"data"]) {
                PictureModel *model = [PictureModel new];
                [model setValuesForKeysWithDictionary:dict];
                [self.dataArray addObject:model];
            }
        }
        
        if (self.dataArray.count > 0) {
            PictureModel *model = self.dataArray[0];
            if (!(model.head_img == nil || [model.head_img isEqualToString:@""])) {
                self.headerBtn = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth - 130, 9 + YG_StatusBarH, 24, 24)];
                [self.headerBtn setImageWithURL:[NSURL URLWithString:model.head_img] forState:(UIControlStateNormal) options:(YYWebImageOptionSetImageWithFadeAnimation)];
                self.headerBtn.layer.cornerRadius = 12;
                self.headerBtn.layer.masksToBounds = YES;
                self.headerBtn.layer.borderWidth = 1;
                self.headerBtn.layer.borderColor = kWhiteColor.CGColor;
                [self.headerBtn addTarget:self action:@selector(headerBtnClicked:) forControlEvents:(UIControlEventTouchUpInside)];
                 [self.customNavBarView addSubview:self.headerBtn];
            }else{
                self.headerBtn.hidden = YES;
            }
            
            [self.photoDescView removeFromSuperview];
            self.photoDescView = [[DDPhotoDescView alloc] initWithTitle:model.title desc:model.text index: 0 totalCount:self.dataArray.count];
            [self.view insertSubview:self.photoDescView belowSubview:self.bottomView];
            self.currentIndex = 0;
            //设置默认页码
            self.pageLabel.text = [[NSString stringWithFormat:@"%ld ∕ ",self.currentIndex + 1] stringByAppendingString:[NSString stringWithFormat:@"%lu",(unsigned long)self.dataArray.count]];
            [self.collectionView reloadData];
        }
    } failure:^(NSError *error) {
        [self.activityIndicator stopAnimating];
    }];
}

- (void)headerBtnClicked:(UIButton *)sender
{
    if (self.dataArray.count) {
        PictureModel *model = self.dataArray[0];
        JstyleNewsJMNumDetailsViewController *jstylePersonalMVC = [JstyleNewsJMNumDetailsViewController new];
        jstylePersonalMVC.did = model.did;
        [self.navigationController pushViewController:jstylePersonalMVC animated:YES];
    }
}

/**添加评论的数据*/
- (void)addJstyleArticleCommentDataSource
{
    NSDictionary *parameters = @{@"uid":[[JstyleToolManager sharedManager] getUserId],
                                 @"type":@"1",
                                 @"hid":[NSString stringWithFormat:@"%@",self.rid],
                                 @"content":self.commentTextField.text,
                                 @"pid":@""
                                 };
    [[JstyleNewsNetworkManager shareManager] POSTURL:ADD_COMMENT_URL parameters:parameters success:^(id responseObject) {
        if ([responseObject[@"code"] integerValue] == 1) {
            ZTShowAlertMessage(@"发布成功");
            self.commentTextField.text = @"";
            //评论数增加
            NSInteger commentNum = [self.commentLabel.text integerValue] + 1;
            if (commentNum > 9999) {
                self.commentLabel.text = [NSString stringWithFormat:@"%.1f万  ",commentNum/10000.0];
            }else{
                self.commentLabel.text = [NSString stringWithFormat:@"%ld  ",(long)commentNum];
            }
            
            
        }
    } failure:^(NSError *error) {
        ZTShowAlertMessage(@"评论失败, 请稍后再试");
    }];
}


/**加入收藏数据请求*/
- (void)addJstyleNewsArticleCollection
{
    NSDictionary *parameters = @{@"platform_type":@"2",
                                 @"rid":[NSString stringWithFormat:@"%@",self.rid],
                                 @"type":@"1",
                                 @"uid":[[JstyleToolManager sharedManager] getUserId],
                                 @"uuid":[[JstyleToolManager sharedManager] getUDID]
                                 };
    [[JstyleNewsNetworkManager shareManager] GETURL:ADD_COLLECTION_URL parameters:parameters success:^(id responseObject) {
        if ([responseObject[@"code"] integerValue] == 1) {
            [self.shouCangBtn setImage:JSImage(@"图文收藏红") forState:(UIControlStateNormal)];
        }else{
            [self.shouCangBtn setImage:JSImage(@"图文收藏白") forState:(UIControlStateNormal)];
        }
    } failure:nil];
}

/**点击点赞状态的数据*/
- (void)addJstyleNewsArticlePraise:(UIButton *)sender
{
    NSDictionary *parameters = @{@"platform_type":@"2",
                                 @"rid":[NSString stringWithFormat:@"%@",self.rid],
                                 @"type":@"1",
                                 @"uid":[[JstyleToolManager sharedManager] getUserId],
                                 @"uuid":[[JstyleToolManager sharedManager] getUDID]
                                 };
    [[JstyleNewsNetworkManager shareManager] GETURL:ADD_PRAISE_URL parameters:parameters success:^(id responseObject) {

        if ([responseObject[@"code"] integerValue] == 1) {

            if ([responseObject[@"data"][@"praise_type"] integerValue] == 1) {
                //ZTShowAlertMessage(@"点赞成功");
                [self.dianZanBtn setImage:[UIImage imageNamed:@"图文点赞红"] forState:UIControlStateNormal];
                [ThumbUpSpecialEffec addThumbUpSpecialEffecWithBigShineColor:RGBACOLOR(255, 95, 89, 1) smallShineColor:RGBACOLOR(216, 152, 148, 1) shineFillColor:RGBACOLOR(171, 171, 171, 1) button:self.dianZanBtn];
            }else{
                //ZTShowAlertMessage(@"取消点赞");
                [self.dianZanBtn setImage:[UIImage imageNamed:@"图文点赞"] forState:UIControlStateNormal];
            }
        }else{
            [SVProgressHUD showWithStatus:@"网络繁忙，请稍后重试"];
            [SVProgressHUD dismissWithDelay:0.4];
        }
        
    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"网络错误,请重试"];
        [SVProgressHUD dismissWithDelay:0.4];
    }];
}

/**获取点赞、收藏的数据*/
- (void)getJstyleNewsArticlePraiseStatus
{
    NSDictionary *parameters = @{@"platform_type":@"2",
                                 @"rid":[NSString stringWithFormat:@"%@",self.rid],
                                 @"type":@"1",
                                 @"uid":[[JstyleToolManager sharedManager] getUserId],
                                 @"uuid":[[JstyleToolManager sharedManager] getUDID]
                                 };
    [[JstyleNewsNetworkManager shareManager] GETURL:GET_PRAISESTATE_URL parameters:parameters success:^(id responseObject) {
        if ([responseObject[@"code"] integerValue] == 1) {
            if ([responseObject[@"data"][@"follow_type"] integerValue] == 1) {
                [self.shouCangBtn setImage:JSImage(@"图文收藏红") forState:UIControlStateNormal];
            }else{
                [self.shouCangBtn setImage:JSImage(@"图文收藏白") forState:UIControlStateNormal];
            }

            if ([responseObject[@"data"][@"praise_type"] integerValue] == 1) {
                [self.dianZanBtn setImage:[UIImage imageNamed:@"图文点赞红"] forState:UIControlStateNormal];
            }else{
                [self.dianZanBtn setImage:[UIImage imageNamed:@"图文点赞"] forState:UIControlStateNormal];
            }

            NSString * comment_num = responseObject[@"data"][@"comment_num"];
            if ([comment_num integerValue] > 9999) {
                self.commentLabel.text = [NSString stringWithFormat:@"%.1f万  ",[responseObject[@"data"][@"praise_num"] floatValue]/10000];
            }else{
                if ([comment_num integerValue] == 0||[comment_num isEmptyEstring]) {
                    self.commentLabel.text = @"";
                } else {
                    self.commentLabel.text = [NSString stringWithFormat:@"%@  ",responseObject[@"data"][@"comment_num"]];
                }
            }
        }else{
            [SVProgressHUD showWithStatus:@"网络繁忙，请稍后重试"];
            [SVProgressHUD dismissWithDelay:0.4];
        }
        
    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"网络错误,请重试"];
        [SVProgressHUD dismissWithDelay:0.4];
    }];
}

/**分享数据*/
-(void)getShareData
{
    NSDictionary *parameters = @{@"platform_type":@"2",
                                 @"uid":[[JstyleToolManager sharedManager] getUserId],
                                 @"uuid":[[JstyleToolManager sharedManager] getUDID],
                                 @"id":[NSString stringWithFormat:@"%@",self.rid],
                                 @"type":@"0"};
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

- (void)saveImageToPhotos:(UIImage*)savedImage
{
    UIImageWriteToSavedPhotosAlbum(savedImage, self, @selector(image:didFinishSavingWithError:contextInfo:), (__bridge void *)self);
}
// 回调
- (void)image: (UIImage *) image didFinishSavingWithError: (NSError *) error contextInfo: (void *) contextInfo
{
    ZTShowAlertMessage(@"保存成功");
}

#pragma mark --UIKeyboard event listening(键盘事件的监听)
-(void)registKeyboardNotifications{
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

#pragma mark -- Keyboard Notifications通知
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

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [_commentTextField resignFirstResponder];
    _toolBarHoldView.hidden = YES;
}

- (int)getTotalCharacterFromString:(NSString*)string {
    int strlength = 0;
    
    char* p = (char*)[string cStringUsingEncoding:NSUnicodeStringEncoding];
    
    for (int i=0 ; i< [string lengthOfBytesUsingEncoding:NSUnicodeStringEncoding] ;i++) {
        
        if (*p) {
            p++;
            strlength++;
        }else {
            p++;
        }
    }
    return (strlength+1)/2;
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)addRightTwoBarsWithFirstImage:(UIImage *)firstImage firstAction:(SEL)firstAction secondImage:(UIImage *)secondImage secondAction:(SEL)secondAction
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_W-90, YG_StatusBarH, 90, 44)];
    view.backgroundColor = [UIColor clearColor];
    
    UIButton *firstButton = [UIButton buttonWithType:UIButtonTypeCustom];
    firstButton.frame = CGRectMake(50, 0, 40, 44);
    [firstButton setImage:firstImage forState:UIControlStateNormal];
    [firstButton addTarget:self action:firstAction forControlEvents:UIControlEventTouchUpInside];
    firstButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [firstButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, - 8 * kScreenWidth/375.0)];
    [view addSubview:firstButton];
    
    UIButton *secondButton = [UIButton buttonWithType:UIButtonTypeCustom];
    secondButton.frame = CGRectMake(0, 0, 40, 44);
    [secondButton setImage:secondImage forState:UIControlStateNormal];
    [secondButton addTarget:self action:secondAction forControlEvents:UIControlEventTouchUpInside];
    secondButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [secondButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, - 15 * kScreenWidth/375.0)];
    [view addSubview:secondButton];
    
    [self.customNavBarView addSubview:view];
    
    //
    UIButton * leftBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    leftBtn.frame = CGRectMake(0, YG_StatusBarH, 44, 44);
    [leftBtn setImage:[UIImage imageNamed:@"文章返回白"] forState:(UIControlStateNormal)];
    [leftBtn addTarget:self action:@selector(leftBarButtonAction) forControlEvents:(UIControlEventTouchUpInside)];
    [self.customNavBarView addSubview:leftBtn];
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    [[SDImageCache sharedImageCache] clearMemory];
    [[YYWebImageManager sharedManager].cache.memoryCache removeAllObjects];
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
