//
//  JstyleNewsJMAttentionArticleSmallImageCell.m
//  JstyleNews
//
//  Created by JingHongMuYun on 2018/3/29.
//  Copyright © 2018年 JstyleNews. All rights reserved.
//

#import "JstyleNewsJMAttentionArticleSmallImageCell.h"
#import "JstyleNewsJMNumDetailsViewController.h"

@implementation JstyleNewsJMAttentionArticleSmallImageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.authorImageView.layer.cornerRadius = 15;
    self.authorImageView.layer.masksToBounds = YES;
    self.authorImageView.layer.borderColor = JSColor(@"#DEDEDE").CGColor;
    self.authorImageView.layer.borderWidth = 0.5;
    
    [self.focusBtn addTarget:self action:@selector(focusBtnClick) forControlEvents:UIControlEventTouchUpInside];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
        JstyleNewsJMNumDetailsViewController *jstylePersonalMediaVC = [JstyleNewsJMNumDetailsViewController new];
        jstylePersonalMediaVC.did = self.model.author_did;
        [self.viewController.navigationController pushViewController:jstylePersonalMediaVC animated:YES];
    }];
    [self.authorImageView addGestureRecognizer:tap];
}

- (void)setModel:(JstyleNewsJMAttentionListModel *)model {
    _model = model;
    [self.authorImageView setImageWithURL:[NSURL URLWithString:model.author_img] placeholder:SZ_Place_Header options:(YYWebImageOptionSetImageWithFadeAnimation) completion:nil];
    self.authorNameLabel.text = [NSString stringWithFormat:@"%@",model.author_name];
    self.timeLabel.text = [NSString stringWithFormat:@"%@",model.ctime];
    [self.backImageView setImageWithURL:[NSURL URLWithString:model.poster] placeholder:SZ_Place_S_N options:(YYWebImageOptionSetImageWithFadeAnimation) completion:nil];
    self.nameLabel.attributedText = [[NSString stringWithFormat:@"%@",model.title] attributedStringWithlineSpace:3 font:JSTitleFont];
    
    self.focusBtn.selected = (model.isShowAuthor.integerValue == 1);
}

- (void)focusBtnClick {
    if (self.focusBtnBlock) {
        self.focusBtnBlock(_model.author_did);
    }
}

@end
