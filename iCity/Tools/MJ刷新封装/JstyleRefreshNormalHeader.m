//
//  JstyleRefreshNormalHeader.m
//  JstyleNews
//
//  Created by 赵涛 on 2017/10/24.
//  Copyright © 2017年 JstyleNews. All rights reserved.
//

#import "JstyleRefreshNormalHeader.h"

@implementation JstyleRefreshNormalHeader

#pragma mark - 重写父类的方法
- (void)prepare
{
    [super prepare];
    // 初始化间距
    self.labelLeftInset = 5;
}

- (void)placeSubviews
{
    [super placeSubviews];
    // 状态标签
    self.stateLabel.width = kScreenWidth * 2/3;
    if ([self.stateLabel.text isEqualToString:@"已加载全部内容"]) {
        self.stateLabel.centerX = kScreenWidth/2;
    }else{
        self.stateLabel.centerX = kScreenWidth/2 + 15;
    }
}

@end
