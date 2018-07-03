//
//  JstyleshowShareRedView.m
//  Exquisite
//
//  Created by 数字跃动 on 2017/3/10.
//  Copyright © 2017年 Jstyle. All rights reserved.
//

#import "JstyleshowShareRedView.h"

@implementation JstyleshowShareRedView

-(void)showShareRedView:(NSString *)backViewImgNameStr  btnImgNameStr:(NSString *)btnImgNameStr
{
    UIWindow * window = [UIApplication sharedApplication].keyWindow;
    window.backgroundColor = [UIColor whiteColor];
    
    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    backView.backgroundColor = kDarkOneColor;
    backView.alpha = 0.6;
    
    CGFloat backWidth = 230/375.0*kScreenWidth;
    CGFloat backHeight = 223.5/667.0*kScreenHeight;
    CGFloat x = (kScreenWidth - backWidth)/2;
    CGFloat y = (kScreenHeight - backHeight)/2 - 10;
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(x, y, backWidth, backHeight)];
    imageView.image = [UIImage imageNamed:backViewImgNameStr];
    
    
    UIButton *bottomBtn = [[UIButton alloc]initWithFrame:CGRectMake((backWidth - 90)/2, backHeight - 67, 90, 32)];
    [bottomBtn setImage:[UIImage imageNamed:btnImgNameStr] forState:UIControlStateNormal];
    
    
    UIButton *xxxbtn = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(imageView.frame) - 16, CGRectGetMaxY(imageView.frame) - 31, 16, 16)];
    [xxxbtn setImage:[UIImage imageNamed:@"优惠券关闭"] forState:UIControlStateNormal];
    [xxxbtn addTarget:self action:@selector(guanbi) forControlEvents:UIControlEventTouchUpInside];
    
    [window addSubview:backView];
    [backView addSubview:imageView];
    [imageView addSubview:bottomBtn];
    
}
- (void)guanbi
{
    
}
@end
