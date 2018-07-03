//
//  ICityKnowledgeBaseCollectionViewCell.m
//  iCity
//
//  Created by 王磊 on 2018/4/27.
//  Copyright © 2018年 LongYuan. All rights reserved.
//

#import "ICityKnowledgeBaseCollectionViewCell.h"

@interface ICityKnowledgeBaseCollectionViewCell ()

@property (nonatomic, strong) UIImageView *posterImageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *descLabel;

@end

@implementation ICityKnowledgeBaseCollectionViewCell

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
    
    self.layer.cornerRadius = 3.0;
    self.layer.masksToBounds = YES;
    
    UIImageView *posterImageView = [[UIImageView alloc] initWithImage:SZ_Place_S_N];
    self.posterImageView = posterImageView;
    posterImageView.contentMode = UIViewContentModeScaleAspectFill;
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
    descLabel.font = [UIFont systemFontOfSize:(10*SCREEN_W/414) weight:(UIFontWeightMedium)];
    self.descLabel = descLabel;
    descLabel.numberOfLines = 1;
    [descLabel sizeToFit];
    [self.contentView addSubview:descLabel];
    [descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(posterImageView);
        make.top.mas_equalTo(self.nameLabel.mas_bottom).offset(4.5);
    }];
    
}

- (void)setModel:(ICityKnowledgeBaseModel *)model {
    _model = model;
    
    [self.posterImageView setImageWithURL:[NSURL URLWithString:model.img] placeholder:SZ_Place_S_N];
    
    if (![model.source_num isNotBlank]) {
        model.source_num = @"0";
    }
    if (![model.follow_num isNotBlank]) {
        model.follow_num = @"0";
    }
    
    self.nameLabel.text = model.name == nil ? @"" : model.name;
    self.descLabel.text = [NSString stringWithFormat:@"%@资源丨%@关注",[model.source_num dealNumberStr],[model.follow_num dealNumberStr]];
}

@end
