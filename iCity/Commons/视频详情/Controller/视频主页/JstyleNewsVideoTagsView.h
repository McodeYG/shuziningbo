//
//  JstyleNewsVideoTagsView.h
//  JstyleNews
//
//  Created by JingHongMuYun on 2017/12/14.
//  Copyright © 2017年 JstyleNews. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JstyleNewsVideoTagsView : UIView{
    CGRect previousFrame ;
    int totalHeight ;
    NSMutableArray *_tagArr;
}

/**
 * 整个view的背景色
 */
@property(nonatomic, retain) UIColor *GBbackgroundColor;

/**
 * 圆角
 */
@property (nonatomic, assign) CGFloat cornerRadius;

/**
 * 按钮颜色
 */
@property (nonatomic, copy) UIColor *tagBackgroundColor;

/**
 * 按钮字体大小
 */
@property (nonatomic, assign) CGFloat tagFont;

@property (nonatomic, assign) CGFloat horizontalPadding;
@property (nonatomic, assign) CGFloat verticalPadding;

/**
 *  设置单一颜色
 */
@property(nonatomic) UIColor *signalTagColor;
/**
 *  回调统计选中tag
 */
@property(nonatomic, copy) void (^didselectItemBlock)(NSInteger indexPath);
@property(nonatomic, assign) BOOL canTouch;
/**
 *  标签文本赋值
 */
- (void)setTagWithTagArray:(NSArray *)array;

@end
