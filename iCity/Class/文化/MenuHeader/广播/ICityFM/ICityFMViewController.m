//
//  ICityFMViewController.m
//  HSQiCITY
//
//  Created by chunzheng wang on 2018/5/1.
//  Copyright © 2018年 chunzheng wang. All rights reserved.
//

#import "ICityFMViewController.h"
#import <Masonry.h>
#import "UILabel+Addition.h"
#import "UIColor+Addition.h"
#import <AVFoundation/AVFoundation.h>
#import "Album.h"
#import "JailNetWorking.h"
#import "UIActivityIndicatorView+XYActivity.h"
#import "Constant.h"
#import "XYPlayer.h"
#import "VRPlayerView.h"

//横向比例
#define WidthScale(number) ([UIScreen mainScreen].bounds.size.width/375.*(number))
//纵向比例
#define HeightScale(number) ([UIScreen mainScreen].bounds.size.height/667.*(number))

@interface ICityFMViewController ()
//FM的名字
@property(nonatomic,strong)UILabel *nameFMLabel;
//主播的名字
@property(nonatomic,strong)UILabel *nameLabel;
///时间的名字
@property(nonatomic,strong)UILabel *timeLabel;
//播放按钮
@property(nonatomic,strong)UIButton *playerBtn;
/**播放器*/
@property (nonatomic, strong)VRPlayerView *vrPlayer;


@property (nonatomic, strong) NSMutableArray<Album *> *dataArray;

@property (nonatomic, strong) dispatch_queue_t concurrent_queue;

@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic, strong) NSMutableArray *sortTypeArray;
///是不是暂停
@property (nonatomic) BOOL isPause;

@property (nonatomic) int clickCount;

@end

@implementation ICityFMViewController

- (VRPlayerView *)vrPlayer {
    if (!_vrPlayer) {
        NSLog(@"%zd",self.index);
        if (self.index >= (NSInteger)(self.fmDatas.count)) {
            --self.index;
            ZTShowAlertMessage(@"没有更多啦");
            return nil;
        } else if (self.index < 0) {
            ++self.index;
            ZTShowAlertMessage(@"已经是第一个啦");
            return nil;
        } else {
            
            NSString * urlString = self.fmDatas[self.index].address;
            urlString = [urlString stringByReplacingOccurrencesOfString:@" " withString:@""];//第一个url返回的多了一个空格
            NSURL * url = [NSURL URLWithString:urlString];
            
            _vrPlayer = [[VRPlayerView alloc]initWithFrame:CGRectZero withVrUrl:url withVrType:VrType_FFmpeg_Normal];
            
//            NSLog(@"===%@\n===%@",urlString,url.absoluteString);
            _vrPlayer.progressSlider.hidden = YES;
            _vrPlayer.backBtn.hidden = YES;
        }
    }
    return _vrPlayer;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = self.fmDatas[self.index].radioname;
    
    [self setupUI];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:JSImage(@"nav_icon_back_default") style:UIBarButtonItemStylePlain target:self action:@selector(popAction)];
    [self vrPlayer];
    self.vrPlayer.isPauseStatus = NO;
    [self.vrPlayer play];
}

- (void)popAction {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    NSDictionary *navbarTitleTextAttributes = @{
                                                NSForegroundColorAttributeName:kThemeeModeTitleColor,
                                                NSFontAttributeName:[UIFont systemFontOfSize:18]
                                                };
    [self.navigationController.navigationBar setTitleTextAttributes:navbarTitleTextAttributes];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:kNavigationBarColor] forBarMetrics:UIBarMetricsDefault];
    NSString *currentThemeName  = [ThemeTool themeString];
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"bg_%@",currentThemeName]] forBarMetrics:UIBarMetricsDefault];
    
    self.vrPlayer.isPauseStatus = NO;
    [self.vrPlayer play];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    NSLog(@"FMViewConMMMM");
    
    NSDictionary *navbarTitleTextAttributes = @{
                                                NSForegroundColorAttributeName:JSColor(@"#000000"),
                                                NSFontAttributeName:[UIFont systemFontOfSize:18]
                                                };
    [self.navigationController.navigationBar setTitleTextAttributes:navbarTitleTextAttributes];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:kWhiteColor] forBarMetrics:UIBarMetricsDefault];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    self.vrPlayer.isPauseStatus = YES;
    [self.vrPlayer pause];
}

-(void)resetUI {
    if (self.vrPlayer.isPauseStatus) {
        [self.playerBtn setBackgroundImage:[UIImage imageNamed:@"fm_play"] forState:UIControlStateNormal];
    
    } else {
        [self.playerBtn setBackgroundImage:[UIImage imageNamed:@"fm_pause"] forState:UIControlStateNormal];
    }
}

-(void)setupUI{
    
    [self.view addSubview:self.vrPlayer];
    
    if (self.index >= self.fmDatas.count) {
        return;
    }
    ICityBoradcastModel *model = self.fmDatas[self.index];
    
    UIImageView *BGImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pic"]];
    BGImg.contentMode = UIViewContentModeScaleAspectFill;
    BGImg.clipsToBounds = YES;
    [self.view addSubview:BGImg];
    [BGImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.offset(0);
        make.bottom.mas_offset(-133-YG_SafeBottom_H);
    }];
    
    UIView *backView = [UIView new];
    backView.backgroundColor = [UIColor clearColor];
    [BGImg addSubview:backView];
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.offset(0);
        make.centerY.offset(0);
        make.width.offset(WidthScale(300));
        make.height.offset(WidthScale(300));
    }];
    
    backView.layer.borderColor = [UIColor colorWithHex:0xCCCCCC].CGColor;
    backView.layer.cornerRadius = 2;
    backView.layer.borderWidth = 1;
    //广播名字
    UILabel *nameFMLabel = [UILabel makeLabelWithTextColor:[UIColor colorWithHex:0x666666] andTextFont:18 andContentText:model.showname];
    self.nameFMLabel = nameFMLabel;
    [backView addSubview:nameFMLabel];
    [nameFMLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(WidthScale(113));
        make.centerX.offset(0);
    }];
    [nameFMLabel sizeToFit];
    ///主播名字
    UILabel *nameLabel = [UILabel makeLabelWithTextColor:[UIColor colorWithHex:0x666666] andTextFont:12 andContentText:model.anchor];
    self.nameLabel = nameLabel;
    [backView addSubview:nameLabel];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.offset(0);
        make.centerY.offset(0);
    }];
    //时间
    UILabel *timeLabel = [UILabel makeLabelWithTextColor:[UIColor colorWithHex:0x999999] andTextFont:12 andContentText:[NSString stringWithFormat:@"%@ - %@",model.start_time, model.end_time]];
    self.timeLabel = timeLabel;
    
    [backView addSubview:timeLabel];
    [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(nameLabel.mas_bottom).offset(10);
        make.centerX.offset(0);
        
    }];
    [self setupBottomUI];
    
}
-(void)setupBottomUI{
    UIButton *playerBtn = [UIButton new];
    self.playerBtn = playerBtn;
    [playerBtn setBackgroundImage:[UIImage imageNamed:@"fm_pause"] forState:UIControlStateNormal];
    [self.view addSubview:playerBtn];
    [playerBtn sizeToFit];
    [playerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.offset(HeightScale(-36));
        make.centerX.offset(0);
    }];
    [playerBtn addTarget:self action:@selector(playerBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *previousBtn = [UIButton new];
    [previousBtn setBackgroundImage:[UIImage imageNamed:@"content_button_last_default"] forState:UIControlStateNormal];
    [self.view addSubview:previousBtn];
    [previousBtn sizeToFit];
    [previousBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(playerBtn.mas_left).offset(WidthScale(-40));
        make.centerY.equalTo(playerBtn.mas_centerY).offset(0);
    }];
    [previousBtn addTarget:self action:@selector(previousBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *nextBtn = [UIButton new];
    [nextBtn setBackgroundImage:[UIImage imageNamed:@"content_button_next_default"] forState:UIControlStateNormal];
    [self.view addSubview:nextBtn];
    [nextBtn sizeToFit];
    [nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(playerBtn.mas_centerY).offset(0);
        make.left.equalTo(playerBtn.mas_right).offset(WidthScale(40));
    }];
    [nextBtn addTarget:self action:@selector(nextBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)start {
    [self.vrPlayer play];
}

- (void)playerBtnClick{
    
    if (self.vrPlayer.isPauseStatus) {
        [self.vrPlayer play];
        self.vrPlayer.isPauseStatus = NO;
    } else {
        [self.vrPlayer pause];
        self.vrPlayer.isPauseStatus = YES;
    }
    [self resetUI];
}

- (void)previousBtnClick{
    --self.index;
    [self resetFMDataView];
}

- (void)nextBtnClick{
    ++self.index;
    [self resetFMDataView];
}

- (void)resetFMDataView {
    
    NSLog(@"%zd",self.index);
    [self.vrPlayer removeFromSuperview];
    [self.vrPlayer releseTimer];
    self.vrPlayer = nil;
    [self.view addSubview:self.vrPlayer];
    [self.vrPlayer play];
    
    if (self.index < self.fmDatas.count) {
        ICityBoradcastModel *model = self.fmDatas[self.index];
        
        self.title = model.radioname;
        self.nameFMLabel.text = model.showname;
        self.nameLabel.text = model.anchor;
        self.timeLabel.text = [NSString stringWithFormat:@"%@ - %@",model.start_time, model.end_time];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)dealloc {
    [self.vrPlayer removeFromSuperview];
    [self.vrPlayer releseTimer];
    self.vrPlayer = nil;
    
}

@end
