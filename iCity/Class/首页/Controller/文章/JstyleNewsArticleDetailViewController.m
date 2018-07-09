//
//  JstyleNewsArticleDetailViewController.m
//  JstyleNews
//
//  Created by JingHongMuYun on 2017/12/28.
//  Copyright © 2017年 JstyleNews. All rights reserved.
//

#import "JstyleNewsArticleDetailViewController.h"
#import "ArticleDetailViewControllerHeader.h"


static NSString *JstyleNewsArticleDetailTitleContentCellID = @"JstyleNewsArticleDetailTitleContentCellID";
@implementation JstyleNewsArticleDetailViewController

- (WKUserScript *)userScript
{
    if (!_userScript) {
        NSString *jsString =
        @"function getImages(){\
        var objs = document.getElementsByTagName(\"img\");\
        var imgScr = '';\
        for(var i=0;i<objs.length;i++){\
        objs[i].height='auto';\
        if(objs[i].width > 100){\
        imgScr = imgScr + objs[i].src + '+';\
        }\
        };\
        return imgScr;\
        };\
        function registerImageClickAction(){\
        var imgs=document.getElementsByTagName('img');\
        var length=imgs.length;\
        for(var i=0;i<length;i++){\
        img=imgs[i];\
        img.onclick=function(){\
        window.location.href='image-preview:'+this.src}\
        }\
        }";
        if (ISNightMode) {
            jsString = [jsString stringByAppendingString:@";\
                        var tags = document.body.getElementsByTagName ('*');\
                        for( var i = 0; i < tags.length; i++){\
                        tags[i].style.backgroundColor='#252525';\
                        }"];
        }
        _userScript = [[WKUserScript alloc] initWithSource:jsString injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
    }
    return _userScript;
}

- (WKWebView *)webView {
    if (_webView == nil) {
        WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc]init];
        //configuration.selectionGranularity = WKSelectionGranularityCharacter;
        [configuration.userContentController addUserScript:self.userScript];
        _webViewHeight = 100;//初始高度，
        _webView = [[WKWebView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 100) configuration:configuration];
        _webView.scrollView.showsVerticalScrollIndicator = NO;
        _webView.scrollView.scrollEnabled = NO;
        _webView.backgroundColor = kNightModeBackColor;
        [_webView setOpaque:NO];
        _webView.UIDelegate = self;
        _webView.navigationDelegate = self;
        if (@available(iOS 11.0, *)) {
            _webView.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
            _webView.scrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
            _webView.scrollView.scrollIndicatorInsets = _webView.scrollView.contentInset;
        }

        CGFloat h = self.topContentInset>100?200*kScreenWidth/375.0:0;
        _progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, h, kScreenWidth, 2)];
        _progressView.tintColor = kGlobalGoldColor;
        _progressView.trackTintColor = [UIColor clearColor];
    }
    return _webView;
}

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation
{
    [self.tableView addSubview:self.progressView];
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    [self.tableView reloadData];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //获取图片数组
        [webView evaluateJavaScript:@"getImages()" completionHandler:^(id _Nullable result, NSError * _Nullable error) {
            NSMutableArray *imgSrcArray = [NSMutableArray arrayWithArray:[result componentsSeparatedByString:@"+"]];
            if (imgSrcArray.count >= 2) {
                [imgSrcArray removeLastObject];
            }
            self.imageUrlArray = imgSrcArray;
            self.imageArray = [NSMutableArray array];
            for (NSInteger i = 0; i < self.imageUrlArray.count; i++) {
                UIImageView *imageView = [YYAnimatedImageView new];
                [self.imageArray addObject:imageView];
                imageView.imageURL = [NSURL URLWithString:self.imageUrlArray[i]];
                [self.contenterView addSubview:imageView];
            }
            
        }];
        [webView evaluateJavaScript:@"registerImageClickAction();" completionHandler:nil];
        if (ISNightMode) {
            [webView evaluateJavaScript:@"document.body.style.webkitTextFillColor= '#999999'" completionHandler:nil];
            [webView evaluateJavaScript:@"document.body.style.backgroundColor = '#252525'" completionHandler:nil];
        }
    });
}

- (void)dealloc
{
    [SVProgressHUD dismiss];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    if ([self.titleModel.poster isNotBlank]) {
        self.topContentInset = 200*kScreenWidth/375.0;
    }else{
        self.topContentInset = YG_StatusAndNavightion_H;
    }
    
    self.view.backgroundColor = kNightModeBackColor;
    self.webView.backgroundColor = kNightModeBackColor;
    
    
    [self addScaleImageView];
    [self setBottomViewAndButtons];
    [self addTableView];
    [self addCommentToolBar];
    [self setupWKWebView];
    
    [self getShareData];
    [self creatMyNavigationBar];
    
    [self addNoSingleView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    
    if (self.topContentInset>100) {//无图iphoneX是88，别的是64；有图是200*KScale
        if (ISNightMode) {
            
            [self.backBtn setImage:JSImage(@"文章返回黑") forState:(UIControlStateNormal)];
            [self.shareBtn setImage:JSImage(@"图集分享黑") forState:(UIControlStateNormal)];
        }else{
            [self.backBtn setImage:JSImage(@"文章返回白") forState:(UIControlStateNormal)];
            [self.shareBtn setImage:JSImage(@"图集分享白") forState:(UIControlStateNormal)];
        }
        
        self.naviBar.backgroundColor = kNightBackColor(_alphaMemory);

        
    }else{
        //无图文章
        
        self.naviBar.backgroundColor = kNightModeBackColor;
        self.titleLab.alpha = _alphaMemory;
        if (!ISNightMode) {
            
            [self.backBtn setImage:JSImage(@"文章返回黑") forState:(UIControlStateNormal)];
            [self.shareBtn setImage:JSImage(@"图集分享黑") forState:(UIControlStateNormal)];
        }else{
            [self.backBtn setImage:JSImage(@"文章返回白") forState:(UIControlStateNormal)];
            [self.shareBtn setImage:JSImage(@"图集分享白") forState:(UIControlStateNormal)];
        }
    }
    

    
    [_webView.scrollView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    [_webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];

    [self getJstyleNewsArticlePraiseStatus];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

    [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
    [self.webView.scrollView removeObserver:self forKeyPath:@"contentSize"];
}


- (void)creatMyNavigationBar {
    //导航
    self.naviBar = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_W, YG_StatusAndNavightion_H)];
    self.naviBar.backgroundColor = kNightBackColor(0);
    [self.view addSubview:self.naviBar];
    //返回
    self.backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.backBtn.frame = CGRectMake(0, StatusBarHeight, 54, 44);
    [self.backBtn addTarget:self action:@selector(leftBarButtonAction) forControlEvents:UIControlEventTouchUpInside];
    
    [self.backBtn setContentMode:(UIViewContentModeCenter)];
    [self.naviBar addSubview:self.backBtn];
    //分享
    self.shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.shareBtn.frame = CGRectMake(kScreenWidth-54, StatusBarHeight, 54, 44);
    [self.shareBtn addTarget:self action:@selector(rightBarButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.shareBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 5 * kScreenWidth / 375.0, 0, 0)];
    [self.naviBar addSubview:self.shareBtn];
    
    //title
    self.titleLab = [[UILabel alloc]initWithFrame:CGRectMake(64, StatusBarHeight+10, SCREEN_W-128, 20)];
    self.titleLab.font = [UIFont systemFontOfSize:18];
    self.titleLab.textAlignment = NSTextAlignmentCenter;
    [self.naviBar addSubview:self.titleLab];
    
    if (self.detailModel.title) {
        self.titleLab.text = self.detailModel.title;
    }
}

- (NSArray<id<UIPreviewActionItem>> *)previewActionItems {
    
    UIPreviewAction *action1 = [UIPreviewAction actionWithTitle:@"收藏" style:UIPreviewActionStyleDefault handler:^(UIPreviewAction * _Nonnull action, UIViewController * _Nonnull previewViewController) {
        
        [((JstyleNewsArticleDetailViewController *)previewViewController).shouCangBtn sendActionsForControlEvents:UIControlEventTouchUpInside];
    }];
    
    UIPreviewAction *action2 = [UIPreviewAction actionWithTitle:@"点赞" style:UIPreviewActionStyleDefault handler:^(UIPreviewAction * _Nonnull action, UIViewController * _Nonnull previewViewController) {
        
        [((JstyleNewsArticleDetailViewController *)previewViewController).dianZanBtn sendActionsForControlEvents:UIControlEventTouchUpInside];
    }];
    
    return @[action1,action2];
}

- (void)addNoSingleView{
    
    if ([[JstyleToolManager sharedManager] getCurrentNetStatus] == NotReachable) {
        self.noSingleView = [[JstyleNewsNoSinglePlaceholderView alloc] initWithFrame:CGRectMake(0, 200*kScreenWidth/375.0, kScreenWidth, (kScreenHeight - 200*kScreenWidth/375.0 - (IS_iPhoneX ? 58 : 48)))];
        [self.view addSubview:self.noSingleView];
        self.tableView.scrollEnabled = NO;
        __weak typeof(self)weakSelf = self;
        self.noSingleView.reloadBlock = ^{
            [SVProgressHUD showWithStatus:@"正在努力加载"];
            [weakSelf loadNetworkContent];
        };
    }
}



#pragma mark - 动态选择加载方式(本地预加载 or 当前页请求)
- (void)setupWKWebView {
    
    if (self.titleModel == nil) {
        [self loadNetworkContent];
    } else {
        [self loadLocalContent];
    }
    
    //图片浏览器需要一个View
    _contenterView = [[UIView alloc] init];
    _contenterView.center = self.view.center;
    [self.view addSubview:_contenterView];
}

#pragma mark - KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (object == self.webView && [keyPath isEqualToString:@"estimatedProgress"]) {
        CGFloat newprogress = [[change objectForKey:NSKeyValueChangeNewKey] floatValue];
        if (newprogress >= 1) {
            self.progressView.hidden = YES;
            [self.progressView setProgress:0 animated:NO];
        }else {
            self.progressView.hidden = NO;
            [self.progressView setProgress:newprogress animated:YES];
        }
    }
    
    if ([keyPath isEqualToString:@"contentSize"]) {
        
        _webViewHeight = self.webView.scrollView.contentSize.height;//为了保障这个有效，_webView的初始高度（frame）不能太高
        if (_webViewHeight != _currentWebViewHeight) {
            _currentWebViewHeight = _webViewHeight;
            _webView.frame = CGRectMake(0, 0, kScreenWidth, _webViewHeight);
            [self.tableView reloadData];
        }
    }
}

// 加载headerView
- (void)addScaleImageView
{
    self.headerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, self.topContentInset)];
    self.headerImageView.backgroundColor = [UIColor clearColor];
    self.headerImageView.contentMode = UIViewContentModeScaleAspectFill;//UIViewContentModeScaleAspectFit
    self.headerImageView.clipsToBounds = YES;
    self.headerImageView.image = [UIImage imageNamed:@"placeholder"];
    [self.view addSubview:self.headerImageView];
    
}

- (void)addTableView
{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, -YG_StatusAndNavightion_H, SCREEN_W, SCREEN_H+YG_StatusAndNavightion_H-YG_SafeBottom_H) style:(UITableViewStyleGrouped)];
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    _tableView.separatorColor = kSingleLineColor;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    if (@available(iOS 11.0, *)) {
        _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        _tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _tableView.scrollIndicatorInsets = _tableView.contentInset;
    }
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    self.tableView.tableFooterView = [UIView new];
    [_tableView registerNib:[UINib nibWithNibName:@"JstyleNewsArticleDetailTitleContentCell" bundle:nil] forCellReuseIdentifier:JstyleNewsArticleDetailTitleContentCellID];
    [_tableView registerNib:[UINib nibWithNibName:@"JstyleNewsCommentViewCell" bundle:nil] forCellReuseIdentifier:@"JstyleNewsCommentViewCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"JstyleNewsCommentPlaceHolderCell" bundle:nil] forCellReuseIdentifier:@"JstyleNewsCommentPlaceHolderCell"];
    
     [self.tableView registerNib:[UINib nibWithNibName:@"JstyleNewsMyCollectionArticleTableViewCell" bundle:nil] forCellReuseIdentifier:@"article_cell_id"];
    
    [self.view addSubview:_tableView];
    _tableView.sd_layout
    .topSpaceToView(self.view, 0)
    .bottomSpaceToView(self.bottomView, 0)
    .leftEqualToView(self.view)
    .rightEqualToView(self.view);
}

#pragma mark -- tableView的代理方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 5;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case 3:
            if (!self.dataArray.count) return nil;
            return [self addHeaderViewWithTitle:@"相关推荐文章" columnHidden:YES];
            break;
        case 4:{
            return [self addHeaderViewWithTitle:@"最新评论" columnHidden:NO];
        }
            break;
        default:
            return nil;
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case 3:
            if (!self.dataArray.count) return 0.01;
            return 48;
            break;
        case 4:
            return 58;
            break;
        default:
            return 0.01;
            break;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section == 4 && [self.commentCount integerValue] > 2) return [self addFooterViewWithTitle:[NSString stringWithFormat:@"查看全部%@条评论",self.commentCount]];
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 4 && [self.commentCount integerValue] > 2) return 78;
    return 0.01;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
        case 1:
        case 2:
            return 1;
            break;
        case 3:
//            if (!self.dataArray.count) return 0;
//            return 1;
            return self.dataArray.count;
            break;
        case 4:
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
            static NSString *ID = @"ImageViewCellID";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
            if (!cell) {
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
            }
            
            cell.textLabel.backgroundColor = [UIColor redColor];
            cell.backgroundColor = [UIColor clearColor];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
            break;
        case 1:{
            //文章标题cell
            JstyleNewsArticleDetailTitleContentCell *cell = [tableView dequeueReusableCellWithIdentifier:JstyleNewsArticleDetailTitleContentCellID forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            cell.model = (self.titleModel.author_img == nil ? self.detailModel : self.titleModel);
            
            __weak typeof(self)weakSelf = self;
            cell.subscribeBlock = ^(NSString *did) {
                if ([[JstyleToolManager sharedManager] isTourist]) {
                    [[JstyleToolManager sharedManager] loginInViewController];
                    return;
                }
                //添加订阅
                [weakSelf addJstyleNewsManagerSubscriptionWithDid:did];
            };
            
            cell.tapPersonBlock = ^(NSString *did) {
                //自媒体主页
                JstyleNewsJMNumDetailsViewController *personVC = [JstyleNewsJMNumDetailsViewController new];
                personVC.did = did;
                [weakSelf.navigationController pushViewController:personVC animated:YES];
            };
            
            return cell;
        }
            break;
        case 2:{
            //webView文章
            static NSString *ID = @"WKWebViewCellID";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
            if (!cell) {
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell.contentView addSubview:self.webView];
            return cell;
        }
            break;
        case 3:{
            //推荐的文章
            
//            static NSString *ID = @"JstyleNewsVideoDetailTuijianTableViewCell";
//            JstyleNewsVideoDetailTuijianTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
//            if (!cell) {
//                cell = [[JstyleNewsVideoDetailTuijianTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
//            }
//            [cell.articleCollectionView reloadDataWithDataArray:self.dataArray];
//            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            if (!self.dataArray.count) {
                static NSString *ID = @"cellID";
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
                if (!cell) {
                    cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
                }
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                return cell;
            }
            
            JstyleNewsMyCollectionArticleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"article_cell_id" forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            if (indexPath.row < self.dataArray.count) {
                cell.model = self.dataArray[indexPath.row];
            }
            
            return cell;
        }
            break;
        case 4:{
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
                //回复
                cell.replyBtn.userInteractionEnabled = NO;
                cell.replyBlock = ^(NSString *userName, NSString *contentId) {
                    weakSelf.placeHolder.text = [NSString stringWithFormat:@"回复给%@:", userName];
                    [weakSelf.commentTextView becomeFirstResponder];
                    weakSelf.contentId = contentId;
                };
                //点赞
                cell.praiseBlock = ^(NSString *contentId, BOOL isSelected) {
                    [weakSelf addJstyleNewsArticlePraiseWithRid:contentId indexPath:indexPath];
                };
             
                
                if (indexPath.row < self.commentArray.count) {
                    cell.model = self.commentArray[indexPath.row];
                }
                cell.delegate = self;
                cell.index = indexPath;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                return cell;
            }
        }
            break;
        default:{
            UITableViewCell *cell = [UITableViewCell new];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
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
        case 0:
            return self.topContentInset;
            break;
        case 1:
            return [self.tableView cellHeightForIndexPath:indexPath model:(self.titleModel?self.titleModel:self.detailModel) keyPath:@"model" cellClass:[JstyleNewsArticleDetailTitleContentCell class] contentViewWidth:kScreenWidth];
            break;
        case 2:
            
            return _webViewHeight;
            break;
        case 3:
        {
            //            if (!self.dataArray.count) return 0;
            //            return 160;
            JstyleNewsMyCollectionModel * model = self.dataArray[indexPath.row];
            if ([model.poster isNotBlank]) {
                return ArticleImg_H + 31;
            } else {//无图情况
                
                CGRect labelF  = [[NSString stringWithFormat:@"%@",model.title] getAttributedStringRectWithSpace:3
                                                                                                        withFont:18
                                                                                                       withWidth:SCREEN_W-20];
                return labelF.size.height+15+12+31;
            }
        }
            
            break;
        case 4:
        {
            if (!self.commentArray.count) return 250;
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

#pragma mark - 跳转到评论详情---推荐文章详情
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 4) {
        if (indexPath.row < self.commentArray.count) {
            JstyleNewsCommentModel *model = self.commentArray[indexPath.row];
            JstyleNewsCoverCommentViewController *jstyleNewsVideoCCVC = [JstyleNewsCoverCommentViewController new];
            jstyleNewsVideoCCVC.model = model;
            jstyleNewsVideoCCVC.vid = self.rid;
            jstyleNewsVideoCCVC.type = @"1";
            self.isPushToCommentVC = YES;
            [self.navigationController pushViewController:jstyleNewsVideoCCVC animated:YES];
        }
    }else if (indexPath.section == 3) {
        JstyleNewsArticleDetailViewController *articleVC = [JstyleNewsArticleDetailViewController new];
        if (indexPath.row < self.dataArray.count) {
            JstyleNewsMyCollectionModel * dataModel = self.dataArray[indexPath.row];
            articleVC.rid = dataModel.id;
            JstyleNewsArticleDetailModel * model = [JstyleNewsArticleDetailModel new];
            model.title = dataModel.title;
            model.content = dataModel.content;
            model.author_img = dataModel.author_img;
            model.author_did = dataModel.author_did;
            model.author_name = dataModel.author_name;
            
            model.poster = dataModel.poster;
            model.ctime = dataModel.ctime;
            model.cname = dataModel.cname;
            model.isShowAuthor = dataModel.isShowAuthor;
            model.TOrFOriginal = dataModel.TOrFOriginal;//#内容精选
            articleVC.titleModel = model;
        }
        [self.navigationController pushViewController:articleVC animated:YES];
    }
}

#pragma mark - 导航每次跳转调用跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    // 获取点击的图片
    if ([navigationAction.request.URL.scheme isEqualToString:@"image-preview"]) {
        NSString *URLpath = [navigationAction.request.URL.absoluteString substringFromIndex:[@"image-preview:" length]];
        
        URLpath = [URLpath stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        for (NSInteger i = 0; i<_imageUrlArray.count; i++) {
            if ([URLpath isEqualToString:_imageUrlArray[i]]) {
                _index = i;
            }
        }
        
        SDPhotoBrowser *browser = [[SDPhotoBrowser alloc] init];
        browser.currentImageIndex = _index;
        browser.sourceImagesContainerView = _contenterView;
        browser.imageCount = _imageUrlArray.count;
        browser.delegate = self;
        [browser show];
        
    }
    decisionHandler(WKNavigationActionPolicyAllow);
}

#pragma mark - SDPhotoBrowserDelegate
- (NSURL *)photoBrowser:(SDPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index
{
    NSString *imageName = _imageUrlArray[index];
    NSURL *url = [[NSBundle mainBundle] URLForResource:imageName withExtension:nil];
    return url;
}

- (UIImage *)photoBrowser:(SDPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index
{
    UIImageView *imageView = _imageArray[index];
    return imageView.image;
}


#pragma mark - 滑动代理
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == self.tableView) {
        [self.webView setNeedsLayout];
   
    
        CGFloat offsetY = scrollView.contentOffset.y + _tableView.contentInset.top;//注意
        if (self.topContentInset>100) {
        
            [self imageArticalWithoffsetY:offsetY];

        }else{
            [self textArticalWithoffsetY:offsetY];
        }
        
    
    }
}

#pragma mark - 滑动有图的文章
- (void)imageArticalWithoffsetY:(CGFloat)offsetY {
    
    if (offsetY <= self.topContentInset) {
        if (ISNightMode) {
            [self.backBtn setImage:JSImage(@"文章返回黑") forState:(UIControlStateNormal)];
            [self.shareBtn setImage:JSImage(@"图集分享黑") forState:(UIControlStateNormal)];
        }else{
            [self.backBtn setImage:JSImage(@"文章返回白") forState:(UIControlStateNormal)];
            [self.shareBtn setImage:JSImage(@"图集分享白") forState:(UIControlStateNormal)];
        }
    }
    
    
    if (offsetY <= self.topContentInset) {
        
        _alphaMemory = offsetY/(self.topContentInset) >= 1 ? 1 : offsetY/(self.topContentInset);
        self.naviBar.backgroundColor = kNightBackColor(_alphaMemory);
        
        self.titleLab.text = @"";
    }else if (offsetY > self.topContentInset) {
        _alphaMemory = 1;
        
        self.naviBar.backgroundColor = kNightBackColor(1);
        
        if (self.detailModel || self.titleModel) {
            self.titleLab.text = (self.titleModel?self.titleModel.title:self.detailModel.title);
        }
        if (!ISNightMode) {
            [self.backBtn setImage:JSImage(@"文章返回黑") forState:(UIControlStateNormal)];
            [self.shareBtn setImage:JSImage(@"图集分享黑") forState:(UIControlStateNormal)];
        }else{
            [self.backBtn setImage:JSImage(@"文章返回白") forState:(UIControlStateNormal)];
            [self.shareBtn setImage:JSImage(@"图集分享白") forState:(UIControlStateNormal)];
            
        }
    }
    
    if (offsetY < 0.000001) {
        _headerImageView.transform = CGAffineTransformMakeScale(1 + offsetY/(-200), 1 + offsetY/(-200));
        CGRect frame = _headerImageView.frame;
        frame.origin.y = 0;
        _headerImageView.frame = frame;
    }else{
        _headerImageView.transform = CGAffineTransformMakeScale(1, 1);
        _headerImageView.frame = CGRectMake(0, - (offsetY/4), kScreenWidth, 200*kScreenWidth/375.0);
    }
}
#pragma mark - 滑动无图的文章
- (void)textArticalWithoffsetY:(CGFloat)offsetY {
    
    
    if (offsetY <= self.topContentInset) {
        _alphaMemory = offsetY/(self.topContentInset) >= 1 ? 1 : offsetY/(self.topContentInset);
        self.titleLab.alpha = _alphaMemory;
       
//        self.titleLab.text = @"";
        
    }else if (offsetY > self.topContentInset) {
        _alphaMemory = 1;
        self.titleLab.alpha = _alphaMemory;
        if (self.detailModel || self.titleModel) {
            self.titleLab.text = (self.titleModel?self.titleModel.title:self.detailModel.title);
        }
       
    }
    
}

#pragma mark - 获取头部标题、点赞、收藏的数据
- (void)getJstyleNewsArticlePraiseStatus
{
    JstyleNewsNetworkManager *manager = [JstyleNewsNetworkManager shareManager];
    
    NSDictionary *paramaters = @{
                                 @"id":[NSString stringWithFormat:@"%@",self.rid],
                                 @"uid":[[JstyleToolManager sharedManager] getUserId],
                                 @"uuid":[[JstyleToolManager sharedManager] getUDID]
                                 };
    [manager GETURL:ARTICLE_DETAIL_URL parameters:paramaters success:^(id responseObject) {
        
        if (![responseObject[@"code"] isEqualToString:@"1"]) {
            return ;
        }
        
        self.detailModel = [JstyleNewsArticleDetailModel modelWithJSON:responseObject[@"data"][@"article"]];
        // 获取当前自媒体订阅状态,重新获取预加载的titleModel
        if (self.titleModel != nil) {
            self.titleModel.isShowAuthor = self.detailModel.isShowAuthor;
        }
        [self.tableView reloadSection:1 withRowAnimation:UITableViewRowAnimationNone];
        
        //推荐、评论数据
        [self.dataArray removeAllObjects];
        [self.commentArray removeAllObjects];
        [self.dataArray addObjectsFromArray:[NSArray modelArrayWithClass:[JstyleNewsMyCollectionModel class] json:responseObject[@"data"][@"article"][@"articleAss"]]];
        [self.commentArray addObjectsFromArray:[NSArray modelArrayWithClass:[JstyleNewsCommentModel class] json:responseObject[@"data"][@"commentList"]]];
        self.commentCount = responseObject[@"data"][@"commentCount"];
        
        //点赞、收藏状态
        NSString *numStr = responseObject[@"data"][@"commentCount"];
        
        self.commentLabel.hidden = (([numStr integerValue] == 0)?YES:NO);
        if ([numStr integerValue] > 9999) {
            self.commentLabel.text = [NSString stringWithFormat:@"%.1f万  ",[numStr integerValue]/10000.0];
        }else{
            self.commentLabel.text = [NSString stringWithFormat:@"%@  ",numStr];
        }
        
        if ([responseObject[@"data"][@"stateMap"][@"praise_type"] integerValue] == 1) {
            [self.dianZanBtn setImage:JSImage(@"视频点赞红") forState:(UIControlStateNormal)];
        }else{
            [self.dianZanBtn setImage:JSImage(@"视频点赞线") forState:(UIControlStateNormal)];
        }
        
        if ([responseObject[@"data"][@"stateMap"][@"follow_type"] integerValue] == 1) {
            [self.shouCangBtn setImage:JSImage(@"视频收藏红") forState:(UIControlStateNormal)];
        }else{
            [self.shouCangBtn setImage:JSImage(@"视频收藏线") forState:(UIControlStateNormal)];
        }
        [self.tableView reloadData];
    } failure:nil];
}

#pragma mark - 添加评论数据
- (void)addJstyleNewsArticleCommentData
{
    NSDictionary *parameters = @{@"uid":[[JstyleToolManager sharedManager] getUserId],
                                 @"type":@"1",
                                 @"hid":[NSString stringWithFormat:@"%@",self.rid],
                                 @"content":self.commentTextView.text,
                                 @"pid":@""
                                 };
    [[JstyleNewsNetworkManager shareManager] POSTURL:ADD_COMMENT_URL parameters:parameters success:^(id responseObject) {
        
        if ([responseObject[@"code"] integerValue] == 1) {
            ZTShowAlertMessage(@"发布成功");
            self.commentTextView.text = @"";
            self.placeHolder.hidden = NO;
            [self getJstyleNewsArticlePraiseStatus];
            [self.tableView scrollToBottom];
        }
        
    } failure:^(NSError *error) {
        ZTShowAlertMessage(@"评论失败, 请稍后再试");
    }];
}

#pragma mark - 回复某条评论数据
- (void)addJstyleNewsVideoCommentWithPid:(NSString *)pid
{
    NSDictionary *parameters = @{@"uid":[[JstyleToolManager sharedManager] getUserId],
                                 @"type":@"1",
                                 @"hid":[NSString stringWithFormat:@"%@",self.rid],
                                 @"content":self.commentTextView.text,
                                 @"pid":pid
                                 };
    [[JstyleNewsNetworkManager shareManager] POSTURL:ADD_COMMENT_URL parameters:parameters success:^(id responseObject) {
        
        if ([responseObject[@"code"] integerValue] == 1) {
            ZTShowAlertMessage(@"回复成功");
            self.commentTextView.text = @"";
            self.placeHolder.hidden = NO;
            [self getJstyleNewsArticlePraiseStatus];
        }
        
    } failure:^(NSError *error) {
        ZTShowAlertMessage(@"评论失败, 请稍后再试");
    }];
}

#pragma mark - 添加文章点赞、收藏
- (void)addJstyleNewsArticlePraise
{
    NSDictionary *parameters = @{@"platform_type":@"2",
                                 @"rid":[NSString stringWithFormat:@"%@",self.rid],
                                 @"type":@"1",
                                 @"uid":[[JstyleToolManager sharedManager] getUserId],
                                 @"uuid":[[JstyleToolManager sharedManager] getUDID]
                                 };
    [[JstyleNewsNetworkManager shareManager] GETURL:ADD_PRAISE_URL parameters:parameters success:^(id responseObject) {
        
        if ([responseObject[@"code"] integerValue] == 1) {
            //震动反馈
            UIImpactFeedbackGenerator *impactFeedback = [[UIImpactFeedbackGenerator alloc] initWithStyle:UIImpactFeedbackStyleLight];
            [impactFeedback impactOccurred];
            
            if ([responseObject[@"data"][@"praise_type"] integerValue] == 1) {
                [self.dianZanBtn setImage:JSImage(@"视频点赞红") forState:(UIControlStateNormal)];
                [ThumbUpSpecialEffec addThumbUpSpecialEffecWithBigShineColor:RGBACOLOR(255, 95, 89, 1) smallShineColor:RGBACOLOR(216, 152, 148, 1) shineFillColor:RGBACOLOR(171, 171, 171, 1) button:self.dianZanBtn];
            }else{
                [self.dianZanBtn setImage:JSImage(@"视频点赞线") forState:(UIControlStateNormal)];
            }
        }else{
            ZTShowAlertMessage(responseObject[@"data"]);
        }
    } failure:^(NSError *error) {
        
    }];
}

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
            [self.shouCangBtn setImage:JSImage(@"视频收藏红") forState:(UIControlStateNormal)];
        }else{
            [self.shouCangBtn setImage:JSImage(@"视频收藏线") forState:(UIControlStateNormal)];
        }
        
    } failure:nil];
}

#pragma mark - 添加评论点赞
- (void)addJstyleNewsArticlePraiseWithRid:(NSString *)rid indexPath:(NSIndexPath *)indexPath
{
    NSDictionary *parameters = @{@"platform_type":@"2",
                                 @"rid":[NSString stringWithFormat:@"%@",rid],
                                 @"type":@"3",
                                 @"uid":[[JstyleToolManager sharedManager] getUserId],
                                 @"uuid":[[JstyleToolManager sharedManager] getUDID]
                                 };
    [[JstyleNewsNetworkManager shareManager] GETURL:ADD_PRAISE_URL parameters:parameters success:^(id responseObject) {
        
        if ([responseObject[@"code"] integerValue] == 1) {
            JstyleNewsCommentModel *model = self.commentArray[indexPath.row];
            model.is_praise = responseObject[@"data"][@"praise_type"];
            model.praise_num = [NSString stringWithFormat:@"%ld",[model.praise_num integerValue] + ([model.is_praise integerValue] == 1 ? 1: - 1)];
            
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

#pragma mark - 添加订阅 - 或者关注/
- (void)addJstyleNewsManagerSubscriptionWithDid:(NSString *)did
{
    if ([[JstyleToolManager sharedManager] isTourist]) {
        [[JstyleToolManager sharedManager] loginInViewController];
        return;
    }
    if (@available(iOS 10.0, *)) {
        UIImpactFeedbackGenerator *impactFeedback = [[UIImpactFeedbackGenerator alloc] initWithStyle:UIImpactFeedbackStyleLight];
        [impactFeedback impactOccurred];
    }
    NSDictionary *parameters = @{@"platform_type":@"2",
                                 @"did":[NSString stringWithFormat:@"%@",did],
                                 @"uid":[[JstyleToolManager sharedManager] getUserId],
                                 @"uuid":[[JstyleToolManager sharedManager] getUDID]
                                 };
    [[JstyleNewsNetworkManager shareManager] GETURL:MANAGER_SUBSCRIPTION_URL parameters:parameters success:^(id responseObject) {
        if ([responseObject[@"code"] integerValue] == 1) {
            NSString *followType = responseObject[@"data"][@"follow_type"];
            self.detailModel.isShowAuthor = followType;
            self.titleModel.isShowAuthor = followType;
            [self.tableView reloadRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1] withRowAnimation:(UITableViewRowAnimationNone)];
        }else{
            if ([responseObject[@"data"] isKindOfClass:[NSString class]]) {
                ZTShowAlertMessage(responseObject[@"data"]);
            }
        }
    } failure:nil];
}

#pragma mark - 分享数据*/
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

#pragma mark - 添加评论输入框
- (void)addCommentToolBar
{
    _commentBar = [[JstyleNewsBaseBottomView alloc] initWithFrame:CGRectMake(0, kScreenHeight - 124-YG_SafeBottom_H/2, kScreenWidth, 124)];
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
    _sendButton.frame = CGRectMake(kScreenWidth - 77, 85, 70, 30);
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
    
    self.toolBarHoldView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_W, SCREEN_H)];
    self.toolBarHoldView.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.3];
    
    [self.toolBarHoldView addSubview:_commentBar];
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


#pragma mark - 添加底部按钮
- (void)setBottomViewAndButtons
{
    CGFloat bottomViewHeight = IS_iPhoneX ? 78 : 48;
    _bottomView = [[UIView alloc]init];
    _bottomView.backgroundColor = kLightWhiteColor;
    [self.view addSubview:_bottomView];
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
    //收藏
    _shouCangBtn = [[UIButton alloc]init];
    [_shouCangBtn setImage:JSImage(@"视频收藏线") forState:UIControlStateNormal];
    [_shouCangBtn addTarget:self action:@selector(shouCangBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_bottomView addSubview:_shouCangBtn];
    _shouCangBtn.sd_layout
    .rightSpaceToView(_bottomView, 15)
    .topSpaceToView(_bottomView, 15)
    .widthIs(20)
    .heightIs(20);
    //点赞
    _dianZanBtn = [[UIButton alloc]init];
    [_dianZanBtn setImage:JSImage(@"视频点赞线") forState:(UIControlStateNormal)];
    [_dianZanBtn addTarget:self action:@selector(dianZanBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_bottomView addSubview:_dianZanBtn];
    _dianZanBtn.sd_layout
    .rightSpaceToView(_shouCangBtn, 25)
    .topSpaceToView(_bottomView, 15)
    .widthIs(20)
    .heightIs(20);
    //评论
    UIButton *commentBtn = [[UIButton alloc]init];
    [commentBtn setImage:JSImage(@"文章评论") forState:UIControlStateNormal];
    [commentBtn addTarget:self action:@selector(commentBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_bottomView addSubview:commentBtn];
    commentBtn.sd_layout
    .rightSpaceToView(_dianZanBtn, 25)
    .topSpaceToView(_bottomView, 15)
    .widthIs(18)
    .heightIs(20);
    
    _commentLabel = [[UILabel alloc]init];
    _commentLabel.backgroundColor = [UIColor redColor];
    _commentLabel.clipsToBounds = YES;
    _commentLabel.layer.cornerRadius = 5;
    _commentLabel.adjustsFontSizeToFitWidth = YES;
    _commentLabel.textColor = kWhiteColor;
    _commentLabel.font = [UIFont systemFontOfSize:8];
    _commentLabel.textAlignment = NSTextAlignmentCenter;
    [_bottomView addSubview:_commentLabel];
    _commentLabel.sd_layout
    .leftSpaceToView(commentBtn, - 5)
    .bottomSpaceToView(commentBtn, - 5)
    .heightIs(10);
    [_commentLabel setSingleLineAutoResizeWithMaxWidth:30];
}
#pragma mark - 点击评论图标，跳转到评论列表
- (void)commentBtnClicked:(UIButton *)sender
{
    if ([[JstyleToolManager sharedManager] getCurrentNetStatus] == NotReachable) {
        ZTShowAlertMessage(@"当前无网络,请检查网络");
        return;
    }
    JstyleNewsCommentViewController *jstyleNewsVideoCVC = [JstyleNewsCommentViewController new];
    jstyleNewsVideoCVC.type = @"1";
    jstyleNewsVideoCVC.vid = self.rid;

    self.isPushToCommentVC = YES;
    [self.navigationController pushViewController:jstyleNewsVideoCVC animated:YES];
}

- (void)shouCangBtnClicked:(UIButton *)sender
{
    if ([[JstyleToolManager sharedManager] getCurrentNetStatus] == NotReachable) {
        ZTShowAlertMessage(@"当前无网络,请检查网络");
        return;
    }
    [self addJstyleNewsArticleCollection];
}

- (void)dianZanBtnClicked:(UIButton *)sender
{
    if ([[JstyleToolManager sharedManager] getCurrentNetStatus] == NotReachable) {
        ZTShowAlertMessage(@"当前无网络,请检查网络");
        return;
    }
    [self addJstyleNewsArticlePraise];
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
        ZTShowAlertMessage(@"昵称不能含有表情等特殊字符");
        return;
    }
    if (self.contentId) {
        [self addJstyleNewsVideoCommentWithPid:self.contentId];
    }else{
        [self addJstyleNewsArticleCommentData];
    }
    [_commentTextView resignFirstResponder];
    _placeHolder.text = @"说点什么...";
    _toolBarHoldView.hidden = YES;
    self.contentId = nil;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [_commentTextView resignFirstResponder];
    _placeHolder.text = @"说点什么...";
    _toolBarHoldView.hidden = YES;
    self.contentId = nil;
}

- (UIView *)addHeaderViewWithTitle:(NSString *)title columnHidden:(BOOL)columnHidden
{
    JstyleNewsBaseView *headerView = [[JstyleNewsBaseView alloc] init];
    UIView *singleLine = [[UIView alloc] init];
    singleLine.backgroundColor = ISNightMode?kDarkThreeColor:kSingleLineColor;
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
    nameLabel.font = [UIFont systemFontOfSize:18 weight:(UIFontWeightMedium)];
    nameLabel.text = title;
    nameLabel.textColor = ISNightMode?kDarkFiveColor:kDarkOneColor;
    [headerView addSubview:nameLabel];
    nameLabel.sd_layout
    .centerYEqualToView(squareView)
    .leftSpaceToView(squareView, 10)
    .rightSpaceToView(headerView, 10)
    .heightIs(20);
    
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
    jstyleNewsVideoCVC.type = @"1";
    jstyleNewsVideoCVC.vid = self.rid;
    self.isPushToCommentVC = YES;
    [self.navigationController pushViewController:jstyleNewsVideoCVC animated:YES];
}

- (void)leftBarButtonAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)rightBarButtonAction
{
    [[JstyleToolManager sharedManager] shareActionWithShareTitle:self.shareTitle shareDesc:self.shareDesc shareImgUrl:self.shareImgUrl shareLinkUrl:self.shareUrl viewController:self];
}

#pragma mark - 加载文章模板并加载本地内容数据
- (void)loadLocalContent {
    if ([self.titleModel.poster isNotBlank]) {
         [self.headerImageView setImageWithURL:[NSURL URLWithString:self.titleModel.poster] placeholder:[UIImage imageNamed:@"placeholder"]];
    }else {
        
        [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:self.titleModel.poster]];
        
    }
    
   
    
    NSString *path = [[NSBundle mainBundle] bundlePath];
    NSURL *baseURL = [NSURL fileURLWithPath:path];
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"JstyleNewsArticleTemplate" ofType:@"html"];
    NSString *articleTemplate = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    
    if (self.titleModel.title != nil && self.titleModel.content != nil) {
        
        NSString *HTMLTitleString = [articleTemplate stringByReplacingOccurrencesOfString:@"标题" withString:self.titleModel.title];
        NSString *HTMLString = [HTMLTitleString stringByReplacingOccurrencesOfString:@"内容" withString:self.titleModel.content];
        [self.webView loadHTMLString:HTMLString baseURL:baseURL];
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.noSingleView removeFromSuperview];
        self.noSingleView = nil;
        self.tableView.scrollEnabled = YES;
    });
}

#pragma mark - 加载文章模板并请求网络内容数据
- (void)loadNetworkContent {
    
    JstyleNewsNetworkManager *manager = [JstyleNewsNetworkManager shareManager];
    NSDictionary *paramaters = @{
                                 @"id":[NSString stringWithFormat:@"%@",self.rid],
                                 @"uid":[[JstyleToolManager sharedManager] getUserId],
                                 @"uuid":[[JstyleToolManager sharedManager] getUDID]
                                 };
    
    [manager GETURL:ARTICLE_DETAIL_URL parameters:paramaters success:^(id responseObject) {
        
        if (![responseObject[@"code"] isEqualToString:@"1"]) {
            ZTShowAlertMessage(responseObject[@"error"]);
            return ;
        }
        self.detailModel = [JstyleNewsArticleDetailModel modelWithJSON:responseObject[@"data"][@"article"]];
        if ([self.detailModel.poster isNotBlank]) {
            self.headerImageView.hidden = NO;
            self.topContentInset = 200*kScreenWidth/375.0;
            [self.headerImageView setImageWithURL:[NSURL URLWithString:self.detailModel.poster] placeholder:[UIImage imageNamed:@"placeholder"]];
        }else{
            self.headerImageView.hidden = YES;
            self.topContentInset = YG_StatusAndNavightion_H;
            self.headerImageView.frame = CGRectMake(0, 0, SCREEN_W, 0);
        }
       
        
        NSString *titleString = self.detailModel.title;
        NSString *contentString = self.detailModel.content;
        
        NSString *path = [[NSBundle mainBundle] bundlePath];
        NSURL *baseURL = [NSURL fileURLWithPath:path];
        
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"JstyleNewsArticleTemplate" ofType:@"html"];
        NSString *articleTemplate = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
        
        if (titleString != nil && contentString != nil) {
            NSString *HTMLTitleString = [articleTemplate stringByReplacingOccurrencesOfString:@"标题" withString:titleString];
            NSString *HTMLString = [HTMLTitleString stringByReplacingOccurrencesOfString:@"内容" withString:contentString];
            
            [self.webView loadHTMLString:HTMLString baseURL:baseURL];
        }
        
        [self.noSingleView removeFromSuperview];
        self.noSingleView = nil;
        self.tableView.scrollEnabled = YES;
        [SVProgressHUD dismiss];
        
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
        [SVProgressHUD dismiss];
    }];
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

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return ISNightMode?UIStatusBarStyleLightContent:UIStatusBarStyleDefault;
}

@end


