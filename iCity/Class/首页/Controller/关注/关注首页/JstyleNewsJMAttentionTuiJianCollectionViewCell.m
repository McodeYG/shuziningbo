//
//  JstyleNewsJMAttentionTuiJianCollectionViewCell.m
//  JstyleNews
//
//  Created by JingHongMuYun on 2018/3/28.
//  Copyright © 2018年 JstyleNews. All rights reserved.
//

#import "JstyleNewsJMAttentionTuiJianCollectionViewCell.h"

@implementation JstyleNewsJMAttentionTuiJianCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.backHoldView.layer.borderColor = JSColor(@"#EFEFEF").CGColor;
    self.backHoldView.layer.borderWidth = 1;
    self.headerHoldView.layer.cornerRadius = 25.5;
    self.headerHoldView.layer.borderColor = JSColor(@"#EF252F").CGColor;
    self.headerHoldView.layer.borderWidth = 0.8;
    self.headerImageView.layer.cornerRadius = 22.5;
    self.headerImageView.layer.masksToBounds = YES;
    [self.focusBtn addTarget:self action:@selector(focusBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    self.backHoldView.layer.shadowColor = kDarkNineColor.CGColor;
    self.backHoldView.layer.shadowOpacity = 0.08;
    self.backHoldView.layer.shadowRadius = 4.0;
    self.backHoldView.layer.shadowOffset = CGSizeMake(0, 6);
}

- (void)setModel:(JstyleNewsJMAttentionListModel *)model
{
    _model = model;
    [self.headerImageView setImageWithURL:[NSURL URLWithString:model.head_img] placeholder:SZ_Place_Header options:(YYWebImageOptionSetImageWithFadeAnimation) completion:nil];
    self.nameLabel.text = [NSString stringWithFormat:@"%@",model.pen_name];
    self.introLabel.text = [NSString stringWithFormat:@"%@",model.instruction];
    
    self.focusBtn.selected = (model.isFollow.integerValue == 1);
}

- (void)focusBtnClick {
    if (self.focusBtnBlock) {
        self.focusBtnBlock(_model.did);
    }
}

@end
