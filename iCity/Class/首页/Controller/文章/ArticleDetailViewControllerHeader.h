//
//  ArticleDetailViewControllerHeader.h
//  iCity
//
//  Created by mayonggang on 2018/6/29.
//  Copyright © 2018年 LongYuan. All rights reserved.
//

#ifndef ArticleDetailViewControllerHeader_h
#define ArticleDetailViewControllerHeader_h

#import "JstyleNewsVideoDetailTuijianTableViewCell.h"
#import "JstyleNewsCommentViewCell.h"
#import "JstyleNewsCommentPlaceHolderCell.h"
#import "JstyleNewsCoverCommentViewController.h"
#import "JstyleNewsCommentViewController.h"
#import "WRNavigationBar.h"
#import <WebKit/WebKit.h>
#import "JstyleNewsArticleDetailTitleContentCell.h"

#import "SDPhotoBrowser.h"
#import "JstyleNewsJMNumDetailsViewController.h"
#import "JstyleNewsMyCollectionArticleTableViewCell.h"

@interface JstyleNewsArticleDetailViewController ()<UITableViewDelegate, UITableViewDataSource, UITextViewDelegate, WKUIDelegate, WKNavigationDelegate, SDPhotoBrowserDelegate>

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
//头视图高度
@property (nonatomic, assign) CGFloat topContentInset;

@property (nonatomic, strong) JstyleNewsBaseBottomView *commentBar;
@property (nonatomic, strong) UITextView *commentTextView;
@property (nonatomic, strong) UILabel *placeHolder;
@property (nonatomic, strong) UIButton *sendButton;
@property (nonatomic, strong) UIView *toolBarHoldView;

/**底部评论点赞view*/
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UILabel *commentLabel;
@property (nonatomic, strong) UIButton *shouCangBtn;
@property (nonatomic, strong) UIButton *dianZanBtn;

@property (nonatomic, copy) NSString *shareImgUrl;
@property (nonatomic, copy) NSString *shareUrl;
@property (nonatomic, copy) NSString *shareTitle;
@property (nonatomic, copy) NSString *shareDesc;

@property (nonatomic, strong) JstyleNewsNoSinglePlaceholderView *noSingleView;

//为防止进入评论详情后返回本页时的导航栏透明
@property (nonatomic, assign) BOOL isPushToCommentVC;

//导航栏
@property (nonatomic, strong) UIView *naviBar;
//导航栏标题
@property (nonatomic, strong) UILabel *titleLab;
//导航栏返回按钮
@property (nonatomic, strong) UIButton *backBtn;
//导航栏分享
@property (nonatomic, strong) UIButton *shareBtn;

@end


#endif /* ArticleDetailViewControllerHeader_h */
