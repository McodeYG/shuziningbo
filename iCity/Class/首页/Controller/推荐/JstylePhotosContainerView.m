//
//  JstylePhotosContainerView.m
//  Exquisite
//
//  Created by JingHongMuYun on 2017/11/28.
//  Copyright © 2017年 JstyleStar. All rights reserved.
//

#import "JstylePhotosContainerView.h"

@implementation JstylePhotosContainerView
{
    NSMutableArray *_imageViewsArray;
    
}

- (instancetype)initWithMaxItemsCount:(NSInteger)count verticalMargin:(CGFloat)verticalMargin horizontalMargin:(CGFloat)horizontalMargin verticalEdgeInset:(CGFloat)verticalEdgeInset horizontalEdgeInset:(CGFloat)horizontalEdgeInset
{
    if (self = [super init]) {
        self.maxItemsCount = count;
        self.verticalMargin = verticalMargin;
        self.horizontalMargin = horizontalMargin;
        self.verticalEdgeInset = verticalEdgeInset;
        self.horizontalEdgeInset = horizontalEdgeInset;
        self.backgroundColor = kNightModeBackColor;

    }
    return self;
}

- (void)setPhotoNamesArray:(NSArray *)photoNamesArray
{
    _photoNamesArray = photoNamesArray;
    
    if (!_imageViewsArray) {
        _imageViewsArray = [NSMutableArray new];
    }
    
    int needsToAddItemsCount = (int)(_photoNamesArray.count - _imageViewsArray.count);
    
    if (needsToAddItemsCount > 0) {
        for (int i = 0; i < needsToAddItemsCount; i++) {
            YYAnimatedImageView *imageView = [YYAnimatedImageView new];
            [self addSubview:imageView];
            [_imageViewsArray addObject:imageView];
        }
    }
    
    NSMutableArray *temp = [NSMutableArray new];
    
    [_imageViewsArray enumerateObjectsUsingBlock:^(YYAnimatedImageView *imageView, NSUInteger index, BOOL *stop) {
        if (index < self.photoNamesArray.count) {
            imageView.contentMode = UIViewContentModeScaleAspectFill;
            imageView.backgroundColor = [kWhiteColor colorWithAlphaComponent:0.3];
            imageView.clipsToBounds = YES;
            imageView.hidden = NO;
            imageView.userInteractionEnabled = NO;
            imageView.sd_layout.autoHeightRatio(10/16.0);
            //设置图片
            [imageView setImageWithURL:[NSURL URLWithString:self.photoNamesArray[index]]  placeholder:SZ_Place_S_N options:(YYWebImageOptionSetImageWithFadeAnimation) completion:nil];
            [temp addObject:imageView];
            
            UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapAction:)];
            [imageView addGestureRecognizer:singleTap];
            UIView *singleTapView = [singleTap view];
            singleTapView.tag = index + 4100;
        } else {
            [imageView sd_clearAutoLayoutSettings];
            imageView.hidden = YES;
        }
    }];
    
    [self setupAutoWidthFlowItems:[temp copy] withPerRowItemsCount:self.maxItemsCount verticalMargin:self.verticalMargin horizontalMargin:self.horizontalMargin verticalEdgeInset:self.verticalEdgeInset horizontalEdgeInset:self.horizontalEdgeInset];
}

- (void)singleTapAction:(id)sender
{
    UITapGestureRecognizer *singleTap = (UITapGestureRecognizer *)sender;
    NSInteger index = singleTap.view.tag - 4100;
    if (self.delegate && [self.delegate respondsToSelector:@selector(jstylePhotosContainerView:didSelectedIndex:)]) {
        [self.delegate jstylePhotosContainerView:self didSelectedIndex:index];
    }
}

@end
