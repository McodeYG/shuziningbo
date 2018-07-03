//
//  XYPlayer.m
//  MusicPlayer
//
//  Created by leiliang on 15/12/12.
//  Copyright © 2015年 leiliang. All rights reserved.
//

#import "XYPlayer.h"

#define MAX_AUDIO_INDEX ([XYPlayer sharePlayer].dataArray.count - 1)

@interface XYPlayer ()

@property (nonatomic, copy) CompletionBlock tempCompletionBlock;

@property (nonatomic, copy) GetParamsBlock tempGetParamsBlock;

// 音频列表
@property (nonatomic, strong, readwrite) NSMutableArray<Album *> *dataArray;
// 播放器
@property (nonatomic, strong, readwrite) AVPlayer *player;
// 当前时间
@property (nonatomic, strong, readwrite) NSString *currentTime;
// 结束时间
@property (nonatomic, strong, readwrite) NSString *endTime;
// 歌曲时间(秒数)
@property (nonatomic, assign, readwrite) CGFloat duration;
// 当前播放百分比
@property (nonatomic, assign, readwrite) CGFloat currentPercent;
// 音频名称
@property (nonatomic, strong, readwrite) NSString *audioName;
// 音频URL
@property (nonatomic, strong, readwrite) NSString *playURL;
// 音频封面图片URL
@property (nonatomic, strong, readwrite) NSString *CDCover;
// 播放状态 (YES: 正在播放, NO: 已经暂停或停止)
@property (nonatomic, assign, readwrite) enum PlayingState playingState;

@property (nonatomic, strong) dispatch_queue_t concurrent_queue;

@property (nonatomic, strong) id timeObserver;

@end

@implementation XYPlayer

+ (XYPlayer *)sharePlayer {
    static XYPlayer *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[XYPlayer alloc] init];
        manager->_player = [[AVPlayer alloc] init];
        manager->_concurrent_queue = dispatch_queue_create("com.concurrent.queue", DISPATCH_QUEUE_CONCURRENT);
        manager->_dataArray = [NSMutableArray array];
    });
    return manager;
}

- (void)addTimeObserver {
    // 每次更换其他音频时，移除上一次的监听，否则可能会导致监听混乱
    if (self.timeObserver) {
        [self.player removeTimeObserver:self.timeObserver];
    }
    // 添加时间监听
    __weak __typeof(self) weakSelf = self;
    self.timeObserver = [self.player addPeriodicTimeObserverForInterval:CMTimeMake(1, 1) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
        CGFloat currentTime = CMTimeGetSeconds(time);
        CGFloat totalTime = CMTimeGetSeconds(weakSelf.currentItem.duration);
        
        weakSelf.duration = totalTime;
        
        weakSelf.currentTime = [NSString stringWithFormat:@"%02d:%02d", (int)currentTime / 60, (int)currentTime % 60];
        weakSelf.endTime = [NSString stringWithFormat:@"%02d:%02d", (int)totalTime / 60, (int)totalTime % 60];
        weakSelf.currentPercent = currentTime / totalTime;
        // 取得播放时间
        if (weakSelf.tempCompletionBlock) {
            weakSelf.tempCompletionBlock(weakSelf.currentTime, weakSelf.endTime, weakSelf.currentPercent);
        }
        
        if ([weakSelf.currentTime isEqualToString:weakSelf.endTime]) {
            // 为了保证这个判断只走一次，需要移除playerItem
            [weakSelf.player replaceCurrentItemWithPlayerItem:nil];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                Album *album = [XYPlayer getNextAudioFileWithPlayingSortType];
                if (album.playUrl32.length > 0) {
                    [weakSelf playAudioWithURL:album.playUrl32];
                    // 自动播放下一首之后需要更新外部UI
                    if (weakSelf.tempGetParamsBlock) {
                        weakSelf.tempGetParamsBlock(album.title, album.playUrl32, album.coverSmall);
                    }
                }
            });
        }
    }];
}


- (void)setCurrentAudioInfoWithAudioName:(NSString *)audioName
                                 playURL:(NSString *)playURL
                                 CDCover:(NSString *)CDCover {
    self.audioName = audioName;
    self.playURL = playURL;
    self.CDCover = CDCover;
}

- (void)getCurrentAudioInfo:(GetParamsBlock)getParamsBlock {
    getParamsBlock(self.audioName, self.playURL, self.CDCover);
    self.tempGetParamsBlock = getParamsBlock;
}

- (void)playAudioWithURL:(NSString *)URL {
    AVAsset *asset = [AVAsset assetWithURL:[NSURL URLWithString:URL]];
    AVPlayerItem *playerItem = [[AVPlayerItem alloc] initWithAsset:asset];
    [self.player replaceCurrentItemWithPlayerItem:playerItem];
    [self.player play];
    [self addTimeObserver];
    // 播放状态 正在播放
    self.playingState = PlayingStateBePlaying;
}

- (void)play {
    [self.player play];
    // 播放状态 正在播放
    self.playingState = PlayingStateBePlaying;
}

- (void)pause {
    [self.player pause];
    // 播放状态 暂停
    self.playingState = PlayingStateBePause;
}

- (void)closeDown {
    [self.player replaceCurrentItemWithPlayerItem:nil];
    // 播放状态 停止
    self.playingState = PlayingStateBeStop;
}

- (void)refreshPlayingRateWithPercent:(CGFloat)percent {
    CGFloat timeByPercent = percent * CMTimeGetSeconds(self.currentItem.duration);
    switch (self.currentItem.status) {
        case AVPlayerItemStatusReadyToPlay:
        {
            // seekToTime: completionHandler: 此方法搜索音频指定时间
            [self.player seekToTime:CMTimeMake((int64_t)timeByPercent, 1) completionHandler:^(BOOL finished) {
                [self play];
            }];
        }
            break;
        default:
            break;
    }
}

- (void)refreshPlayTime:(CompletionBlock)completionBlock {
    self.tempCompletionBlock = completionBlock;
}

- (NSInteger)currentIndex {
    if (_currentIndex < 0) {
        // 当前位置最少是第0首
        return 0;
    }
    return _currentIndex;
}

- (AVPlayerItem *)currentItem {
    return self.player.currentItem;
}

- (void)switchToNextPlayingSortType:(SwitchBlock)switchBlock {
    switch (self.playingSortType) {
        case PlayingSortTypeSequence:
            self.playingSortType = PlayingSortTypeLoop;
            break;
        case PlayingSortTypeLoop:
            self.playingSortType = PlayingSortTypeRandom;
            break;
        case PlayingSortTypeRandom:
            self.playingSortType = PlayingSortTypeSingleloop;
            break;
        case PlayingSortTypeSingleloop:
            self.playingSortType = PlayingSortTypeSequence;
            break;
        default:
            break;
    }
    switchBlock(self.playingSortType);
}

- (void)refreshAudioList:(NSArray *)audioList {
    self.dataArray = [NSMutableArray arrayWithArray:audioList];
}

- (void)turnVolumeSize:(float)volume {
    self.player.volume = volume;
}

- (float)volume {
    return self.player.volume;
}

#pragma mark -
#pragma mark - 可供外部调用
+ (Album *)getNextAudioFileWithPlayingSortType {
    Album *album = [[Album alloc] init];
    switch ([XYPlayer sharePlayer].playingSortType) {
        case PlayingSortTypeSequence:
        {
            if ([XYPlayer sharePlayer].currentIndex != MAX_AUDIO_INDEX) {
                [XYPlayer sharePlayer].currentIndex ++;
                album = [XYPlayer sharePlayer].dataArray[[XYPlayer sharePlayer].currentIndex];
                [[XYPlayer sharePlayer] setCurrentAudioInfoWithAudioName:album.title playURL:album.playUrl32 CDCover:album.coverSmall];
            }
        }
            break;
        case PlayingSortTypeLoop:
        {
            if ([XYPlayer sharePlayer].currentIndex == MAX_AUDIO_INDEX) {
                [XYPlayer sharePlayer].currentIndex = 0;
            } else {
                [XYPlayer sharePlayer].currentIndex ++;
            }
            album = [XYPlayer sharePlayer].dataArray[[XYPlayer sharePlayer].currentIndex];
            [[XYPlayer sharePlayer] setCurrentAudioInfoWithAudioName:album.title playURL:album.playUrl32 CDCover:album.coverSmall];
        }
            break;
        case PlayingSortTypeRandom:
        {
            [XYPlayer sharePlayer].currentIndex = (NSInteger)(arc4random() % (MAX_AUDIO_INDEX - 1));
            album = [XYPlayer sharePlayer].dataArray[[XYPlayer sharePlayer].currentIndex];
            [[XYPlayer sharePlayer] setCurrentAudioInfoWithAudioName:album.title playURL:album.playUrl32 CDCover:album.coverSmall];
        }
            break;
        case PlayingSortTypeSingleloop:
            album = [XYPlayer sharePlayer].dataArray[[XYPlayer sharePlayer].currentIndex];
            break;
        default:
            break;
    }
    return album;
}

+ (NSString *)getCurrentTimeWithPercent:(CGFloat)percent {
    CGFloat percentTime = percent * [XYPlayer sharePlayer].duration;
    NSString *percentTimeStr =  [NSString stringWithFormat:@"%02d:%02d", (int)percentTime / 60, (int)percentTime % 60];
    return percentTimeStr;
}

@end
