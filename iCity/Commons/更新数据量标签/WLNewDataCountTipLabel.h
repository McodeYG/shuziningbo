//
//  WLNewDataCountTipLabel.h
//  JstyleNews
//
//  Created by 王磊 on 2018/2/6.
//  Copyright © 2018年 JstyleNews. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WLNewDataCountTipLabel : UILabel

/**
 显示更新count条数据

 @param count 新数据数量
 */
- (void)showWithCount:(NSInteger)count;

/**
 显示没有新数据
 */
- (void)showWithNoMoreData;

+ (instancetype)newDataCountTipLabelWithSuperView:(UIView *)superView;

@end
