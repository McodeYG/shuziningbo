//
//  XYPlayer.h
//  MusicPlayer
//
//  Created by leiliang on 15/12/12.
//  Copyright © 2015年 leiliang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import "Album.h"

enum PlayingState: NSInteger {
    PlayingStateBePlaying = 1, // 正在播放
    PlayingStateBeStop    = 0, // 停止播放（清除之前播放所有内容）
    PlayingStateBePause   = -1 // 暂停播放
};

enum PlayingSortType: NSInteger {
    PlayingSortTypeSequence   = 0, // 顺序播放
    PlayingSortTypeLoop       = 1, // 循环播放
    PlayingSortTypeRandom     = 2, // 随机播放
    PlayingSortTypeSingleloop = 3, // 单曲循环
};

typedef void(^CompletionBlock)(NSString *currentTime, NSString *endTime, CGFloat currentPercent);

typedef void(^SwitchBlock)(enum PlayingSortType playingSortType);

typedef void(^GetParamsBlock)(NSString *audioName, NSString *playURL, NSString *CDCover);


@interface XYPlayer : NSObject


+ (XYPlayer *)sharePlayer;

// 音频列表
@property (nonatomic, strong, readonly) NSMutableArray<Album *> *dataArray;
// 播放器
@property (nonatomic, strong, readonly) AVPlayer *player;
// 当前音频位置(从0开始计数，0...n)
@property (nonatomic, assign) NSInteger currentIndex;
// 播放状态 (YES: 正在播放, NO: 已经暂停或停止)
@property (nonatomic, assign, readonly) enum PlayingState playingState;
// currentItem
@property (nonatomic, strong, readonly) AVPlayerItem *currentItem;
/**
 * 播放模式 (顺序，循环，随机，单曲...)
 */
@property (nonatomic, assign) enum PlayingSortType playingSortType;
// 获取当前音量值
@property (nonatomic, assign, readonly) float volume;

// 更新音频列表
- (void)refreshAudioList:(NSArray *)audioList;

// 设置当前播放音频信息
/**
 * audiOName : 歌曲名
 * playURL   : 音频URL
 * CDCover   : CD封面
 */
- (void)setCurrentAudioInfoWithAudioName:(NSString *)audioName
                                 playURL:(NSString *)playURL
                                 CDCover:(NSString *)CDCover;

// 获取当前播放音频信息
- (void)getCurrentAudioInfo:(GetParamsBlock)getParamsBlock;

// 根据百分比更新播放进度
- (void)refreshPlayingRateWithPercent:(CGFloat)percent;

// 刷新播放时间
- (void)refreshPlayTime:(CompletionBlock)completionBlock;
// 调整音量
- (void)turnVolumeSize:(float)volume;
// 根据URL播放音频文件
- (void)playAudioWithURL:(NSString *)URL;
// 播放
- (void)play;
// 暂停播放
- (void)pause;
// 停止播放（清空播放位置）
- (void)closeDown;

// 切换到下一播放模式
- (void)switchToNextPlayingSortType:(SwitchBlock)switchBlock;

// 获取下一首歌曲对象
+ (Album *)getNextAudioFileWithPlayingSortType;
// 根据百分比获取当前进度时间
+ (NSString *)getCurrentTimeWithPercent:(CGFloat)percent;

@end
