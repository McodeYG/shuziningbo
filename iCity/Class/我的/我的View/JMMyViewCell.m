//
//  JMMyViewHeaderView.h
//  Exquisite
//
//  Created by apple on 16/5/3.
//  Copyright © 2016年 zhaotao. All rights reserved.
//

#import "JMMyViewCell.h"

@implementation JMMyViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.titleLabel.textColor = kDarkNineColor;
    
    _phoneLabel = [[UILabel alloc]init];
    _phoneLabel.textColor = [UIColor colorFromHexString:@"#b73432"];
    _phoneLabel.font = [UIFont systemFontOfSize:16];
    _phoneLabel.textAlignment = NSTextAlignmentRight;
    [self addSubview:_phoneLabel];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
