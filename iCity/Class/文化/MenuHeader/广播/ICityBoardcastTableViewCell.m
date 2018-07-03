//
//  ICityBoardcastTableViewCell.m
//  HSQiCITY
//
//  Created by chunzheng wang on 2018/5/1.
//  Copyright © 2018年 chunzheng wang. All rights reserved.
//

#import "ICityBoardcastTableViewCell.h"
#import <Masonry.h>
#import "UILabel+Addition.h"
#import "UIColor+Addition.h"

//横向比例
#define WidthScale(number) ([UIScreen mainScreen].bounds.size.width/375.*(number))
//纵向比例
#define HeightScale(number) ([UIScreen mainScreen].bounds.size.height/667.*(number))
@interface ICityBoardcastTableViewCell ()
///tvBigImg 电视台大标志
@property (weak, nonatomic)UIImageView *tvBigImg;
///电视台名字
@property (weak, nonatomic)UILabel *tvNameLabel;
///描述
@property (weak, nonatomic)UILabel *desLabel;
///人数
@property (weak, nonatomic)UILabel *peopleLabel;

@end
@implementation ICityBoardcastTableViewCell

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
-(void)setupUI {
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    UIImageView *tvBigImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pic2"]];
    self.tvBigImg = tvBigImg;
    
    [self addSubview:tvBigImg];
    [tvBigImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(10);
        make.top.offset(10);
        make.width.offset(75);
        make.height.offset(75);
    }];
    UILabel *tvNameLabel = [UILabel makeLabelWithTextColor:[UIColor colorWithHex:0x222222] andTextFont:17 andContentText:@"宁波交通广播"];
    self.tvNameLabel = tvNameLabel;
    
    [self addSubview:tvNameLabel];
    [tvNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(13);
        make.left.equalTo(tvBigImg.mas_right).offset(20);
        
    }];
    UILabel *desLabel = [UILabel makeLabelWithTextColor:[UIColor colorWithHex:0x666666] andTextFont:13 andContentText:@"正在直播：1028交通服务热线"];
    self.desLabel = desLabel;
    [self addSubview:desLabel];
    [desLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(tvNameLabel.mas_left).offset(0);
        make.top.equalTo(tvNameLabel.mas_bottom).offset(8);
        
    }];
    
    
    UIImageView *sanJiaoImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"content_icon_listen_default"]];
    [self addSubview:sanJiaoImg];
    [sanJiaoImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(desLabel.mas_left).offset(0);
        make.top.equalTo(desLabel.mas_bottom).offset(11);
        ///宽7 高9
        make.width.offset(WidthScale(7));
        make.height.offset(HeightScale(9));
        
    }];
    ///renshu
    UILabel *peopleLabel = [UILabel makeLabelWithTextColor:[UIColor colorWithHex:0x999999] andTextFont:10 andContentText:@"555W"];
    self.peopleLabel = peopleLabel;
    [self addSubview:peopleLabel];
    [peopleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(sanJiaoImg.mas_right).offset(7);
        make.centerY.equalTo(sanJiaoImg.mas_centerY).offset(0);
        
    }];
    
    NSString * str = ISNightMode?@"content_button_play_night":@"content_button_play_default";
    UIImageView *playerImg = [[UIImageView alloc] init];
    playerImg.image = [UIImage imageNamed:str];
    [self addSubview:playerImg];
    [playerImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(28*kScale);
        make.height.mas_equalTo(28*kScale);
        make.centerY.offset(0);
        make.right.offset(-10);
    }];
   
    
    self.contentView.backgroundColor = kNightModeBackColor;
    self.tvNameLabel.textColor = kNightModeTextColor;
    
}

-(void)setModel:(ICityBoradcastModel *)model {
    _model = model;
    [self.tvBigImg setImageWithURL:[NSURL URLWithString:model.picture] placeholder:SZ_Place_S_N];
    self.tvNameLabel.text = model.radioname == nil ? @"" : model.radioname;
    self.desLabel.text = [NSString stringWithFormat:@"%@：%@",(model.playstate.integerValue == 1 ? @"正在播放":@""), model.showname];
    self.peopleLabel.text = model.packagenum == nil ? @"" : model.packagenum;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
