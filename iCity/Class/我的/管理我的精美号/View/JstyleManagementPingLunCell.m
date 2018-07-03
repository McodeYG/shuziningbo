//
//  JstyleManagementPingLunCell.m
//  Exquisite
//
//  Created by 数字跃动 on 2017/10/11.
//  Copyright © 2017年 Jstyle. All rights reserved.
//

#import "JstyleManagementPingLunCell.h"

@interface JstyleManagementPingLunCell ()

@property (weak, nonatomic) IBOutlet UIImageView *avatorImageView;
@property (weak, nonatomic) IBOutlet UILabel *nicknameLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UILabel *ctime;

@property (weak, nonatomic) IBOutlet UIView *pinkView;
@end

@implementation JstyleManagementPingLunCell

-(void)awakeFromNib {
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
    
    self.avatorImageView.layer.cornerRadius = 20;
    self.avatorImageView.layer.masksToBounds = YES;
    self.nicknameLabel.textColor = kDarkThreeColor;
    self.locationLabel.textColor = kDarkFiveColor;
    self.pinkView.backgroundColor = kDeepPinkColor;
//    self.pinkView.alpha = 0.34;
    self.titleLabel.textColor = kDeepPinkColor;
//    self.titleLabel.alpha = 0.34;
    
    //给label添加点击跳转手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureClick:)];
    [self.titleLabel addGestureRecognizer:tap];
    
    self.pinkView.lee_theme
    .LeeCustomConfig(ThemeMainBtnTitleOrBorderColor, ^(id item, id value) {
        if ([[LEETheme currentThemeTag] isEqualToString:ThemeName_Black]) {
            [item setBackgroundColor:[JSColor(@"#FF252F") colorWithAlphaComponent:0.88]];
        } else {
            [item setBackgroundColor:[value colorWithAlphaComponent:0.88]];
        }
    });
    self.titleLabel.lee_theme
    .LeeCustomConfig(ThemeMainBtnTitleOrBorderColor, ^(id item, id value) {
        if ([[LEETheme currentThemeTag] isEqualToString:ThemeName_Black]) {
            [item setTextColor:[JSColor(@"#FF252F") colorWithAlphaComponent:0.88]];
        } else {
            [item setTextColor:[value colorWithAlphaComponent:0.88]];
        }
    });
    
}

- (void)tapGestureClick:(UITapGestureRecognizer *)tap {
    self.titleTapBlock();
}

- (void)setModel:(JstyleManagementCommentModel *)model {
    _model = model;
    [self.avatorImageView setImageWithURL:[NSURL URLWithString:model.avator] placeholder:[UIImage imageNamed:@"placeholder"] options:(YYWebImageOptionSetImageWithFadeAnimation) completion:nil];
    self.nicknameLabel.text = model.nick_name;
    self.titleLabel.text = model.title;
    self.locationLabel.text = model.address;
    self.ctime.text = model.ctime;
}

@end
