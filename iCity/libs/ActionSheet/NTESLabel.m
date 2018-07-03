//
//  NTESLabel.m
//  Exquisite
//
//  Created by 赵涛 on 2017/11/6.
//  Copyright © 2017年 Jstyle. All rights reserved.
//

#import "NTESLabel.h"

@implementation NTESLabel

- (void)drawTextInRect:(CGRect)rect{
    [super drawTextInRect:UIEdgeInsetsInsetRect(rect, self.edgeInset)];
}

@end
