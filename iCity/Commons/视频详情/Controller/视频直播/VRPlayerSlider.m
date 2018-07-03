//
//  VRPlayerSlider.m
//  JstyleNews
//
//  Created by JingHongMuYun on 2017/12/14.
//  Copyright © 2017年 JstyleNews. All rights reserved.
//

#import "VRPlayerSlider.h"

@implementation VRPlayerSlider

- (CGRect)trackRectForBounds:(CGRect)bounds {
    bounds = [super trackRectForBounds:bounds];
    return CGRectMake(bounds.origin.x, bounds.origin.y, bounds.size.width, 3);
}

//- (CGRect)thumbRectForBounds:(CGRect)bounds trackRect:(CGRect)rect value:(float)value
//{
//    bounds = [super thumbRectForBounds:bounds trackRect:rect value:value];
//    return CGRectMake(bounds.origin.x, bounds.origin.y, 10, 10);
//}

@end
