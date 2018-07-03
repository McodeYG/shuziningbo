//
//  JstyleNewsAdvertisementViewController.m
//  JstyleNews
//
//  Created by 数字跃动 on 2018/1/9.
//  Copyright © 2018年 JstyleNews. All rights reserved.
//

#import "JstyleNewsAdvertisementViewController.h"
#import "DrawCircleProgressButton.h"
#import "JstyleNewsAdvertisementModel.h"
#import "JstyleNewsArticleDetailViewController.h"
#import "JstylePictureTextViewController.h"
#import "JstyleNewsVideoDetailViewController.h"
#import "JstyleNewsActivityWebViewController.h"
#import "JstyleNewsTabBarController.h"
#import "JstyleNewsNavigationController.h"

@interface JstyleNewsAdvertisementViewController ()

///广告位
@property (nonatomic, strong) YYAnimatedImageView *imageView;
@property (nonatomic, strong) JstyleNewsAdvertisementModel *model;
@property (nonatomic, weak) UIImageView *backgroundView;

@property (nonatomic, strong) NSTimer *timer;

@end

static CGFloat timeInterval = 5.0f;
@implementation JstyleNewsAdvertisementViewController

- (YYAnimatedImageView *)imageView {
    if (_imageView == nil) {
        _imageView = [[YYAnimatedImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 115 * kScale)];
        _imageView.userInteractionEnabled = NO;
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        _imageView.clipsToBounds = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureClick)];
        [_imageView addGestureRecognizer:tap];
    }
    return _imageView;
}

- (void)tapGestureClick {
    
    if (self.model == nil) {
        return;
    }
    
    [self.timer invalidate];
    self.timer = nil;
    
    JstyleNewsTabBarController *tabbarC = [[JstyleNewsTabBarController alloc] initWithViewControllers:nil tabBarItemsAttributes:nil imageInsets:UIEdgeInsetsZero titlePositionAdjustment:UIOffsetZero];
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    window.rootViewController = tabbarC;
    
    JstyleNewsNavigationController *navigationController = tabbarC.childViewControllers.firstObject;
    
    switch (self.model.banner_type.integerValue) {
        case 1:///1.文章
        {
            if (self.model.isImageArticle.integerValue == 1) {
                //图片集
                JstylePictureTextViewController *pictureVC = [JstylePictureTextViewController new];
                pictureVC.rid = self.model.rid;
                [navigationController pushViewController:pictureVC animated:YES];
            } else {
                //文章
                JstyleNewsArticleDetailViewController *articleVC = [JstyleNewsArticleDetailViewController new];
                articleVC.rid = self.model.rid;
                articleVC.titleModel.content = self.model.content;
                [navigationController pushViewController:articleVC animated:YES];
            }
        }
            break;
        case 2:///2.视频 直播
        {
            JstyleNewsVideoDetailViewController *videoVC = [JstyleNewsVideoDetailViewController new];
            videoVC.vid = self.model.rid;
            videoVC.videoTitle = self.model.title;
            videoVC.videoUrl = self.model.url_sd;
            videoVC.videoType = self.model.videoType;
            [navigationController pushViewController:videoVC animated:YES];
        }
            break;
        case 3:///3.H5
        {
            JstyleNewsActivityWebViewController *acticityVC = [JstyleNewsActivityWebViewController new];
            acticityVC.urlString = self.model.h5url;
            acticityVC.isShare = self.model.isShare.integerValue;
            [navigationController pushViewController:acticityVC animated:YES];
        }
            break;
        default:
            break;
    }
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.translucent = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadData];
    [self setupUI];
}

- (void)setupUI {
    
    UIImageView *backgroundView = [[UIImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.backgroundView = backgroundView;
    backgroundView.userInteractionEnabled = YES;
    [backgroundView setImage:[UIImage imageNamed:IS_iPhoneX?@"欢迎页-iPhone X":@"欢迎页"]];
    [self.view addSubview:backgroundView];
    
    [self.backgroundView addSubview:self.imageView];
    
}

- (void)setupSkipBtn {
    DrawCircleProgressButton *skipBtn = [[DrawCircleProgressButton alloc] initWithFrame:CGRectMake(kScreenWidth-30-15, 15, 30, 30)];
    skipBtn.lineWidth = 2;
    [skipBtn setTitle:@"跳过" forState:UIControlStateNormal];
    [skipBtn setTitleColor:kWhiteColor forState:UIControlStateNormal];
    skipBtn.titleLabel.font = [UIFont systemFontOfSize:10];
    [skipBtn addTarget:self action:@selector(removeProgress) forControlEvents:UIControlEventTouchUpInside];
    [self.backgroundView addSubview:skipBtn];
    
    __weak typeof(self)weakSelf = self;
    [skipBtn startAnimationDuration:timeInterval withBlock:^{
        [weakSelf removeProgress];
    }];
    
    [self setupTimer];
}

- (void)setupTimer {
//    self.timer = [NSTimer scheduledTimerWithTimeInterval:timeInterval target:self selector:@selector(removeProgress) userInfo:nil repeats:NO];
    self.timer = [[NSTimer alloc] initWithFireDate:[NSDate dateWithTimeIntervalSinceNow:timeInterval] interval:timeInterval target:self selector:@selector(removeProgress) userInfo:nil repeats:NO];
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    [self.timer fireDate];
}

- (void)removeProgress {
    [self.timer invalidate];
    self.timer = nil;
    [self.imageView removeFromSuperview];
    
    JstyleNewsTabBarController *tabbarC = [[JstyleNewsTabBarController alloc] initWithViewControllers:nil tabBarItemsAttributes:nil imageInsets:UIEdgeInsetsZero titlePositionAdjustment:UIOffsetZero];
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    window.rootViewController = tabbarC;
}

- (void)loadData {
    
    JstyleNewsNetworkManager *manager = [JstyleNewsNetworkManager shareManager];
    [manager GETURL:ICity_WELCOMEPAGE parameters:nil success:^(id responseObject) {
        
        if ([responseObject[@"code"] isEqualToString:@"1"]) {
            [self setupSkipBtn];
           
            self.imageView.userInteractionEnabled = YES;
            self.model = [JstyleNewsAdvertisementModel modelWithJSON:responseObject[@"data"]];
            [self.imageView setImageWithURL:[NSURL URLWithString:self.model.poster] options:YYWebImageOptionProgressiveBlur];
        } else {
            [self removeProgress];
        }
        
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
        [self removeProgress];
    }];
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)dealloc {
    
}

@end
