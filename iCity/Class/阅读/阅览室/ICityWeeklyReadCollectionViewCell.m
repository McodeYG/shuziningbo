//
//  ICityWeeklyReadCollectionViewCell.m
//  iCity
//
//  Created by 王磊 on 2018/4/27.
//  Copyright © 2018年 LongYuan. All rights reserved.
//

#import "ICityWeeklyReadCollectionViewCell.h"

@interface ICityWeeklyReadCollectionViewCell ()

@property (nonatomic, strong) UIImageView *posterImageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *typeLabel;

@end

@implementation ICityWeeklyReadCollectionViewCell

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
    
    
//    self.layer.cornerRadius = 3.0;
//    self.layer.masksToBounds = YES;
    
    UIImageView *posterImageView = [[UIImageView alloc] initWithImage:SZ_Place_F_T];
    self.posterImageView = posterImageView;
//    posterImageView.contentMode = UIViewContentModeScaleAspectFill;
    posterImageView.layer.cornerRadius = 3.0;
    posterImageView.clipsToBounds = YES;
    [self.contentView addSubview:posterImageView];
//    [posterImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.top.right.offset(0);
//        make.height.offset(self.height - 45);
//    }];
    [posterImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.offset(0);
        make.height.offset(ReadImg_h);
    }];
    //上边书名
    UILabel *nameLabel = [UILabel labelWithColor:kNightModeTextColor fontSize:15 text:@"" alignment:NSTextAlignmentLeft];
    self.nameLabel = nameLabel;
    nameLabel.numberOfLines = 1;
    [nameLabel sizeToFit];
    [self.contentView addSubview:nameLabel];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(posterImageView);
        make.top.equalTo(posterImageView.mas_bottom).offset(9);
    }];
    //下边小字
    UILabel *typeLabel = [UILabel labelWithColor:kNightModeDescColor fontSize:13 text:@"" alignment:NSTextAlignmentLeft];
    self.typeLabel = typeLabel;
    typeLabel.numberOfLines = 1;
    [typeLabel sizeToFit];
    [self.contentView addSubview:typeLabel];
    [typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(nameLabel);
        make.top.equalTo(nameLabel.mas_bottom).offset(5);
    }];
    [self applyTheme];
}

- (void)setModel:(ICityWeeklyReadModel *)model {
    _model = model;
    
    [self.posterImageView setImageWithURL:[NSURL URLWithString:model.picture] placeholder:SZ_Place_F_T];
    self.nameLabel.text = model.bookname;
    
    self.typeLabel.text = [model.type bookType];
    
    
}

-(void)applyTheme {
    [super applyTheme];
    
    self.nameLabel.textColor =  kNightModeTextColor;
    self.typeLabel.textColor =  kNightModeDescColor;
}


@end
