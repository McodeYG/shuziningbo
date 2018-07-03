//
//  JstyleNewsCommentPlaceHolderCell.m
//  JstyleNews
//
//  Created by JingHongMuYun on 2018/1/2.
//  Copyright © 2018年 JstyleNews. All rights reserved.
//

#import "JstyleNewsCommentPlaceHolderCell.h"

@implementation JstyleNewsCommentPlaceHolderCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.nameLabel.textColor = kDarkFiveColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
