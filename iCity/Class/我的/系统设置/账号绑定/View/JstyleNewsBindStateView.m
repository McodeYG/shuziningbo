//
//  JstyleNewsBindStateView.m
//  JstyleNews
//
//  Created by JingHongMuYun on 2018/4/12.
//  Copyright © 2018年 JstyleNews. All rights reserved.
//

#import "JstyleNewsBindStateView.h"

@implementation JstyleNewsBindStateView

+ (void)showAlertWithTitle:(NSString *)title withImageName:(NSString *)imageName
{
    if ([title isKindOfClass:[NSNull class]]) return;
    UIWindow * window = [UIApplication sharedApplication].keyWindow;
    window.backgroundColor = [UIColor whiteColor];
    
    UIView *holdView = [[UIView alloc] init];
    holdView.backgroundColor = [kDarkZeroColor colorWithAlphaComponent:0.54];
    holdView.frame = window.frame;
    
    UIView *alertView = [[UIView alloc] init];
    alertView.backgroundColor = kWhiteColor;
    alertView.layer.cornerRadius = 8;
    alertView.center = CGPointMake(kScreenWidth/2, kScreenHeight/2 - 33);
    alertView.bounds = CGRectMake(0, 0, 260, 152);
    [holdView addSubview:alertView];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = title;
    titleLabel.font = JSFont(16);
    titleLabel.textColor = kDarkThreeColor;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [alertView addSubview:titleLabel];
    titleLabel.sd_layout
    .leftSpaceToView(alertView, 15)
    .rightSpaceToView(alertView, 15)
    .heightIs(22)
    .bottomSpaceToView(alertView, 20);
    
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.image = JSImage(imageName);
    [alertView addSubview:imageView];
    imageView.sd_layout
    .bottomSpaceToView(titleLabel, 20)
    .widthIs(60)
    .heightIs(60)
    .centerXEqualToView(alertView);
    
    [window addSubview:holdView];
    
    alertView.layer.position = CGPointMake(kScreenWidth/2, kScreenHeight/2 - 33);
    alertView.transform = CGAffineTransformMakeScale(0.85, 0.85);
    [UIView animateWithDuration:0.25 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:1 options:UIViewAnimationOptionCurveLinear animations:^{
        alertView.transform = CGAffineTransformMakeScale(1.0, 1.0);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:1.5f animations:^{
            holdView.alpha = 0.99;
        } completion:^(BOOL finished) {
            [holdView removeFromSuperview];
        }];
    }];
}

@end
