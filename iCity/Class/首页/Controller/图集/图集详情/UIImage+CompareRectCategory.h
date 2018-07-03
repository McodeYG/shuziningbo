//
//  UIImage+GQImageViewrCategory.h
//  ImageViewer
//
//  Created by 高旗 on 17/1/19.
//  Copyright © 2017年 tusm. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (CompareRectCategory)

/**
 等比例自适应imageView大小

 @param size 父视图size
 @return 适配后的size
 */
- (CGRect)imageSizeCompareWithSize:(CGSize)size;

@end
