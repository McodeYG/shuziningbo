//
//  JstyleNewsPhotographyContestProtocalTableViewCell.m
//  JstyleNews
//
//  Created by 王磊 on 2018/3/23.
//  Copyright © 2018年 JstyleNews. All rights reserved.
//

#import "JstyleNewsPhotographyContestProtocalTableViewCell.h"

@interface JstyleNewsPhotographyContestProtocalTableViewCell ()

@property (nonatomic, strong) UILabel *protocalLabel;
@property (nonatomic, strong) UIButton *agreeBtn;

@end

@implementation JstyleNewsPhotographyContestProtocalTableViewCell

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
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.agreeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.agreeBtn setImage:JSImage(@"摄影大赛未阅读") forState:UIControlStateNormal];
    [self.agreeBtn setImage:JSImage(@"摄影大赛已阅读") forState:UIControlStateSelected];
    [self.agreeBtn sizeToFit];
    [self.contentView addSubview:self.agreeBtn];
    [self.agreeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.centerY.offset(0);
    }];
    [self.agreeBtn addTarget:self action:@selector(agreeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.agreeBtn.selected = YES;
    
    self.protocalLabel = [[UILabel alloc] init];
    self.protocalLabel.userInteractionEnabled = YES;
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:@"我已阅读摄影大赛协议"];
    [attrStr setColor:kDarkSixColor range:NSMakeRange(0, 4)];
    [attrStr setColor:JSColor(@"#7293bf") range:NSMakeRange(4, 6)];
    self.protocalLabel.attributedText = attrStr;
    self.protocalLabel.font = [UIFont fontWithName:@"PingFang SC" size:13];
    [self.protocalLabel sizeToFit];
    [self.contentView addSubview:self.protocalLabel];
    [self.protocalLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.agreeBtn.mas_right).offset(10);
        make.centerY.offset(0);
    }];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapProtocalLabel)];
    [self.protocalLabel addGestureRecognizer:tap];
}

- (void)tapProtocalLabel {
    if (self.tapProtocalBlock) {
        self.tapProtocalBlock();
    }
}

- (void)agreeBtnClick:(UIButton *)button {
    
    if (self.agreeBtnBlock) {
        self.agreeBtnBlock(button);
    }
}

@end
