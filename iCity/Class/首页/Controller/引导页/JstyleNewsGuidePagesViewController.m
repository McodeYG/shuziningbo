//
//  JstyleNewsGuidePagesViewController.m
//  JstyleNews
//
//  Created by 数字跃动 on 2018/1/8.
//  Copyright © 2018年 JstyleNews. All rights reserved.
//

#import "JstyleNewsGuidePagesViewController.h"
#import "JstyleNewsTabBarController.h"
#import "JstyleNewFeatureSelectedTagViewController.h"

@interface JstyleNewsGuidePagesViewController ()<UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) NSArray<NSString *> *imagesArray;
@property (nonatomic, strong) UIImageView *pageIndicatorImageView;
@property (nonatomic, strong) UIImageView *pageIndicatorImageView2;
@property (nonatomic, strong) UIImageView *pageIndicatorImageView3;
@property (nonatomic, strong) UIImageView *pageAlreadyImageView;
@property (nonatomic, strong) UIImageView *pageAlreadyImageView2;
@property (nonatomic, strong) UIImageView *pageAlreadyImageView3;
@property (nonatomic, strong) UIButton *beginBtn;

@end

@implementation JstyleNewsGuidePagesViewController

- (NSArray<NSString *> *)imagesArray {
    if (_imagesArray == nil) {
        _imagesArray = IS_iPhoneX ? @[@"引导页1-10",@"引导页2-10",@"引导页3-10"] : @[@"引导页1",@"引导页2",@"引导页3"];
    }
    return _imagesArray;
}

- (UIScrollView *)scrollView {
    if (_scrollView == nil) {
        _scrollView = [[UIScrollView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _scrollView.delegate = self;
        _scrollView.contentSize = CGSizeMake(self.imagesArray.count * kScreenWidth, kScreenHeight);
        _scrollView.pagingEnabled = YES;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
    }
    return _scrollView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
    
}

- (void)setupUI {
    
    [self.view addSubview:self.scrollView];
    
    CGFloat bottomMargin = IS_iPhoneX ? -100 : -60;
    
    for (NSInteger i = 0; i < self.imagesArray.count; i++) {
        
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:self.imagesArray[i]]];
        imageView.frame = CGRectMake(i * kScreenWidth, 0, kScreenWidth, kScreenHeight);
        imageView.userInteractionEnabled = YES;
        
        [self.scrollView addSubview:imageView];
        
        if (i == self.imagesArray.count - 1) {
            [imageView addSubview:self.beginBtn];
            [self.beginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.offset(6);
                make.bottom.offset(IS_iPhoneX ? -80 : -35);
            }];
        }
    }
    
    UIImageView *pageIndicatorImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"引导页-椭圆"]];
    self.pageIndicatorImageView = pageIndicatorImageView;
    pageIndicatorImageView.alpha = 0;
    [self.view addSubview:pageIndicatorImageView];
    [self.view bringSubviewToFront:pageIndicatorImageView];
    [pageIndicatorImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.offset(-25);
        make.bottom.offset(bottomMargin);
    }];
    UIImageView *pageAlreadyImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"引导页-圆角矩形"]];
    self.pageAlreadyImageView = pageAlreadyImageView;
    [self.view addSubview:pageAlreadyImageView];
    [self.view bringSubviewToFront:pageAlreadyImageView];
    [pageAlreadyImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.offset(-25);
        make.bottom.offset(bottomMargin);
    }];
    
    UIImageView *pageIndicatorImageView2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"引导页-椭圆"]];
    self.pageIndicatorImageView2 = pageIndicatorImageView2;
    [self.view addSubview:pageIndicatorImageView2];
    [self.view bringSubviewToFront:pageIndicatorImageView2];
    [pageIndicatorImageView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.offset(0);
        make.bottom.offset(bottomMargin);
    }];
    UIImageView *pageAlreadyImageView2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"引导页-圆角矩形"]];
    self.pageAlreadyImageView2 = pageAlreadyImageView2;
    pageAlreadyImageView2.alpha = 0;
    [self.view addSubview:pageAlreadyImageView2];
    [self.view bringSubviewToFront:pageAlreadyImageView2];
    [pageAlreadyImageView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.offset(0);
        make.bottom.offset(bottomMargin);
    }];
    
    UIImageView *pageIndicatorImageView3 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"引导页-椭圆"]];
    self.pageIndicatorImageView3 = pageIndicatorImageView3;
    [self.view addSubview:pageIndicatorImageView3];
    [self.view bringSubviewToFront:pageIndicatorImageView3];
    [pageIndicatorImageView3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.offset(25);
        make.bottom.offset(bottomMargin);
    }];
    UIImageView *pageAlreadyImageView3 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"引导页-圆角矩形"]];
    self.pageAlreadyImageView3 = pageAlreadyImageView3;
    pageAlreadyImageView3.alpha = 0;
    [self.view addSubview:pageAlreadyImageView3];
    [self.view bringSubviewToFront:pageAlreadyImageView3];
    [pageAlreadyImageView3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.offset(25);
        make.bottom.offset(bottomMargin);
    }];
}

- (void)beginBtnClick {
    //进入主页
    JstyleNewFeatureSelectedTagViewController *tagVC = [JstyleNewFeatureSelectedTagViewController new];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:tagVC];
    [UIApplication sharedApplication].keyWindow.rootViewController = nav;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    NSInteger page = scrollView.contentOffset.x / kScreenWidth;
    
    //alpha变化比率
    CGFloat scale = (((NSInteger)scrollView.contentOffset.x) % (NSInteger)kScreenWidth) * (1.0 / -kScreenWidth) + 1;
    
    switch (page) {
        case 0:
        {
            self.pageAlreadyImageView.alpha = scale;
            self.pageIndicatorImageView.alpha = 1 - scale;
            
            
            self.pageIndicatorImageView2.alpha = scale;
            self.pageIndicatorImageView3.alpha = 1;
            self.pageAlreadyImageView2.alpha = 1 - scale;
            self.pageAlreadyImageView3.alpha = 0;
        }
            break;
        case 1:
        {
            self.pageAlreadyImageView2.alpha = scale;
            self.pageIndicatorImageView2.alpha = 1 - scale;
            
            self.pageIndicatorImageView.alpha = 1;
            self.pageIndicatorImageView3.alpha = scale;
            self.pageAlreadyImageView.alpha = 0;
            self.pageAlreadyImageView3.alpha = 1 - scale;
        }
            break;
        case 2:
        {
            self.pageAlreadyImageView3.alpha = scale;
            self.pageIndicatorImageView3.alpha = 1 - scale;
            
            self.pageIndicatorImageView.alpha = 1;
            self.pageIndicatorImageView2.alpha = scale;
            self.pageAlreadyImageView.alpha = 0;
            self.pageAlreadyImageView2.alpha = 1 - scale;
        }
            break;
        default:
            break;
    }
    
    if (scrollView.contentOffset.x > ((self.imagesArray.count-2)*kScreenWidth + kScreenWidth/2)) {
        
        self.pageIndicatorImageView.hidden = YES;
        self.pageIndicatorImageView2.hidden = YES;
        self.pageIndicatorImageView3.hidden = YES;
        self.pageAlreadyImageView.hidden = YES;
        self.pageAlreadyImageView2.hidden = YES;
        self.pageAlreadyImageView3.hidden = YES;
    } else {
        
        self.pageIndicatorImageView.hidden = NO;
        self.pageIndicatorImageView2.hidden = NO;
        self.pageIndicatorImageView3.hidden = NO;
        self.pageAlreadyImageView.hidden = NO;
        self.pageAlreadyImageView2.hidden = NO;
        self.pageAlreadyImageView3.hidden = NO;
    }
}

- (UIButton *)beginBtn {
    if (_beginBtn == nil) {
        _beginBtn = [UIButton buttonWithNormalImage:[UIImage imageNamed:@"引导页-马上开启"] selectedImage:[UIImage imageNamed:@"引导页-马上开启"] target:self action:@selector(beginBtnClick)];
        [_beginBtn sizeToFit];
        _beginBtn.alpha = 1;
    }
    return _beginBtn;
}

@end
