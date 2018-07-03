//
//  JstyleMyMemuViewCell.m
//  Exquisite
//
//  Created by 赵涛 on 2016/11/24.
//  Copyright © 2016年 LanBao. All rights reserved.
//

#import "JstyleMyMenuViewCell.h"

@implementation JstyleMyMenuViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    UIView *rightLine = [[UIView alloc]initWithFrame:CGRectMake(kScreenWidth/4 - 0.5, 0, 0.5, kScreenWidth/4)];
    rightLine.backgroundColor = kSingleLineColor;
    [self addSubview:rightLine];
    
    _bottomLine = [[UIView alloc]initWithFrame:CGRectMake(0, kScreenWidth/4 - 0.5, kScreenWidth/4, 0.5)];
    _bottomLine.backgroundColor = kSingleLineColor;
    [self addSubview:_bottomLine];
}

@end
