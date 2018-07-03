//
//  JstyleManagementTwoSelectedButton.m
//  Exquisite
//
//  Created by 数字跃动 on 2017/9/29.
//  Copyright © 2017年 Jstyle. All rights reserved.
//

#import "JstyleManagementTwoSelectedButton.h"

@implementation JstyleManagementTwoSelectedButton

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setup];
}

- (void)setup {
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.titleLabel sizeToFit];
    [self.imageView sizeToFit];
    
    // 调整文字
    self.titleLabel.x = self.bounds.size.width / 2 - self.titleLabel.bounds.size.width / 2;
    self.titleLabel.y = self.bounds.size.height / 2 - self.titleLabel.bounds.size.height / 2;
    
    // 调整图片
    self.imageView.x = self.titleLabel.origin.x + self.titleLabel.bounds.size.width + 5;
    self.imageView.y = self.titleLabel.origin.y + 4;
    
}
@end
