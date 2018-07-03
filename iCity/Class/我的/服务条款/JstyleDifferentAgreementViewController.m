//
//  JstyleDifferentAgreementViewController.m
//  Exquisite
//
//  Created by JingHongMuYun on 2018/3/9.
//  Copyright © 2018年 JstyleStar. All rights reserved.
//

#import <WebKit/WebKit.h>
#import "JstyleDifferentAgreementViewController.h"

@interface JstyleDifferentAgreementViewController ()<WKNavigationDelegate, WKUIDelegate>

@property (nonatomic, strong) WKWebView *webView;

@end

@implementation JstyleDifferentAgreementViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kWhiteColor;
    [self addWebView];
}

- (void)addWebView{
    WKWebViewConfiguration *wkWebConfig = [[WKWebViewConfiguration alloc] init];
    _webView = [[WKWebView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) configuration:wkWebConfig];
    _webView.backgroundColor = kWhiteColor;
    _webView.navigationDelegate = self;
    _webView.UIDelegate = self;
    NSURL *url = [NSURL URLWithString:_urlStr];
    NSURLRequest *request = [NSURLRequest requestWithURL:url.absoluteURL];
    [_webView loadRequest:request];
    [self.view addSubview:_webView];
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{
    self.title = webView.title;
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
