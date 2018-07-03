//
//  UIActivityIndicatorView+XYActivity.m
//  MusicPlayer
//
//  Created by mac on 15/12/14.
//  Copyright © 2015年 leiliang. All rights reserved.
//

#import "UIActivityIndicatorView+XYActivity.h"
#import "AppDelegate.h"

@implementation UIActivityIndicatorView (XYActivity)

+ (UIActivityIndicatorView *)shareActivity {
    static UIActivityIndicatorView *activity = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        activity.frame = CGRectMake(0, 0, 100, 100);
        activity.backgroundColor = [UIColor colorWithWhite:0.3 alpha:0.3];
        activity.center = [AppDelegate keyWindow].center;
        activity.clipsToBounds = YES;
        activity.layer.cornerRadius = 10;
        [[AppDelegate keyWindow] addSubview:activity];
    });
    return activity;
}

+ (void)startAnimation {
    [[UIActivityIndicatorView shareActivity] startAnimating];
}

+ (void)stopAnimation {
    [[UIActivityIndicatorView shareActivity] stopAnimating];
}


@end
