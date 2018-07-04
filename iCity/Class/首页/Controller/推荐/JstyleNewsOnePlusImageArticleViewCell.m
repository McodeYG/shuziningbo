//
//  JstyleNewsOnePlusImageArticleViewCell.m
//  JstyleNews
//
//  Created by 赵涛 on 2017/10/24.
//  Copyright © 2017年 JstyleNews. All rights reserved.
//

#import "JstyleNewsOnePlusImageArticleViewCell.h"

@implementation JstyleNewsOnePlusImageArticleViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.closeBtn.hidden = YES;
    self.subjectLabel.textColor = kDarkNineColor;
    self.holdView.backgroundColor = [kDarkZeroColor colorWithAlphaComponent:0.33];
    self.holdView.layer.cornerRadius = 10;
    self.holdView.layer.masksToBounds = YES;
    
    self.nameLabel.sd_layout
    .leftSpaceToView(self.contentView, 10)
    .rightSpaceToView(self.contentView, 10)
    .topSpaceToView(self.contentView, 10)
    .autoHeightRatio(0);
    self.nameLabel.isAttributedContent = YES;
    [self.nameLabel setMaxNumberOfLinesToShow:2];
    
    self.backImageView.sd_layout
    .leftSpaceToView(self.contentView, 10)
    .rightSpaceToView(self.contentView, 10)
    .topSpaceToView(self.nameLabel, 10)
    .autoHeightRatio(10/16.0);
    
    self.imageNumLabel.sd_layout
    .rightEqualToView(self.backImageView).offset(-12)
    .bottomEqualToView(self.backImageView).offset(-10)
    .heightIs(11);
    [self.imageNumLabel setSingleLineAutoResizeWithMaxWidth:50];
    
    self.iconImageView.sd_layout
    .rightSpaceToView(self.imageNumLabel, 5)
    .centerYEqualToView(self.imageNumLabel)
    .widthIs(11)
    .heightIs(11);
    
    self.holdView.sd_layout
    .rightEqualToView(self.imageNumLabel).offset(7)
    .bottomEqualToView(self.backImageView).offset(-5)
    .leftEqualToView(self.iconImageView).offset(-7)
    .heightIs(20);
    
    self.closeBtn.sd_layout
    .rightSpaceToView(self.contentView, 10)
    .topSpaceToView(self.backImageView, 15)
    .widthIs(11)
    .heightIs(11);
    
    self.subjectLabel.sd_layout
    .leftSpaceToView(self.contentView, 10)
    .rightSpaceToView(self.closeBtn, 10)
    .centerYEqualToView(self.closeBtn)
    .heightIs(12);
    
    //置顶
    self.setTopLab = [[UILabel alloc]init];
    self.setTopLab.font = [UIFont systemFontOfSize:12];
    self.setTopLab.textColor = [UIColor colorFromHexString:@"ee6767"];
    self.setTopLab.layer.borderWidth = 1;
    self.setTopLab.layer.lee_theme
    .LeeConfigBorderColor(@"setupLabelLayer");
    self.setTopLab.hidden = YES;
    
    self.setTopLab.layer.masksToBounds = YES;
    self.setTopLab.layer.cornerRadius = 3;
    self.setTopLab.text = @"置顶";
    self.setTopLab.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:self.setTopLab];
    
    //置顶
    self.setTopLab.sd_layout
    .centerYEqualToView(self.subjectLabel)
    .leftSpaceToView(self.contentView, 10)
    .widthIs(30)
    .heightIs(16);
    
    //分割线
    self.footerView = [[UIView alloc]init];
    self.footerView.backgroundColor = kNightModeLineColor;
    [self.contentView addSubview:self.footerView];
    
    self.footerView.sd_layout
    .leftSpaceToView(self.contentView, 10)
    .rightSpaceToView(self.contentView, 10)
    .bottomEqualToView(self.contentView)
    .heightIs(0.5);
    
}

- (void)setModel:(JstyleNewsHomePageModel *)model
{
    _model = model;
    [self.backImageView setImageWithURL:[NSURL URLWithString:model.poster] placeholder:SZ_Place_S_N options:(YYWebImageOptionSetImageWithFadeAnimation) completion:nil];
    self.nameLabel.attributedText = [[NSString stringWithFormat:@"%@",model.title] attributedStringWithlineSpace:3 font:JSTitleFont];
    self.subjectLabel.text = [[NSString stringWithFormat:@"%@",model.author_name] stringByAppendingString:[NSString stringWithFormat:@"  %@",[NSDate compareCurrentTimeWithTimeString:model.ctime]]];
    
    if ([model.posternum integerValue] > 0) {
        self.holdView.hidden = NO;
        self.iconImageView.hidden = NO;
        self.imageNumLabel.hidden = NO;
        self.imageNumLabel.text = [NSString stringWithFormat:@"%@图",model.posternum];
    }else{
        self.holdView.hidden = YES;
        self.iconImageView.hidden = YES;
        self.imageNumLabel.hidden = YES;
    }
    
    [self setupAutoHeightWithBottomView:self.closeBtn bottomMargin:15];
}
- (void)setModel:(JstyleNewsHomePageModel *)model withIndex:(NSIndexPath *)index
{
    _model = model;
    [self.backImageView setImageWithURL:[NSURL URLWithString:model.poster] placeholder:SZ_Place_S_N options:(YYWebImageOptionSetImageWithFadeAnimation) completion:nil];
    self.nameLabel.attributedText = [[NSString stringWithFormat:@"%@",model.title] attributedStringWithlineSpace:3 font:JSTitleFont];
    self.subjectLabel.text = [[NSString stringWithFormat:@"%@",model.author_name] stringByAppendingString:[NSString stringWithFormat:@"  %@",[NSDate compareCurrentTimeWithTimeString:model.ctime]]];
    
    if ([model.posternum integerValue] > 0) {
        self.holdView.hidden = NO;
        self.iconImageView.hidden = NO;
        self.imageNumLabel.hidden = NO;
        self.imageNumLabel.text = [NSString stringWithFormat:@"%@图",model.posternum];
    }else{
        self.holdView.hidden = YES;
        self.iconImageView.hidden = YES;
        self.imageNumLabel.hidden = YES;
    }
    //置顶设置
    if (index.section==0&&index.row<3) {
        self.setTopLab.hidden = NO;
        
        self.subjectLabel.sd_resetLayout
        .leftSpaceToView(self.contentView, 10+30+8)
        .rightSpaceToView(self.closeBtn, 10)
        .centerYEqualToView(self.closeBtn)
        .heightIs(12);
        
    }else{
        self.setTopLab.hidden = YES;
        
        self.subjectLabel.sd_resetLayout
        .leftSpaceToView(self.contentView, 10)
        .rightSpaceToView(self.closeBtn, 10)
        .centerYEqualToView(self.closeBtn)
        .heightIs(12);
    }
    
    if (index.section==0) {
        self.subjectLabel.text = [[NSString stringWithFormat:@"%@",model.author_name] stringByAppendingString:[NSString stringWithFormat:@"   %@",@"刚刚"]];
    }
    
    [self setupAutoHeightWithBottomView:self.closeBtn bottomMargin:15];
}

-(void)applyTheme {
    [super applyTheme];
    self.footerView.backgroundColor = kNightModeLineColor;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
