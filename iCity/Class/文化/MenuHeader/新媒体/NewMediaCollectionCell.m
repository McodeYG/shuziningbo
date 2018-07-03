//
//  NewMediaCollectionCell.m
//  iCity
//
//  Created by mayonggang on 2018/6/15.
//  Copyright © 2018年 LongYuan. All rights reserved.
//

#import "NewMediaCollectionCell.h"

@interface NewMediaCollectionCell ()

/**头像*/
@property (nonatomic, strong) UIImageView * headerImgV;
/**姓名*/
@property (nonatomic, strong) UILabel * nameLab;

@end


@implementation NewMediaCollectionCell


- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews {
    //
    self.contentView.backgroundColor = kNightModeBackColor;
    CGFloat item_W      = (SCREEN_W-25)/5;
    CGFloat header_W    = 90/2;
    self.headerImgV = [[UIImageView alloc]initWithFrame:CGRectMake(item_W/2-header_W/2, 15, header_W, header_W)];
    self.headerImgV.userInteractionEnabled = YES;
    self.headerImgV.layer.masksToBounds = YES;
    self.headerImgV.layer.cornerRadius = header_W/2;
    [self.contentView addSubview:self.headerImgV];
    self.headerImgV.image = JSImage(@"placeholder_zheng");
    
    //
    self.nameLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 15+header_W+9, item_W, 17)];
    self.nameLab.textColor = kNightModeTextColor;
    self.nameLab.textAlignment = NSTextAlignmentCenter;
    self.nameLab.font = JSFont(15);
    self.nameLab.text = @"新媒体";
    [self.contentView addSubview:self.nameLab];
}


-(void)setModel:(NewspaperModel *)model {
    
    
    [self.headerImgV sd_setImageWithURL:[NSURL URLWithString:model.head_img] placeholderImage:JSImage(@"placeholder_zheng")];
    
    self.nameLab.text = model.pen_name;

    
}


@end
