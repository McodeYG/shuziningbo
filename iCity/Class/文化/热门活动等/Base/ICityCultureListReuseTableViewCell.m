//
//  ICityCultureListReuseTableViewCell.m
//  iCity
//
//  Created by 王磊 on 2018/5/3.
//  Copyright © 2018年 LongYuan. All rights reserved.
//

#import "ICityCultureListReuseTableViewCell.h"
#import "ICityCultureReuseModel.h"

@interface ICityCultureListReuseTableViewCell()

@property (nonatomic, weak) UIImageView *posterImageView;
@property (nonatomic, weak) UILabel *titleNameLabel;
@property (nonatomic, weak) UILabel *description1Label;//三行灰色小标题描述
@property (nonatomic, weak) UILabel *description2Label;
@property (nonatomic, weak) UILabel *description3Label;

@end

@implementation ICityCultureListReuseTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self setupUI];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UIImageView *posterImageView = [[UIImageView alloc] init];
    self.posterImageView = posterImageView;
    posterImageView.contentMode = UIViewContentModeScaleAspectFill;
    posterImageView.layer.cornerRadius = 3.0;
    posterImageView.clipsToBounds = YES;
    [self.contentView addSubview:posterImageView];
    [posterImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.offset(10);
        make.width.offset(112.0*kScale);
        make.height.offset(112.0*kScale*(149.0/112.0));
    }];
    
    UILabel *titleNameLabel = [UILabel labelWithColor:kDarkTwoColor fontSize:17 text:@"" alignment:NSTextAlignmentLeft];
    self.titleNameLabel = titleNameLabel;
    titleNameLabel.numberOfLines = 2;
    [self.contentView addSubview:titleNameLabel];
    [titleNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(posterImageView.mas_right).offset(15);
        make.top.equalTo(posterImageView);
        make.right.offset(-10);
    }];
    
    UILabel *description1Label = [self setupDescriptionLabel];
    self.description1Label = description1Label;
    [self.contentView addSubview:description1Label];
    [description1Label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(titleNameLabel);
        make.top.equalTo(titleNameLabel.mas_bottom).offset(12);
        make.trailing.equalTo(titleNameLabel);
    }];
    
    UILabel *description2Label = [self setupDescriptionLabel];
    self.description2Label = description2Label;
    [self.contentView addSubview:description2Label];
    [description2Label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(description1Label);
        make.top.equalTo(description1Label.mas_bottom).offset(4);
    }];
    
    UILabel *description3Label = [self setupDescriptionLabel];
    self.description3Label = description3Label;
    [self.contentView addSubview:description3Label];
    [description3Label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(description2Label);
        make.top.equalTo(description2Label.mas_bottom).offset(4);
    }];
    
    UIView *line = [UIView new];
    line.backgroundColor = JSColor(@"#F0F0F0");
    [self.contentView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(10);
        make.right.offset(-10);
        make.bottom.offset(0);
        make.height.offset(0.5);
    }];
    
}

- (UILabel *)setupDescriptionLabel {
    UILabel *descriptionLabel = [UILabel labelWithColor:kDarkSixColor fontSize:13 text:@"" alignment:NSTextAlignmentLeft];
    descriptionLabel.numberOfLines = 0;
    return descriptionLabel;
}

- (void)setModel:(id)model {
    _model = model;
    
    NSURL *imageURL;
    NSString *name;
    NSString *description1;
    NSString *description2;
    NSString *description3;
    
    if ([model isMemberOfClass:[ICityCultureMorePopularActivitiesModel class]]) {
        
        ICityCultureMorePopularActivitiesModel *popularModel = model;
        
        imageURL = [NSURL URLWithString:popularModel.image];
        name = popularModel.name == nil ? @"" : popularModel.name;
        description1 = [NSString stringWithFormat:@"费用：%@" , popularModel.sale_price];
        description2 = [NSString stringWithFormat:@"时间：%@ %@" , popularModel.start_time, popularModel.end_time];
        description3 = [NSString stringWithFormat:@"地址：%@" , popularModel.address];
    
    } else if ([model isMemberOfClass:[ICityCultureMoreMapModel class]]) {
        
        ICityCultureMoreMapModel *mapModel = model;
        
        imageURL = [NSURL URLWithString:mapModel.img];
        name = mapModel.name;
        description1 = mapModel.scenic_type;
        description2 = mapModel.scenic_season;
        description3 = mapModel.scenic_time;
    }
    
    [self.posterImageView setImageWithURL:imageURL placeholder:SZ_Place_F_T];
    self.titleNameLabel.text = name;
    self.description1Label.text = description1;
    self.description2Label.text = description2;
    self.description3Label.text = description3;
}



@end
