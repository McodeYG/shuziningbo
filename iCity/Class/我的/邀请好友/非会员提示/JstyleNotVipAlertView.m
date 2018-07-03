//
//  JstyleNotVipAlertView.m
//  Exquisite
//
//  Created by JingHongMuYun on 2018/3/7.
//  Copyright © 2018年 JstyleStar. All rights reserved.
//

#import "JstyleNotVipAlertView.h"

@interface JstyleNotVipAlertView()

@property (nonatomic, strong) UIView *holdView;

@property (nonatomic, strong) UIButton *closeBtn;

@end

@implementation JstyleNotVipAlertView

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
    _holdView.userInteractionEnabled = YES;
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
    
    UILabel *introLabel = [[UILabel alloc] init];
    introLabel.numberOfLines = 0;
    introLabel.textColor = kDarkFiveColor;
    introLabel.font = JSFont(14);
    introLabel.userInteractionEnabled = YES;
    NSString *text = @"您还不是会员，开通会员享受更多权益";
    introLabel.attributedText = [text attributedStringWithlineSpace:8 range:NSMakeRange(7, 4) textAlignment:NSTextAlignmentCenter textColor:kGlobalGoldColor textFont:JSFont(14)];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
    [introLabel addGestureRecognizer:tap];
    
    [_holdView addSubview:introLabel];
    introLabel.sd_layout
    .leftSpaceToView(_holdView, 25)
    .rightSpaceToView(_holdView, 25)
    .centerYEqualToView(_holdView)
    .heightIs(50);
}

- (void)closeBtnClicked:(UIButton *)sender
{
    [self removeFromSuperview];
}

- (void)tapAction
{
    [[JstyleToolManager sharedManager] isVIP];
    [self removeFromSuperview];
}

@end

