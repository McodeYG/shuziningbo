//
//  ShowMessage.m
//  Exquisite
//
//  Created by 赵涛 on 16/4/28.
//  Copyright © 2016年 LanBao. All rights reserved.
//

#import "ZTShowMessage.h"

@implementation ZTShowMessage : UIView

+ (void)showMessage:(NSString *)message
{
    if ([message isKindOfClass:[NSNull class]]) return;
    UIWindow * window = [UIApplication sharedApplication].keyWindow;
    window.backgroundColor = [UIColor whiteColor];
    UIView *showView =  [[UIView alloc]init];
    showView.backgroundColor = [UIColor blackColor];
    showView.frame = CGRectMake(1, 1, 1, 1);
    showView.alpha = 1.0f;
    showView.layer.cornerRadius = 2.0f;
    showView.layer.masksToBounds = YES;
    showView.center = CGPointMake(kScreenWidth/2, kScreenHeight/2);
    
    CGRect rect = [message boundingRectWithSize:CGSizeMake(kScreenWidth, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14*kScreenWidth/375.0]} context:nil];
    
    UILabel *showLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, rect.size.width + 20, 28*kScreenWidth/375.0)];
    showLabel.text = message;
    showLabel.textAlignment = NSTextAlignmentCenter;
    showLabel.font = [UIFont systemFontOfSize:14*kScreenWidth/375.0];
    showLabel.textColor = [UIColor whiteColor];
    
    [showView addSubview:showLabel];
    showView.bounds = CGRectMake(0, 0, showLabel.width, 28*kScreenWidth/375.0);
    [window addSubview:showView];
    [UIView animateWithDuration:1.0f animations:^{
        showView.alpha = 0.99;
    } completion:^(BOOL finished) {
        [showView removeFromSuperview];
    }];
}

+ (void)showMessage:(NSString *)message withAlignment:(AlertMessageAlignment)alignment
{
    if ([message isKindOfClass:[NSNull class]]) return;
    UIWindow * window = [UIApplication sharedApplication].keyWindow;
    window.backgroundColor = [UIColor whiteColor];
    UIView *showView =  [[UIView alloc]init];
    showView.backgroundColor = [UIColor blackColor];
    showView.frame = CGRectMake(1, 1, 1, 1);
    showView.alpha = 1.0f;
    showView.layer.cornerRadius = 2.0f;
    showView.layer.masksToBounds = YES;
    switch (alignment) {
        case AlertMessageAlignmentTop:
            showView.center = CGPointMake(kScreenWidth/2, kScreenHeight/3);
            break;
        case AlertMessageAlignmentCenter:
            showView.center = CGPointMake(kScreenWidth/2, kScreenHeight/2);
            break;
        case AlertMessageAlignmentBottom:
            showView.center = CGPointMake(kScreenWidth/2, kScreenHeight*2/3);
            break;
        default:
            showView.center = CGPointMake(kScreenWidth/2, kScreenHeight/2);
            break;
    }
    
    CGRect rect = [message boundingRectWithSize:CGSizeMake(kScreenWidth, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14*kScreenWidth/375.0]} context:nil];
    
    UILabel *showLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, rect.size.width + 20, 28*kScreenWidth/375.0)];
    showLabel.text = message;
    showLabel.textAlignment = NSTextAlignmentCenter;
    showLabel.font = [UIFont systemFontOfSize:14*kScreenWidth/375.0];
    showLabel.textColor = [UIColor whiteColor];
    
    [showView addSubview:showLabel];
    showView.bounds = CGRectMake(0, 0, showLabel.width, 28*kScreenWidth/375.0);
    [window addSubview:showView];
    [UIView animateWithDuration:1.0f animations:^{
        showView.alpha = 0.99;
    } completion:^(BOOL finished) {
        [showView removeFromSuperview];
    }];
}

+ (void)showMessage:(NSString *)message withDuration:(NSTimeInterval)duration
{
    if ([message isKindOfClass:[NSNull class]]) return;
    UIWindow * window = [UIApplication sharedApplication].keyWindow;
    window.backgroundColor = [UIColor whiteColor];
    UIView *showView =  [[UIView alloc]init];
    showView.backgroundColor = [UIColor blackColor];
    showView.frame = CGRectMake(1, 1, 1, 1);
    showView.alpha = 1.0f;
    showView.layer.cornerRadius = 2.0f;
    showView.layer.masksToBounds = YES;
    showView.center = CGPointMake(kScreenWidth/2, kScreenHeight/2);
    
    CGRect rect = [message boundingRectWithSize:CGSizeMake(kScreenWidth, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14*kScreenWidth/375.0]} context:nil];
    
    UILabel *showLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, rect.size.width + 20, 28*kScreenWidth/375.0)];
    showLabel.text = message;
    showLabel.textAlignment = NSTextAlignmentCenter;
    showLabel.font = [UIFont systemFontOfSize:14*kScreenWidth/375.0];
    showLabel.textColor = [UIColor whiteColor];
    
    [showView addSubview:showLabel];
    showView.bounds = CGRectMake(0, 0, showLabel.width, 28*kScreenWidth/375.0);
    [window addSubview:showView];
    [UIView animateWithDuration:duration animations:^{
        showView.alpha = 0.99;
    } completion:^(BOOL finished) {
        [showView removeFromSuperview];
    }];
}

+ (void)showMessage:(NSString *)message withDuration:(NSTimeInterval)duration showInView:(UIView *)view
{
    if ([message isKindOfClass:[NSNull class]]) return;
    CGFloat width = view.width;
    CGFloat height = view.height;
    UIView *showView =  [[UIView alloc]init];
    showView.backgroundColor = [UIColor blackColor];
    showView.frame = CGRectMake(1, 1, 1, 1);
    showView.alpha = 1.0f;
    showView.layer.cornerRadius = 2.0f;
    showView.layer.masksToBounds = YES;
    showView.center = CGPointMake(width/2, height/2);
    
    CGRect rect = [message boundingRectWithSize:CGSizeMake(width, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14*width/375.0]} context:nil];
    
    UILabel *showLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, rect.size.width + 20, 28*width/375.0)];
    showLabel.text = message;
    showLabel.textAlignment = NSTextAlignmentCenter;
    showLabel.font = [UIFont systemFontOfSize:14*width/375.0];
    showLabel.textColor = [UIColor whiteColor];
    
    [showView addSubview:showLabel];
    showView.bounds = CGRectMake(0, 0, showLabel.width, 28*width/375.0);
    [view addSubview:showView];
    [UIView animateWithDuration:duration animations:^{
        showView.alpha = 0.99;
    } completion:^(BOOL finished) {
        [showView removeFromSuperview];
    }];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
