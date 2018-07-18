//
//  MoreListView.h
//  iCity
//
//  Created by mayonggang on 2018/7/13.
//  Copyright © 2018年 LongYuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ICityLifeBannerModel.h"


@interface MoreListView : UIView{

    NSMutableArray*_tagArr;
    
}

//总高度
@property (nonatomic, assign) int totalHeight;

@property(nonatomic) CGRect   previousFrame;
/**
 * 整个view的背景色
 */
@property(nonatomic,retain) UIColor *GBbackgroundColor;

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
@property (nonatomic, strong) UIColor *titleColor;

@property (nonatomic, assign) CGFloat horizontalPadding;
@property (nonatomic, assign) CGFloat verticalPadding;


/**
 *  设置单一颜色
 */
@property(nonatomic) UIColor *signalTagColor;
/**
 *  回调统计选中tag
 */
@property(nonatomic,copy) void (^didselectItemBlock)(NSInteger indexPath);

/**
 *  标签文本赋值
 */
-(void)setTagWithTagArray:(NSArray*)arr andSelectIndex:(NSUInteger)index;



@end
