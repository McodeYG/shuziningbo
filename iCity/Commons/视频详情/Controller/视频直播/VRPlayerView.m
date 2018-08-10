//
//  VRPlayerView.m
//  VRVr
//
//  Created by 数字宁波 on 2017/5/2.
//  Copyright © 2017年 赵涛. All rights reserved.
//

#import "VRPlayerView.h"
#define kBottomHeight 35.0
@interface VRPlayerView ()
///请求当前直播是否真正结束接口的次数
@property (nonatomic, assign) NSInteger times;

@property (nonatomic, assign) BOOL isTopBottomHidden;

@property (nonatomic, assign) BOOL isFullScreen;

//记录上次视频相关操作的时间
@property (nonatomic, assign) NSTimeInterval lastShowTopBottomTime;

//网络监测添加的view
@property (nonatomic, strong) UIView *netHoldView;
@property (nonatomic, strong) UILabel *alertLabel;
@property (nonatomic, strong) UIButton *continueBtn;
@property (nonatomic, strong) NSURL *vrUrl;
@property (nonatomic, assign) VRPlayerType vrType;

@end

@implementation VRPlayerView

- (instancetype)initWithFrame:(CGRect)frame withVrUrl:(NSURL *)vrUrl withVrType:(VRPlayerType)vrType
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.vrUrl = [NSURL URLWithString:[vrUrl.absoluteString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        self.vrType = vrType;
        self.player = [SGPlayer player];
        [self.player registerPlayerNotificationTarget:self
                                          stateAction:@selector(stateAction:)
                                       progressAction:@selector(progressAction:)
                                       playableAction:@selector(playableAction:)
                                          errorAction:@selector(errorAction:)];
        [self addSubview:self.player.view];
        
        [self setUI];
        NSInteger netStatus = [[JstyleToolManager sharedManager] getCurrentNetStatus];
        switch (netStatus) {
            case 1:{
                switch (vrType){
                    case VrType_AVPlayer_Normal:
                        [self.player replaceVideoWithURL:vrUrl];
                        break;
                    case VrType_AVPlayer_VR:
                        [self.player replaceVideoWithURL:vrUrl videoType:SGVideoTypeVR];
                        break;
                    case VrType_AVPlayer_VR_Box:
                        self.player.displayMode = SGDisplayModeBox;
                        [self.player replaceVideoWithURL:vrUrl videoType:SGVideoTypeVR];
                        break;
                    case VrType_FFmpeg_Normal:
                        self.player.decoder = [SGPlayerDecoder decoderByFFmpeg];
                        self.player.decoder.hardwareAccelerateEnableForFFmpeg = NO;
                        [self.player replaceVideoWithURL:vrUrl];
                        break;
                    case VrType_FFmpeg_Normal_Hardware:
                        self.player.decoder = [SGPlayerDecoder decoderByFFmpeg];
                        [self.player replaceVideoWithURL:vrUrl];
                        break;
                    case VrType_FFmpeg_VR:
                        self.player.decoder = [SGPlayerDecoder decoderByFFmpeg];
                        self.player.decoder.hardwareAccelerateEnableForFFmpeg = NO;
                        [self.player replaceVideoWithURL:vrUrl videoType:SGVideoTypeVR];
                        break;
                    case VrType_FFmpeg_VR_Hardware:
                        self.player.decoder = [SGPlayerDecoder decoderByFFmpeg];
                        [self.player replaceVideoWithURL:vrUrl videoType:SGVideoTypeVR];
                        break;
                    case VrType_FFmpeg_VR_Box:
                        self.player.displayMode = SGDisplayModeBox;
                        self.player.decoder = [SGPlayerDecoder decoderByFFmpeg];
                        self.player.decoder.hardwareAccelerateEnableForFFmpeg = NO;
                        [self.player replaceVideoWithURL:vrUrl videoType:SGVideoTypeVR];
                        break;
                    case VrType_FFmpeg_VR_Box_Hardware:
                        self.player.displayMode = SGDisplayModeBox;
                        self.player.decoder = [SGPlayerDecoder decoderByFFmpeg];
                        [self.player replaceVideoWithURL:vrUrl videoType:SGVideoTypeVR];
                        break;
                }
            }
                break;
            case 2:
                if ([[JstyleToolManager sharedManager] isVideoPlayOnlyWifi]) {
                    [self addNetStatusHoldView];
                }else{
                    switch (vrType){
                        case VrType_AVPlayer_Normal:
                            [self.player replaceVideoWithURL:vrUrl];
                            break;
                        case VrType_AVPlayer_VR:
                            [self.player replaceVideoWithURL:vrUrl videoType:SGVideoTypeVR];
                            break;
                        case VrType_AVPlayer_VR_Box:
                            self.player.displayMode = SGDisplayModeBox;
                            [self.player replaceVideoWithURL:vrUrl videoType:SGVideoTypeVR];
                            break;
                        case VrType_FFmpeg_Normal:
                            self.player.decoder = [SGPlayerDecoder decoderByFFmpeg];
                            self.player.decoder.hardwareAccelerateEnableForFFmpeg = NO;
                            [self.player replaceVideoWithURL:vrUrl];
                            break;
                        case VrType_FFmpeg_Normal_Hardware:
                            self.player.decoder = [SGPlayerDecoder decoderByFFmpeg];
                            [self.player replaceVideoWithURL:vrUrl];
                            break;
                        case VrType_FFmpeg_VR:
                            self.player.decoder = [SGPlayerDecoder decoderByFFmpeg];
                            self.player.decoder.hardwareAccelerateEnableForFFmpeg = NO;
                            [self.player replaceVideoWithURL:vrUrl videoType:SGVideoTypeVR];
                            break;
                        case VrType_FFmpeg_VR_Hardware:
                            self.player.decoder = [SGPlayerDecoder decoderByFFmpeg];
                            [self.player replaceVideoWithURL:vrUrl videoType:SGVideoTypeVR];
                            break;
                        case VrType_FFmpeg_VR_Box:
                            self.player.displayMode = SGDisplayModeBox;
                            self.player.decoder = [SGPlayerDecoder decoderByFFmpeg];
                            self.player.decoder.hardwareAccelerateEnableForFFmpeg = NO;
                            [self.player replaceVideoWithURL:vrUrl videoType:SGVideoTypeVR];
                            break;
                        case VrType_FFmpeg_VR_Box_Hardware:
                            self.player.displayMode = SGDisplayModeBox;
                            self.player.decoder = [SGPlayerDecoder decoderByFFmpeg];
                            [self.player replaceVideoWithURL:vrUrl videoType:SGVideoTypeVR];
                            break;
                    }
                }
                break;
            case 3:
                ZTShowAlertMsg(@"当前无网络,请检查网络", 2);
                break;
            default:
                break;
        }
    }
    return self;
}

- (void)addNetStatusHoldView
{
    _netHoldView = [[UIView alloc] init];
    _netHoldView.backgroundColor = [UIColor blackColor];
    [self insertSubview:_netHoldView belowSubview:_backBtn];
    _netHoldView.sd_layout
    .topEqualToView(self)
    .bottomEqualToView(self)
    .leftEqualToView(self)
    .rightEqualToView(self);
    
    _netBackBtn = [[UIButton alloc] init];
    [_netBackBtn setImage:[UIImage imageNamed:@"roundreturn"] forState:UIControlStateNormal];
    [_netBackBtn addTarget:self action:@selector(backBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_netHoldView addSubview:_netBackBtn];
    _netBackBtn.sd_layout
    .topSpaceToView(_netHoldView, 20)
    .leftSpaceToView(_netHoldView, 10)
    .widthIs(30)
    .heightIs(30);
    
    _alertLabel = [[UILabel alloc] init];
    _alertLabel.textColor = kWhiteColor;
    _alertLabel.text = @"播放将使用手机流量";
    _alertLabel.textAlignment = NSTextAlignmentCenter;
    _alertLabel.font = JSFont(16);
    [_netHoldView addSubview:_alertLabel];
    _alertLabel.sd_layout
    .leftEqualToView(_netHoldView)
    .rightEqualToView(_netHoldView)
    .centerYEqualToView(_netHoldView).offset(- 20)
    .heightIs(15);
    
    _continueBtn = [[UIButton alloc] init];
    _continueBtn.backgroundColor = [UIColor colorFromHexString:@"D49008"];
    _continueBtn.titleLabel.font = JSFont(14);
    [_continueBtn setTitle:@"继续播放" forState:(UIControlStateNormal)];
    [_continueBtn setTitleColor:kWhiteColor forState:(UIControlStateNormal)];
    _continueBtn.layer.cornerRadius = 15;
    _continueBtn.layer.masksToBounds = YES;
    [_continueBtn addTarget:self action:@selector(continueBtnClicked:) forControlEvents:(UIControlEventTouchUpInside)];
    [_netHoldView addSubview:_continueBtn];
    _continueBtn.sd_layout
    .centerXEqualToView(_netHoldView)
    .centerYEqualToView(_netHoldView).offset(20)
    .widthIs(80)
    .heightIs(30);
}

- (void)continueBtnClicked:(UIButton *)sender
{
    [_netHoldView removeFromSuperview];
    switch (self.vrType){
        case VrType_AVPlayer_Normal:
            [self.player replaceVideoWithURL:self.vrUrl];
            break;
        case VrType_AVPlayer_VR:
            [self.player replaceVideoWithURL:self.vrUrl videoType:SGVideoTypeVR];
            break;
        case VrType_AVPlayer_VR_Box:
            self.player.displayMode = SGDisplayModeBox;
            [self.player replaceVideoWithURL:self.vrUrl videoType:SGVideoTypeVR];
            break;
        case VrType_FFmpeg_Normal:
            self.player.decoder = [SGPlayerDecoder decoderByFFmpeg];
            self.player.decoder.hardwareAccelerateEnableForFFmpeg = NO;
            [self.player replaceVideoWithURL:self.vrUrl];
            break;
        case VrType_FFmpeg_Normal_Hardware:
            self.player.decoder = [SGPlayerDecoder decoderByFFmpeg];
            [self.player replaceVideoWithURL:self.vrUrl];
            break;
        case VrType_FFmpeg_VR:
            self.player.decoder = [SGPlayerDecoder decoderByFFmpeg];
            self.player.decoder.hardwareAccelerateEnableForFFmpeg = NO;
            [self.player replaceVideoWithURL:self.vrUrl videoType:SGVideoTypeVR];
            break;
        case VrType_FFmpeg_VR_Hardware:
            self.player.decoder = [SGPlayerDecoder decoderByFFmpeg];
            [self.player replaceVideoWithURL:self.vrUrl videoType:SGVideoTypeVR];
            break;
        case VrType_FFmpeg_VR_Box:
            self.player.displayMode = SGDisplayModeBox;
            self.player.decoder = [SGPlayerDecoder decoderByFFmpeg];
            self.player.decoder.hardwareAccelerateEnableForFFmpeg = NO;
            [self.player replaceVideoWithURL:self.vrUrl videoType:SGVideoTypeVR];
            break;
        case VrType_FFmpeg_VR_Box_Hardware:
            self.player.displayMode = SGDisplayModeBox;
            self.player.decoder = [SGPlayerDecoder decoderByFFmpeg];
            [self.player replaceVideoWithURL:self.vrUrl videoType:SGVideoTypeVR];
            break;
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.player.view.frame = self.bounds;
}

- (void)setTitle:(NSString *)title
{
    _title = title;
//    self.liveTitleLabel.text = title;
}

- (void)setUI
{
    self.isTopBottomHidden = NO;
    _lastShowTopBottomTime = [[NSDate date] timeIntervalSince1970];
    _splashTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(topBottomHidenAction) userInfo:nil repeats:YES];
    
    UIView *holdView = [[UIView alloc] init];
    [self addSubview:holdView];
    holdView.sd_layout
    .topEqualToView(self)
    .leftEqualToView(self)
    .rightEqualToView(self)
    .bottomEqualToView(self);
    
    _indicatorView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    [self addSubview:_indicatorView];
    _indicatorView.sd_layout
    .centerXEqualToView(self)
    .centerYEqualToView(self);
    
    //底部bottomView
    _bottomView = [[UIImageView alloc]init];
    _bottomView.userInteractionEnabled = YES;
    [self addSubview:_bottomView];
    //autoLayout bottomView
    _bottomView.sd_layout
    .topEqualToView(self)
    .leftEqualToView(self)
    .rightEqualToView(self)
    .bottomEqualToView(self);
    
    [self setAutoresizesSubviews:NO];
    
    //返回
    self.backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.backBtn setImage:[UIImage imageNamed:@"roundreturn"] forState:UIControlStateNormal];
    [self.backBtn addTarget:self action:@selector(backBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.backBtn setEnlargeEdgeWithTop:10 right:10 bottom:10 left:10];
    [_bottomView addSubview:_backBtn];
    _backBtn.sd_layout
    .topSpaceToView(_bottomView, 20)
    .leftSpaceToView(_bottomView, 10)
    .widthIs(30)
    .heightIs(30);
    
    //视频更多按钮
    _moreBtn = [[UIButton alloc]init];
    _moreBtn.hidden = YES;
    [_moreBtn setImage:[UIImage imageNamed:@"文章分享白"] forState:(UIControlStateNormal)];
    [_moreBtn addTarget:self action:@selector(moreBtnBtnClicked:) forControlEvents:(UIControlEventTouchUpInside)];
    [_moreBtn setEnlargeEdgeWithTop:10 right:10 bottom:10 left:10];
    [_bottomView addSubview:_moreBtn];
    _moreBtn.sd_layout
    .topSpaceToView(_bottomView, 20)
    .rightSpaceToView(_bottomView, 10)
    .widthIs(30)
    .heightIs(30);
    
    //视频标题
    _liveTitleLabel = [[UILabel alloc]init];
    _liveTitleLabel.text = self.title;
    _liveTitleLabel.textColor = [UIColor whiteColor];
    _liveTitleLabel.font = [UIFont systemFontOfSize:16];
    [_bottomView addSubview:_liveTitleLabel];
    _liveTitleLabel.sd_layout
    .centerYEqualToView(_backBtn)
    .leftSpaceToView(self.backBtn, 10)
    .rightSpaceToView(self.moreBtn, 10)
    .heightIs(20);
    
    //播放/暂停按钮
    _playPauseBtn = [[VRPlayerPlayButton alloc]initWithFrame:CGRectMake(0, 0, 16, 16) state:(VRPlayerPlayButtonStatePause)];
    [_playPauseBtn setEnlargeEdgeWithTop:30 right:30 bottom:30 left:30];
    [_bottomView addSubview:_playPauseBtn];
    _playPauseBtn.sd_layout
    .centerXEqualToView(self.bottomView)
    .centerYEqualToView(self.bottomView).offset(-5)
    .widthIs(16)
    .heightIs(16);
    [_playPauseBtn addTarget:self action:@selector(PlayOrPauseAction:) forControlEvents:UIControlEventTouchUpInside];
//    [_playPauseBtn setImage:[UIImage imageNamed:@"videopause"] forState:UIControlStateNormal];
//    [_playPauseBtn setImage:[UIImage imageNamed:@"videoplay"] forState:UIControlStateSelected];
    
    MPVolumeView *volumeView = [[MPVolumeView alloc]init];
    for (UIControl *view in volumeView.subviews) {
        if ([view.superclass isSubclassOfClass:[VRPlayerSlider class]]) {
            self.volumeSlider = (VRPlayerSlider *)view;
        }
    }
    
    //进度条
    _progressSlider = [[VRPlayerSlider alloc]init];
    _progressSlider.minimumValue = 0.0;
    _progressSlider.maximumValue = 1.0;
    [_progressSlider setThumbImage:[UIImage imageNamed:@"dot"] forState:UIControlStateNormal];
    _progressSlider.minimumTrackTintColor = kGlobalGoldColor;
    _progressSlider.maximumTrackTintColor = kDarkNineColor;
    _progressSlider.value = 0.0;
    
    [_progressSlider addTarget:self action:@selector(progressTouchUp:) forControlEvents:(UIControlEventTouchUpInside)];
    [_progressSlider addTarget:self action:@selector(progressTouchDown:) forControlEvents:(UIControlEventTouchDown)];
    [self.bottomView addSubview:self.progressSlider];
    _progressSlider.backgroundColor = [UIColor clearColor];
    //autoLayout slider
    _progressSlider.sd_layout
    .leftSpaceToView(self.bottomView, -2)
    .rightSpaceToView(self.bottomView, -2)
    .bottomEqualToView(self.bottomView)
    .heightIs(4);
    
    //全屏按钮
    _fullScreenBtn = [[UIButton alloc]init];
    [_fullScreenBtn setEnlargeEdgeWithTop:10 right:10 bottom:10 left:10];
    [_bottomView addSubview:_fullScreenBtn];
    _fullScreenBtn.sd_layout
    .rightSpaceToView(self.bottomView, 15)
    .bottomSpaceToView(self.bottomView, 25)
    .widthIs(25)
    .heightIs(25);
    [_fullScreenBtn addTarget:self action:@selector(fullScreenBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [_fullScreenBtn setImage:[UIImage imageNamed:@"视频全屏"] forState:UIControlStateNormal];
    [_fullScreenBtn setImage:[UIImage imageNamed:@"视频全屏"] forState:UIControlStateSelected];
    
    //切换BOX模式
    _boxButton = [[UIButton alloc]init];
     [_boxButton setEnlargeEdgeWithTop:10 right:10 bottom:10 left:10];
    [_bottomView addSubview:_boxButton];
    _boxButton.sd_layout
    .rightSpaceToView(_fullScreenBtn, 10)
    .centerYEqualToView(_fullScreenBtn)
    .widthIs(30)
    .heightIs(kBottomHeight - 20);
    [_boxButton setImage:[UIImage imageNamed:@"vrbox"] forState:(UIControlStateNormal)];
    [_boxButton addTarget:self action:@selector(twoEyesType) forControlEvents:(UIControlEventTouchUpInside)];
    
    _lineLabel = [[UILabel alloc]init];
    _lineLabel.text = @"/";
    _lineLabel.textColor = [UIColor whiteColor];
    _lineLabel.textAlignment = NSTextAlignmentCenter;
    _lineLabel.font = [UIFont systemFontOfSize:12];
    [self.bottomView addSubview:_lineLabel];
    _lineLabel.sd_layout
    .topSpaceToView(_playPauseBtn, 10)
    .centerXEqualToView(self.bottomView)
    .widthIs(5)
    .heightIs(20);
    
    //leftTimeLabel
    self.leftTimeLabel = [[UILabel alloc]init];
    self.leftTimeLabel.textAlignment = NSTextAlignmentRight;
    self.leftTimeLabel.textColor = [UIColor whiteColor];
    self.leftTimeLabel.backgroundColor = [UIColor clearColor];
    self.leftTimeLabel.font = [UIFont systemFontOfSize:12];
    self.leftTimeLabel.text = @"00:00";
    [self.bottomView addSubview:self.leftTimeLabel];
    //autoLayout timeLabel
    self.leftTimeLabel.sd_layout
    .leftSpaceToView(self.bottomView, 15)
    .rightSpaceToView(_lineLabel, 10)
    .centerYEqualToView(_lineLabel)
    .heightIs(20);
    
    //rightTimeLabel
    self.rightTimeLabel = [[UILabel alloc]init];
    self.rightTimeLabel.textAlignment = NSTextAlignmentLeft;
    self.rightTimeLabel.textColor = [UIColor whiteColor];
    self.rightTimeLabel.backgroundColor = [UIColor clearColor];
    self.rightTimeLabel.font = [UIFont systemFontOfSize:12];
    self.rightTimeLabel.text = @"00:00";
    [self.bottomView addSubview:self.rightTimeLabel];
    //autoLayout timeLabel
    self.rightTimeLabel.sd_layout
    .leftSpaceToView(_lineLabel, 10)
    .rightSpaceToView(self.bottomView, 15)
    .centerYEqualToView(_lineLabel)
    .heightIs(20);
    
    //返回放在最上边
    [_bottomView bringSubviewToFront:_backBtn];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appwillResignActive:) name:UIApplicationWillResignActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appBecomeActive:) name:UIApplicationDidBecomeActiveNotification object:nil];
    
    // 单击的 Recognizer
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    singleTap.numberOfTapsRequired = 1; // 单击
    singleTap.numberOfTouchesRequired = 1;
    [self addGestureRecognizer:singleTap];
    
    // 双击的 Recognizer
    UITapGestureRecognizer* doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
    doubleTap.numberOfTouchesRequired = 1; //手指数
    doubleTap.numberOfTapsRequired = 2; // 双击
    // 解决点击当前view时候响应其他控件事件
    [singleTap setDelaysTouchesBegan:YES];
    [doubleTap setDelaysTouchesBegan:YES];
    [singleTap requireGestureRecognizerToFail:doubleTap];//处理手势冲突，只响应其中一个
    [self addGestureRecognizer:doubleTap];
}

- (void)handleSingleTap:(UITapGestureRecognizer *)tapGestureRecognizer
{
    self.isTopBottomHidden = !self.isTopBottomHidden;
    if (!self.isTopBottomHidden) {
        [UIView animateWithDuration:1 animations:^{
            self.bottomView.hidden = YES;
        }];
        //隐藏系统状态栏
        if (self.delegate && [self.delegate respondsToSelector:@selector(vrPlayerView:statusBarHidden:)]) {
            [self.delegate vrPlayerView:self statusBarHidden:YES];
        }
    }else{
        [UIView animateWithDuration:1 animations:^{
            self.bottomView.hidden = NO;
        }];
        //显示系统状态栏
        if (self.delegate && [self.delegate respondsToSelector:@selector(vrPlayerView:statusBarHidden:)]) {
            [self.delegate vrPlayerView:self statusBarHidden:NO];
        }
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(vrPlayerView:tapGestureRecognizer:)]) {
        [self.delegate vrPlayerView:self tapGestureRecognizer:tapGestureRecognizer];
    }
    _lastShowTopBottomTime = [[NSDate date] timeIntervalSince1970];
}

- (void)handleDoubleTap:(UITapGestureRecognizer *)tapGestureRecognizer
{
    self.bottomView.hidden = NO;
    //显示系统状态栏
    if (self.delegate && [self.delegate respondsToSelector:@selector(vrPlayerView:statusBarHidden:)]) {
        [self.delegate vrPlayerView:self statusBarHidden:NO];
    }
    [self.playPauseBtn sendActionsForControlEvents:(UIControlEventTouchUpInside)];
    _lastShowTopBottomTime = [[NSDate date] timeIntervalSince1970];
}

#pragma mark appwillResignActive
- (void)appwillResignActive:(NSNotification *)note
{
    [_player pause];
}
- (void)appBecomeActive:(NSNotification *)note
{
    [_player play];
}

- (void)twoEyesType
{
    _isBoxType = !_isBoxType;
    if (_isBoxType) {
        self.player.displayMode = SGDisplayModeBox;
    }else{
        self.player.displayMode = SGDisplayModeNormal;
    }
    
    _lastShowTopBottomTime = [[NSDate date] timeIntervalSince1970];
}

- (void)backBtnClicked:(UIButton *)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(vrPlayerView:backBtnClicked:)]) {
        [self.delegate vrPlayerView:self backBtnClicked:self.isFullScreen];
    }
}

- (void)moreBtnBtnClicked:(UIButton *)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(vrPlayerView:moreBtn:)]) {
        [self.delegate vrPlayerView:self moreBtn:self.moreBtn];
    }
}

- (void)PlayOrPauseAction:(VRPlayerPlayButton *)sender{
    _isPauseStatus = !_isPauseStatus;
    if (_isPauseStatus) {
        sender.selected = YES;
        sender.buttonState = VRPlayerPlayButtonStatePlay;
        [self.player pause];
    }else{
        sender.selected = NO;
        sender.buttonState = VRPlayerPlayButtonStatePause;
        [self.player play];
    }
    
    _lastShowTopBottomTime = [[NSDate date] timeIntervalSince1970];
}

- (void)play
{
    [self.player play];
}

- (void)pause
{
    [self.player pause];
}

- (void)fullScreenBtnAction:(UIButton *)sender
{
    sender.selected = !sender.selected;
    if (sender.selected) {
        [self fullScreen];
        self.isFullScreen = YES;
        self.moreBtn.hidden = NO;
        self.liveTitleLabel.text = self.title;//横屏显示标题，竖屏小画面不显示标题
    }else{
        [self smallScreen];
        self.isFullScreen = NO;
        self.moreBtn.hidden = YES;
        self.liveTitleLabel.text = @"";//横屏显示标题，竖屏小画面不显示标题
    }
    if ([self.delegate respondsToSelector:@selector(vrPlayerView:clickedFullScreen:)]) {
        [self.delegate vrPlayerView:self clickedFullScreen:sender];
    }
    
    _lastShowTopBottomTime = [[NSDate date] timeIntervalSince1970];
}

- (void)fullScreen
{
    self.lineLabel.hidden = YES;
    self.fullScreenBtn.hidden = YES;
    [self.backBtn setImage:[UIImage imageNamed:@"视频全屏"] forState:UIControlStateNormal];
    
    self.backBtn.sd_resetLayout
    .topSpaceToView(_bottomView, 10)
    .leftSpaceToView(_bottomView, 10)
    .widthIs(30)
    .heightIs(30);
    
    self.moreBtn.sd_resetLayout
    .topSpaceToView(_bottomView, 10)
    .rightSpaceToView(_bottomView, 10)
    .widthIs(30)
    .heightIs(30);
    
    self.leftTimeLabel.sd_resetLayout
    .leftSpaceToView(self.bottomView, 10)
    .bottomSpaceToView(self.bottomView, 10)
    .heightIs(20)
    .widthIs(50);
    
    self.rightTimeLabel.sd_resetLayout
    .rightSpaceToView(self.bottomView, 10)
    .bottomSpaceToView(self.bottomView, 10)
    .heightIs(20)
    .widthIs(50);
    
    self.progressSlider.sd_resetLayout
    .leftSpaceToView(self.bottomView, 70)
    .rightSpaceToView(self.bottomView, 70)
    .bottomSpaceToView(self.bottomView, 15)
    .heightIs(10);
}

- (void)smallScreen
{
    self.lineLabel.hidden = NO;
    self.fullScreenBtn.hidden = NO;
    [self.backBtn setImage:[UIImage imageNamed:@"roundreturn"] forState:UIControlStateNormal];
    
    self.backBtn.sd_resetLayout
    .topSpaceToView(_bottomView, 20)
    .leftSpaceToView(_bottomView, 10)
    .widthIs(30)
    .heightIs(30);
    
    self.moreBtn.sd_resetLayout
    .topSpaceToView(_bottomView, 20)
    .rightSpaceToView(_bottomView, 10)
    .widthIs(30)
    .heightIs(30);
    
    self.leftTimeLabel.sd_resetLayout
    .leftSpaceToView(self.bottomView, 15)
    .rightSpaceToView(_lineLabel, 10)
    .centerYEqualToView(_lineLabel)
    .heightIs(20);
    
    self.rightTimeLabel.sd_resetLayout
    .leftSpaceToView(_lineLabel, 10)
    .rightSpaceToView(self.bottomView, 15)
    .centerYEqualToView(_lineLabel)
    .heightIs(20);
    
    self.progressSlider.sd_resetLayout
    .leftSpaceToView(self.bottomView, -2)
    .rightSpaceToView(self.bottomView, -2)
    .bottomSpaceToView(self.bottomView, 0)
    .heightIs(4);
}

- (void)progressTouchDown:(id)sender
{
    self.progressSilderTouching = YES;
    _lastShowTopBottomTime = [[NSDate date] timeIntervalSince1970];
}

- (void)progressTouchUp:(id)sender
{
    self.progressSilderTouching = NO;
    [self.player seekToTime:self.player.duration * self.progressSlider.value];
    _lastShowTopBottomTime = [[NSDate date] timeIntervalSince1970];
}

- (void)stateAction:(NSNotification *)notification
{
    SGState * state = [SGState stateFromUserInfo:notification.userInfo];
    
    switch (state.current) {
        case SGPlayerStateNone:
            break;
        case SGPlayerStateBuffering:
            if (self.vid) {
                [self judgeWhyLiveStop];//111
            }
            [_indicatorView startAnimating];
            break;
        case SGPlayerStateReadyToPlay:
            [_indicatorView startAnimating];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"RemoveVideoPlaceholderImage" object:nil];
            self.rightTimeLabel.text = [self timeStringFromSeconds:self.player.duration];
            [self.player play];
            _lastShowTopBottomTime = [[NSDate date] timeIntervalSince1970];
            break;
        case SGPlayerStatePlaying:
            [[NSNotificationCenter defaultCenter] postNotificationName:@"RemoveVideoPlaceholderImage" object:nil];
            self.rightTimeLabel.text = [self timeStringFromSeconds:self.player.duration];
            [_indicatorView stopAnimating];
            _lastShowTopBottomTime = [[NSDate date] timeIntervalSince1970];
            break;
        case SGPlayerStateSuspend:
            break;
        case SGPlayerStateFinished:
            if (self.vid) {
                [self judgeWhyLiveStop];//111
            }
            self.progressSlider.value = 0.0;
            self.leftTimeLabel.text = @"00:00";
            [self.player seekToTime:0];
            [self.playPauseBtn sendActionsForControlEvents:(UIControlEventTouchUpInside)];
            break;
        case SGPlayerStateFailed:
            [self judgeWhyLiveStop];
            break;
    }
}

- (void)progressAction:(NSNotification *)notification
{
    SGProgress * progress = [SGProgress progressFromUserInfo:notification.userInfo];
    if (!self.progressSilderTouching) {
        self.progressSlider.value = progress.percent;
    }
    self.leftTimeLabel.text = [self timeStringFromSeconds:progress.current];
}

- (void)playableAction:(NSNotification *)notification
{
    //    SGPlayable * playable = [SGPlayable playableFromUserInfo:notification.userInfo];
    //    NSLog(@"playable time : %f", playable.current);
}

- (void)errorAction:(NSNotification *)notification
{
    SGError * error = [SGError errorFromUserInfo:notification.userInfo];
    NSLog(@"player did error : %@", error.error);
}

- (NSString *)timeStringFromSeconds:(CGFloat)seconds
{
    return [NSString stringWithFormat:@"%ld:%.2ld", (long)seconds / 60, (long)seconds % 60];
}

- (void)topBottomHidenAction
{
    NSTimeInterval currentTime = [[NSDate date] timeIntervalSince1970];
    if ((currentTime - _lastShowTopBottomTime) > 2.0) {
        if (self.isTopBottomHidden) {
            self.isTopBottomHidden = !self.isTopBottomHidden;
            [UIView animateWithDuration:1 animations:^{
                self.bottomView.hidden = YES;
            }];
            //隐藏系统状态栏
            if (self.delegate && [self.delegate respondsToSelector:@selector(vrPlayerView:statusBarHidden:)]) {
                [self.delegate vrPlayerView:self statusBarHidden:YES];
            }
        }
    }
}

- (void)releseTimer
{
    [_splashTimer invalidate];
    _splashTimer = nil;
}

- (void)dealloc
{
    [self.player removePlayerNotificationTarget:self];
}

#pragma mark - 获取当前直播是否结束
-(void)judgeWhyLiveStop
{
//    self.times++;
//    if (self.times == 3) {
//        return;
//    }
//    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:self.vid,@"vid", nil];
//    // 初始化Manager
//    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//    
//    // get请求
//    [manager GET:JSTYLELIVE_ISLIVE_URL parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
//        if ([dictionary[@"data"][@"islive"] integerValue] == 1) {
//            NSLog(@"弹出直播占位图");
//            dispatch_async(dispatch_get_main_queue(), ^{
//                [[NSNotificationCenter defaultCenter] postNotificationName:@"ShowVideoPlaceholderImage" object:nil];
//            });
//        } else {
//            [self judgeWhyLiveStop];
//        }
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        
//    }];
    
}



@end
