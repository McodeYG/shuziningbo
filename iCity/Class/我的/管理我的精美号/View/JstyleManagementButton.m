//
//  JstyleManagementButton.m
//  Exquisite
//
//  Created by 数字跃动 on 2017/9/26.
//  Copyright © 2017年 Jstyle. All rights reserved.
//

#import "JstyleManagementButton.h"

@implementation JstyleManagementButton

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
    
    [self.imageView sizeToFit];
    [self.titleLabel sizeToFit];
    
    // 调整图片
    self.imageView.x = self.bounds.size.width / 2 - self.imageView.bounds.size.width / 2;
    self.imageView.y = 23.4;
    
    // 调整文字
    self.titleLabel.x = self.bounds.size.width / 2 - self.titleLabel.bounds.size.width / 2;
    self.titleLabel.y = 23.4 + 19 + 7.6;
}

@end
