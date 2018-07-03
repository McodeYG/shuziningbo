//
//  JstyleRefreshGiftHeader.m
//  JstyleNews
//
//  Created by 赵涛 on 2017/10/24.
//  Copyright © 2017年 JstyleNews. All rights reserved.
//

#import "JstyleRefreshGiftHeader.h"

@implementation JstyleRefreshGiftHeader

#pragma mark - 重写方法
#pragma mark 基本设置
- (void)prepare
{
    [super prepare];
    
    self.mj_h = 75;
    // 初始化间距
    //    self.labelLeftInset = 5;
    // 初始化文字
    //    [self setTitle:@"" forState:MJRefreshStateIdle];
    //    [self setTitle:@"释放刷新" forState:MJRefreshStatePulling];
    //    [self setTitle:@"正在刷新..." forState:MJRefreshStateRefreshing];
    //    [self setTitle:@"已加载全部内容" forState:MJRefreshStateNoMoreData];
    //    self.stateLabel.font = [UIFont systemFontOfSize:14];
    //    self.stateLabel.textColor = RGBACOLOR(140, 140, 140, 1);
    
    //设置普通状态的动画图片
    NSMutableArray *idleImages = [NSMutableArray array];
    for (NSUInteger i = 1; i<=15; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"刷新动画-%zd", i]];
        [idleImages addObject:image];
    }

    // 设置即将刷新状态的动画图片（一松开就会刷新的状态）
    NSMutableArray *refreshingImages = [NSMutableArray array];
    for (NSUInteger i = 4; i<=15; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"刷新动画-%zd", i]];
        [refreshingImages addObject:image];
    }
    
    [self setImages:refreshingImages duration:2 forState:MJRefreshStateIdle];
    [self setImages:idleImages duration:2 forState:MJRefreshStatePulling];
    [self setImages:idleImages duration:2 forState:MJRefreshStateRefreshing];
    
    self.lastUpdatedTimeLabel.hidden = NO;
    self.stateLabel.hidden = YES;
    
    self.lastUpdatedTimeLabel.font = [UIFont systemFontOfSize:10];
    self.lastUpdatedTimeLabel.textColor = RGBACOLOR(140, 140, 140, 1);
    self.lastUpdatedTimeLabel.mj_x = 0;
    self.lastUpdatedTimeLabel.mj_y = 75 - 18;
    self.lastUpdatedTimeLabel.mj_w = self.mj_w;
    self.lastUpdatedTimeLabel.mj_h = 10;
    
}

- (void)placeSubviews
{
    [super placeSubviews];
    
    self.gifView.contentMode = UIViewContentModeCenter;
    self.gifView.mj_x = 0;
    self.gifView.mj_y = 5;
    self.gifView.mj_w = self.mj_w;
    self.gifView.mj_h = 50;
    
}

- (void)endRefreshing
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.state = MJRefreshStateIdle;
    });
}

#pragma mark - 日历获取在9.x之后的系统使用currentCalendar会出异常。在8.0之后使用系统新API。
- (NSCalendar *)currentCalendar {
    if ([NSCalendar respondsToSelector:@selector(calendarWithIdentifier:)]) {
        return [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
    }
    return [NSCalendar currentCalendar];
}

#pragma mark key的处理
- (void)setLastUpdatedTimeKey:(NSString *)lastUpdatedTimeKey
{
    [super setLastUpdatedTimeKey:lastUpdatedTimeKey];
    
    // 如果label隐藏了，就不用再处理
    if (self.lastUpdatedTimeLabel.hidden) return;
    
    NSDate *lastUpdatedTime = [[NSUserDefaults standardUserDefaults] objectForKey:lastUpdatedTimeKey];
    
    // 如果有block
    if (self.lastUpdatedTimeText) {
        self.lastUpdatedTimeLabel.text = self.lastUpdatedTimeText(lastUpdatedTime);
        return;
    }
    
    if (lastUpdatedTime) {
        // 1.获得年月日
        NSCalendar *calendar = [self currentCalendar];
        NSUInteger unitFlags = NSCalendarUnitYear| NSCalendarUnitMonth | NSCalendarUnitDay |NSCalendarUnitHour |NSCalendarUnitMinute;
        NSDateComponents *cmp1 = [calendar components:unitFlags fromDate:lastUpdatedTime];
        NSDateComponents *cmp2 = [calendar components:unitFlags fromDate:[NSDate date]];
        
        // 2.格式化日期
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        BOOL isToday = NO;
        if ([cmp1 day] == [cmp2 day]) { // 今天
            formatter.dateFormat = @" HH:mm";
            isToday = YES;
        } else if ([cmp1 year] == [cmp2 year]) { // 今年
            formatter.dateFormat = @"MM-dd HH:mm";
        } else {
            formatter.dateFormat = @"yyyy-MM-dd HH:mm";
        }
        NSString *time = [formatter stringFromDate:lastUpdatedTime];
        
        // 3.显示日期
        self.lastUpdatedTimeLabel.text = [NSString stringWithFormat:@"%@%@%@",
                                          [NSBundle mj_localizedStringForKey:MJRefreshHeaderLastTimeText],
                                          isToday ? [NSBundle mj_localizedStringForKey:MJRefreshHeaderDateTodayText] : @"",
                                          time];
    } else {
        self.lastUpdatedTimeLabel.text = [NSString stringWithFormat:@"%@%@",
                                          [NSBundle mj_localizedStringForKey:MJRefreshHeaderLastTimeText],
                                          [NSBundle mj_localizedStringForKey:MJRefreshHeaderNoneLastDateText]];
    }
    
}

@end
