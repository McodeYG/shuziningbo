//
//  JstyleNewsCommentViewCell.m
//  JstyleNews
//
//  Created by JingHongMuYun on 2017/12/4.
//  Copyright © 2017年 JstyleNews. All rights reserved.
//

#import "JstyleNewsCommentViewCell.h"

@implementation JstyleNewsCommentViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.commentLabel.textColor = ISNightMode?kDarkNineColor:kDarkTwoColor;
    
    
    self.headerImageView.layer.cornerRadius = 16;
    self.headerImageView.layer.borderColor = kPurpleColor.CGColor;
    self.headerImageView.layer.borderWidth = 1;
    
    [self.replyBtn setTitleColor:(ISNightMode?kDarkFiveColor:kDarkNineColor) forState:(UIControlStateNormal)];
    
    [self.replyBtn addTarget:self action:@selector(replyBtnCLicked:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.thumbBtn addTarget:self action:@selector(praiseBtnCLicked:) forControlEvents:(UIControlEventTouchUpInside)];
    
    self.showBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
//    self.showBtn.hidden = YES;
    [self.showBtn setTitle:@"全文" forState:(UIControlStateNormal)];
    [self.showBtn setTitleColor:[UIColor colorFromHexString:@"#43669c"] forState:(UIControlStateNormal)];
    [self.showBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [self.contentView addSubview:self.showBtn];
    [self.showBtn addTarget:self action:@selector(showBtnAction:) forControlEvents:(UIControlEventTouchUpInside)];
    
    
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
    
    self.replyNumLabel.sd_layout
    .bottomEqualToView(self.headerImageView)
    .rightSpaceToView(self.contentView, 8)
    .widthIs(32)
    .heightIs(11);
    
    self.replyBtn.sd_layout
    .bottomSpaceToView(self.replyNumLabel, 8)
    .centerXEqualToView(self.replyNumLabel)
    .heightIs(11);
    [self.replyBtn setupAutoSizeWithHorizontalPadding:0 buttonHeight:11];
    [self.replyBtn setEnlargeEdgeWithTop:10 right:10 bottom:10 left:10];
    
    self.thumbNumLabel.sd_layout
    .bottomEqualToView(self.headerImageView)
    .rightSpaceToView(self.replyNumLabel, 3)
    .widthIs(32)
    .heightIs(11);
    
    self.thumbBtn.sd_layout
    .centerYEqualToView(self.replyBtn)
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
    
//    self.commentLabel.sd_layout
//    .topSpaceToView(self.headerImageView, 15)
//    .leftSpaceToView(self.headerImageView, 10)
//    .rightSpaceToView(self.contentView, 10)
//    .autoHeightRatio(0);
    
    [self.commentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView).offset(15+32+10);
        make.right.mas_equalTo(self.contentView).offset(-10);
        make.top.mas_equalTo(self.contentView).offset(15+32+15);
    }];
    
    self.showBtn.sd_layout
    .topSpaceToView(self.commentLabel, 5)
    .rightSpaceToView(self.contentView, 10)
    .heightIs(25)
    .widthIs(45);
}

- (void)setModel:(JstyleNewsCommentModel *)model
{
    _model = model;
    [self.headerImageView setImageWithURL:[NSURL URLWithString:model.avator] placeholder:SZ_Place_Header options:(YYWebImageOptionSetImageWithFadeAnimation) completion:nil];
    self.nickNameLabel.text = [NSString stringWithFormat:@"%@",model.nick_name];
    self.timeLabel.text = [NSString stringWithFormat:@"%@",model.ctime];
    self.thumbNumLabel.text = [NSString stringWithFormat:@"%@",model.praise_num];
    self.replyNumLabel.text = [NSString stringWithFormat:@"%@",model.reply_num];
   
    
    if ([model.isbetauser integerValue] == 1) {
        _crownImageView.hidden = NO;
        _headerImageView.layer.borderWidth = 1;
        _nickNameLabel.textColor = kPurpleColor;
    }else{
        _crownImageView.hidden = YES;
        _headerImageView.layer.borderWidth = 0;
        _nickNameLabel.textColor = kLightBlueColor;
    }
    
    NSString * comment = [NSString stringWithFormat:@"%@",model.content];
    self.commentLabel.text = comment;
    CGFloat comH = [comment heightForFont:[UIFont systemFontOfSize:14] width:SCREEN_W-32-35];

    
    if (model.isShowBtn&&comH>70) {
        self.showBtn.hidden = NO;//显示按钮
        self.commentLabel.numberOfLines = 4;
    } else {
        self.showBtn.hidden = YES;
        self.commentLabel.numberOfLines = 0;
    }
    
    
    
    if ([model.is_praise integerValue] == 1) {
        [self.thumbBtn setImage:JSImage(@"点赞-面") forState:(UIControlStateNormal)];
    }else{
        [self.thumbBtn setImage:JSImage(@"点赞-线") forState:(UIControlStateNormal)];
    }
    

//    [self setupAutoHeightWithBottomView:self.commentLabel bottomMargin:10];
}

- (void)replyBtnCLicked:(UIButton *)sender
{
    self.replyBlock(_model.nick_name, _model.id);
}

- (void)praiseBtnCLicked:(UIButton *)sender
{
    self.praiseBlock(_model.id,sender.selected);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)showBtnAction:(UIButton *)btn {
    btn.hidden = YES;
    if (_delegate && [_delegate respondsToSelector:@selector(cell:unflodBtnAction:)]) {
        [_delegate cell:self unflodBtnAction:btn];
    }
    
}

@end
