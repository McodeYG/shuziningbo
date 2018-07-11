//
//  ICityCultureDetailViewController.m
//  iCity
//
//  Created by 王磊 on 2018/5/3.
//  Copyright © 2018年 LongYuan. All rights reserved.
//  文化地图 -- 旅游景点

#import "ICityCultureDetailViewController.h"
#import "JstyleNewsVideoDetailTuijianTableViewCell.h"
#import "JstyleNewsCommentViewCell.h"
#import "JstyleNewsCommentPlaceHolderCell.h"
#import "JstyleNewsCoverCommentViewController.h"
#import "JstyleNewsCommentViewController.h"
#import "WRNavigationBar.h"
#import <WebKit/WebKit.h>
#import "ICityCultureDetailTitleContentCell.h"
#import "JstyleNewsArticleDetailTuijianModel.h"
#import "SDPhotoBrowser.h"
#import "JstyleNewsJMNumDetailsViewController.h"

@interface ICityCultureDetailViewController ()<UITableViewDelegate, UITableViewDataSource, UITextViewDelegate, WKUIDelegate, WKNavigationDelegate,SDPhotoBrowserDelegate>

@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, strong) WKUserScript *userScript;
@property (nonatomic, assign) NSInteger webViewHeight;
@property (nonatomic, strong) JstyleNewsArticleDetailModel *detailModel;
@property (nonatomic, assign) NSInteger currentWebViewHeight;

/**webView的进度条*/
@property (nonatomic, strong) UIProgressView *progressView;

@property (nonatomic, assign) NSInteger index;
@property (nonatomic, strong) NSMutableArray *imageArray;
@property (nonatomic, strong) NSMutableArray *imageUrlArray;
@property (nonatomic, strong) UIView *contenterView;

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSMutableArray *commentArray;
@property (nonatomic, copy) NSString *commentCount;
@property (nonatomic, copy) NSString *contentId;

@property (nonatomic, strong) UIImageView *headerImageView;
@property (nonatomic, assign) CGFloat alphaMemory;
@property (nonatomic, assign) CGFloat topContentInset;
//分享
@property (nonatomic, copy) NSString *shareImgUrl;
@property (nonatomic, copy) NSString *shareUrl;
@property (nonatomic, copy) NSString *shareTitle;
@property (nonatomic, copy) NSString *shareDesc;

@property (nonatomic, strong) JstyleNewsNoSinglePlaceholderView *noSingleView;

@end

static NSString *ICityCultureDetailTitleContentCellID = @"ICityCultureDetailTitleContentCellID";

@implementation ICityCultureDetailViewController

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
        _webViewHeight = kScreenHeight;
        _webView = [[WKWebView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) configuration:configuration];
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
        
        _progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, 211*kScreenWidth/375.0, kScreenWidth, 2)];
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
    
    self.view.backgroundColor = kWhiteColor;
    self.webView.backgroundColor = kWhiteColor;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self removeBarBackgroundView];
    });
    
    [self addLeftBarButtonWithImage:JSImage(@"文章返回白") action:@selector(leftBarButtonAction)];
    
    _topContentInset = 200*kScreenWidth/375.0;
    [self addScaleImageView];
    [self addTableView];
    [self setupWKWebView];
    [self getShareData];
    [self addNoSingleView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    

    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.navigationController.navigationBar.translucent = YES;
    NSDictionary *titleColor = @{
                                 NSForegroundColorAttributeName:kNightModeTitleColor,
                                 NSFontAttributeName:[UIFont systemFontOfSize:18]
                                 };
    [self.navigationController.navigationBar setTitleTextAttributes:titleColor];
    
    if (ISNightMode) {
        [self addLeftBarButtonWithImage:JSImage(@"文章返回黑") action:@selector(leftBarButtonAction)];
        [self addRightBarButtonWithFirstImage:JSImage(@"图集分享黑") action:@selector(rightBarButtonAction)];
    }else{
        [self addLeftBarButtonWithImage:JSImage(@"文章返回白") action:@selector(leftBarButtonAction)];
        [self addRightBarButtonWithFirstImage:JSImage(@"图集分享白") action:@selector(rightBarButtonAction)];
    }
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    if (_alphaMemory >0) {
        
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:kNightBackColor(_alphaMemory)] forBarMetrics:(UIBarMetricsDefault)];
    }else{
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:kNightBackColor(0)] forBarMetrics:(UIBarMetricsDefault)];
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

- (void)addNoSingleView{
    if ([[JstyleToolManager sharedManager] getCurrentNetStatus] == NotReachable) {
        self.noSingleView = [[JstyleNewsNoSinglePlaceholderView alloc] initWithFrame:CGRectMake(0, 211*kScreenWidth/375.0, kScreenWidth, (kScreenHeight - 211*kScreenWidth/375.0 - (IS_iPhoneX ? 58 : 48)))];
        [self.view addSubview:self.noSingleView];
        self.tableView.scrollEnabled = NO;
        __weak typeof(self)weakSelf = self;
        self.noSingleView.reloadBlock = ^{
            [SVProgressHUD showWithStatus:@"正在努力加载"];
            [weakSelf loadNetworkContent];
        };
    }
}

- (void)removeBarBackgroundView {
    [self wr_setNavBarBackgroundAlpha:0];
    [self wr_setNavBarShadowImageHidden:YES];
    UIView *barBackgroundView = self.navigationController.navigationBar.subviews.firstObject;
    if (@available(iOS 11.0, *))
    {   // sometimes we can't change _UIBarBackground alpha
        for (UIView *view in barBackgroundView.subviews) {
            view.alpha = 0;
        }
    } else {
        barBackgroundView.alpha = 0;
    }
}

#pragma mark - 动态选择加载方式(本地预加载 or 当前页请求)
- (void)setupWKWebView {
    
    if (self.titleModel == nil) {
        [self loadNetworkContent];
    } else {
        if ([self.titleModel.content isNotBlank]) {
             [self loadLocalContent];
        } else {
             [self loadNetworkContent];
        }
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
        
        _webViewHeight = self.webView.scrollView.contentSize.height;
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
    self.headerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 211*kScreenWidth/375.0)];
    self.headerImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.headerImageView.clipsToBounds = YES;
    self.headerImageView.image = [UIImage imageNamed:@"placeholder"];
    [self.view addSubview:self.headerImageView];
}

- (void)addTableView
{
    _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:(UITableViewStylePlain)];
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
    [_tableView registerNib:[UINib nibWithNibName:@"ICityCultureDetailTitleContentCell" bundle:nil] forCellReuseIdentifier:ICityCultureDetailTitleContentCellID];
    
    [self.view addSubview:_tableView];
    _tableView.sd_layout
    .topSpaceToView(self.view, 0)
    .bottomSpaceToView(self.view, 0)
    .leftEqualToView(self.view)
    .rightEqualToView(self.view);
}

#pragma mark -- tableView的代理方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
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
            ICityCultureDetailTitleContentCell *cell = [tableView dequeueReusableCellWithIdentifier:ICityCultureDetailTitleContentCellID forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            cell.model = (self.titleModel == nil ? self.detailModel : self.titleModel);
            __weak typeof(self)weakSelf = self;
            cell.subscribeBlock = ^(NSString *did) {
                if ([[JstyleToolManager sharedManager] isTourist]) {
                    [[JstyleToolManager sharedManager] loginInViewController];
                    return;
                }
                [weakSelf addJstyleNewsManagerSubscriptionWithDid:did];
            };
            
            cell.tapPersonBlock = ^(NSString *did) {
                JstyleNewsJMNumDetailsViewController *personVC = [JstyleNewsJMNumDetailsViewController new];
                personVC.did = did;
                [weakSelf.navigationController pushViewController:personVC animated:YES];
            };
            
            return cell;
        }
            break;
        case 2:{
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
        default:{
            UITableViewCell *cell = [UITableViewCell new];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
            return 211*kScreenWidth/375.0;
            break;
        case 1:
            return self.titleModel ? self.titleModel.cellHeight : self.detailModel.cellHeight;
            break;
        case 2:
            return _webViewHeight;
            break;
        default:
            return 0;
            break;
    }
}

#pragma mark - 导航每次跳转调用跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    // 获取点击的图片
    if ([navigationAction.request.URL.scheme isEqualToString:@"image-preview"]) {
        NSString *URLpath = [navigationAction.request.URL.absoluteString substringFromIndex:[@"image-preview:" length]];
        
        URLpath = [URLpath stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        for (NSInteger i = 0; i<self.imageUrlArray.count; i++) {
            if ([URLpath isEqualToString:self.imageUrlArray[i]]) {
                _index = i;
            }
        }
        
        SDPhotoBrowser *browser = [[SDPhotoBrowser alloc] init];
        browser.currentImageIndex = _index;
        browser.sourceImagesContainerView = _contenterView;
        browser.imageCount = self.imageUrlArray.count;
        browser.delegate = self;
        [browser show];
        
    }
    decisionHandler(WKNavigationActionPolicyAllow);
}

#pragma mark - SDPhotoBrowserDelegate
- (NSURL *)photoBrowser:(SDPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index
{
    NSString *imageName = self.imageUrlArray[index];
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
    }
    
    CGFloat offsetY = scrollView.contentOffset.y + _tableView.contentInset.top;//注意
    if (offsetY <= _topContentInset) {
        _alphaMemory = offsetY/(_topContentInset) >= 1 ? 1 : offsetY/(_topContentInset);

        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:kNightBackColor(_alphaMemory)] forBarMetrics:(UIBarMetricsDefault)];

        if (offsetY <= _topContentInset) {
            if (ISNightMode) {
                [self addLeftBarButtonWithImage:JSImage(@"文章返回黑")action:@selector(leftBarButtonAction)];
                [self addRightBarButtonWithFirstImage:JSImage(@"图集分享黑") action:@selector(rightBarButtonAction)];
            }else{
                [self addLeftBarButtonWithImage:JSImage(@"文章返回白") action:@selector(leftBarButtonAction)];
                [self addRightBarButtonWithFirstImage:JSImage(@"图集分享白") action:@selector(rightBarButtonAction)];
            }
        }
        
        
        
        self.title = @"";
    }else if (offsetY > _topContentInset) {
        _alphaMemory = 1;
//        [self wr_setNavBarBackgroundAlpha:1];
//        [self wr_setNavBarShadowImageHidden:NO];
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:kNightBackColor(1)] forBarMetrics:(UIBarMetricsDefault)];
        
        if (!ISNightMode) {
            [self addLeftBarButtonWithImage:JSImage(@"文章返回黑") action:@selector(leftBarButtonAction)];
            [self addRightBarButtonWithFirstImage:JSImage(@"图集分享黑") action:@selector(rightBarButtonAction)];
        }else{
            [self addLeftBarButtonWithImage:JSImage(@"文章返回白") action:@selector(leftBarButtonAction)];
            [self addRightBarButtonWithFirstImage:JSImage(@"图集分享白") action:@selector(rightBarButtonAction)];
        }
        
        if (self.detailModel || self.titleModel) {
            self.title = (self.titleModel?self.titleModel.title:@"");
        }
    }
    
    if (offsetY < 0.000001) {
        _headerImageView.transform = CGAffineTransformMakeScale(1 + offsetY/(-200), 1 + offsetY/(-200));
        CGRect frame = _headerImageView.frame;
        frame.origin.y = 0;
        _headerImageView.frame = frame;
    }else{
        _headerImageView.transform = CGAffineTransformMakeScale(1, 1);
        _headerImageView.frame = CGRectMake(0, - (offsetY/4), kScreenWidth, 211*kScreenWidth/375.0);
    }
}

#pragma mark - 加载文章模板并加载本地内容数据
- (void)loadLocalContent {
    
    if (self.poster) {
        [self.headerImageView setImage:self.poster];
    } else {
        [self.headerImageView setImageWithURL:[NSURL URLWithString:self.titleModel.poster] placeholder:SZ_Place_Header];
    }
    
    NSString *path = [[NSBundle mainBundle] bundlePath];
    NSURL *baseURL = [NSURL fileURLWithPath:path];
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"JstyleNewsArticleTemplate" ofType:@"html"];
    NSString *articleTemplate = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    
    if (self.titleModel.content != nil) {
        
//        NSString *HTMLTitleString = [articleTemplate stringByReplacingOccurrencesOfString:@"标题" withString:self.titleModel.title];
        NSString *HTMLTitleString = articleTemplate;
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
            NSLog(@"加载文章模板并请求网络内容数据 = %@",responseObject[@"message"]);
            return ;
        }
        self.detailModel = [JstyleNewsArticleDetailModel modelWithJSON:responseObject[@"data"][@"article"]];
        
        if (!self.titleModel.poster) {
            self.titleModel = [JstyleNewsArticleDetailModel modelWithJSON:responseObject[@"data"][@"article"]];
        }
        
        if (self.poster) {
            [self.headerImageView setImage:self.poster];
        } else {
            [self.headerImageView setImageWithURL:[NSURL URLWithString:self.titleModel.poster] placeholder:SZ_Place_Header];
        }
        
        NSString *titleString = self.detailModel.title;
        NSString *contentString = self.detailModel.content;
        
        NSString *path = [[NSBundle mainBundle] bundlePath];
        NSURL *baseURL = [NSURL fileURLWithPath:path];
        
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"JstyleNewsArticleTemplate" ofType:@"html"];
        NSString *articleTemplate = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
        
        if (contentString != nil) {
            NSString *HTMLTitleString = articleTemplate;
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

/**添加订阅*/
- (void)addJstyleNewsManagerSubscriptionWithDid:(NSString *)did
{
    if ([[JstyleToolManager sharedManager] isTourist]) {
        [[JstyleToolManager sharedManager] loginInViewController];
        return;
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
                NSLog(@"%@",responseObject[@"message"]);
            }
        }
    } failure:nil];
}

/**获取头部标题、点赞、收藏的数据*/
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
        [self.dataArray addObjectsFromArray:[NSArray modelArrayWithClass:[JstyleNewsArticleDetailTuijianModel class] json:responseObject[@"data"][@"article"][@"articleAss"]]];
        [self.commentArray addObjectsFromArray:[NSArray modelArrayWithClass:[JstyleNewsCommentModel class] json:responseObject[@"data"][@"commentList"]]];
        self.commentCount = responseObject[@"data"][@"commentCount"];
        
        [self.tableView reloadData];
        
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

- (void)leftBarButtonAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return ISNightMode?UIStatusBarStyleLightContent:UIStatusBarStyleDefault;
}

- (void)rightBarButtonAction
{
    [[JstyleToolManager sharedManager] shareActionWithShareTitle:self.shareTitle shareDesc:self.shareDesc shareImgUrl:self.shareImgUrl shareLinkUrl:self.shareUrl viewController:self];
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

@end
