//
//  ICityCultureMapCollectionViewCell.m
//  iCity
//
//  Created by 王磊 on 2018/5/2.
//  Copyright © 2018年 LongYuan. All rights reserved.
//

#import "ICityCultureMapCollectionViewCell.h"

@interface ICityCultureMapCollectionViewCell()

@property (nonatomic, strong) UIImageView *posterImageView;
@property (nonatomic, strong) UILabel *titleNameLabel;

@end

@implementation ICityCultureMapCollectionViewCell

-(void)awakeFromNib {
    [super awakeFromNib];
    
    [self setupUI];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    
    CGFloat margin = 10;
    CGFloat cellWidth = (kScreenWidth - margin*4)/3.0;
    CGFloat cellHeight = cellWidth * 149.0 / 112.0;
    
    UIImageView *posterImageView = [[UIImageView alloc] init];
    self.posterImageView = posterImageView;
    posterImageView.contentMode = UIViewContentModeScaleAspectFill;
    posterImageView.layer.cornerRadius = 3.0;
    posterImageView.clipsToBounds = YES;
    [self.contentView addSubview:posterImageView];
    [posterImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.offset(0);
        make.height.offset(cellHeight);
    }];
    
    UILabel *titleNameLabel = [UILabel labelWithColor:kDarkTwoColor fontSize:15 text:@"标题"];
    self.titleNameLabel = titleNameLabel;
    titleNameLabel.numberOfLines = 2;
    [titleNameLabel sizeToFit];
    [self.contentView addSubview:titleNameLabel];
    [titleNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(posterImageView.mas_bottom).offset(5);
        make.bottom.left.right.offset(0);
    }];
    [self applyTheme];
}

- (void)setModel:(ICityCultureReuseModel *)model {
    _model = model;
    
    [self.posterImageView setImageWithURL:[NSURL URLWithString:model.img] placeholder:SZ_Place_F_T];
    self.titleNameLabel.text = model.name == nil ? @"" : model.name;
}


-(void)applyTheme {
    [super applyTheme];
    self.titleNameLabel.textColor = kNightModeTextColor;
}
@end
