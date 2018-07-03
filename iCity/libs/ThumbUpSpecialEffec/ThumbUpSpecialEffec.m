//
//  ThumbUpSpecialEffec.m
//  测试
//
//  Created by JingHongMuYun on 2018/1/15.
//  Copyright © 2018年 JstyleNews. All rights reserved.
//

#import "ThumbUpSpecialEffec.h"

@implementation ThumbUpSpecialEffec

+ (void)addThumbUpSpecialEffecWithBigShineColor:(UIColor *)bigShineColor smallShineColor:(UIColor *)smallShineColor shineFillColor:(UIColor *)shineFillColor button:(UIButton *)button
{
    //params
    ZXYShineParams *shineParams = [[ZXYShineParams alloc]init];
    shineParams.shineCount = 0;
    shineParams.animDuration = 1.5;
    
    //shine动画
    ZXYShineLayer *shineLayer = [[ZXYShineLayer alloc] init];
    shineLayer.frame = button.bounds;
    shineLayer.params = shineParams;
    shineLayer.fillColor = shineFillColor;
    
    ZXYShineParams *params = [[ZXYShineParams alloc]init];
    params.allowRandomColor = NO;
    params.bigShineColor = bigShineColor;
    params.smallShineColor = smallShineColor;
    params.shineCount = 10;
    params.animDuration = 1.5;
    params.smallShineOffsetAngle = 0;
    params.shineTurnAngle = 0;
    //angle动画
    ZXYShineAngleLayer *angleLayer = [[ZXYShineAngleLayer alloc] initFrame:button.bounds params:params];
    shineLayer.endAnim = ^{
        //scale动画
        CAKeyframeAnimation  *anim = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
        anim.duration  = 0.25;
        anim.repeatCount = 1;
        anim.values = @[@0.4, @0.6, @0.8, @1.0, @1.1, @1.0];
        anim.calculationMode = kCAAnimationCubic;
        [button.imageView.layer addAnimation:anim forKey:@"scale"];
    };
    
    [button.layer addSublayer:shineLayer];
    [button.layer addSublayer:angleLayer];
    
    [shineLayer startAnim];
    [angleLayer startAnim];
}

@end
