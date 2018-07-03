//
//  ICityHotProgramCollectionViewCell.m
//  iCity
//
//  Created by 王磊 on 2018/5/1.
//  Copyright © 2018年 LongYuan. All rights reserved.
//

#import "ICityHotProgramCollectionViewCell.h"

@interface ICityHotProgramCollectionViewCell()

@property (nonatomic, strong) UIImageView *posterImageView;
@property (nonatomic, strong) UIView *titleBackgroundImageView;
@property (nonatomic, strong) UILabel *titleNameLabel;

@end

@implementation ICityHotProgramCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
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
    
    UIImageView *posterImageView = [[UIImageView alloc] initWithImage:JSImage(@"hot_program")];
    self.posterImageView = posterImageView;
    posterImageView.contentMode = UIViewContentModeScaleAspectFill;
    posterImageView.layer.cornerRadius = 4;
    posterImageView.layer.masksToBounds = YES;
    [self.contentView addSubview:posterImageView];
    [posterImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.offset(0);
    }];
    
//    UIImageView *titleBackgroundImageView = [[UIImageView alloc] initWithImage:JSImage(@"hot_program_title_background_left")];
    UIView *titleBackgroundImageView = [[UIView alloc] init];
    self.titleBackgroundImageView = titleBackgroundImageView;
    titleBackgroundImageView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
    [posterImageView addSubview:titleBackgroundImageView];
    [titleBackgroundImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.offset(0);
        make.height.offset(25);
    }];
    
    UILabel *titleNameLabel = [UILabel labelWithColor:kWhiteColor fontSize:15 text:@"#宁波影视频道" alignment:NSTextAlignmentCenter];
    self.titleNameLabel = titleNameLabel;
    titleNameLabel.numberOfLines = 1;
    [titleBackgroundImageView addSubview:titleNameLabel];
    [titleNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.offset(0);
        make.left.right.offset(0);
    }];
    
    [self applyTheme];
}

- (void)setModel:(ICityHotProgramModel *)model {
    _model = model;
    
    [self.posterImageView setImageWithURL:[NSURL URLWithString:model.poster] placeholder:SZ_Place_S_N];
    self.titleNameLabel.text = (model.title == nil ? @"" : model.title);
}

@end
