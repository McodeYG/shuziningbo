//
//  ICityCitiesCultureCollectionViewCell.m
//  iCity
//
//  Created by 王磊 on 2018/5/1.
//  Copyright © 2018年 LongYuan. All rights reserved.
//

#import "ICityCitiesCultureCollectionViewCell.h"

@interface ICityCitiesCultureCollectionViewCell()

@property (nonatomic, strong) UIImageView *posterImageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *descLabel;

@end

@implementation ICityCitiesCultureCollectionViewCell

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
    
    self.backgroundColor = kWhiteColor;
    self.layer.cornerRadius = 3.0;
    self.layer.masksToBounds = YES;
    
    UIImageView *posterImageView = [[UIImageView alloc] initWithImage:SZ_Place_S_N];
    self.posterImageView = posterImageView;
    posterImageView.contentMode = UIViewContentModeScaleAspectFill;
    posterImageView.clipsToBounds = YES;
    [self.contentView addSubview:posterImageView];
    [posterImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.offset(0);
    }];
    
    UIView *maskView = [[UIView alloc] init];
    maskView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2];
    [posterImageView addSubview:maskView];
    [maskView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.offset(0);
    }];
    
    UILabel *nameLabel = [UILabel labelWithColor:kWhiteColor fontSize:15 text:@"领域" alignment:NSTextAlignmentCenter];
    self.nameLabel = nameLabel;
    nameLabel.numberOfLines = 1;
    [nameLabel sizeToFit];
    [self.contentView addSubview:nameLabel];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(posterImageView);
        make.centerY.equalTo(posterImageView).offset(-nameLabel.height/2.0);
    }];
    
    UILabel *descLabel = [UILabel labelWithColor:kWhiteColor fontSize:12 text:@"0资源丨0关注" alignment:NSTextAlignmentCenter];
    self.descLabel = descLabel;
    descLabel.font = [UIFont systemFontOfSize:(10*SCREEN_W/414) weight:(UIFontWeightMedium)];

    descLabel.numberOfLines = 1;
    [descLabel sizeToFit];
    [self.contentView addSubview:descLabel];
    [descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(posterImageView);
        make.top.mas_equalTo(self.nameLabel.mas_bottom).offset(4.5);
    }];
    [self applyTheme];
}
//城市名片
- (void)setModel:(ICityKnowledgeBaseModel *)model {
    _model = model;
    
    [self.posterImageView setImageWithURL:[NSURL URLWithString:model.img] placeholder:SZ_Place_S_N];
    self.nameLabel.text = model.name == nil ? @"" : model.name;
    
    if (![model.source_num isNotBlank]) {
        model.source_num = @"0";
    }
    if (![model.follow_num isNotBlank]) {
        model.follow_num = @"0";
    }
    self.descLabel.text = [NSString stringWithFormat:@"%@资源丨%@关注",[model.source_num dealNumberStr],[model.follow_num dealNumberStr]];
}




@end
