//
//  SegmentTapView.h
//  haha
//
//  Created by 赵涛 on 16/3/23.
//  Copyright © 2016年 Dark Knight. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SegmentTapViewDelegate <NSObject>
@optional
/**
 选择index回调
 
 @param index
 */
-(void)selectedIndex:(NSInteger)index;
@end

@interface SegmentTapView : UIView

/**
 选择回调
 */
@property (nonatomic, assign)id<SegmentTapViewDelegate> delegate;
/**
 数据源
 */
@property (nonatomic, strong)NSArray *dataArray;
/**
 字体非选中时颜色
 */
@property (nonatomic, strong)UIColor *textNomalColor;
/**
 字体选中时颜色
 */
@property (nonatomic, strong)UIColor *textSelectedColor;
/**
 横线颜色
 */
@property (nonatomic, strong)UIColor *lineColor;
/**
 字体大小
 */
@property (nonatomic, assign)CGFloat titleFont;
/**
 Initialization
 
 @param frame     fram
 @param dataArray 标题数组
 @param font      标题字体大小
 
 @return instance
 */
-(instancetype)initWithFrame:(CGRect)frame withDataArray:(NSArray *)dataArray withFont:(CGFloat)font;
/**
 手动选择
 @param index inde（从1开始）
 */
-(void)selectIndex:(NSInteger)index;

@end
