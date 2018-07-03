//
//  ZTPageControl.m
//  Exquisite
//
//  Created by 赵涛 on 16/5/11.
//  Copyright © 2016年 LanBao. All rights reserved.
//

#import "ZTPageControl.h"

@implementation ZTPageControl

- (void)setCurrentPage:(NSInteger)currentPage
{
    [super setCurrentPage:currentPage];
    for (NSUInteger subviewIndex = 0; subviewIndex < [self.subviews count]; subviewIndex++) {
        UIImageView* subview = [self.subviews objectAtIndex:subviewIndex];
        CGSize size;
        size.height = 6.6;
        size.width = 11;
        if (subviewIndex == currentPage){
            subview.layer.cornerRadius = 3.3;
            subview.layer.masksToBounds = YES;
            [subview setFrame:CGRectMake(subview.frame.origin.x, subview.frame.origin.y,
                                         size.width,size.height)];
        }else{
            [subview setFrame:CGRectMake(subview.frame.origin.x, subview.frame.origin.y,
                                         size.height,size.height)];
        }
    }
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
