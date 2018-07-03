//
//  WLNewDataCountTipLabel.m
//  JstyleNews
//
//  Created by 王磊 on 2018/2/6.
//  Copyright © 2018年 JstyleNews. All rights reserved.
//

#import "WLNewDataCountTipLabel.h"

@interface WLNewDataCountTipLabel()

@end

@implementation WLNewDataCountTipLabel

+ (instancetype)newDataCountTipLabelWithSuperView:(UIView *)superView {
    WLNewDataCountTipLabel *tipLabel = [[self alloc] init];
    tipLabel.backgroundColor = JSColor(@"D6E9F7");
    tipLabel.textColor = JSColor(@"#2796E3");
    tipLabel.font = [UIFont fontWithName:@"PingFang SC" size:14];
    tipLabel.textAlignment = NSTextAlignmentCenter;
    tipLabel.alpha = 0;
    tipLabel.frame = CGRectMake(0, 0, kScreenWidth, 31);
    [superView addSubview:tipLabel];
    [superView bringSubviewToFront:tipLabel];
    return tipLabel;
}

- (void)showWithNoMoreData {
    
    self.text = @"暂时没有新内容啦";
    self.frame = CGRectMake(0, 0, self.width, self.height);
    [UIView animateWithDuration:0.25 animations:^{
        self.alpha = 1;
    } completion:^(BOOL finished) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:0.5 animations:^{
                self.alpha = 0;
                self.frame = CGRectMake(0, -self.height, self.width, self.height);
            }];
        });
    }];
}

- (void)showWithCount:(NSInteger)count {
    
    self.text = [NSString stringWithFormat:@"成功为您推荐%zd条新内容",count];
    self.frame = CGRectMake(0, 0, self.width, self.height);
    [UIView animateWithDuration:0.25 animations:^{
        self.alpha = 1;
    } completion:^(BOOL finished) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:0.5 animations:^{
                self.alpha = 0;
                self.frame = CGRectMake(0, -self.height, self.width, self.height);
            }];
        });
    }];
}

@end
