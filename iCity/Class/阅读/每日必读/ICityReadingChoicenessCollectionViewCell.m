//
//  ICityReadingChoicenessCollectionViewCell.m
//  iCity
//
//  Created by 王磊 on 2018/4/27.
//  Copyright © 2018年 LongYuan. All rights reserved.
//

#import "ICityReadingChoicenessCollectionViewCell.h"
#import "ICityLifeBannerModel.h"

@interface ICityReadingChoicenessCollectionViewCell ()

@property (nonatomic, strong) UIImageView *posterImageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *descLabel;

@end

@implementation ICityReadingChoicenessCollectionViewCell

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
    
    UIImageView *posterImageView = [[UIImageView alloc] init];
    self.posterImageView = posterImageView;
//    posterImageView.contentMode = UIViewContentModeScaleAspectFit;
    posterImageView.layer.cornerRadius = 4.0;
    posterImageView.clipsToBounds = YES;
    [self.contentView addSubview:posterImageView];
    [posterImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(0);
        make.left.offset(0);
        make.width.mas_equalTo(SCREEN_W-40);
        make.height.mas_equalTo((SCREEN_W - 40)/670.f*278.f);
    }];
    
    UILabel *nameLabel = [UILabel labelWithColor:kNightModeTextColor fontSize:15 text:@"名刊会"];
    self.nameLabel = nameLabel;
    [nameLabel sizeToFit];
    [self.contentView addSubview:nameLabel];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(posterImageView);
        make.top.equalTo(posterImageView.mas_bottom).offset(15);
    }];
    
    UILabel *descLabel = [UILabel labelWithColor:kNightModeDescColor fontSize:13 text:@"逝者|时间再无霍金,时间永留简史"];
    self.descLabel = descLabel;
    [descLabel sizeToFit];
    [self.contentView addSubview:descLabel];
    [descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(nameLabel);
        make.top.equalTo(nameLabel.mas_bottom).offset(4);
    }];
    [self applyTheme];
}

- (void)setModel:(ICityLifeBannerModel *)model {
    _model = model;
    
    [self.posterImageView setImageWithURL:[NSURL URLWithString:model.poster] placeholder:JSImage(@"placeholder_reading")];
    self.nameLabel.text = (model.title == nil ? @"" : model.title);
    self.descLabel.text = (model.remark == nil ? @"" : model.remark);
}

-(void)applyTheme {
    [super applyTheme];
    
    self.nameLabel.textColor =  kNightModeTextColor;
    self.descLabel.textColor =  kNightModeDescColor;
}

@end
