//
//  JstylePartyDetailsViewController.m
//  Exquisite
//
//  Created by 数字跃动 on 2017/7/6.
//  Copyright © 2017年 Jstyle. All rights reserved.
//
//  活动详情

#import "JstylePartyDetailsViewController.h"
#import <WebKit/WebKit.h>
//#import "PlayerViewController.h"

#import "JstyleNewsArticleDetailViewController.h"
//#import "JstyleArticleCategoryViewController.h"
//#import "JstyleVideoPlayerViewController.h"
//#import "JMChoseOneViewController.h"

//#import "JMHomeBannerViewController.h"
#import "JstyleArticleCommentCollectionCell.h"
#import "JstylePartyRegistrationViewController.h"
#import <SafariServices/SafariServices.h>

// 分享
#import "ActionSheetView.h"
typedef void (^KeyboardDidMoveBlock)(CGRect keyboardFrameInView, BOOL opening, BOOL closing);
@interface JstylePartyDetailsViewController ()<UIScrollViewDelegate,WKUIDelegate,WKNavigationDelegate,
WKScriptMessageHandler,UICollectionViewDelegate,UICollectionViewDataSource, UITextViewDelegate>

/**推荐文章的collectionview*/
@property (nonatomic, strong) UICollectionView *collectionView;
/**文章的数组*/
@property (nonatomic ,strong) NSMutableArray *articleArray;
/***/
@property (nonatomic, strong) UIImageView *headerImageView;
/**webView的进度条*/
@property (nonatomic, strong) UIProgressView *progressView;


/**webView*/
@property (nonatomic, strong) WKWebView *webView;
/**添加图片标记*/
@property (nonatomic, assign)BOOL isAddHeaderImageView;
@property (nonatomic, assign)CGFloat webViewHeight;
@property (nonatomic, assign)CGFloat webMarkHeight;
/**分享的标题*/
//@property (nonatomic, copy) NSString *shareTitle;
@property (nonatomic, copy) NSString *titleName;
/**视频页面*/
//@property (nonatomic, strong) PlayerViewController *jmLiveDetailVC;
/**跳转视频页面所需要的vid*/
@property (nonatomic, copy) NSString *vidString;

@property (nonatomic, copy) NSString *shareImageurl;
@property (nonatomic, copy) NSString *ashareurl;
@property (nonatomic, copy) NSString *describes;
@property (nonatomic, copy) NSString *allString;

@property (nonatomic, strong) UIView *commentBar;
@property (nonatomic, strong) UITextView *commentTextView;
@property (nonatomic, strong) UIButton *sendButton;
@property (nonatomic, strong) UIView *holdView;
@property (nonatomic, strong) NSMutableArray *commentArray;
@property (nonatomic, strong) UIView *toolBarHoldView;
@property (nonatomic, strong) KeyboardDidMoveBlock keyboardDidMoveBlock;

@property (nonatomic, strong) UIButton *baoMingBtn;

@end

static NSInteger page;
static NSInteger typeInt;
@implementation JstylePartyDetailsViewController

- (void)dealloc
{
    [_webView removeObserver:self forKeyPath:@"estimatedProgress"];
    if (_webMarkHeight != _webViewHeight) {
        [_webView.scrollView removeObserver:self forKeyPath:@"contentSize"];
    }
}



- (NSMutableArray *)articleArray
{
    if (!_articleArray) {
        _articleArray = [NSMutableArray array];
    }
    return _articleArray;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.title = @"活动详情";
    self.view.backgroundColor = [UIColor whiteColor];
    self.extendedLayoutIncludesOpaqueBars = YES;
    _isAddHeaderImageView = NO;
    [self addRightTwoBarButtonsWithFirstImage:[UIImage imageNamed:@"分享黑色"] firstAction:@selector(firstBarButtonAction) secondImage:[UIImage imageNamed:@"点赞-黑色"] secondAction:@selector(secondBarButtonAction)];
    
//    [self addRightBarButtonWithFirstImage:[UIImage imageNamed:@"点赞-黑色"] action:@selector(secondBarButtonAction)];
    
    [self addWkWebView];
    [self addCollectionView];
    [self addCommentToolBar];
//    [self addBaoMingBtn];
    [self addReshAction];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self getShareData];
        [self getJstylePartyCommentDataSource];
    });
}

- (void)addBaoMingBtn
{
    self.baoMingBtn = [[UIButton alloc]init];
    [self.view addSubview:self.baoMingBtn];
    
    
    
    if (IS_iPhoneX) {
        self.baoMingBtn.layer.cornerRadius = 24;
        
        [self.baoMingBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.offset(48);
            make.left.offset(15);
            make.right.offset(-15);
            make.bottom.offset(-34);
        }];
    } else {
        self.baoMingBtn.sd_layout
        .leftEqualToView(self.view)
        .rightEqualToView(self.view)
        .bottomEqualToView(self.view)
        .heightIs(48);
    }
    
    [self.baoMingBtn setTitleColor:kWhiteColor forState:UIControlStateNormal];
    self.baoMingBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [self.baoMingBtn addTarget:self action:@selector(baoMingBtnClick:) forControlEvents:UIControlEventTouchUpInside];
}

-(void)baoMingBtnClick:(UIButton *)sender
{
    if ([[JstyleToolManager sharedManager] isTourist]) {
        [[JstyleToolManager sharedManager] loginInViewController];
        return;
    }
    
    [self getPartySignInDataSource];
}

/**获取必选填数*/
- (void)getPartySignInDataSource
{
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:self.partyId,@"id", nil];
    JstyleNewsNetworkManager *manager = [JstyleNewsNetworkManager shareManager];;
    
    // post请求
    [manager GETURL:JSTYLE_PARTY_SIGNIN_URL parameters:parameters success:^(id responseObject) {
        if ([responseObject[@"code"] integerValue] == 1) {
            JstylePartyRegistrationViewController *jstylePartyRegistrationVC = [JstylePartyRegistrationViewController new];
            jstylePartyRegistrationVC.partyId = self.partyId;
            jstylePartyRegistrationVC.typeStr = responseObject[@"data"][@"parameter_type"];
            [self.navigationController pushViewController:jstylePartyRegistrationVC animated:YES];
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    typeInt = 3;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self addJstylePartyCollectionDataSource];
    });
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:kNightModeBackColor] forBarMetrics:UIBarMetricsDefault];
    
    NSDictionary *navbarTitleTextAttributes = @{NSForegroundColorAttributeName:kNightModeTitleColor,
                                                NSFontAttributeName:[UIFont systemFontOfSize:18] };
    [self.navigationController.navigationBar setTitleTextAttributes:navbarTitleTextAttributes];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)addCommentToolBar
{
    _commentBar = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight, kScreenWidth, 60)];
    _commentBar.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth;
    _commentBar.backgroundColor = [UIColor whiteColor];
    self.commentTextView = [[UITextView alloc] initWithFrame:CGRectMake(5,6,_commentBar.width - 100,48)];
    self.commentTextView.layer.borderColor = kDarkNineColor.CGColor;
    self.commentTextView.layer.borderWidth = 0.3;
    self.commentTextView.layer.cornerRadius = 2;
    self.commentTextView.layer.masksToBounds = YES;
    self.commentTextView.tintColor = kNormalRedColor;
    self.commentTextView.returnKeyType = UIReturnKeyDefault;
    self.commentTextView.font = [UIFont systemFontOfSize:14];
    self.commentTextView.textColor = kDarkTwoColor;
    //    self.commentTextView.delegate = self;
    [_commentBar addSubview:self.commentTextView];
    
    _sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_sendButton setTitle:@"发送" forState:UIControlStateNormal];
    _sendButton.frame = CGRectMake(kScreenWidth - 77, 15, 70, 30);
    _sendButton.layer.cornerRadius = 15;
    _sendButton.layer.masksToBounds = YES;
    _sendButton.tintColor = [UIColor whiteColor];
    _sendButton.backgroundColor = kNormalRedColor;
    _sendButton.titleLabel.font = [UIFont systemFontOfSize:14];

    _sendButton.lee_theme
    .LeeCustomConfig(ThemeMainBtnTitleOrBorderColor, ^(id item, id value) {
        [item layer].backgroundColor = [value CGColor];
    });
    [_sendButton addTarget:self action:@selector(chatSendButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
    
    [_commentBar addSubview:_sendButton];
    
    __weak typeof (self)blockSelf = self;
    self.keyboardDidMoveBlock =^(CGRect keyboardFrameInView, BOOL opening, BOOL closing){
        CGRect toolBarFrame = blockSelf.commentBar.frame;
        toolBarFrame.origin.y = keyboardFrameInView.origin.y - toolBarFrame.size.height;
        blockSelf.commentBar.frame = toolBarFrame;
    };
    [self registerKeyboardNotification];
    _toolBarHoldView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    _toolBarHoldView.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.3];
    
    [_toolBarHoldView addSubview:_commentBar];
    [self.view addSubview:_toolBarHoldView];
    _toolBarHoldView.hidden = YES;
}


- (void)chatSendButtonAction:(UIButton *)button
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
    if (!(self.commentTextView.text == nil || [self.commentTextView.text isEqualToString:@""])) {
        [self addJstyleArticleCommentDataSource];
    }
    [_commentTextView resignFirstResponder];
    _toolBarHoldView.hidden = YES;
}

- (void)addWkWebView
{
    //wkWebView:文章网页
    WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc]init];
    configuration.selectionGranularity = WKSelectionGranularityCharacter;
    //注册js方法
    [configuration.userContentController addScriptMessageHandler:self name:@"展开更多"];
    
    _webViewHeight = kScreenHeight;
    _webView = [[WKWebView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) configuration:configuration];
    _webView.scrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    _webView.scrollView.showsVerticalScrollIndicator = NO;
    _webView.scrollView.scrollEnabled = NO;
    _webView.backgroundColor = [UIColor whiteColor];
    _webView.UIDelegate = self;
    _webView.navigationDelegate = self;
    //    self.webView.scrollView.contentInset = UIEdgeInsetsMake(200, 0, 0, 0);
    [_webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:NULL];
    [_webView.scrollView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    _progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, 3)];
    _progressView.tintColor = [UIColor clearColor];
    _progressView.trackTintColor = [UIColor clearColor];
    self.urlStr = [JSTYLE_PARTY_DESC_URL stringByAppendingString:[NSString stringWithFormat:@"?id=%@&uid=%@",self.partyId,[[JstyleToolManager sharedManager] getUserId]]];
    
    NSURL *url = [NSURL URLWithString:_urlStr];
    NSURLRequest *request = [NSURLRequest requestWithURL:url.absoluteURL];
    [_webView loadRequest:request];
    
    ///添加自定义长按功能菜单
    [self setupMenuController];
}

#pragma mark - MenuController
- (BOOL)canBecomeFirstResponder {
    return YES;
}

- (void)setupMenuController {
    
    UIMenuController *menu = [UIMenuController sharedMenuController];
    
    [menu setMenuVisible:YES animated:YES];
    [menu setTargetRect:self.webView.bounds inView:self.webView];
    
    UIMenuItem *item1 = [[UIMenuItem alloc] initWithTitle:@"百度一下" action:@selector(searchItemClick)];
    UIMenuItem *item2 = [[UIMenuItem alloc] initWithTitle:@"分享" action:@selector(shareItemClick)];
    
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"9.0")) {
        menu.menuItems = @[item1,item2];
    }
    
    [menu update];
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    if (action == @selector(copy:) || action == @selector(searchItemClick) || action == @selector(shareItemClick)){
        return YES;
    }
    return NO;
}

- (void)searchItemClick {
    
    [self.webView evaluateJavaScript:@"window.getSelection().toString()" completionHandler:^(NSString * _Nullable str, NSError * _Nullable error) {
        
        NSString *url = [NSString stringWithFormat:@"https://www.baidu.com/s?wd=%@",str];
        
        NSString *encodedString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,(CFStringRef)url,(CFStringRef)@"!$&'()*+,-./:;=?@_~%#[]",NULL,kCFStringEncodingUTF8));
        
        SFSafariViewController *safariVC = [[SFSafariViewController alloc] initWithURL:[NSURL URLWithString:encodedString]];
        
        safariVC.modalPresentationStyle = UIModalPresentationFormSheet;
        [self presentViewController:safariVC animated:YES completion:nil];
    }];
}

- (void)shareItemClick {
    [self firstBarButtonAction];
}

- (void)copy:(id)sender {
    
    [self.webView evaluateJavaScript:@"window.getSelection().toString()" completionHandler:^(NSString * _Nullable str, NSError * _Nullable error) {
        
        UIPasteboard *board = [UIPasteboard generalPasteboard];
        board.string = str;
    }];
}

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message{
    //接受传过来的消息从而决定app调用的方法
    NSDictionary *dict = message.body;
    NSString *method = [dict objectForKey:@"method"];
    NSLog(@"%@",method);
}

// 加载footView
- (void)addCollectionView
{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    flowLayout.minimumInteritemSpacing = 15;
    flowLayout.minimumLineSpacing = 0;
    _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) collectionViewLayout:flowLayout];
    _collectionView.showsVerticalScrollIndicator = NO;
    //    _collectionView.scrollEnabled = NO;
    _collectionView.backgroundColor = [UIColor clearColor];
    //    _collectionView.contentInset = UIEdgeInsetsMake(64 + _topContentInset, 0, 0, 0);
    //    _collectionView.scrollIndicatorInsets = UIEdgeInsetsMake(64 + _topContentInset, 0, 0, 0);
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.decelerationRate = 0.5;
    [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
    [_collectionView registerNib:[UINib nibWithNibName:@"JMArticleTuiJianViewCell" bundle:nil] forCellWithReuseIdentifier:@"JMArticleTuiJianViewCell"];
    [_collectionView registerNib:[UINib nibWithNibName:@"JstyleArticleCommentCollectionCell" bundle:nil] forCellWithReuseIdentifier:@"JstyleArticleCommentCollectionCell"];
    [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"imageViewHeaderID"];
    [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"collectionCellID"];
    
    [self.view addSubview:self.collectionView];
    //    [self.webView.scrollView addSubview:_collectionView];
}

/**
 * 添加刷新操作
 */
- (void)addReshAction
{
    self.collectionView.mj_header = [JstyleRefreshGiftHeader headerWithRefreshingBlock:^{
        page = 1;
        [self getJstylePartyCommentDataSource];
    }];
    
    JstyleRefreshAutoNormalFooter *footer = [JstyleRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        page ++;
        [self getJstylePartyCommentDataSource];
    }];
    self.collectionView.mj_footer = footer;
}

- (void)addObserverForWebViewContentSize{
    [self.webView.scrollView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
}
- (void)removeObserverForWebViewContentSize{
    [self.webView.scrollView removeObserver:self forKeyPath:@"contentSize"];
}

/**
 * 网页缓存写入文件
 */
- (void)writeToCache
{
    NSString * htmlResponseStr = [NSString stringWithContentsOfURL:[NSURL URLWithString:_urlStr] encoding:NSUTF8StringEncoding error:Nil];
    //创建文件管理器
    NSFileManager *fileManager = [[NSFileManager alloc]init];
    //获取document路径,括号中属性为当前应用程序独享
    NSString *cachesPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory,      NSUserDomainMask, YES) objectAtIndex:0];
    [fileManager createDirectoryAtPath:[cachesPath stringByAppendingString:@"/Caches"] withIntermediateDirectories:YES attributes:nil error:nil];
    //定义记录文件全名以及路径的字符串filePath
    NSString * path = [cachesPath stringByAppendingString:[NSString stringWithFormat:@"/Caches/%lu.html",(unsigned long)[_urlStr hash]]];
    
    [htmlResponseStr writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:nil];
}

/**观察者监听webView进度条进度和计算webView的高度*/
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"estimatedProgress"]) {
        if (object == _webView) {
            [self.progressView setAlpha:1.0f];
            [self.progressView setProgress:self.webView.estimatedProgress animated:YES];
            
            if(_webView.estimatedProgress >= 1.0f) {
                [UIView animateWithDuration:0.3 delay:0.3 options:UIViewAnimationOptionCurveEaseOut animations:^{
                    [self.progressView setAlpha:0.0f];
                } completion:^(BOOL finished) {
                    [self.progressView setProgress:0.0f animated:NO];
                }];
            }
        }else{
            [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        }
    }
    
    if ([keyPath isEqualToString:@"contentSize"]) {
        //取消监听，因为这里会调整contentSize，避免无限递归
//        [self removeObserverForWebViewContentSize];
        _webViewHeight = self.webView.scrollView.contentSize.height;
        _webView.frame = CGRectMake(0, 0, kScreenWidth, _webViewHeight);
        //        CGSize contentSize = self.webView.scrollView.contentSize;
        //        _collectionView.frame = CGRectMake(0, contentSize.height, kScreenWidth, _collectionView.contentSize.height);
        //        self.webView.scrollView.contentInset = UIEdgeInsetsMake(200, 0, _collectionView.height, 0);
        //        if (!_isAddHeaderImageView) {
        //            _isAddHeaderImageView = YES;
        //            [self.webView.scrollView addSubview:self.headerImageView];
        //        }
        [self.collectionView reloadData];
//        if (_webMarkHeight != _webViewHeight) {
//            //重新监听
//            [self addObserverForWebViewContentSize];
//        }
    }
}

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation
{
    [self.view addSubview:self.progressView];
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{
    [_webView evaluateJavaScript:@"document.documentElement.scrollHeight" completionHandler:^(id _Nullable result, NSError * _Nullable error) {
        _webMarkHeight = [result doubleValue];
        //        self.webView.frame = CGRectMake(0, 0, kScreenWidth, _webViewHeight);
        //        [self.collectionView reloadData];
    }];
}

/*
-(WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures
{
    if (!navigationAction.targetFrame.isMainFrame) {
        NSString *urlStr = navigationAction.request.URL.absoluteString;
        if ([urlStr containsString:@"Goods"] ||[urlStr containsString:@"goods"] ) {
            JstyleGoodsDetailsViewController *jmTuiJianGoodsVc = [JstyleGoodsDetailsViewController new];
            NSString *allurl = urlStr;
            NSArray *allUrlArr = [allurl componentsSeparatedByString:@"&"];
            NSString *gidUrlString = allUrlArr[1];
            
            NSString *gidString = [gidUrlString substringFromIndex:4];
            NSString *goodsUrl = [NSString stringWithFormat:@"%@&isapp=1", allurl];
            jmTuiJianGoodsVc.urlStr = goodsUrl;
            jmTuiJianGoodsVc.gid = gidString;
            [self.navigationController pushViewController:jmTuiJianGoodsVc animated:YES];
            
        }else if ([urlStr containsString:@"index/articledesc"])
        {
            JstyleNewsArticleDetailViewController *jmArticleDetailVC = [JstyleNewsArticleDetailViewController new];
            NSString *urlString = urlStr;
            NSArray *urlStringary = [urlString componentsSeparatedByString:@"?"];
            NSString *url = urlStringary[1];
            NSString *str = [url substringFromIndex:4];
            jmArticleDetailVC.rid = str;
            [MobClick event:@"ArticleDetail"];
            [self.navigationController pushViewController:jmArticleDetailVC animated:YES];
        }else if ([urlStr containsString:@"index/videodec"] && [urlStr containsString:@"liveroomid"])
        {
            PlayerViewController *jmLiveDetailVC = [PlayerViewController new];
            _jmLiveDetailVC = jmLiveDetailVC;
            NSArray *urlStringary = [urlStr componentsSeparatedByString:@"&"];
            NSString *vidStr = urlStringary[0];
            NSArray *vidAry = [vidStr componentsSeparatedByString:@"?"];
            NSString *vidString = [vidAry[1] substringFromIndex:4];
            jmLiveDetailVC.vid = vidString;
            _vidString = vidString;
            NSString *nameAryStr = urlStringary[1];
            NSString *nameStr = [nameAryStr substringFromIndex:6];
            NSString *nameString = [self URLDecodedString:nameStr];
            jmLiveDetailVC.titleStr = nameString;
            
            NSString *vUrlAryStr = urlStringary[2];
            NSString *vUrlStr = [vUrlAryStr substringFromIndex:5];
            jmLiveDetailVC.urlStr = vUrlStr;
            
            NSString *roomIdAryStr = urlStringary[3];
            NSString *roomIdStr = [roomIdAryStr substringFromIndex:7];
            jmLiveDetailVC.roomId = roomIdStr;
            
            NSString *liveRoomIdAryStr = urlStringary[4];
            NSString *liveRoomIdStr = [liveRoomIdAryStr substringFromIndex:11];
            jmLiveDetailVC.liveRoomId = liveRoomIdStr;
            [self getVideoData];
            
        }else if ([urlStr containsString:@"smallcate/articlelist"]) {
            JstyleArticleCategoryViewController *articleCategoryVC = [JstyleArticleCategoryViewController new];
            
            NSString *allurl = urlStr;
            NSArray *allUrlArr = [allurl componentsSeparatedByString:@"?"];
            NSString *gidUrlString = allUrlArr[1];
            
            NSArray *cidCateNameArr = [gidUrlString componentsSeparatedByString:@"&"];
            NSString *cidString = cidCateNameArr[0];
            NSString *cidId = [cidString substringFromIndex:4];
            articleCategoryVC.cid = cidId;
            
            NSString *cateNameString = cidCateNameArr[1];
            NSString *cateName = [cateNameString substringFromIndex:9];
            NSString *nameString = [self URLDecodedString:cateName];
            articleCategoryVC.categoryTitle = nameString;
            [self.navigationController pushViewController:articleCategoryVC animated:YES];
        }else if ([urlStr containsString:@"live"] && ![urlStr containsString:@"videodec"]) {
            JstyleVideoPlayerViewController *videoPlayVC = [JstyleVideoPlayerViewController new];
            NSArray *urlStringary = [urlStr componentsSeparatedByString:@"&"];
            NSString *vidStr = urlStringary[0];
            NSArray *vidAry = [vidStr componentsSeparatedByString:@"?"];
            NSString *vidString = [vidAry[1] substringFromIndex:4];
            videoPlayVC.liveID = vidString;
            
            NSString *nameAryStr = urlStringary[1];
            NSString *nameStr = [nameAryStr substringFromIndex:6];
            videoPlayVC.liveName = nameStr;
            
            //            NSString *vUrlAryStr = urlStringary[2];
            //            NSString *vUrlStr = [vUrlAryStr substringFromIndex:5];
            //            videoPlayVC.liveUrlStr = vUrlStr;
            NSRange range = [urlStr rangeOfString:@"vurl="];//匹配得到的下标
            NSString *vUrlStr = [urlStr substringFromIndex:range.location + 5];//截取范围类的字符串
            videoPlayVC.liveUrlStr = vUrlStr;
            
            [self.navigationController pushViewController:videoPlayVC animated:YES];
        }else if ([urlStr containsString:@"brand"]) {
            JMChoseOneViewController *choseOneVC = [JMChoseOneViewController new];
            NSArray *urlStringary = [urlStr componentsSeparatedByString:@"&"];
            NSString *vidStr = urlStringary[0];
            NSArray *vidAry = [vidStr componentsSeparatedByString:@"?"];
            NSString *vidString = [vidAry[1] substringFromIndex:10];
            choseOneVC.key = vidString;
            choseOneVC.keyName = @"brandname";
            choseOneVC.titleString = vidString;
            [self.navigationController pushViewController:choseOneVC animated:YES];
        }else if ([urlStr containsString:@"special"]) {
            JstyleSpecialSubjectViewController *specialSubjectVC = [JstyleSpecialSubjectViewController new];
            NSArray *urlStringary = [urlStr componentsSeparatedByString:@"&"];
            NSString *vidStr = urlStringary[0];
            NSArray *vidAry = [vidStr componentsSeparatedByString:@"?"];
            NSString *vidString = [vidAry[1] substringFromIndex:3];
            specialSubjectVC.ID = vidString;
            
            NSString *nameAryStr = urlStringary[1];
            NSString *nameStr = [nameAryStr substringFromIndex:5];
            specialSubjectVC.specialTitle = nameStr;
            [self.navigationController pushViewController:specialSubjectVC animated:NO];
        }
        else
        {
            JMHomeBannerViewController *jmHomeBannerWVC = [JMHomeBannerViewController new];
            jmHomeBannerWVC.urlStr = urlStr;
            [MobClick event:@"HomeBannerOne"];
            [self.navigationController pushViewController:jmHomeBannerWVC animated:YES];
        }
        
    }
    return nil;
}
 */

- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error
{
    //ZTShowAlertMessage(@"数据加载失败");
}

#pragma mark -- collectionView的代理方法
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (section == 1) {
        
        return self.commentArray.count;
    }
    return 1;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        if (kind == UICollectionElementKindSectionHeader){
            UICollectionReusableView *reusableView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header" forIndexPath:indexPath];
            for (UIView *view in reusableView.subviews) {
                [view removeFromSuperview];
            }
            [reusableView addSubview:[self addHeaderViewWithName:@"评论区"]];
            return reusableView;
        }
    }
    return nil;
}

- (UIView *)addHeaderViewWithName:(NSString *)name{
    
    UIView *singleLine1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 0.5)];
    singleLine1.backgroundColor = kSingleLineColor;
    
    UIView *singleLine2 = [[UIView alloc]initWithFrame:CGRectMake(0, 43.5, kScreenWidth, 0.5)];
    singleLine2.backgroundColor = kSingleLineColor;
    
    UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 150, 24)];
    nameLabel.text = name;
    nameLabel.textAlignment = NSTextAlignmentLeft;
    nameLabel.font = [UIFont systemFontOfSize:16];
    nameLabel.textColor = kDarkOneColor;
    
    UIButton *pingLunBtn = [[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth - 90, 9.5, 75, 25)];
    pingLunBtn.contentMode = UIViewContentModeScaleAspectFit;
    [pingLunBtn setImage:[UIImage imageNamed:@"发表评论"] forState:UIControlStateNormal];
    [pingLunBtn addTarget:self action:@selector(thirdBarButtonAction) forControlEvents:UIControlEventTouchUpInside];

    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 44)];
    headerView.backgroundColor = [UIColor whiteColor];
    
    [headerView addSubview:singleLine1];
    [headerView addSubview:singleLine2];
    [headerView addSubview:nameLabel];
    [headerView addSubview: pingLunBtn];
    
    return headerView;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    if (section == 1) {
        return CGSizeMake(kScreenWidth, 44);
    }
    return CGSizeMake(0 ,0);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:{
            static NSString *cellID = @"collectionCellID";
            UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
            // [self addWkWebView];
            [cell addSubview:_webView];
            
            return cell;
        }
            break;
        case 1:{
            static NSString *cellID = @"JstyleArticleCommentCollectionCell";
            JstyleArticleCommentCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
            
            cell.model = self.commentArray[indexPath.row];
            return cell;
        }
            break;
        default:
            return nil;
            break;
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
            return CGSizeMake(kScreenWidth, _webViewHeight);
            break;
        case 1:{
            JMCommentModel *model = self.commentArray[indexPath.row];
            CGRect rect = [NSString getStringSizeWithString:model.content andFont:13 andWidth:kScreenWidth - 80];
            return CGSizeMake(kScreenWidth, rect.size.height + 80);
        }
            break;
        default:
            return CGSizeMake(0, 0);
            break;
    }
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}



- (UIColor *)randomColor
{
    CGFloat r = arc4random_uniform(255);
    CGFloat g = arc4random_uniform(255);
    CGFloat b = arc4random_uniform(255);
    
    return [UIColor colorWithRed:(r / 255.0) green:(g / 255.0) blue:(b / 255.0) alpha:1];
}


/**视频类型*/
//-(void)getVideoData
//{
//    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:_vidString,@"vid", nil];
//    // 初始化Manager
//    JstyleNewsNetworkManager *manager = [JstyleNewsNetworkManager shareManager];;
//
//
//    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy defaultPolicy];
//    securityPolicy.allowInvalidCertificates = YES;
//    manager.securityPolicy = securityPolicy;
//    // get请求
//    [manager GET:JSTYLELIVE_VIDEOSTATUS_URL parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
//        if ([dictionary[@"code"] integerValue] == 1) {
//            _jmLiveDetailVC.liveStatus = [NSString stringWithFormat:@"%@",dictionary[@"data"][@"isvideo"]];
//            _jmLiveDetailVC.imageUrl = [NSString stringWithFormat:@"%@", dictionary[@"data"][@"img"]];
//            [self.navigationController pushViewController:_jmLiveDetailVC animated:YES];
//        }else
//        {
//            _jmLiveDetailVC.liveStatus = @"3";
//            [self.navigationController pushViewController:_jmLiveDetailVC animated:YES];
//        }
//
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//
//    }];
//}

/**分享数据*/
-(void)getShareData
{
    NSDictionary *parameters = @{@"uid":[[JstyleToolManager sharedManager] getUserId],
                                 @"uuid":[[JstyleToolManager sharedManager] getUDID],
                                 @"id":self.partyId,
                                 @"type":@"9"};
    // 初始化Manager
    JstyleNewsNetworkManager *manager = [JstyleNewsNetworkManager shareManager];;
    
    [manager GETURL:COMMON_SHARE_URL parameters:parameters success:^(id responseObject) {
        if ([responseObject[@"code"] integerValue] == 1) {
            self.ashareurl = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"ashareurl"]];
            self.titleName = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"title"]];
            self.shareImageurl = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"poster"]];
            self.describes = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"describes"]];
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

#pragma mark - 获取评论的数据
- (void)getJstylePartyCommentDataSource
{
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:self.partyId,@"id",[NSString stringWithFormat:@"%ld",(long)page],@"page", nil];
    // 初始化Manager
    JstyleNewsNetworkManager *manager = [JstyleNewsNetworkManager shareManager];;
    
    [manager GETURL:JSTYLE_PARTY_COMMENT_URL parameters:parameters success:^(id responseObject) {
        if ([responseObject[@"code"] integerValue] != 1) {
            
            if (page != 1) {
                [self.collectionView.mj_header endRefreshing];
                [self.collectionView.mj_footer endRefreshingWithNoMoreData];
            }else{
                [self.collectionView.mj_header endRefreshing];
                [self.collectionView.mj_footer endRefreshing];
            }
            return ;
        }
        
        if (page == 1) {
            [self.commentArray removeAllObjects];
        }
        
        for (NSDictionary *dict in responseObject[@"data"]) {
            JMCommentModel *model = [JMCommentModel new];
            [model setValuesForKeysWithDictionary:dict];
            [self.commentArray addObject:model];
        }
        
        [self.collectionView reloadData];
        [self.collectionView.mj_header endRefreshing];
        [self.collectionView.mj_footer endRefreshing];
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
        [self.collectionView.mj_header endRefreshing];
        [self.collectionView.mj_footer endRefreshing];
    }];
}

#pragma mark - 添加评论的数据
- (void)addJstyleArticleCommentDataSource
{
   
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:[[JstyleToolManager sharedManager] getUserId],@"uid",self.partyId,@"id",self.commentTextView.text,@"comment", nil];
    // 初始化Manager
    JstyleNewsNetworkManager *manager = [JstyleNewsNetworkManager shareManager];;
    
    
    [manager POSTURL:JSTYLE_PARTY_ADDCOMMENT_URL parameters:parameters success:^(id responseObject) {
        if ([responseObject[@"code"] integerValue] == 1) {
            page = 1;
            [self getJstylePartyCommentDataSource];
            ZTShowAlertMessage(responseObject[@"data"]);
            self.commentTextView.text = nil;
        
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
    
}

/**获取当前活动状态数据*/
- (void)addJstylePartyCollectionDataSource
{
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:[[JstyleToolManager sharedManager] getUserId],@"uid",[[JstyleToolManager sharedManager] getUDID],@"uuid", self.partyId,@"rid",[NSString stringWithFormat:@"%ld",(long)typeInt], @"type", self.orderId, @"orderid", nil];
    
    JstyleNewsNetworkManager *manager = [JstyleNewsNetworkManager shareManager];;
    
    [manager GETURL:JM_COLLECTION_PRAISE_URL parameters:parameters success:^(id responseObject) {
        if ([responseObject[@"code"] isEqualToString:@"1"]) {
            
            if (typeInt == 3) {
                switch ([responseObject[@"data"][@"praise_num"] integerValue]) {
                    case 0:
                        self.baoMingBtn.userInteractionEnabled = YES;
                        self.baoMingBtn.backgroundColor = kLightRedColor;
                        [self.baoMingBtn setTitle:@"立即报名" forState:UIControlStateNormal];
                        break;
                    case 1:
                        self.baoMingBtn.userInteractionEnabled = NO;
                        self.baoMingBtn.backgroundColor = kDarkNineColor;
                        [self.baoMingBtn setTitle:@"报名成功" forState:UIControlStateNormal];
                        break;
                    case 2:
                        self.baoMingBtn.userInteractionEnabled = NO;
                        self.baoMingBtn.backgroundColor = kDarkNineColor;
                        [self.baoMingBtn setTitle:@"活动取消" forState:UIControlStateNormal];
                        break;
                    case 3:
                        self.baoMingBtn.userInteractionEnabled = NO;
                        self.baoMingBtn.backgroundColor = kDarkNineColor;
                        [self.baoMingBtn setTitle:@"活动结束" forState:UIControlStateNormal];
                        break;
                    case 4:
                        self.baoMingBtn.userInteractionEnabled = NO;
                        self.baoMingBtn.backgroundColor = kDarkNineColor;
                        [self.baoMingBtn setTitle:@"进行中" forState:UIControlStateNormal];
                        break;
                    case 5:
                        self.baoMingBtn.userInteractionEnabled = NO;
                        self.baoMingBtn.backgroundColor = kDarkNineColor;
                        [self.baoMingBtn setTitle:@"报名取消" forState:UIControlStateNormal];
                        break;
                    case 6:
                        self.baoMingBtn.userInteractionEnabled = NO;
                        self.baoMingBtn.backgroundColor = kDarkNineColor;
                        [self.baoMingBtn setTitle:@"名额已满" forState:UIControlStateNormal];
                        break;
                    default:
                        self.baoMingBtn.userInteractionEnabled = YES;
                        self.baoMingBtn.backgroundColor = kLightRedColor;
                        [self.baoMingBtn setTitle:@"立即报名" forState:UIControlStateNormal];
                        break;
                }
                
                if ([responseObject[@"data"][@"praise_type"]integerValue] == 1) {
                    [self addRightTwoBarButtonsWithFirstImage:[UIImage imageNamed:@"聚会分享"] firstAction:@selector(firstBarButtonAction) secondImage:[UIImage imageNamed:@"聚会点赞红色"] secondAction:@selector(secondBarButtonAction)];
//                    [self addRightBarButtonWithFirstImage:[UIImage imageNamed:@"聚会点赞红色"] action:@selector(secondBarButtonAction)];
                    
                }else{
                    [self addRightTwoBarButtonsWithFirstImage:[UIImage imageNamed:@"聚会分享"] firstAction:@selector(firstBarButtonAction) secondImage:[UIImage imageNamed:@"聚会点赞"] secondAction:@selector(secondBarButtonAction)];
//                    [self addRightBarButtonWithFirstImage:[UIImage imageNamed:@"聚会点赞"] action:@selector(secondBarButtonAction)];
                }
            }
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
        
    }];
}


- (void)collectionNavigationBtnClick {
    JstyleNewsNetworkManager *manager = [JstyleNewsNetworkManager shareManager];
    NSDictionary *paramaters = @{
                                 @"type":@"4",
                                 @"rid":self.partyId,
                                 @"uid":[[JstyleToolManager sharedManager] getUserId],
                                 @"uuid":[[JstyleToolManager sharedManager] getUDID]
                                 };
    [manager GETURL:ADD_COLLECTION_URL parameters:paramaters success:^(id responseObject) {
        
            if ([responseObject[@"code"]integerValue] == 1) {
                [self addRightTwoBarButtonsWithFirstImage:[UIImage imageNamed:@"聚会分享"] firstAction:@selector(firstBarButtonAction) secondImage:[UIImage imageNamed:@"聚会点赞红色"] secondAction:@selector(secondBarButtonAction)];
            }else{
                [self addRightTwoBarButtonsWithFirstImage:[UIImage imageNamed:@"聚会分享"] firstAction:@selector(firstBarButtonAction) secondImage:[UIImage imageNamed:@"聚会点赞"] secondAction:@selector(secondBarButtonAction)];
            }
        
    } failure:^(NSError *error) {
        
    }];
    
}

/**友盟分享*/
- (void)firstBarButtonAction
{
    [[JstyleToolManager sharedManager] shareActionWithShareTitle:self.titleName shareDesc:self.describes shareImgUrl:self.shareImageurl shareLinkUrl:self.ashareurl viewController:self];
}

- (void)secondBarButtonAction
{
    [self collectionNavigationBtnClick];
}

/**
 * 评论事件
 */
- (void)thirdBarButtonAction
{
    _toolBarHoldView.hidden = NO;
    [self.commentTextView becomeFirstResponder];
}

- (NSString *)URLDecodedString:(NSString *)str
{
    NSString *decodedString=(__bridge_transfer NSString *)CFURLCreateStringByReplacingPercentEscapesUsingEncoding(NULL, (__bridge CFStringRef)str, CFSTR(""), CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding));
    
    return decodedString;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    [[SDImageCache sharedImageCache] clearMemory];
    [[YYWebImageManager sharedManager].cache.memoryCache removeAllObjects];
    // Dispose of any resources that can be recreated.
}

#pragma mark --UIKeyboard event listening(键盘事件的监听)
-(void)registerKeyboardNotification{
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(inputKeyboardWillChangeFrame:)
                                                 name:UIKeyboardWillChangeFrameNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(inputKeyboardDidChangeFrame:)
                                                 name:UIKeyboardDidChangeFrameNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(inputKeyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

#pragma mark -- Keyboard Notifications通知
- (void)inputKeyboardWillChangeFrame:(NSNotification *)notification
{
    CGRect keyboardEndFrameWindow;
    [[notification.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue: &keyboardEndFrameWindow];
    
    double keyboardTransitionDuration;
    [[notification.userInfo valueForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&keyboardTransitionDuration];
    
    UIViewAnimationCurve keyboardTransitionAnimationCurve;
    [[notification.userInfo valueForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&keyboardTransitionAnimationCurve];
    
    CGRect keyboardEndFrameView = [self.view convertRect:keyboardEndFrameWindow fromView:nil];
    
    self.keyboardDidMoveBlock(keyboardEndFrameView,NO,NO);
}

- (void)inputKeyboardDidChangeFrame:(NSNotification *)notification
{
    CGRect keyboardEndFrameWindow;
    [[notification.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue: &keyboardEndFrameWindow];
    
    double keyboardTransitionDuration;
    [[notification.userInfo valueForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&keyboardTransitionDuration];
    
    UIViewAnimationCurve keyboardTransitionAnimationCurve;
    [[notification.userInfo valueForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&keyboardTransitionAnimationCurve];
    
    CGRect keyboardEndFrameView = [self.view convertRect:keyboardEndFrameWindow fromView:nil];
    
    self.keyboardDidMoveBlock(keyboardEndFrameView,NO,NO);
}

- (void)inputKeyboardWillHide:(NSNotification *)notification
{
    CGRect keyboardEndFrameWindow;
    [[notification.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue: &keyboardEndFrameWindow];
    
    double keyboardTransitionDuration;
    [[notification.userInfo valueForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&keyboardTransitionDuration];
    
    UIViewAnimationCurve keyboardTransitionAnimationCurve;
    [[notification.userInfo valueForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&keyboardTransitionAnimationCurve];
    
    CGRect keyboardEndFrameView = [self.view convertRect:keyboardEndFrameWindow fromView:nil];
    self.keyboardDidMoveBlock(keyboardEndFrameView,NO,NO);
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [_commentTextView resignFirstResponder];
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


-(void)popBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSMutableArray *)commentArray
{
    if (!_commentArray) {
        _commentArray = [NSMutableArray array];
    }
    return _commentArray;
}

-(UIStatusBarStyle)preferredStatusBarStyle {
    
    return ISNightMode?UIStatusBarStyleLightContent:UIStatusBarStyleDefault;
}

@end
