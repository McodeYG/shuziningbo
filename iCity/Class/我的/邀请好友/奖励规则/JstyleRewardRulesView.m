//
//  JstyleRewardRulesView.m
//  Exquisite
//
//  Created by JingHongMuYun on 2018/3/6.
//  Copyright © 2018年 JstyleStar. All rights reserved.
//

#import "JstyleRewardRulesView.h"

@interface JstyleRewardRulesView()

@property (nonatomic, strong) UIView *holdView;

@property (nonatomic, strong) UIButton *closeBtn;

@end

@implementation JstyleRewardRulesView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setUpViews];
    }
    return self;
}

- (void)setUpViews{
    _holdView = [[UIView alloc] init];
    _holdView.backgroundColor = kWhiteColor;
    _holdView.layer.cornerRadius = 8;
    _holdView.layer.masksToBounds = YES;
    [self addSubview:_holdView];
    _holdView.sd_layout
    .widthIs(277)
    .heightIs(186)
    .centerXEqualToView(self)
    .centerYEqualToView(self);
    
    _closeBtn = [[UIButton alloc] init];
    [_closeBtn setImage:JSImage(@"daysign关闭") forState:(UIControlStateNormal)];
    [_closeBtn addTarget:self action:@selector(closeBtnClicked:) forControlEvents:(UIControlEventTouchUpInside)];
    [self addSubview:_closeBtn];
    _closeBtn.sd_layout
    .rightEqualToView(_holdView)
    .bottomSpaceToView(_holdView, 15)
    .widthIs(23)
    .heightIs(23);
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"奖励规则";
    titleLabel.font = JSFont(18);
    titleLabel.textColor = kDarkTwoColor;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [_holdView addSubview:titleLabel];
    titleLabel.sd_layout
    .leftSpaceToView(_holdView, 10)
    .rightSpaceToView(_holdView, 10)
    .topSpaceToView(_holdView, 25)
    .heightIs(23);
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = [kLightLineColor colorWithAlphaComponent:0.4];
    [_holdView addSubview:lineView];
    lineView.sd_layout
    .leftSpaceToView(_holdView, 32)
    .rightSpaceToView(_holdView, 32)
    .topSpaceToView(titleLabel, 15)
    .heightIs(0.5);
    
    JstyleLabel *introLabel = [[JstyleLabel alloc] init];
    introLabel.numberOfLines = 0;
    NSString *text = @"成为数字宁波VIP会员即可邀请好友。每邀请一名好友成为会员，即可获得奖励100元";
    introLabel.attributedText = [text attributedStringWithlineSpace:8 textColor:kDarkFiveColor font:JSFont(14) textAlignment:(NSTextAlignmentCenter)];
    [_holdView addSubview:introLabel];
    introLabel.sd_layout
    .leftSpaceToView(_holdView, 40)
    .rightSpaceToView(_holdView, 40)
    .topSpaceToView(lineView, 15);
}

- (void)closeBtnClicked:(UIButton *)sender
{
    [self removeFromSuperview];
}

@end
