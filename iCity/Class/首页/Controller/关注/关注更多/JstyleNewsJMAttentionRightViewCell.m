//
//  JstyleNewsJMAttentionRightViewCell.m
//  JstyleNews
//
//  Created by JingHongMuYun on 2018/4/2.
//  Copyright © 2018年 JstyleNews. All rights reserved.
//

#import "JstyleNewsJMAttentionRightViewCell.h"

@implementation JstyleNewsJMAttentionRightViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.headerImageView.layer.cornerRadius = 20;
    self.headerImageView.layer.masksToBounds = YES;
    self.headerImageView.layer.borderColor = JSColor(@"#DEDEDE").CGColor;
    self.headerImageView.layer.borderWidth = 0.5;
    
    self.focusBtn.layer.cornerRadius = 13;
    self.focusBtn.layer.masksToBounds = YES;
//    self.focusBtn.layer.borderColor = JSColor(@"DEDEDE").CGColor;
//    self.focusBtn.backgroundColor = kPinkColor;
//    [self.focusBtn setTitleColor:kWhiteColor forState:(UIControlStateNormal)];
    [self.focusBtn addTarget:self action:@selector(focusBtnClicked:) forControlEvents:(UIControlEventTouchUpInside)];
    
    [self applyTheme];
}

- (void)setModel:(SearchModel *)model
{
    _model = model;
    [self.headerImageView setImageWithURL:[NSURL URLWithString:model.head_img] placeholder:SZ_Place_Header options:(YYWebImageOptionSetImageWithFadeAnimation) completion:nil];
    self.nameLabel.text = model.pen_name;
    self.introLabel.text = model.instruction;
    if ([model.isFollow integerValue] == 1) {
        self.focusBtn.selected = YES;
//        self.focusBtn.layer.borderWidth = 0.5;
//        self.focusBtn.backgroundColor = kWhiteColor;
//        [self.focusBtn setTitle:@"已关注" forState:(UIControlStateNormal)];
//        [self.focusBtn setTitleColor:JSColor(@"646464") forState:(UIControlStateNormal)];
//        self.focusBtn.lee_theme
//        .LeeCustomConfig(ThemeMainBtnTitleOrBorderColor, ^(id item, id value) {
//            [item layer].borderColor = [value CGColor];
//            [item setTitleColor:value forState:UIControlStateNormal];
//            [item setBackgroundColor:kWhiteColor];
//        });
    }else{
        self.focusBtn.selected = NO;
//        self.focusBtn.layer.borderWidth = 0.0;
//        self.focusBtn.backgroundColor = kPinkColor;
//        [self.focusBtn setTitle:@"＋ 关注" forState:(UIControlStateNormal)];
//        [self.focusBtn setTitleColor:kWhiteColor forState:(UIControlStateNormal)];
//        self.focusBtn.lee_theme
//        .LeeCustomConfig(ThemeMainBtnTitleOrBorderColor, ^(id item, id value) {
//            //[item layer].borderColor = [value CGColor];
//            [item setTitleColor:kWhiteColor forState:UIControlStateNormal];
//            [item setBackgroundColor:value];
//        });
    }
}

- (void)focusBtnClicked:(UIButton *)sender
{
    if (self.focusBlock) {
        self.focusBlock(_model.did);
    }
}

-(void)applyTheme {
    [super applyTheme];
    self.nameLabel.textColor = kNightModeTextColor;
    self.introLabel.textColor = kNightModeDescColor;
}


@end
