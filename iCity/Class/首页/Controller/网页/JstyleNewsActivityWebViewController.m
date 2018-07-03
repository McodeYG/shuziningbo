//
//  JstyleNewsActivityWebViewController.m
//  JstyleNews
//
//  Created by JingHongMuYun on 2017/12/26.
//  Copyright © 2017年 JstyleNews. All rights reserved.
//

// 广告活动
#import "JstyleNewsActivityWebViewController.h"
#import <WebKit/WebKit.h>
#import "SDPhotoBrowser.h"
#import "JstyleNewsPhotographyContestViewController.h"

#define PhotographyShareURL ICity_BASE @"home/homepage/shareshoot.htm"

@interface JstyleNewsActivityWebViewController ()<WKNavigationDelegate, WKUIDelegate, SDPhotoBrowserDelegate>

@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, strong) WKUserScript *userScript;
@property (nonatomic, strong) NSMutableArray *imageArray;
@property (nonatomic, strong) NSMutableArray *imageUrlArray;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, strong) UIView *contenterView;
@property (nonatomic, strong) UIProgressView *progressView;

@property (nonatomic, copy) NSString *shareImgUrl;
@property (nonatomic, copy) NSString *shareUrl;
@property (nonatomic, copy) NSString *shareTitle;
@property (nonatomic, copy) NSString *shareDesc;

@end

@implementation JstyleNewsActivityWebViewController

- (void)dealloc
{
    [_webView removeObserver:self forKeyPath:@"estimatedProgress"];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    UIColor * color = (ISNightMode)?[UIColor colorFromHexString:@"#252525"]:kWhiteColor;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:color] forBarMetrics:UIBarMetricsDefault];

    NSDictionary *navbarTitleTextAttributes = @{
                                                NSForegroundColorAttributeName:kNightModeTitleColor,
                                                NSFontAttributeName:[UIFont systemFontOfSize:18]
                                                };
    [self.navigationController.navigationBar setTitleTextAttributes:navbarTitleTextAttributes];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.navigationItem.title = (self.navigationTitle == nil ? @"" : self.navigationTitle);

    //监听登录成功,刷新界面
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginInSuccessNotification) name:@"JSTYLENEWSGETUSERINFONOTIFICATION" object:nil];
    
    [self getShareData];
    
    UIImage * img = ISNightMode?JSImage(@"文章返回白"):JSImage(@"文章返回黑");
    [self addLeftBarButtonWithImage:img action:@selector(leftBarButtonAction)];
    
    if (self.isShare == 1) {
        [self addRightBarButtonWithFirstImage:ISNightMode?JSImage(@"图集分享白"):JSImage(@"图集分享黑") action:@selector(rightBarButtonAction)];
    }
    
    [self addWkWebView];
}

- (void)loginInSuccessNotification {
    
    //拼接UID
    if ([self.urlString containsString:@"?uid="]) {
        self.urlString = [self.urlString stringByAppendingString:[NSString stringWithFormat:@"%@",[[JstyleToolManager sharedManager] getUserId]]];
    } else if ([self.urlString containsString:@"&uid="]) {
        self.urlString = [self.urlString stringByAppendingString:[NSString stringWithFormat:@"%@",[[JstyleToolManager sharedManager] getUserId]]];
    }
    NSURL *url = [NSURL URLWithString:self.urlString];
    [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
}

- (void)addWkWebView
{
    WKUserContentController *wkUController = [[WKUserContentController alloc] init];
    if (!self.isNeedShareImage) {
        [wkUController addUserScript:self.userScript];
    }
    
    WKWebViewConfiguration *wkWebConfig = [[WKWebViewConfiguration alloc] init];
    wkWebConfig.userContentController = wkUController;
    
    _webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, SCREEN_H-YG_SafeBottom_H-YG_StatusAndNavightion_H) configuration:wkWebConfig];
    [_webView sizeToFit];
    _webView.backgroundColor = kNightModeBackColor;
    [_webView setOpaque:NO];
    _webView.navigationDelegate = self;
    _webView.UIDelegate = self;
    [_webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:NULL];
    _progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 2)];
    _progressView.tintColor = kGlobalGoldColor;
    _progressView.trackTintColor = kWhiteColor;
    [self.view addSubview:_webView];
    
    //拼接UID
    if ([self.urlString containsString:@"?"] && ![self.urlString containsString:@"uid="]) {
        self.urlString = [self.urlString stringByAppendingString:[NSString stringWithFormat:@"&uid=%@",[[JstyleToolManager sharedManager] getUserId]]];
    } else if ([self.urlString containsString:@"&"] && ![self.urlString containsString:@"uid="]) {
        self.urlString = [self.urlString stringByAppendingString:[NSString stringWithFormat:@"?uid=%@",[[JstyleToolManager sharedManager] getUserId]]];
    }
    NSURL *url = [NSURL URLWithString:self.urlString];
    [_webView loadRequest:[NSURLRequest requestWithURL:url]];
    
    _contenterView = [[UIView alloc] init];
    _contenterView.center = self.view.center;
    [self.view addSubview:_contenterView];
}

- (WKUserScript *)userScript
{
    if (!_userScript) {
        static  NSString * const jsGetImages =
        @"function getImages(){\
        var objs = document.getElementsByTagName(\"img\");\
        var imgScr = '';\
        for(var i=0;i<objs.length;i++){\
        if(objs[i].width > 100){\
        imgScr = imgScr + objs[i].src + '+';\
        }\
        };\
        return imgScr;\
        };function registerImageClickAction(){\
        var imgs=document.getElementsByTagName('img');\
        var length=imgs.length;\
        for(var i=0;i<length;i++){\
        img=imgs[i];\
        img.onclick=function(){\
        window.location.href='image-preview:'+this.src}\
        }\
        }";
        _userScript = [[WKUserScript alloc] initWithSource:jsGetImages injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
    }
    return _userScript;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    
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
}

#pragma mark - 导航每次跳转调用跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    
    NSString *absoluteString = navigationAction.request.URL.absoluteString;
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
        
        decisionHandler(WKNavigationActionPolicyAllow);
        
    } else if ([absoluteString containsString:@"shareinvatepage"]) {
        //吊起分享
        [self rightBarButtonAction];
        
        decisionHandler(WKNavigationActionPolicyAllow);
        
    } else if ([absoluteString containsString:@"photographyContest"]) {
        //进入摄影大赛
        NSArray *paramaterArr = [absoluteString componentsSeparatedByString:@"?"];
        NSString *shootTwoId = [paramaterArr.lastObject componentsSeparatedByString:@"="].lastObject;
        JstyleNewsPhotographyContestViewController *photographyVC = [JstyleNewsPhotographyContestViewController new];
        photographyVC.shootTwoId = shootTwoId;
        [self.navigationController pushViewController:photographyVC animated:YES];
        
        decisionHandler(WKNavigationActionPolicyCancel);
        
    } else if ([absoluteString containsString:@"activitylogin"]) {
        //网页提示登录
        [[JstyleToolManager sharedManager] loginInViewController];
        
        decisionHandler(WKNavigationActionPolicyCancel);
        
    } else if ([absoluteString containsString:@"needToShare"]) {
        //需要友盟分享
        [self needToShareActionWithURLString:absoluteString];
        
        decisionHandler(WKNavigationActionPolicyCancel);
        
    } else {
        decisionHandler(WKNavigationActionPolicyAllow);
    }
}

- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler {
    NSLog(@"捕获Alert");
    completionHandler();
}

- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL))completionHandler {
    NSLog(@"捕获Confirm");
    completionHandler(NO);
}

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation
{
    [self.view addSubview:_progressView];
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{
    
    if ([webView.title isNotBlank]) {
        self.title = webView.title;
    }
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

-(WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures
{
    if (!navigationAction.targetFrame.isMainFrame) {
        //NSString *urlStr = navigationAction.request.URL.absoluteString;
        //ZTShowAlertMessage(urlStr);
    }
    return nil;
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

//分享数据
-(void)getShareData
{
    NSDictionary *parameters = @{@"uid":[[JstyleToolManager sharedManager] getUserId],
                                 @"uuid":[[JstyleToolManager sharedManager] getUDID],
                                 @"id":[NSString stringWithFormat:@"%@",self.urlString],
                                 @"type":self.isNeedShareImage ? @"6" : @"3"
                                 };
    [[JstyleNewsNetworkManager shareManager] POSTURL:COMMON_SHARE_URL parameters:parameters success:^(id responseObject) {
        if ([responseObject[@"code"] integerValue] == 1) {
            self.shareUrl = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"ashareurl"]];
            self.shareTitle = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"title"]];
            self.shareImgUrl = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"poster"]];
            self.shareDesc = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"describes"]];
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

- (void)rightBarButtonAction
{
    if (self.shareUrl == nil || self.shareTitle == nil) {
        [self getShareData];
        return;
    }
    ///是否仅仅需要传图片
    if (self.isNeedShareImage) {
        [[JstyleToolManager sharedManager] sharePictureWithShareTitle:self.shareTitle shareDesc:self.shareDesc shareUrl:self.shareImgUrl shareImgUrl:self.shareImgUrl viewController:self];
    } else {
        [[JstyleToolManager sharedManager] shareActionWithShareTitle:self.shareTitle shareDesc:self.shareDesc shareImgUrl:self.shareImgUrl shareLinkUrl:self.shareUrl viewController:self];
    }
}

- (void)needToShareActionWithURLString:(NSString *)urlString {
    
    NSString *idS = [[urlString componentsSeparatedByString:@"?"].lastObject componentsSeparatedByString:@"="].lastObject;
    
    NSDictionary *parameters = @{@"uid":[[JstyleToolManager sharedManager] getUserId],
                                 @"uuid":[[JstyleToolManager sharedManager] getUDID],
                                 @"url":[NSString stringWithFormat:@"%@",urlString],
                                 @"id":idS
                                 };
    [[JstyleNewsNetworkManager shareManager] POSTURL:PhotographyShareURL parameters:parameters success:^(id responseObject) {
        if ([responseObject[@"code"] integerValue] == 1) {
            self.shareUrl = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"ashareurl"]];
            self.shareTitle = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"title"]];
            self.shareImgUrl = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"poster"]];
            self.shareDesc = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"describes"]];
            [[JstyleToolManager sharedManager] shareActionWithShareTitle:self.shareTitle shareDesc:self.shareDesc shareImgUrl:self.shareImgUrl shareLinkUrl:self.shareUrl viewController:self];
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

- (void)leftBarButtonAction {
    
    if ([self.webView canGoBack]) {
        [self.webView goBack];
    }else {
        if (self.isNeedPopToFirstVC) {
            if (self.navigationController.viewControllers.count > 1) {
                [self.navigationController popToViewController:self.navigationController.viewControllers[1] animated:YES];
            }
        } else {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return ISNightMode?UIStatusBarStyleLightContent:UIStatusBarStyleDefault;
}



@end
