//
//  JStyleDaySignInViewController.m
//  Exquisite
//
//  Created by 数字跃动 on 2017/2/27.
//  Copyright © 2017年 Jstyle. All rights reserved.
//

#import "JStyleDaySignInViewController.h"
#import <WebKit/WebKit.h>
//#import "JStyleDayLuckydrawViewController.h"
#import "JStyleJiFenDetailViewController.h"
#import "ActionSheetView.h"

@interface JStyleDaySignInViewController ()<WKNavigationDelegate,WKUIDelegate>

@property (nonatomic, strong) WKWebView *webView;

@property (nonatomic, strong) UIProgressView *progressView;

@property (nonatomic, copy) NSString *titleName;
@property (nonatomic, copy) NSString *describes;
@property (nonatomic, copy) NSString *shareUrl;
@property (nonatomic, copy) NSString *shareImageUrl;
@property (nonatomic, copy) NSString *pictureUrlString;

@end

@implementation JStyleDaySignInViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"每日签到";
    self.view.backgroundColor = [UIColor whiteColor];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self addRightBarButtonWithFirstImage:[UIImage imageNamed:@"分享黑色"] action:@selector(firstBarButtonAction)];
    
    [self addWkWebView];
    
    [self getShareData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSURL *url = [NSURL URLWithString:[MY_JIFEN_QIANDAO_URL stringByAppendingString:[NSString stringWithFormat:@"?uid=%@",[[JstyleToolManager sharedManager] getUserId]]]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url.absoluteURL];
    [_webView loadRequest:request];
}

- (void)addWkWebView
{
    WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc]init];
    configuration.selectionGranularity = WKSelectionGranularityCharacter;
    _webView = [[WKWebView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64) configuration:configuration];
    _webView.backgroundColor = kWhiteColor;
    _webView.scrollView.showsVerticalScrollIndicator = NO;
    _webView.UIDelegate = self;
    _webView.navigationDelegate = self;
    
    [_webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:NULL];
    
    _progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 3)];
    _progressView.tintColor = kDarkOneColor;
    _progressView.trackTintColor = [UIColor whiteColor];
    
    [self.view addSubview:self.webView];
}

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation
{
    [self.view addSubview:_progressView];
}

-(WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures
{
    if (!navigationAction.targetFrame.isMainFrame) {
        NSString *urlStr = navigationAction.request.URL.absoluteString;
        if ([urlStr containsString:@"integral"]) {
            JStyleJiFenDetailViewController *jstyleJifenVC = [JStyleJiFenDetailViewController new];
            [self.navigationController pushViewController:jstyleJifenVC animated:YES];
        }else if ([urlStr containsString:@"qiandao"]){
                NSString *allurl = urlStr;
                NSArray *allUrlArr = [allurl componentsSeparatedByString:@"imgurl="];
                _pictureUrlString = [[self URLDecodedString:allUrlArr[1]] componentsSeparatedByString:@"&"].firstObject;
                [self sharePicture];
            
        }else if([urlStr containsString:@"lucklydrawpage"]){
//            JStyleDayLuckydrawViewController *dayLuckyDrawVC = [JStyleDayLuckydrawViewController new];
//            [self.navigationController pushViewController:dayLuckyDrawVC animated:YES];
        }else{
//            JStyleJiFenGoodsDetailViewController *jstyleJiFenGoodsVc = [JStyleJiFenGoodsDetailViewController new];
//            NSString *allurl = urlStr;
//            NSArray *allUrlArr = [allurl componentsSeparatedByString:@"&"];
//            NSString *gidUrlString = allUrlArr[1];
//
//            NSString *gidString = [gidUrlString substringFromIndex:4];
//            NSString *goodsUrl = [NSString stringWithFormat:@"%@&isapp=1", allurl];
//            jstyleJiFenGoodsVc.urlStr = goodsUrl;
//            jstyleJiFenGoodsVc.gid = gidString;
//            [self.navigationController pushViewController:jstyleJiFenGoodsVc animated:YES];
        }
    }
    return nil;
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
        }
        else
        {
            [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        }
    }
}


/**友盟分享*/
- (void)firstBarButtonAction
{
    //右上角分享
    
    [[JstyleToolManager sharedManager] sharePictureWithShareTitle:self.titleName shareDesc:self.describes shareUrl:self.shareImageUrl shareImgUrl:self.shareImageUrl viewController:self];
    

}

- (void)sharePicture
{
    //弹窗分享
    if ([[JstyleToolManager sharedManager] isTourist]) {
        [[JstyleToolManager sharedManager] loginInViewController];
        return;
    }
//    [[JstyleToolManager sharedManager] sharePictureWithShareTitle:nil shareDesc:nil shareUrl:self.shareImageUrl shareImg:nil viewController:self];
     [[JstyleToolManager sharedManager] sharePictureWithShareTitle:self.titleName shareDesc:self.describes shareUrl:self.shareImageUrl shareImgUrl:self.shareImageUrl viewController:self];
}
/**分享数据*/
-(void)getShareData {
    
    JstyleNewsNetworkManager *manager = [JstyleNewsNetworkManager shareManager];
    
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:@"1",@"type", nil];
    
    [manager GETURL:QIANDAO_LUCKYDRAW_URL parameters:parameters success:^(id responseObject) {
        if ([responseObject[@"code"] integerValue] == 1) {
//            self.shareUrl = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"url"]];
            self.titleName = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"title"]];
            self.shareImageUrl = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"image"]];
            self.describes = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"describes"]];
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}
- (NSString *)URLDecodedString:(NSString *)str
{
    NSString *decodedString=(__bridge_transfer NSString *)CFURLCreateStringByReplacingPercentEscapesUsingEncoding(NULL, (__bridge CFStringRef)str, CFSTR(""), CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding));
    
    return decodedString;
}
- (void)dealloc
{
    [_webView removeObserver:self forKeyPath:@"estimatedProgress"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    [[SDImageCache sharedImageCache] clearMemory];
    [[YYWebImageManager sharedManager].cache.memoryCache removeAllObjects];
    // Dispose of any resources that can be recreated.
}

@end
