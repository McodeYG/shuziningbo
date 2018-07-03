//
//  SearchPicturesCell.m
//  iCity
//
//  Created by mayonggang on 2018/6/13.
//  Copyright © 2018年 LongYuan. All rights reserved.
//

#import "SearchPicturesCell.h"

@interface SearchPicturesCell ()


/**文章标题*/
@property (nonatomic, strong) UILabel * titleLab;

/**大图*/
@property (nonatomic, strong) UIImageView * rightImg;

/**时间*/
@property (nonatomic, strong) UILabel * timeLab;

/**黑色背景view*/
@property (nonatomic, strong) UIView *holdView;
/**icon*/
@property (nonatomic, strong) UIImageView *iconImageView;
/**图片数量*/
@property (nonatomic, strong) UILabel *imageNumLabel;

@end


@implementation SearchPicturesCell

+(instancetype)initWithTableView:(UITableView *)tableView {
    
    static NSString * cell_id = @"SearchPicturesCell_id";
    SearchPicturesCell * cell = [tableView dequeueReusableCellWithIdentifier:cell_id];
    if (!cell) {
        cell = [[SearchPicturesCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:cell_id];
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
    
    //图片
    self.rightImg = [[UIImageView alloc]init];
    [self.contentView addSubview:self.rightImg];
    //标题
    self.titleLab = [[UILabel alloc]init];
    [self.contentView addSubview:self.titleLab];
    self.titleLab.textColor = kNightModeTextColor;
    self.titleLab.numberOfLines = 2;
    self.titleLab.font = [UIFont systemFontOfSize:18];
    
    //时间
    self.timeLab = [[UILabel alloc]init];
    [self.contentView addSubview:self.timeLab];
    self.timeLab.textColor = kNightModeDescColor;
    self.timeLab.numberOfLines = 2;
    self.timeLab.font = [UIFont systemFontOfSize:12];
    
    //
    self.holdView = [[UIView alloc]init];
    [self.rightImg addSubview:self.holdView];
    self.holdView.backgroundColor = [kDarkZeroColor colorWithAlphaComponent:0.33];
    self.holdView.layer.cornerRadius = 10;
    self.holdView.layer.masksToBounds = YES;
    //图片数数字
    self.imageNumLabel = [[UILabel alloc]init];
    self.imageNumLabel.textColor = kWhiteColor;
    self.imageNumLabel.font = JSFont(11);
    [self.holdView addSubview:self.imageNumLabel];
    //图片数图标
    self.iconImageView = [[UIImageView alloc]init];
    self.iconImageView.image = JSImage(@"图片数");
    [self.holdView addSubview:self.iconImageView];
    
    
    
    [self.rightImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-10);
        make.top.offset(15);
        make.size.mas_equalTo(CGSizeMake(ArticleImg_W, ArticleImg_H));
    }];
    
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(10);
        make.right.mas_equalTo(self.rightImg.mas_left).offset(-22);
        make.top.offset(15);
    }];
    [self.timeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(10);
        make.bottom.offset(-15);
    }];
    
    [self.holdView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.rightImg.bottom).offset(-6);
        make.right.mas_equalTo(self.rightImg.mas_right).offset(-10);
        make.height.mas_equalTo(20);
        make.width.mas_greaterThanOrEqualTo(25);
    }];
    
    [self.imageNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.holdView.mas_right).offset(-5);
        make.centerY.mas_equalTo(self.holdView);
        make.height.mas_equalTo(11);
        make.left.mas_equalTo(self.holdView).offset(5+11+5);
        make.width.mas_lessThanOrEqualTo(50);
    }];
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.imageNumLabel.mas_left).offset(-5);
        make.centerY.mas_equalTo(self.holdView);
        make.height.mas_equalTo(11);
        make.width.mas_equalTo(11);
    }];
    
}


-(void)setModel:(SearchModel *)model {
    _model = model;
    
    self.timeLab.text = [[NSString stringWithFormat:@"%@",model.author_name] stringByAppendingString:[NSString stringWithFormat:@"   %@",[NSDate compareCurrentTimeWithTimeString:model.ctime]]];
    
    if (model.key.length==0) {
        NSLog(@"%@",model.title);
        self.titleLab.attributedText = [[NSString stringWithFormat:@"%@",model.title] attributedStringWithlineSpace:3 font:JSFont(18)];
    }else{
        self.titleLab.attributedText = [[NSString stringWithFormat:@"%@",model.title] attributedStringWithKey:model.key lineSpace:3 font:JSFont(18)];
    }

    [self.rightImg setImageWithURL:[NSURL URLWithString:model.poster] placeholder:SZ_Place_S_N options:(YYWebImageOptionSetImageWithFadeAnimation) completion:nil];
    
     self.imageNumLabel.text = [NSString stringWithFormat:@"%@图", model.posternum];
}



@end

