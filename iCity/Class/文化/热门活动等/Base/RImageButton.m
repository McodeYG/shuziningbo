//
//  RImageButton.m
//  Gxj
//
//  Created by 马永刚 on 2017/11/24.
//  Copyright © 2017年 马永刚. All rights reserved.
//

#import "RImageButton.h"

@implementation RImageButton

- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    CGFloat imageX = _imageRect.origin.x;
    CGFloat imageY = _imageRect.origin.y;
    CGFloat imageW = CGRectGetWidth(_imageRect);
    CGFloat imageH = CGRectGetHeight(_imageRect);
    return CGRectMake(imageX, imageY, imageW, imageH);
}

//自定义按钮的文字在左边
- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    CGFloat titleX = _titleRect.origin.x;
    CGFloat titleY = _titleRect.origin.y;
    
    CGFloat titleW = CGRectGetWidth(_titleRect);
    
    CGFloat titleH = CGRectGetHeight(_titleRect);
    return CGRectMake(titleX, titleY, titleW, titleH);
}

-(void)setHighlighted:(BOOL)highlighted {
    
}



@end
