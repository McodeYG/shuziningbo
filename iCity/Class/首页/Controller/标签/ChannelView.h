//
//  ChannelView.h
//  标签栏
//
//  Created by admin on 2017/9/29.
//  Copyright © 2017年 xushuoa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChannelView : JstyleNewsBaseView

/**
 *上按钮数组
 **/
@property (nonatomic, strong) NSArray *upBtnDataArr;

/**
 *下按钮数组
 **/
@property (nonatomic, strong) NSArray *belowBtnDataArr;

/**
 *第一个按钮是否参与编辑 （默认为NO）
 **/
@property (nonatomic, assign) BOOL IS_compileFirstBtn;

/**
 *每行按钮个数 （默认为4）
 **/
@property (nonatomic, assign) int btnNumber;

/**
 *按钮字体大小
 **/
@property (nonatomic, assign) CGFloat btnTextFont;

/**
 *返回调整好的标签数组
 **/
@property (nonatomic, copy) void(^dataBlock)(NSMutableArray <NSString *>*dataArr);

/**编辑、完成按钮*/
@property (nonatomic, weak) UIButton *compileBtn;

/**
 *点击对应的上边按钮（未编辑状态的index）
 **/
@property (nonatomic, copy) void(^clickIndexBlock)(NSString *channelName);

@end
