//
//  ICityLifeCollectionViewCell.m
//  iCity
//
//  Created by 王磊 on 2018/4/29.
//  Copyright © 2018年 LongYuan. All rights reserved.
//

#import "ICityLifeCollectionViewCell.h"

@interface ICityLifeCollectionViewCell()

@property (nonatomic, strong) UIImageView *posterImageView;
@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation ICityLifeCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
        
    }
    return self;
}

- (void)setupUI {
    
    UIImageView *posterImageView = [[UIImageView alloc] init];
    self.posterImageView = posterImageView;
    [self.contentView addSubview:posterImageView];
    [posterImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.offset(-13);
        make.centerX.offset(0);
        make.width.height.offset(25);
    }];
    
    UILabel *titleLabel = [UILabel labelWithColor:kDarkThreeColor fontSize:13 text:@"" alignment:NSTextAlignmentCenter];
    self.titleLabel = titleLabel;
    [self.contentView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.offset(13);
        make.centerX.offset(0);
    }];
    
    [self applyTheme];
    
}

- (void)setModel:(ICityLifeMenuModel *)model {
    _model = model;
    
    [self.posterImageView setImageWithURL:[NSURL URLWithString:model.icon] placeholder:SZ_Place_Header];
    [self.posterImageView sizeToFit];
    self.titleLabel.text = (model.name == nil ? @"" : model.name);
    [self.titleLabel sizeToFit];
}

-(void)applyTheme {
    [super applyTheme];
    self.titleLabel.textColor = ISNightMode?kDarkCCCColor:kDarkThreeColor;
}

@end
