//
//  JstyleNewsPhotographyContestTextCell.m
//  JstyleNews
//
//  Created by 王磊 on 2018/3/22.
//  Copyright © 2018年 JstyleNews. All rights reserved.
//

#import "JstyleNewsPhotographyContestTextCell.h"

#define Margin_bothSide 15
#define Margin_leftToCell 107.5

@implementation JstyleNewsThemeButton

+ (instancetype)buttonWithThemeModel:(JstyleNewsPhotographyContestThemeModel *)model {
    JstyleNewsThemeButton *themeBtn = [self buttonWithType:UIButtonTypeCustom];
    [themeBtn setImage:JSImage(@"摄影大赛未勾选") forState:UIControlStateNormal];
    [themeBtn setImage:JSImage(@"摄影大赛勾选") forState:UIControlStateSelected];
    [themeBtn setTitle:model.name forState:UIControlStateNormal];
    [themeBtn setTitle:model.name forState:UIControlStateSelected];
    [themeBtn setTitleColor:kDarkTwoColor forState:UIControlStateNormal];
    [themeBtn sizeToFit];
    themeBtn.themeid = model.id;
    return themeBtn;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self setImageEdgeInsets:UIEdgeInsetsMake(0, -30, 0, 0)];
    [self setTitleEdgeInsets:UIEdgeInsetsMake(0, -25, 0, 0)];
}

@end


@interface JstyleNewsPhotographyContestTextCell ()<UITextFieldDelegate>

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) JstyleNewsThemeButton *themeBtn1;
@property (nonatomic, strong) JstyleNewsThemeButton *themeBtn2;
@property (nonatomic, strong) JstyleNewsThemeButton *themeBtn3;

@end

@implementation JstyleNewsPhotographyContestTextCell

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
    
    self.titleLabel = [UILabel labelWithColor:kDarkTwoColor fontSize:14 text:@"" alignment:NSTextAlignmentLeft];
    [self.contentView addSubview:self.titleLabel];
    [self.titleLabel sizeToFit];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(Margin_bothSide);
        make.centerY.offset(0);
    }];
    
    self.textField = [[UITextField alloc] init];
    self.textField.textColor = kDarkTwoColor;
    self.textField.font = [UIFont fontWithName:@"PingFang SC" size:14];
    self.textField.borderStyle = UITextBorderStyleNone;
    self.textField.returnKeyType = UIReturnKeyDone;
    self.textField.delegate = self;
    [self.contentView addSubview:self.textField];
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(Margin_leftToCell);
        make.centerY.offset(0);
        make.right.offset(-Margin_bothSide);
        make.height.offset(30);
    }];
    
    UIView *line = [UIView new];
    line.backgroundColor = kSingleLineColor;
    [self.contentView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.offset(0);
        make.left.offset(Margin_bothSide);
        make.right.offset(-Margin_bothSide);
        make.height.offset(0.5);
    }];
}

- (void)themeBtnClick:(JstyleNewsThemeButton *)button {
    self.themeBtn1.selected = self.themeBtn2.selected = self.themeBtn3.selected = NO;
    if (self.themeBtnBlock) {
        self.themeBtnBlock(button);
    }
    if (self.themeBtn1.isSelected) {
        self.themeBtn2.selected = NO;
        self.themeBtn3.selected = NO;
    }
    if (self.themeBtn2.isSelected) {
        self.themeBtn1.selected = NO;
        self.themeBtn3.selected = NO;
    }
    if (self.themeBtn3.isSelected) {
        self.themeBtn1.selected = NO;
        self.themeBtn2.selected = NO;
    }
}

- (void)setTitleName:(NSString *)titleName {
    _titleName = titleName;
    
    self.titleLabel.text = titleName;
    if ([self.titleName isEqualToString:@"选择主题"]) {
        self.textField.hidden = YES;
    } else {
        self.textField.hidden = NO;
    }
}

- (void)setThemeArray:(NSArray<JstyleNewsPhotographyContestThemeModel *> *)themeArray {
    _themeArray = themeArray;
    
    if (themeArray.count < 2) {
        return;
    }
    
    if (self.themeBtn1 == nil) {
        self.themeBtn1 = [JstyleNewsThemeButton buttonWithThemeModel:themeArray[0]];
        [self.contentView addSubview:self.themeBtn1];
        [self.themeBtn1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(Margin_leftToCell);
            make.width.offset((kScreenWidth - Margin_leftToCell)/3.0);
            make.centerY.offset(0);
        }];
        [self.themeBtn1 addTarget:self action:@selector(themeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    if (self.themeBtn2 == nil) {
        self.themeBtn2 = [JstyleNewsThemeButton buttonWithThemeModel:themeArray[1]];
        [self.contentView addSubview:self.themeBtn2];
        [self.themeBtn2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.themeBtn1.mas_right).offset(0);
            make.width.offset((kScreenWidth - Margin_leftToCell)/3.0);
            make.centerY.offset(0);
        }];
        [self.themeBtn2 addTarget:self action:@selector(themeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    if (themeArray.count >= 3) {
        if (self.themeBtn3 == nil) {
            self.themeBtn3 = [JstyleNewsThemeButton buttonWithThemeModel:themeArray[2]];
            [self.contentView addSubview:self.themeBtn3];
            [self.themeBtn3 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.themeBtn2.mas_right).offset(0);
                make.width.offset((kScreenWidth - Margin_leftToCell)/3.0);
                make.centerY.offset(0);
            }];
            [self.themeBtn3 addTarget:self action:@selector(themeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        }
    }
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self endEditing:YES];
    return YES;
}

@end
