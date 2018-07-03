//
//  JstyleManagementSystemNoticeDetailViewController.m
//  Exquisite
//
//  Created by 数字跃动 on 2017/10/23.
//  Copyright © 2017年 Jstyle. All rights reserved.
//

#import "JstyleManagementSystemNoticeDetailViewController.h"

@interface JstyleManagementSystemNoticeDetailViewController ()

@property (nonatomic, strong) UIWebView *webView;

@end

@implementation JstyleManagementSystemNoticeDetailViewController

- (UIWebView *)webView {
    if (_webView == nil) {
        _webView = [[UIWebView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        [_webView scalesPageToFit];
    }
    return _webView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"系统消息";
    self.view.backgroundColor = kWhiteColor;
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    
    [self setupWebView];
}

- (void)setupWebView {
    
    [self.view addSubview:self.webView];
    NSString *urlStr = [NSString stringWithFormat:@"%@?id=%@",MANAGER_NOTICEDERAIL_URL,self.URLString];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]];
    [self.webView loadRequest:request];
    NSLog(@"加载H5详情");
}

@end
