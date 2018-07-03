//
//  JstyleNewsCustomBannerViewCell.m
//  JstyleNews
//
//  Created by JingHongMuYun on 2018/1/4.
//  Copyright © 2018年 JstyleNews. All rights reserved.
//

#import "JstyleNewsCustomBannerViewCell.h"

@implementation JstyleNewsCustomBannerViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setupViews];
    }
    return self;
}

- (void)setupViews
{
    self.contentView.backgroundColor = kWhiteColor;
    
    _backImageView = [[UIImageView alloc] init];
    _backImageView.contentMode = UIViewContentModeScaleAspectFill;
    _backImageView.clipsToBounds = YES;
    [self.contentView addSubview:_backImageView];
    
    _nameLabel = [[UILabel alloc] init];
    _nameLabel.font = JSFont(15);
    _nameLabel.textColor = kWhiteColor;
    [self.contentView addSubview:_nameLabel];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _backImageView.sd_layout
    .leftEqualToView(self.contentView)
    .rightEqualToView(self.contentView)
    .topEqualToView(self.contentView)
    .bottomEqualToView(self.contentView);
    
    _nameLabel.sd_layout
    .leftSpaceToView(self.contentView, 15)
    .rightSpaceToView(self.contentView, 86)
    .bottomSpaceToView(self.contentView, 10)
    .autoHeightRatio(0);
    _nameLabel.isAttributedContent = YES;
}

@end
