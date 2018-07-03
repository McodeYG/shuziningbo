//
//  JstyleManagementNavigationBottomMenuView.m
//  Exquisite
//
//  Created by 数字跃动 on 2017/9/25.
//  Copyright © 2017年 Jstyle. All rights reserved.
//

#import "JstyleManagementNavigationBottomMenuView.h"

@interface JstyleManagementNavigationBottomMenuView ()


@end

@implementation JstyleManagementNavigationBottomMenuView

-(void)awakeFromNib {
    [super awakeFromNib];
    
    [self setupUI];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    
    UILabel *countLabel = [UILabel new];
    self.countLabel = countLabel;
    countLabel.text = @"0";
    countLabel.textColor = [[LEETheme currentThemeTag] isEqualToString:ThemeName_White] ? kDarkTwoColor : kLightWhiteColor;
    countLabel.font = [UIFont systemFontOfSize:13];
    [countLabel sizeToFit];
    [self addSubview:countLabel];
    [countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.offset(0);
        make.centerY.offset(-10);
    }];
    
    UILabel *titleLabel = [UILabel new];
    self.titleLabel = titleLabel;
    titleLabel.text = @"?";
    titleLabel.textColor = [[LEETheme currentThemeTag] isEqualToString:ThemeName_White] ? kDarkTwoColor : [kLightWhiteColor colorWithAlphaComponent:0.64];
    titleLabel.font = [UIFont systemFontOfSize:10];
    [titleLabel sizeToFit];
    [self addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.offset(0);
        make.centerY.offset(10);
    }];
    
}

- (void)setModel:(JstyleManagementNavigationBottomMenuModel *)model {
    _model = model;
    self.countLabel.text = model.num;
    self.titleLabel.text = model.name;
}

@end
