//
//  JstyleWave.h
//  Exquisite
//
//  Created by 赵涛 on 16/5/11.
//  Copyright © 2016年 LanBao. All rights reserved.
//


#import <UIKit/UIKit.h>

typedef void(^JstyleWaveBlock)(CGFloat currentY);

@interface JstyleWave : UIView
/**
 *  浪弯曲度
 */
@property (nonatomic, assign) CGFloat waveCurvature;
/**
 *  浪速
 */
@property (nonatomic, assign) CGFloat waveSpeed;
/**
 *  浪高
 */
@property (nonatomic, assign) CGFloat waveHeight;
/**
 *  实浪颜色
 */
@property (nonatomic, strong) UIColor *realWaveColor;
/**
 *  遮罩浪颜色
 */
@property (nonatomic, strong) UIColor *maskWaveColor;

@property (nonatomic, copy) JstyleWaveBlock waveBlock;

- (void)stopWaveAnimation;

- (void)startWaveAnimation;

@end
