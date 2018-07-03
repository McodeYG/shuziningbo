//
//  VRPlayerPlayButton.h
//  JstyleNews
//
//  Created by JstyleNews on 2018/1/11.
//  Copyright © 2017年 JstyleNews. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,VRPlayerPlayButtonState) {
    VRPlayerPlayButtonStatePause = 0,
    VRPlayerPlayButtonStatePlay
};

@interface VRPlayerPlayButton : UIButton

/**
 通过setter方式控制按钮动画
 设置XLPlayButtonStatePlay显示播放按钮
 设置XLPlayButtonStatePause显示暂停按钮
 */
@property (nonatomic, assign) VRPlayerPlayButtonState buttonState;

/**
 创建方法
 */
- (instancetype)initWithFrame:(CGRect)frame state:(VRPlayerPlayButtonState)state;

@end
