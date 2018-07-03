//
//  JstyleArticleCommentCollectionCell.m
//  Exquisite
//
//  Created by 赵涛 on 2017/6/22.
//  Copyright © 2017年 Jstyle. All rights reserved.
//

#import "JstyleArticleCommentCollectionCell.h"

@implementation JstyleArticleCommentCollectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.headerImageView.layer.cornerRadius = 20;
    _singleLine = [[UIView alloc]initWithFrame:CGRectMake(15, self.height - 0.5, kScreenWidth - 15, 0.5)];
    _singleLine.backgroundColor = kSingleLineColor;
    [self.contentView addSubview:_singleLine];
    
    _contentLabel = [[JstyleLabel alloc]initWithFrame:CGRectMake(65, _timeLabel.y + _timeLabel.height + 10, kScreenWidth - 80, 20)];
    _contentLabel.numberOfLines = 0;
    _contentLabel.font = [UIFont systemFontOfSize:13];
    [self.contentView addSubview:_contentLabel];
}

- (void)setModel:(JMCommentModel *)model
{
    _model = model;
    [self.headerImageView setImageWithURL:[NSURL URLWithString:model.avator] placeholder:[UIImage imageNamed:@"placeholder"] options:YYWebImageOptionSetImageWithFadeAnimation completion:nil];
    self.nameLabel.text = model.nick_name;
    self.timeLabel.text = model.ctime;
    self.contentLabel.text = model.content;
    
    CGRect rect = [NSString getStringSizeWithString:model.content andFont:13 andWidth:kScreenWidth - 80];
    _contentLabel.height = rect.size.height;
    _singleLine.y = _contentLabel.y +_contentLabel.height + 12;
}

@end
