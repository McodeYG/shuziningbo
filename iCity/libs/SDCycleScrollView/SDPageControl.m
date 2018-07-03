//
//  SDPageControl.m
//  Exquisite
//
//  Created by 赵涛 on 2017/6/29.
//  Copyright © 2017年 Jstyle. All rights reserved.
//

#import "SDPageControl.h"

#define dotW 6
#define magrin 5

@interface SDPageControl()

@end

@implementation SDPageControl

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    return self;
}

- (void)updateDots
{
    for (int i = 0; i < [self.subviews count]; i++) {
        UIImageView *dot = [self.subviews objectAtIndex:i];
        CGSize size;
        size.height = 6;
        size.width = 6;
        dot.layer.cornerRadius = size.width/2.0;
        dot.layer.masksToBounds = YES;
        [dot setFrame:CGRectMake(dot.frame.origin.x, dot.frame.origin.y, size.width, size.width)];
    }
}

- (void)setCurrentPage:(NSInteger)page
{
    [super setCurrentPage:page];
    [self updateDots];
}

//- (void)layoutSubviews
//{
//    [super layoutSubviews];
//
//    //计算圆点间距
//    CGFloat marginX = dotW + magrin;
//
//    //计算整个pageControll的宽度
//    CGFloat newW = (self.subviews.count - 1 ) * marginX;
//
//    //设置新frame
//    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, newW, self.frame.size.height);
//
//    //遍历subview,设置圆点frame
//    for (int i=0; i<[self.subviews count]; i++) {
//        UIImageView* dot = [self.subviews objectAtIndex:i];
//
//        if (i == self.currentPage) {
//            [dot setFrame:CGRectMake(i * marginX, dot.frame.origin.y, dotW, dotW)];
//        }else {
//            [dot setFrame:CGRectMake(i * marginX, dot.frame.origin.y, dotW, dotW)];
//        }
//    }
//}


@end
