//
//  NewsPaperCell.m
//  iCity
//
//  Created by mayonggang on 2018/6/14.
//  Copyright © 2018年 LongYuan. All rights reserved.
//

#import "NewsPaperCell.h"
#import "UILabel+Addition.h"
#import "UIColor+Addition.h"

//横向比例
#define WidthScale(number) ([UIScreen mainScreen].bounds.size.width/375.*(number))
//纵向比例
#define HeightScale(number) ([UIScreen mainScreen].bounds.size.height/667.*(number))
@interface NewsPaperCell ()
//报纸图标
@property (weak, nonatomic)UIImageView *paperImage;
///报纸名字
@property (weak, nonatomic)UILabel *nameLabel;
///时间
@property (weak, nonatomic)UILabel *timeLabel;

@end

@implementation NewsPaperCell

+(instancetype)initWithTableView:(UITableView *)tableView {
    
    static NSString * cell_id = @"NewsPaperCell_id";
    NewsPaperCell * cell = [tableView dequeueReusableCellWithIdentifier:cell_id];
    if (!cell) {
        cell = [[NewsPaperCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:cell_id];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupViews];
    }
    return self;
}

- (void)setupViews {
    
    
//    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(10, 10, 117, 66)];
//    view.layer.shadowRadius = 2;
//    view.layer.shadowColor = [UIColor grayColor].CGColor;
//    view.layer.shadowOffset = CGSizeMake(1, 1);
//    //width表示阴影与x的便宜量,height表示阴影与y值的偏移量
//    view.layer.shadowOpacity = 0.4;//阴影透明度,默认为0则看不到阴影
//    view.backgroundColor = kWhiteColor;
//    [self.contentView addSubview:view];
    ///报纸大标志
    UIImageView *paperImage = [[UIImageView alloc] init];
    self.paperImage = paperImage;
    self.paperImage.contentMode = UIViewContentModeScaleAspectFit;
    
    [self.contentView addSubview:paperImage];
    [paperImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(10);
        make.width.offset(117);//66高
        make.top.offset(10);
        make.bottom.offset(-10);
    }];
    
    
    ///报纸名字
    UILabel *nameLabel = [UILabel makeLabelWithTextColor:kNightModeTextColor andTextFont:17 andContentText:@"宁波报纸"];
    self.nameLabel = nameLabel;
    [self.contentView addSubview:nameLabel];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.paperImage.mas_top).offset(12);
        make.left.equalTo(self.paperImage.mas_right).offset(23);
        
    }];
    //时间
    UILabel *timeLabel = [UILabel makeLabelWithTextColor:kNightModeDescColor andTextFont:13 andContentText:@"2018-06-13"];
    self.timeLabel = timeLabel;
    
    [self.contentView addSubview:timeLabel];
    [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.paperImage.mas_right).offset(23);
        make.bottom.mas_equalTo(self.paperImage.mas_bottom).offset(-12);
    }];
    
    
    UIImageView *playerImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"paper_icon_more"]];
    [self addSubview:playerImg];
    [playerImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.offset(0);
        make.right.offset(-10);
    }];
    
    self.contentView.backgroundColor = kNightModeBackColor;
    
}
-(void)setModel:(NewspaperModel *)model {
    _model = model;
    [self.paperImage setImageWithURL:[NSURL URLWithString:model.poster] placeholder:SZ_Place_S_N];


    self.nameLabel.text = model.name == nil ? @"" : model.name;;
    self.timeLabel.text = model.start_time == nil ? @"" : model.start_time;;

}





@end
