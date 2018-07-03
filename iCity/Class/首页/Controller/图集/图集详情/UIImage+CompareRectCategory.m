//
//  UIImage+GQImageViewrCategory.m
//  ImageViewer
//
//  Created by 高旗 on 17/1/19.
//  Copyright © 2017年 tusm. All rights reserved.
//

#import "UIImage+CompareRectCategory.h"

@implementation UIImage (CompareRectCategory)

- (CGRect)imageSizeCompareWithSize:(CGSize)size {
    CGSize originSize = size;
    CGSize imageSize = self.size;
    
    CGFloat HScale = imageSize.height / originSize.height;
    CGFloat WScale = imageSize.width / originSize.width;
    CGFloat scale = (HScale > WScale) ? HScale : WScale;
    
    CGFloat height = imageSize.height / scale;
    CGFloat width = imageSize.width / scale;
    
    CGRect confirmRect = CGRectMake((size.width - width) / 2, (size.height - height) / 2, width, height);
    return confirmRect;
}

@end
