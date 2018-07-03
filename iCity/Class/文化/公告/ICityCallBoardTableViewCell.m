//
//  ICityCallBoardTableViewCell.m
//  iCity
//
//  Created by 王磊 on 2018/5/1.
//  Copyright © 2018年 LongYuan. All rights reserved.
//

#import "ICityCallBoardTableViewCell.h"

@interface ICityCallBoardTableViewCell()

@property (nonatomic, strong) UILabel *callboardNameLabel;

@property (nonatomic, strong) UIView *topLine;

@property (nonatomic, strong) UIView *bottomLine;

@end

@implementation ICityCallBoardTableViewCell

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
    
    self.callboardNameLabel = [UILabel labelWithColor:kNightModeTextColor fontSize:14 text:@"公告" alignment:NSTextAlignmentCenter];
    [self.callboardNameLabel sizeToFit];
    [self.contentView addSubview:self.callboardNameLabel];
    [self.callboardNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.offset(0);
        make.left.offset(10);
    }];
    
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = JSColor(@"#DDDDDD");
    [self.contentView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.offset(0);
        make.height.offset(14);
        make.width.offset(0.5);
        make.left.equalTo(self.callboardNameLabel.mas_right).offset(5);
    }];
    
//    UIImageView *iconImageView = [[UIImageView alloc] initWithImage:JSImage(@"")];
//    [self.contentView addSubview:iconImageView];
//    [iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.offset(0);
//        make.left.equalTo(line.mas_right).offset(5);
//    }];
    //轮播广告
    UIView *callBoardHoldView = [[UIView alloc] init];
    self.callBoardHoldView = callBoardHoldView;
    [self.contentView addSubview:callBoardHoldView];
    [callBoardHoldView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(line.mas_right).offset(10);
        make.top.bottom.right.offset(0);
    }];
    
    
    
    _topLine = [[UIView alloc] init];
    [self.contentView addSubview:_topLine];
    [_topLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(0);
        make.height.offset(5);
        make.left.offset(0);
        make.right.offset(0);
    }];
    
    _bottomLine = [[UIView alloc] init];
    [self.contentView addSubview:_bottomLine];
    [_bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.offset(0);
        make.height.offset(5);
        make.left.offset(0);
        make.right.offset(0);
    }];
    
    [self applyTheme];
}

- (void)applyTheme {
    [super applyTheme];
    _bottomLine.backgroundColor = kNightModeLineColor;
    _topLine.backgroundColor = kNightModeLineColor;
    self.callboardNameLabel.textColor = kNightModeTextColor;
}

@end
