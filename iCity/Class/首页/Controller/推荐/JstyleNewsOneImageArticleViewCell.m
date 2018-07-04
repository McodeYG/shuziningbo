//
//  JstyleNewsOneImageArticleViewCell.m
//  JstyleNews
//
//  Created by 赵涛 on 2017/10/24.
//  Copyright © 2017年 JstyleNews. All rights reserved.
//

#import "JstyleNewsOneImageArticleViewCell.h"

@implementation JstyleNewsOneImageArticleViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.subjectLabel.textColor = kDarkNineColor;
    self.closeBtn.hidden = YES;
    
   
//   图片
    [self.backImageView mas_remakeConstraints:^(MASConstraintMaker *make) {

        make.right.offset(-10);
        make.width.mas_equalTo(ArticleImg_W);
        make.height.mas_equalTo(ArticleImg_H);
        make.centerY.mas_equalTo(self.contentView);

    }];
    //文字
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(10);
        make.right.mas_equalTo(self.contentView.mas_right).offset(-(ArticleImg_W+20));
        make.top.mas_equalTo(self.contentView.mas_top).offset(13);
    }];
    //时间
    [self.subjectLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(10);
        make.right.mas_equalTo(self.contentView.mas_right).offset(-(ArticleImg_W+20));
        make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-13);
    }];
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
        make.centerY.mas_equalTo(self.subjectLabel);
        make.left.mas_equalTo(self.contentView).mas_equalTo(10);
        make.width.mas_equalTo(30);
        make.height.mas_equalTo(16);
    }];
    
    //分割线
    self.footerView = [[UIView alloc]init];
    self.footerView.backgroundColor = kNightModeLineColor;
    [self.contentView addSubview:self.footerView];
    
    [self.footerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.contentView);
        make.left.mas_equalTo(self.contentView).mas_equalTo(10);
        make.right.mas_equalTo(self.contentView).mas_equalTo(-10);
        make.height.mas_equalTo(0.5);
    }];


}

//别的界面
- (void)setModel:(JstyleNewsHomePageModel *)model
{
    _model = model;
    [self updateConstraintsWithModel:model];
    
    [self.backImageView setImageWithURL:[NSURL URLWithString:model.poster] placeholder:SZ_Place_S_N options:(YYWebImageOptionSetImageWithFadeAnimation) completion:nil];
    self.nameLabel.attributedText = [[NSString stringWithFormat:@"%@",model.title] attributedStringWithlineSpace:3 font:JSTitleFont];
    self.subjectLabel.text = [[NSString stringWithFormat:@"%@",model.author_name] stringByAppendingString:[NSString stringWithFormat:@"   %@",[NSDate compareCurrentTimeWithTimeString:model.ctime]]];
}

//推荐界面置顶
- (void)setModel:(JstyleNewsHomePageModel *)model withIndex:(NSIndexPath *)index
{
    _model = model;
    
    [self updateConstraintsWithModel:model];
    
    [self.backImageView setImageWithURL:[NSURL URLWithString:model.poster] placeholder:SZ_Place_S_N options:(YYWebImageOptionSetImageWithFadeAnimation) completion:nil];
    self.nameLabel.attributedText = [[NSString stringWithFormat:@"%@",model.title] attributedStringWithlineSpace:3 font:JSTitleFont];
    
    self.subjectLabel.text = [[NSString stringWithFormat:@"%@",model.author_name] stringByAppendingString:[NSString stringWithFormat:@"   %@",[NSDate compareCurrentTimeWithTimeString:model.ctime]]];
    
    
     //置顶设置
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
    
}

- (void)updateConstraintsWithModel:(JstyleNewsHomePageModel *)model {
    
    if ([model.poster isNotBlank]) {
        self.backImageView.hidden = NO;
        
        [self.nameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.contentView).offset(-30-ArticleImg_W);
        }];
        
    }else{
        
        self.backImageView.hidden = YES;
        [self.nameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.contentView).offset(-8);
        }];
        
    }
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
