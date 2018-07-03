//
//  JstyleNewsSearchVideosViewCell.m
//  JstyleNews
//
//  Created by JingHongMuYun on 2017/12/1.
//  Copyright © 2017年 JstyleNews. All rights reserved.
//

#import "JstyleNewsSearchVideosViewCell.h"
#import "JstyleNewsJMNumDetailsViewController.h"

@implementation JstyleNewsSearchVideosViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.tagTimeLabel.textColor = kDarkNineColor;
    self.authorImageView.layer.cornerRadius = 10;
    self.authorImageView.layer.masksToBounds = YES;
    
    UITapGestureRecognizer *authorTap = [[UITapGestureRecognizer alloc]initWithActionBlock:^(id  _Nonnull sender) {
        JstyleNewsJMNumDetailsViewController *jstyleNewsJmNumsDVC = [JstyleNewsJMNumDetailsViewController new];
        jstyleNewsJmNumsDVC.did = self.model.author_did;
        [[self viewController].navigationController pushViewController:jstyleNewsJmNumsDVC animated:YES];
    }];
    [self.authorImageView addGestureRecognizer:authorTap];
}

- (void)setModel:(SearchModel *)model
{
    _model = model;
    [self.backImageView setImageWithURL:[NSURL URLWithString:model.poster] placeholder:SZ_Place_S_N options:(YYWebImageOptionSetImageWithFadeAnimation) completion:nil];
    [self.authorImageView setImageWithURL:[NSURL URLWithString:model.author_img] placeholder:SZ_Place_Header options:(YYWebImageOptionSetImageWithFadeAnimation) completion:nil];
    self.nameLabel.attributedText = [model.title attributedStringWithlineSpace:3 textColor:kDarkOneColor font:JSFont(14)];
    self.tagTimeLabel.text = [NSString stringWithFormat:@"%@",model.author_name];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
