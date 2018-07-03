//
//  JstyleManagementShiPinCell.m
//  Exquisite
//
//  Created by 数字跃动 on 2017/10/10.
//  Copyright © 2017年 Jstyle. All rights reserved.
//

#import "JstyleManagementShiPinCell.h"

@interface JstyleManagementShiPinCell ()

@property (weak, nonatomic) IBOutlet UIImageView *posterImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *rtitleLabel;

@property (weak, nonatomic) IBOutlet UILabel *playnumLabel;
@property (weak, nonatomic) IBOutlet UILabel *sharenumLabel;
@property (weak, nonatomic) IBOutlet UILabel *follownumLabel;


@end

@implementation JstyleManagementShiPinCell

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
}

- (void)setModel:(JstyleManagementTableListModel *)model {
    _model = model;
    [self.posterImageView setImageWithURL:[NSURL URLWithString:model.poster] placeholder:[UIImage imageNamed:@"placeholder"] options:(YYWebImageOptionSetImageWithFadeAnimation) completion:nil];
    self.titleLabel.text = model.title;
    self.rtitleLabel.text = [NSString stringWithFormat:@"#%@",model.rname];
    self.playnumLabel.text = model.play_num;
    
    if ([model.play_num floatValue] > 10000) {
        self.playnumLabel.text = [NSString stringWithFormat:@"%.1f万",[model.play_num floatValue] / 10000];
    } else {
        self.playnumLabel.text = model.play_num;
    }
    
    if ([model.share_num floatValue] > 10000) {
        self.sharenumLabel.text = [NSString stringWithFormat:@"%.1f万",[model.share_num floatValue] / 10000];
    } else {
        self.sharenumLabel.text = model.share_num;
    }

    if ([model.follow_num floatValue] > 10000) {
        self.follownumLabel.text = [NSString stringWithFormat:@"%.1f万",[model.follow_num floatValue] / 10000];
    } else {
        self.follownumLabel.text = model.follow_num;
    }

}

@end
