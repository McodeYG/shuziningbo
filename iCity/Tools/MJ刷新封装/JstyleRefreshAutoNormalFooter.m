//
//  JstyleRefreshAutoNormalFooter.m
//  JstyleNews
//
//  Created by 数字宁波 on 2017/10/24.
//  Copyright © 2017年 JstyleNews. All rights reserved.
//

#import "JstyleRefreshAutoNormalFooter.h"

@implementation JstyleRefreshAutoNormalFooter

#pragma mark - 重写父类的方法
- (void)prepare
{
    [super prepare];
    // 初始化间距
    self.labelLeftInset = 5;
    // 初始化文字
    [self setTitle:@"" forState:MJRefreshStateIdle];
    [self setTitle:@"" forState:MJRefreshStatePulling];
    [self setTitle:@"正在刷新..." forState:MJRefreshStateRefreshing];
    [self setTitle:@"已加载全部内容" forState:MJRefreshStateNoMoreData];
    self.stateLabel.font = JSFont(14);
    self.stateLabel.textColor = RGBACOLOR(140, 140, 140, 1);
}

- (void)placeSubviews
{
    [super placeSubviews];
    // 状态标签
    self.stateLabel.width = self.width * 2/3;
    if ([self.stateLabel.text isEqualToString:@"已加载全部内容"]) {
        self.stateLabel.centerX = self.width/2;
    }else{
        self.stateLabel.centerX = self.width/2 + 15;
    }
}

@end
