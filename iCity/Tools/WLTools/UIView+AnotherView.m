//
//  UIView+AnotherView.m
//  JstyleNews
//
//  Created by JingHongMuYun on 2018/1/10.
//  Copyright © 2018年 JstyleNews. All rights reserved.
//

#import "UIView+AnotherView.h"

@implementation UIView (AnotherView)

/** 判断self和anotherView是否重叠 */
- (BOOL)hu_intersectsWithAnotherView:(UIView *)anotherView
{
    
    //如果anotherView为nil，那么就代表keyWindow
    if (anotherView == nil) anotherView = [UIApplication sharedApplication].keyWindow;
    
    CGRect selfRect = [self convertRect:self.bounds toView:nil];
    
    CGRect anotherRect = [anotherView convertRect:anotherView.bounds toView:nil];
    
    //CGRectIntersectsRect是否有交叉
    return CGRectIntersectsRect(selfRect, anotherRect);
}

@end
