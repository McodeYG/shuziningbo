//
//  JstylePersonalMediaDetailArticleCell.m
//  Exquisite
//
//  Created by 赵涛 on 2017/8/8.
//  Copyright © 2017年 Jstyle. All rights reserved.
//

#import "JstylePersonalMediaDetailArticleCell.h"

@interface JstylePersonalMediaDetailArticleCell()

/**分割线*/
@property (nonatomic, strong) UIView * lineView;

@end

@implementation JstylePersonalMediaDetailArticleCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self.backImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-10);
        make.width.mas_equalTo(ArticleImg_W);
        make.height.mas_equalTo(ArticleImg_H);
        make.centerY.mas_equalTo(self.contentView);
    }];
    
    //文字
    [self.introLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(10);
        make.right.mas_equalTo(self.contentView).offset(-(ArticleImg_W+20));
        make.top.mas_equalTo(self.contentView).offset(10);
    }];
    //时间
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(10);
        make.right.mas_equalTo(self.contentView.mas_right).offset(-(ArticleImg_W+20));
        make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-10);
    }];
}

- (void)setModel:(JstylePersonalMediaDetailModel *)model
{
    _model = model;
   
    if ([model.poster isNotBlank]) {
        self.backImageView.hidden = NO;
        
        [self.introLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.contentView).offset(-30-ArticleImg_W);
        }];
        
    }else{
        
        self.backImageView.hidden = YES;
        [self.introLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.contentView).offset(-10);
        }];
        
    }
    
    [self.backImageView setImageWithURL:[NSURL URLWithString:model.poster] placeholder:SZ_Place_S_N options:(YYWebImageOptionSetImageWithFadeAnimation) completion:nil];
    self.introLabel.attributedText = [model.title attributedStringWithlineSpace:3 font:[UIFont systemFontOfSize:18]];
    self.timeLabel.text = [NSString stringWithFormat:@"%@",model.air_time];
    
//    if (model.praisenum.integerValue >= 10000) {
//        self.followNumLabel.text = [NSString stringWithFormat:@"%.1f万",model.praisenum.floatValue/10000];
//    } else {
//        self.followNumLabel.text = [NSString stringWithFormat:@"%@",model.praisenum];
//    }
    
    if (model.browsenum.integerValue >= 10000) {
        self.readNumberLabel.text = [NSString stringWithFormat:@"阅读 %.1f万",model.browsenum.floatValue/10000];
    } else {
        self.readNumberLabel.text = [NSString stringWithFormat:@"阅读 %@",model.browsenum];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
