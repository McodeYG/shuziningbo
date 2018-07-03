//
//  JstyleManagementZhiBoCell.m
//  Exquisite
//
//  Created by 王磊 on 2017/10/10.
//  Copyright © 2017年 Jstyle. All rights reserved.
//

#import "JstyleManagementZhiBoCell.h"

@interface JstyleManagementZhiBoCell ()

@property (weak, nonatomic) IBOutlet UIImageView *posterImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *rtitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *airtimeLabel;

@property (weak, nonatomic) IBOutlet UILabel *playLabel;
@property (weak, nonatomic) IBOutlet UILabel *fansLabel;
@property (weak, nonatomic) IBOutlet UILabel *forwardLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentLabel;
@property (weak, nonatomic) IBOutlet UILabel *integralLabel;

@property (weak, nonatomic) IBOutlet UILabel *playCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *fansCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *forwardCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *integralCountLabel;

@end

@implementation JstyleManagementZhiBoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self setupUI];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    
    self.posterImageView.layer.cornerRadius = 3;
    self.posterImageView.layer.masksToBounds = YES;
    
    //分割线
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = kLightLineColor;
    line.alpha = 0.15;
    [self.contentView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(0.5);
        make.left.offset(15);
        make.bottom.right.offset(0);
    }];
    
    self.rtitleLabel.textColor = kDarkNineColor;
    
    CGFloat margin = (kScreenWidth - self.playLabel.width - self.fansLabel.width - self.forwardLabel.width - self.commentLabel.width - self.integralLabel.width - 15*2) / 4;
    
    [self.fansLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.forwardLabel.mas_left).offset(-margin);
        make.centerY.equalTo(self.forwardLabel);
    }];
    [self.fansCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.fansLabel);
        make.bottom.equalTo(self.fansLabel.mas_top).offset(-2);
    }];
    
    [self.commentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.forwardLabel.mas_right).offset(margin);
        make.centerY.equalTo(self.forwardLabel);
    }];
    [self.commentCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.commentLabel);
        make.bottom.equalTo(self.commentLabel.mas_top).offset(-2);
    }];
    
}

- (void)setModel:(JstyleManagementTableListModel *)model {
    _model = model;
    
    [self.posterImageView setImageWithURL:[NSURL URLWithString:model.poster] placeholder:[UIImage imageNamed:@"placeholder"] options:(YYWebImageOptionSetImageWithFadeAnimation) completion:nil];
    self.titleLabel.text = model.title;
    self.rtitleLabel.text = [NSString stringWithFormat:@"#%@",model.rname];
    self.airtimeLabel.text = model.air_time;
    
    
    if ([model.play_num floatValue] > 10000) {
        self.playCountLabel.text = [NSString stringWithFormat:@"%.1f万",[model.play_num floatValue] / 10000];
    } else {
        self.playCountLabel.text = model.play_num;
    }
    
    if ([model.fans_num floatValue] > 10000) {
        self.fansCountLabel.text = [NSString stringWithFormat:@"%.1f万",[model.fans_num floatValue] / 10000];
    } else {
        self.fansCountLabel.text = model.fans_num;
    }
    
    if ([model.follow_num floatValue] > 10000) {
        self.forwardCountLabel.text = [NSString stringWithFormat:@"%.1f万",[model.follow_num floatValue] / 10000];
    } else {
        self.forwardCountLabel.text = model.follow_num;
    }
    
    if ([model.comment_num floatValue] > 10000) {
        self.commentCountLabel.text = [NSString stringWithFormat:@"%.1f万",[model.comment_num floatValue] / 10000];
    } else {
        self.commentCountLabel.text = model.comment_num;
    }
    
    if ([model.integral_num floatValue] > 10000) {
        self.integralCountLabel.text = [NSString stringWithFormat:@"%.1f万",[model.integral_num floatValue] / 10000];
    } else {
        self.integralCountLabel.text = model.integral_num;
    }

}

@end
