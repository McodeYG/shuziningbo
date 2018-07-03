//
//  JstyleManagementWenZhangCell.m
//  Exquisite
//
//  Created by 数字跃动 on 2017/9/29.
//  Copyright © 2017年 Jstyle. All rights reserved.
//

#import "JstyleManagementWenZhangCell.h"

@interface JstyleManagementWenZhangCell ()
@property (weak, nonatomic) IBOutlet UIImageView *posterImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *rtitleLabel;


@property (weak, nonatomic) IBOutlet UILabel *readLabel;
@property (weak, nonatomic) IBOutlet UILabel *collectionLabel;
@property (weak, nonatomic) IBOutlet UILabel *shareLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentLabel;
@property (weak, nonatomic) IBOutlet UILabel *likeLabel;

@property (weak, nonatomic) IBOutlet UILabel *readCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *collectionCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *shareCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *likeCountLabel;

@end

@implementation JstyleManagementWenZhangCell

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
    
    CGFloat margin = (kScreenWidth - self.readLabel.width - self.collectionLabel.width - self.shareLabel.width - self.commentLabel.width - self.likeLabel.width - 15*2) / 4;
    
    [self.collectionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.shareLabel.mas_left).offset(-margin);
        make.centerY.equalTo(self.shareLabel);
    }];
    [self.collectionCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.collectionLabel);
        make.bottom.equalTo(self.collectionLabel.mas_top).offset(-2);
    }];
    
    [self.commentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.shareLabel.mas_right).offset(margin);
        make.centerY.equalTo(self.shareLabel);
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
    
    if ([model.com_num floatValue] > 10000) {
        self.readCountLabel.text = [NSString stringWithFormat:@"%.1f万",[model.com_num floatValue] / 10000];
    } else {
        self.readCountLabel.text = model.com_num;
    }
    
    if ([model.follow_num floatValue] > 10000) {
        self.collectionCountLabel.text = [NSString stringWithFormat:@"%.1f万",[model.follow_num floatValue] / 10000];
    } else {
        self.collectionCountLabel.text = model.follow_num;
    }
    
    if ([model.share_num floatValue] > 10000) {
        self.shareCountLabel.text = [NSString stringWithFormat:@"%.1f万",[model.share_num floatValue] / 10000];
    } else {
        self.shareCountLabel.text = model.share_num;
    }
    
    if ([model.comment_num floatValue] > 10000) {
        self.commentCountLabel.text = [NSString stringWithFormat:@"%.1f万",[model.comment_num floatValue] / 10000];
    } else {
        self.commentCountLabel.text = model.comment_num;
    }
    
    if ([model.praise_num floatValue] > 10000) {
        self.likeCountLabel.text = [NSString stringWithFormat:@"%.1f万",[model.praise_num floatValue] / 10000];
    } else {
        self.likeCountLabel.text = model.praise_num;
    }
    
}

@end
