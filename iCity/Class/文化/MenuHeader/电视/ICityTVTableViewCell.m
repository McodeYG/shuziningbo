//
//  ICityTVTableViewCell.m
//  ICityTable
//
//  Created by chunzheng wang on 2018/5/1.
//  Copyright © 2018年 chunzheng wang. All rights reserved.
//

#import "ICityTVTableViewCell.h"
#import <Masonry.h>
#import "UILabel+Addition.h"
#import "UIColor+Addition.h"
#import "JstyleNewsBaseAttentionButton.h"

//横向比例
#define WidthScale(number) ([UIScreen mainScreen].bounds.size.width/375.*(number))
//纵向比例
#define HeightScale(number) ([UIScreen mainScreen].bounds.size.height/667.*(number))
@interface ICityTVTableViewCell ()
///tvBigImg 电视台大标志
@property (weak, nonatomic)UIImageView *tvBigImg;
///littleTVImg 电视台小标志
@property (weak, nonatomic)UIImageView *littleTVImg;
///时间
@property (weak, nonatomic)UILabel *timeLabel;
///电视台名字
@property (weak, nonatomic)UILabel *tvNameLabel;
///集数
@property (weak, nonatomic)UILabel *jiShuLabel;

/**关注按钮*/
@property (nonatomic, strong) JstyleNewsBaseAttentionButton * attentionBtn;

@end

@implementation ICityTVTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setupUI];
    // Initialization code
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    ///电视台大图
    UIImageView *tvBigImg = [[UIImageView alloc] init];
    self.tvBigImg = tvBigImg;
    tvBigImg.contentMode = UIViewContentModeScaleAspectFill;
    tvBigImg.clipsToBounds = YES;
    [self.contentView addSubview:tvBigImg];
    [tvBigImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(10);
        make.width.mas_equalTo(100*IPhone4_Scale);
        make.centerY.mas_equalTo(self.contentView);
        make.height.mas_equalTo(62*IPhone4_Scale);
        
    }];
    ///电视台小标志
    UIImageView *littleTVImg = [[UIImageView alloc] init];
    self.littleTVImg = littleTVImg;
    
    [self.contentView addSubview:littleTVImg];
    [littleTVImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(17/IPhone4_Scale);
        make.left.equalTo(tvBigImg.mas_right).offset(15*IPhone4_Scale);
        make.width.offset(33*IPhone4_Scale);
        make.height.offset(33*IPhone4_Scale);
    }];
    littleTVImg.layer.cornerRadius = (33*IPhone4_Scale)/2.0;
    littleTVImg.layer.masksToBounds = YES;

    

    ///电视台名字
    UILabel *tvNameLabel = [UILabel makeLabelWithTextColor:kNightModeTextColor andTextFont:17*kScale andContentText:@"宁波电视台"];
    self.tvNameLabel = tvNameLabel;
    [self.contentView addSubview:tvNameLabel];
    [tvNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(littleTVImg.mas_centerY).offset(0);
        make.left.equalTo(littleTVImg.mas_right).offset(12);
        make.right.equalTo(self.contentView.mas_right).offset(-66);
        
    }];
    //集数
    UILabel *jiShuLabel = [UILabel makeLabelWithTextColor:[UIColor colorWithHex:0xFF666666] andTextFont:13*kScale andContentText:@"小猪配骑-33集"];
    self.jiShuLabel = jiShuLabel;

    [self.contentView addSubview:jiShuLabel];
    [jiShuLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(tvNameLabel.mas_left).offset(0);
        make.top.equalTo(self.tvNameLabel.mas_bottom).offset(8);
        make.right.equalTo(self.contentView.mas_right).offset(-64);
    }];
    //时间图标
    UIImageView * timeIcon = [[UIImageView alloc]init];
    timeIcon.image = [UIImage imageNamed:@"tv_icon_time"];
    [self.contentView addSubview:timeIcon];
    [timeIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.tvNameLabel);
        make.top.mas_equalTo(self.jiShuLabel.mas_bottom).offset(8);
        make.size.mas_equalTo(CGSizeMake(12, 12));
    }];

    //时间label
    UIColor * color = ISNightMode?[UIColor colorFromHexString:@"#666666"]:[UIColor colorFromHexString:@"#999999"];
    UILabel *timeLabel= [UILabel makeLabelWithTextColor:color andTextFont:12*kScale andContentText:@"19:30~20:45"];
    [self.contentView addSubview:timeLabel];
    self.timeLabel = timeLabel;

    [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(timeIcon.mas_right).offset(3);
        make.centerY.mas_equalTo(timeIcon);
    }];
    
    
    
//    NSString * str = ISNightMode?@"content_button_play_night":@"content_button_play_default";
//    
//    UIImageView *playerImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:str]];
//    [self.contentView addSubview:playerImg];
//    [playerImg mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.offset(0);
//        make.right.offset(-10);
//    }];
    
    
    //关注按钮
    self.attentionBtn = [JstyleNewsBaseAttentionButton buttonWithType:(UIButtonTypeCustom)];
    self.attentionBtn.frame = CGRectMake(SCREEN_W-60, (96-24)/2, 50, 24);
    [self.contentView addSubview:self.attentionBtn];
    self.attentionBtn.normal_title = @"关注";
    self.attentionBtn.layer.cornerRadius = 13;
    self.attentionBtn.layer.masksToBounds = YES;
    
    [self.attentionBtn addTarget:self action:@selector(focusBtnClicked:) forControlEvents:(UIControlEventTouchUpInside)];
    
    self.contentView.backgroundColor = kNightModeBackColor;

}
-(void)setModel:(ICityTVModel *)model {
    
    _model = model;
    [self.tvBigImg setImageWithURL:[NSURL URLWithString:model.picture] placeholder:JSImage(@"placeholder")];
    [self.littleTVImg setImageWithURL:[NSURL URLWithString:model.icon] placeholder:[UIImage imageNamed:@"placeholder_small"]];

    if (![model.start_time isNotBlank]) {
        model.start_time = @"";
    }
    if (![model.end_time isNotBlank]) {
        model.end_time = @"";
    }
    
    self.timeLabel.text = [NSString stringWithFormat:@"%@ ~ %@",model.start_time,model.end_time];
    self.tvNameLabel.text = model.televisionname == nil ? @"" : model.televisionname;;
    self.jiShuLabel.text = model.videoname == nil ? @"" : model.videoname;
    if ([model.isShowAuthor integerValue] == 1) {
        self.attentionBtn.selected = YES;
    }else{
        self.attentionBtn.selected = NO;
        
    }
    
}

- (void)focusBtnClicked:(UIButton *)sender
{
    if (self.focusBlock) {
        self.focusBlock(_model);
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
