//
//  VRPlayerView.h
//  VRVr
//
//  Created by 数字宁波 on 2017/5/2.
//  Copyright © 2017年 赵涛. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import <SGPlayer/SGPlayer.h>
#import "SGPlayer.h"
#import "VRPlayerSlider.h"
#import "VRPlayerPlayButton.h"

@class VRPlayerView;

@import MediaPlayer;
@import AVFoundation;
@import UIKit;

typedef NS_ENUM(NSUInteger, VRPlayerType) {
    VrType_AVPlayer_Normal = 0,//
    VrType_AVPlayer_VR,//VR视频
    VrType_AVPlayer_VR_Box,
    VrType_FFmpeg_Normal,//普通直播
    VrType_FFmpeg_Normal_Hardware,
    VrType_FFmpeg_VR,//VR直播
    VrType_FFmpeg_VR_Hardware,
    VrType_FFmpeg_VR_Box,//VR盒子直播
    VrType_FFmpeg_VR_Box_Hardware,
};

@protocol VRPlayerViewDelegate <NSObject>
@optional;

- (void)vrPlayerView:(VRPlayerView *)vrPlayerView backBtnClicked:(BOOL)backBtnSelected;

- (void)vrPlayerView:(VRPlayerView *)vrPlayerView moreBtn:(UIButton *)moreBtn;

- (void)vrPlayerView:(VRPlayerView *)vrPlayerView clickedFullScreen:(UIButton *)fullScreen;

- (void)vrPlayerView:(VRPlayerView *)vrPlayerView tapGestureRecognizer:(UITapGestureRecognizer *)gestureRecognizer;

- (void)vrPlayerView:(VRPlayerView *)vrPlayerView statusBarHidden:(BOOL)statusBarHidden;

@end

@interface VRPlayerView : UIView

@property (nonatomic, strong) SGPlayer * player;
@property (strong, nonatomic) UIView *bottomView;
@property (strong, nonatomic) UIActivityIndicatorView *indicatorView;
@property (nonatomic, strong) UIButton *backBtn;
@property (nonatomic, strong) UILabel *liveTitleLabel;
@property (nonatomic, strong) UIButton *moreBtn;
@property (nonatomic, strong) VRPlayerPlayButton *playPauseBtn;
@property (nonatomic, strong) UIButton *fullScreenBtn;
@property (strong, nonatomic) VRPlayerSlider *progressSlider;
//时间
@property (nonatomic,strong) UILabel *leftTimeLabel;
@property (nonatomic,strong) UILabel *rightTimeLabel;
@property (nonatomic,strong) UILabel *lineLabel;
@property (nonatomic, assign) BOOL progressSilderTouching;
@property (nonatomic, assign) BOOL singleClicked;
@property (nonatomic, assign) BOOL isBoxType;
@property (nonatomic, assign) BOOL isPauseStatus;
@property (nonatomic, strong) UIButton *boxButton;//切换BOX模式
@property (nonatomic, strong) NSTimer *splashTimer;
@property (nonatomic, copy) NSString *title;
/**网络状态返回按钮*/
@property (nonatomic, strong) UIButton *netBackBtn;
//声音滑块
@property (nonatomic,strong) VRPlayerSlider *volumeSlider;
@property (nonatomic, weak) id<VRPlayerViewDelegate> delegate;

@property (nonatomic, copy) NSString *vid;
- (instancetype)initWithFrame:(CGRect)frame withVrUrl:(NSURL *)vrUrl withVrType:(VRPlayerType)vrType;

- (void)play;

- (void)pause;

- (void)releseTimer;

@end
