//
//  JstylePhotosContainerView.h
//  Exquisite
//
//  Created by JingHongMuYun on 2017/11/28.
//  Copyright © 2017年 JstyleStar. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JstylePhotosContainerView;
@protocol JstylePhotosContainerViewDelegate <NSObject>

@optional;

- (void)jstylePhotosContainerView:(JstylePhotosContainerView *)photosContainerView didSelectedIndex:(NSInteger)index;

@end

@interface JstylePhotosContainerView : UIView

- (instancetype)initWithMaxItemsCount:(NSInteger)count verticalMargin:(CGFloat)verticalMargin horizontalMargin:(CGFloat)horizontalMargin verticalEdgeInset:(CGFloat)verticalEdgeInset horizontalEdgeInset:(CGFloat)horizontalEdgeInset;

@property (nonatomic, strong) NSArray *photoNamesArray;

@property (nonatomic, assign) NSInteger maxItemsCount;

@property (nonatomic, assign) CGFloat verticalMargin;
@property (nonatomic, assign) CGFloat horizontalMargin;
@property (nonatomic, assign) CGFloat verticalEdgeInset;
@property (nonatomic, assign) CGFloat horizontalEdgeInset;

@property (nonatomic, assign) id <JstylePhotosContainerViewDelegate> delegate;

@end
