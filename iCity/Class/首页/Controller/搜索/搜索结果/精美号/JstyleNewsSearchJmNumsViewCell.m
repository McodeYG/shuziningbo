//
//  JstyleNewsSearchJmNumsViewCell.m
//  JstyleNews
//
//  Created by JingHongMuYun on 2017/12/1.
//  Copyright © 2017年 JstyleNews. All rights reserved.
//

#import "JstyleNewsSearchJmNumsViewCell.h"

@implementation JstyleNewsSearchJmNumsViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.backImageView.layer.cornerRadius = 20;
    self.backImageView.layer.masksToBounds = YES;
    self.introLabel.textColor = [UIColor colorFromHexString:@"#B4B4B4"];

    [self.focusOnBtn addTarget:self action:@selector(focusOnBtnClicked:) forControlEvents:(UIControlEventTouchUpInside)];
}

- (void)setModel:(SearchModel *)model
{
    _model = model;
    [self.backImageView setImageWithURL:[NSURL URLWithString:model.head_img] placeholder:SZ_Place_S_N options:(YYWebImageOptionSetImageWithFadeAnimation) completion:nil];
    self.nameLabel.text = model.pen_name;
    self.introLabel.text = model.instruction;
    if ([model.isFollow integerValue] == 1) {
        self.focusOnBtn.layer.borderWidth = 0.5;
        self.focusOnBtn.backgroundColor = kWhiteColor;
        [self.focusOnBtn setTitle:@"查看" forState:(UIControlStateNormal)];
        [self.focusOnBtn setTitleColor:kPinkColor forState:(UIControlStateNormal)];
        self.focusOnBtn.userInteractionEnabled = NO;
        self.focusOnBtn.lee_theme
        .LeeCustomConfig(ThemeMainBtnTitleOrBorderColor, ^(id item, id value) {
            [item layer].borderColor = [value CGColor];
            [item setTitleColor:value forState:UIControlStateNormal];
            [item setBackgroundColor:kWhiteColor];
        });
    }else{
        self.focusOnBtn.layer.borderWidth = 0.0;
        self.focusOnBtn.backgroundColor = kPinkColor;
        [self.focusOnBtn setTitle:@"＋ 关注" forState:(UIControlStateNormal)];
        [self.focusOnBtn setTitleColor:kWhiteColor forState:(UIControlStateNormal)];
        self.focusOnBtn.userInteractionEnabled = YES;
        self.focusOnBtn.lee_theme
        .LeeCustomConfig(ThemeMainBtnTitleOrBorderColor, ^(id item, id value) {
            [item layer].borderColor = [value CGColor];
            [item setTitleColor:kWhiteColor forState:UIControlStateNormal];
            [item setBackgroundColor:value];
        });
    }
}

- (void)focusOnBtnClicked:(UIButton *)sender
{
    if ([[JstyleToolManager sharedManager] isTourist]) {
        [[JstyleToolManager sharedManager] loginInViewController];
        return;
    }
    self.focusOnBlock(_model.did);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
