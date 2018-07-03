//
//  JstyleNewsProtocalViewController.m
//  JstyleNews
//
//  Created by 王磊 on 2018/3/29.
//  Copyright © 2018年 JstyleNews. All rights reserved.
//

#import "JstyleNewsProtocalViewController.h"
#import <WebKit/WebKit.h>

@interface JstyleNewsProtocalViewController ()

@property (nonatomic, strong) WKWebView *webView;

@end

@implementation JstyleNewsProtocalViewController

- (WKWebView *)webView {
    if (_webView == nil) {
        _webView = [[WKWebView alloc] initWithFrame:self.view.bounds configuration:[WKWebViewConfiguration new]];
    }
    return _webView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.webView];
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.url]]];
    
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [closeBtn setTitle:@"关闭" forState:UIControlStateNormal];
    [closeBtn sizeToFit];
    closeBtn.frame = CGRectMake(15, 25, closeBtn.width, closeBtn.height);
    [closeBtn addTarget:self action:@selector(closeBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:closeBtn];
    
}

- (void)closeBtnClick {
    if (self.isModal) {
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

@end
