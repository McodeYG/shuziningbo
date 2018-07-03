//
//  JstyleNewsAccountBindingViewCell.m
//  JstyleNews
//
//  Created by JingHongMuYun on 2018/4/11.
//  Copyright © 2018年 JstyleNews. All rights reserved.
//

#import "JstyleNewsAccountBindingViewCell.h"

@implementation JstyleNewsAccountBindingViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(JstyleNewsThirdPartBindStateModel *)model
{
    self.nameLabel.text = [NSString stringWithFormat:@"%@",model.name];
    if (model.number.length > 5) {
        self.bindLabel.text = @"已绑定";
        self.bindLabel.textColor = kLightBlueColor;
    }else{
        self.bindLabel.text = @"未绑定";
        self.bindLabel.textColor = kDarkNineColor;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
