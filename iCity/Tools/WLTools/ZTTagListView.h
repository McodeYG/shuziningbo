//
//  ViewController.m
//  ZTTagListView
//
//  Created by 赵涛 on 16/5/23.
//  Copyright © 2016年 赵涛. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 *  使用说明
 *1、使用的时候直接创建GBtagListView控件，自定义控件的origin、width、高度随传入数组变量变化自适应
 *2、保留几个属性接口方便使用者自定义控件GBbackgroundColor、signalTagColor
 *3、设置控件属性要放在-(void)setTagWithTagArray:(NSArray*)arr;之后才会有效
 *4、设置过单一标签颜色后，多样色失效单一标签颜色优先级要高于多样色属性
 *5、祝大家使用愉快如果有bug请指正
 */
@interface ZTTagListView : UIView{
    CGRect previousFrame ;
    int totalHeight ;
    NSMutableArray*_tagArr;
    
}
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
@property(nonatomic) BOOL canTouch;
/**
 *  标签文本赋值
 */
-(void)setTagWithTagArray:(NSArray*)arr;


@end
