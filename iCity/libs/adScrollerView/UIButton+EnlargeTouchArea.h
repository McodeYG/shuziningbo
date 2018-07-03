//
//  UIButton+EnlargeTouchArea.h
//  扩大UIButton点击范围
//
//  Created by xiudou on 16/9/13.
//  Copyright © 2016年 xiudo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (EnlargeTouchArea)
- (void)setEnlargeEdgeWithTop:(CGFloat) top right:(CGFloat) right bottom:(CGFloat) bottom left:(CGFloat) left;
@end
