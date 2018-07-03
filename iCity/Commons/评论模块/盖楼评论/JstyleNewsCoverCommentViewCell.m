//
//  JstyleNewsCoverCommentViewCell.m
//  JstyleNews
//
//  Created by JingHongMuYun on 2017/12/7.
//  Copyright © 2017年 JstyleNews. All rights reserved.
//

#import "JstyleNewsCoverCommentViewCell.h"

@implementation JstyleNewsCoverCommentViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.commentLabel.textColor = ISNightMode?kDarkNineColor:kDarkTwoColor;
    self.headerImageView.layer.cornerRadius = 16;
    self.headerImageView.layer.borderColor = kPurpleColor.CGColor;
    self.headerImageView.layer.borderWidth = 1;
    
    [self.thumbBtn addTarget:self action:@selector(thumbBtnClicked:) forControlEvents:(UIControlEventTouchUpInside)];
    
    self.headerImageView.sd_layout
    .topSpaceToView(self.contentView, 15)
    .leftSpaceToView(self.contentView, 15)
    .widthIs(32)
    .heightIs(32);
    
    self.crownImageView.sd_layout
    .rightEqualToView(_headerImageView).offset(3)
    .bottomEqualToView(_headerImageView)
    .widthIs(12)
    .heightIs(12);
    
    self.thumbNumLabel.sd_layout
    .bottomEqualToView(self.headerImageView)
    .rightSpaceToView(self.contentView, 15)
    .heightIs(11);
    [self.thumbNumLabel setSingleLineAutoResizeWithMaxWidth:50];
    
    self.thumbBtn.sd_layout
    .bottomSpaceToView(self.thumbNumLabel, 3)
    .centerXEqualToView(self.thumbNumLabel)
    .widthIs(18)
    .heightIs(18);
    [self.thumbBtn setEnlargeEdgeWithTop:10 right:10 bottom:10 left:10];
    
    self.nickNameLabel.sd_layout
    .topEqualToView(self.headerImageView).offset(4)
    .leftSpaceToView(self.headerImageView, 10)
    .rightSpaceToView(self.thumbNumLabel, 10)
    .heightIs(11);
    
    self.timeLabel.sd_layout
    .topSpaceToView(self.nickNameLabel, 6)
    .leftSpaceToView(self.headerImageView, 10)
    .rightSpaceToView(self.thumbNumLabel, 10)
    .heightIs(11);
    
    self.commentLabel.sd_layout
    .topSpaceToView(self.headerImageView, 15)
    .leftSpaceToView(self.headerImageView, 10)
    .rightSpaceToView(self.contentView, 10)
    .autoHeightRatio(0);
}

- (void)setModel:(JstyleNewsCommentModel *)model
{
    _model = model;
    [self.headerImageView setImageWithURL:[NSURL URLWithString:model.avator] placeholder:SZ_Place_Header options:(YYWebImageOptionSetImageWithFadeAnimation) completion:nil];
    self.nickNameLabel.text = [NSString stringWithFormat:@"%@",model.nick_name];
    self.timeLabel.text = [NSString stringWithFormat:@"%@",model.ctime];
    self.thumbNumLabel.text = [NSString stringWithFormat:@"%@",model.praise_num];
    self.commentLabel.attributedText = [self attributedTextWithText:[NSString stringWithFormat:@"%@",model.content]];
    
    if ([model.isbetauser integerValue] == 1) {
        _crownImageView.hidden = NO;
        _headerImageView.layer.borderWidth = 1;
        _nickNameLabel.textColor = kPurpleColor;
    }else{
        _crownImageView.hidden = YES;
        _headerImageView.layer.borderWidth = 0;
        _nickNameLabel.textColor = kLightBlueColor;
    }
    
    if ([model.is_praise integerValue] == 1) {
        [self.thumbBtn setImage:JSImage(@"点赞-面") forState:(UIControlStateNormal)];
    }else{
        [self.thumbBtn setImage:JSImage(@"点赞-线") forState:(UIControlStateNormal)];
    }
    
    [self setupAutoHeightWithBottomView:self.commentLabel bottomMargin:10];
}

- (void)thumbBtnClicked:(UIButton *)sender
{
    _praiseBlock(_model.id);
}

- (NSAttributedString *)attributedTextWithText:(NSString *)text
{
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:text attributes:nil];
    [attributedString addAttribute:NSFontAttributeName value:JSFont(14) range:NSMakeRange(0,[text length])];
    
    //@:的规则
    NSString *pattern = @"@[0-9a-zA-Z\\u4e00-\\u9fa5-_]+:";
    
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern options:0 error:nil];
    
    NSArray *numArr = [regex matchesInString:text options:0 range:NSMakeRange(0, [text length])];
    
    for (NSTextCheckingResult *attirbute in numArr) {
        [attributedString setAttributes:@{NSForegroundColorAttributeName:kLightBlueColor} range:attirbute.range];
    }
    return attributedString;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
