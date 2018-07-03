//
//  SearchTextArticleCell.m
//  iCity
//
//  Created by mayonggang on 2018/6/13.
//  Copyright © 2018年 LongYuan. All rights reserved.
//

#import "SearchTextArticleCell.h"


@interface SearchTextArticleCell ()


/**文章标题*/
@property (nonatomic, strong) UILabel * titleLab;

/**right*/
@property (nonatomic, strong) UIImageView * rightImg;

/**时间*/
@property (nonatomic, strong) UILabel * timeLab;

@end


@implementation SearchTextArticleCell

+(instancetype)initWithTableView:(UITableView *)tableView {
    
    static NSString * cell_id = @"SearchTextArticleCell_id";
    SearchTextArticleCell * cell = [tableView dequeueReusableCellWithIdentifier:cell_id];
    if (!cell) {
        cell = [[SearchTextArticleCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:cell_id];
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
    
    [self.rightImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-10);
        make.top.offset(15);
        make.size.mas_equalTo(CGSizeMake(ArticleImg_W, ArticleImg_H));
    }];
    
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(10);
        make.right.mas_equalTo(self.contentView).offset(-30-ArticleImg_W);
        make.top.offset(15);
    }];
    [self.timeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(10);
        make.bottom.offset(-15);
    }];
    
}


-(void)setModel:(SearchModel *)model {
    _model = model;
    
    if ([model.poster isNotBlank]) {
        self.rightImg.hidden = NO;
        [self.titleLab mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.contentView).offset(-30-ArticleImg_W);
        }];
    }else {
        self.rightImg.hidden = YES;
        [self.titleLab mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.contentView).offset(-10);
        }];
    }
    self.timeLab.text = [[NSString stringWithFormat:@"%@",model.author_name] stringByAppendingString:[NSString stringWithFormat:@"   %@",[NSDate compareCurrentTimeWithTimeString:model.ctime]]];
    
    if (model.key.length==0) {
        NSLog(@"%@",model.title);
        self.titleLab.attributedText = [[NSString stringWithFormat:@"%@",model.title] attributedStringWithlineSpace:3 font:JSFont(18)];
    }else{
         self.titleLab.attributedText = [[NSString stringWithFormat:@"%@",model.title] attributedStringWithKey:model.key lineSpace:3 font:JSFont(18)];
    }
       
    [self.rightImg sd_setImageWithURL:[NSURL URLWithString:model.poster] placeholderImage:SZ_Place_S_N];
}

@end
