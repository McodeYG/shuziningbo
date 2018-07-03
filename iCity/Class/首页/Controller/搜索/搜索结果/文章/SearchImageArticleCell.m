//
//  SearchImageArticleCell.m
//  iCity
//
//  Created by mayonggang on 2018/6/12.
//  Copyright © 2018年 LongYuan. All rights reserved.
//

#import "SearchImageArticleCell.h"

@interface SearchImageArticleCell ()


/**文章标题*/
@property (nonatomic, strong) UILabel * titleLab;

/**left*/
@property (nonatomic, strong) UIImageView * leftImg;
/**中间的*/
@property (nonatomic, strong) UIImageView * midImg;
/**right*/
@property (nonatomic, strong) UIImageView * rightImg;

/**时间*/
@property (nonatomic, strong) UILabel * timeLab;

@end


@implementation SearchImageArticleCell

+(instancetype)initWithTableView:(UITableView *)tableView {
    
    static NSString * cell_id = @"SearchImageArticleCell_id";
    SearchImageArticleCell * cell = [tableView dequeueReusableCellWithIdentifier:cell_id];
    if (!cell) {
        cell = [[SearchImageArticleCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:cell_id];
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
    
    self.titleLab = [[UILabel alloc]init];
    [self.contentView addSubview:self.titleLab];
    self.titleLab.textColor = kNightModeTextColor;
    self.titleLab.numberOfLines = 2;
    self.titleLab.font = [UIFont systemFontOfSize:18];
    
    
    self.leftImg = [[UIImageView alloc]init];
    [self.contentView addSubview:self.leftImg];
    
    self.midImg = [[UIImageView alloc]init];
    [self.contentView addSubview:self.midImg];
    
    self.rightImg = [[UIImageView alloc]init];
    [self.contentView addSubview:self.rightImg];
    
    self.timeLab = [[UILabel alloc]init];
    [self.contentView addSubview:self.timeLab];
    self.timeLab.textColor = kNightModeDescColor;
    self.timeLab.numberOfLines = 2;
    self.timeLab.font = [UIFont systemFontOfSize:12];
    
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(10);
        make.right.offset(-10);
        make.top.offset(15);
    }];
    CGFloat img_W = ArticleImg_W;
    CGFloat img_H = img_W/16*10;
    [self.leftImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(10);
        make.top.mas_equalTo(self.titleLab.mas_bottom).offset(10);
        make.width.mas_equalTo(img_W);
        make.height.mas_equalTo(img_H);
    }];
    [self.midImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.leftImg.mas_right).offset(4);
        make.top.mas_equalTo(self.titleLab.mas_bottom).offset(10);
        make.width.mas_equalTo(img_W);
        make.height.mas_equalTo(img_H);
    }];
    [self.rightImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.midImg.mas_right).offset(4);
        make.top.mas_equalTo(self.titleLab.mas_bottom).offset(10);
        make.width.mas_equalTo(img_W);
        make.height.mas_equalTo(img_H);
    }];
    [self.timeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(10);
        make.top.mas_equalTo(self.leftImg.mas_bottom).offset(10);
    }];
    
    [self layoutIfNeeded];
}

-(void)setModel:(SearchModel *)model {
    _model = model;
    
//    self.timeLab.text = [NSString stringWithFormat:@"%@",model.ctime];
    self.timeLab.text = [[NSString stringWithFormat:@"%@",model.author_name] stringByAppendingString:[NSString stringWithFormat:@"   %@",[NSDate compareCurrentTimeWithTimeString:model.ctime]]];
    if (model.key.length==0) {
        NSLog(@"%@",model.title);
        self.titleLab.attributedText = [[NSString stringWithFormat:@"%@",model.title] attributedStringWithlineSpace:3 font:JSFont(18)];
    }else{
        self.titleLab.attributedText = [[NSString stringWithFormat:@"%@",model.title] attributedStringWithKey:model.key lineSpace:3 font:JSFont(18)];
    }
    
    if (model.imgs) {
        if (model.imgs.count>2) {
            [self.leftImg sd_setImageWithURL:[NSURL URLWithString:model.imgs.firstObject] placeholderImage:SZ_Place_S_N];
            [self.midImg sd_setImageWithURL:[NSURL URLWithString:model.imgs[1]] placeholderImage:SZ_Place_S_N];
            [self.rightImg sd_setImageWithURL:[NSURL URLWithString:model.imgs.lastObject] placeholderImage:SZ_Place_S_N];
        }
    }
}




@end
