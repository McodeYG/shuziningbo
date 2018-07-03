//
//  ThumbUpSpecialEffec.h
//  测试
//
//  Created by JingHongMuYun on 2018/1/15.
//  Copyright © 2018年 JstyleNews. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZXYShineLayer.h"
#import "ZXYShineParams.h"
#import "ZXYShineAngleLayer.h"

@interface ThumbUpSpecialEffec : NSObject

+ (void)addThumbUpSpecialEffecWithBigShineColor:(UIColor *)bigShineColor smallShineColor:(UIColor *)smallShineColor shineFillColor:(UIColor *)shineFillColor button:(UIButton *)button;

@end
