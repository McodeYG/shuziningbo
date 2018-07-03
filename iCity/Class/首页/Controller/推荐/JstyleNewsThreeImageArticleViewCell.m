//
//  JstyleNewsThreeImageArticleViewCell.m
//  JstyleNews
//
//  Created by 赵涛 on 2017/10/24.
//  Copyright © 2017年 JstyleNews. All rights reserved.
//

#import "JstyleNewsThreeImageArticleViewCell.h"

@implementation JstyleNewsThreeImageArticleViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.closeBtn.hidden = YES;
    self.subjectLabel.textColor = kDarkNineColor;
    self.holdView.backgroundColor = [kDarkZeroColor colorWithAlphaComponent:0.33];
    self.holdView.layer.cornerRadius = 10;
    self.holdView.layer.masksToBounds = YES;
    
    _photosContainerView = [[JstylePhotosContainerView alloc] initWithMaxItemsCount:3 verticalMargin:0 horizontalMargin:3.5 verticalEdgeInset:0 horizontalEdgeInset:10];
    _photosContainerView.delegate = self;
    [self.contentView insertSubview:_photosContainerView belowSubview:_holdView];
    
    self.nameLabel.sd_layout
    .leftSpaceToView(self.contentView, 10)
    .rightSpaceToView(self.contentView, 10)
    .topSpaceToView(self.contentView, 10)
    .autoHeightRatio(0);
    self.nameLabel.isAttributedContent = YES;
    
    self.photosContainerView.sd_layout
    .leftSpaceToView(self.contentView, 0)
    .rightSpaceToView(self.contentView, 0)
    .topSpaceToView(self.nameLabel, 10);
    
    self.imageNumLabel.sd_layout
    .rightEqualToView(self.photosContainerView).offset(- 22)
    .bottomEqualToView(self.photosContainerView).offset(-10)
    .heightIs(11);
    [self.imageNumLabel setSingleLineAutoResizeWithMaxWidth:50];
    
    self.iconImageView.sd_layout
    .rightSpaceToView(self.imageNumLabel, 5)
    .centerYEqualToView(self.imageNumLabel)
    .widthIs(11)
    .heightIs(11);
    
    self.holdView.sd_layout
    .rightEqualToView(self.imageNumLabel).offset(7)
    .leftEqualToView(self.iconImageView).offset(-7)
    .bottomEqualToView(self.photosContainerView).offset(-5)
    .heightIs(20);
    
    self.closeBtn.sd_layout
    .rightSpaceToView(self.contentView, 10)
    .topSpaceToView(self.photosContainerView, 15)
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
    [self.setTopLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-10);
        make.left.mas_equalTo(self.contentView).mas_equalTo(10);
        make.width.mas_equalTo(30);
        make.height.mas_equalTo(16);
    }];
    
    self.footerView = [[UIView alloc]init];
    self.footerView.backgroundColor = kNightModeLineColor;
    [self.contentView addSubview:self.footerView];
    
    self.footerView.sd_layout
    .leftSpaceToView(self.contentView, 10)
    .rightSpaceToView(self.contentView, 10)
    .bottomEqualToView(self.contentView)
    .heightIs(0.5);
    
    [self applyTheme];


}

- (void)setModel:(JstyleNewsHomePageModel *)model 
{
    _model = model;
    self.nameLabel.attributedText = [[NSString stringWithFormat:@"%@",model.title] attributedStringWithlineSpace:3 font:JSTitleFont];
    self.subjectLabel.text = [[NSString stringWithFormat:@"%@",model.author_name] stringByAppendingString:[NSString stringWithFormat:@"   %@",[NSDate compareCurrentTimeWithTimeString:model.ctime]]];
    self.photosContainerView.photoNamesArray = model.poster_imgs;
    
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

- (void)setModel:(JstyleNewsHomePageModel *)model withIndex:(NSIndexPath *)index;
{
    _model = model;
    self.nameLabel.attributedText = [[NSString stringWithFormat:@"%@",model.title] attributedStringWithlineSpace:3 font:JSTitleFont];
    self.subjectLabel.text = [[NSString stringWithFormat:@"%@",model.author_name] stringByAppendingString:[NSString stringWithFormat:@"   %@",[NSDate compareCurrentTimeWithTimeString:model.ctime]]];
    self.photosContainerView.photoNamesArray = model.poster_imgs;
    
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
    
    if (index.section==0&&index.row<3) {
        self.setTopLab.hidden = NO;
        
        [self.subjectLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.contentView.mas_left).mas_equalTo(10+30+8);
            
        }];
    }else{
        self.setTopLab.hidden = YES;
        [self.subjectLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.contentView.mas_left).mas_equalTo(10);
        }];
    }
    if (index.section==0) {
        self.subjectLabel.text = [[NSString stringWithFormat:@"%@",model.author_name] stringByAppendingString:[NSString stringWithFormat:@"   %@",@"刚刚"]];
    }
    
    [self setupAutoHeightWithBottomView:self.closeBtn bottomMargin:15];
}


- (void)applyTheme {
    [super applyTheme];
    
    _photosContainerView.backgroundColor = kNightModeBackColor;
    self.footerView.backgroundColor = kNightModeLineColor;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
