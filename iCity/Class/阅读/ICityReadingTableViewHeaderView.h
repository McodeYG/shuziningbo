//
//  ICityReadingTableViewHeaderView.h
//  iCity
//
//  Created by 王磊 on 2018/4/27.
//  Copyright © 2018年 LongYuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ICityReadingTableViewHeaderView : UIView

@property (nonatomic, copy) void(^moreBtnBlock)(void);

- (instancetype)initWithTitleName:(NSString *)titleName showMoreBtn:(BOOL)showMoreBtn;
@property (nonatomic, strong) UIView *line;

@end
