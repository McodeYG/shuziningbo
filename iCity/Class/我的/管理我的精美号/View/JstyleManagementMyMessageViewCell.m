//
//  JstyleManagementMyMessageViewCell.m
//  Exquisite
//
//  Created by 数字宁波 on 2017/10/12.
//  Copyright © 2017年 Jstyle. All rights reserved.
//

#import "JstyleManagementMyMessageViewCell.h"

@interface JstyleManagementMyMessageViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *shenHeLabel;
@property (weak, nonatomic) IBOutlet UILabel *tongGuoLabel;

@end

@implementation JstyleManagementMyMessageViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.messageLabel.textColor = ISNightMode?kDarkNineColor:kDarkTwoColor;
    self.timeLabel.textColor = kDarkNineColor;
    
    self.messageLabel.sd_layout
    .topSpaceToView(self.contentView, 15)
    .leftSpaceToView(self.contentView, 15)
    .rightSpaceToView(self.contentView, 15)
    .autoHeightRatio(0);
    
    self.timeLabel.sd_layout
    .topSpaceToView(self.messageLabel, 10)
    .rightSpaceToView(self.contentView, 15)
    .heightIs(11);
    [self.timeLabel setSingleLineAutoResizeWithMaxWidth:300];

    [self.shenHeLabel sizeToFit];
    [self.shenHeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.timeLabel);
        make.left.equalTo(self.messageLabel);
    }];
    
    [self.tongGuoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.shenHeLabel);
        make.left.equalTo(self.shenHeLabel.mas_right).offset(2);
    }];
}

- (void)setModel:(JstyleManagementMyMessageModel *)model
{
    self.messageLabel.text = model.title;
    self.timeLabel.text = model.ctime;
    
    [self setupAutoHeightWithBottomView:self.timeLabel bottomMargin:15];
    
    //根据模型给tongGuoLabel的文字和颜色赋值
    //...
}

@end
