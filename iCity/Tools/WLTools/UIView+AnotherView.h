//
//  UIView+AnotherView.h
//  JstyleNews
//
//  Created by JingHongMuYun on 2018/1/10.
//  Copyright © 2018年 JstyleNews. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (AnotherView)

/** 判断self和anotherView是否重叠 */
- (BOOL)hu_intersectsWithAnotherView:(UIView *)anotherView;

@end
