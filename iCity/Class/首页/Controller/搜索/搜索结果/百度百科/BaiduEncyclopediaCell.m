//
//  BaiduEncyclopediaCell.m
//  iCity
//
//  Created by mayonggang on 2018/6/13.
//  Copyright © 2018年 LongYuan. All rights reserved.
//

#import "BaiduEncyclopediaCell.h"
#import "UIImageView+JstyleWebCache.h"

@interface BaiduEncyclopediaCell ()


/**文章标题*/
@property (nonatomic, strong) UILabel * titleLab;

/**right*/
@property (nonatomic, strong) UIImageView * rightImg;

/**时间*/
@property (nonatomic, strong) UILabel * infoLab;

@end


@implementation BaiduEncyclopediaCell

+(instancetype)initWithTableView:(UITableView *)tableView {
    
    static NSString * cell_id = @"BaiduEncyclopediaCell_id";
    BaiduEncyclopediaCell * cell = [tableView dequeueReusableCellWithIdentifier:cell_id];
    if (!cell) {
        cell = [[BaiduEncyclopediaCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:cell_id];
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
    self.titleLab.font = [UIFont systemFontOfSize:18];
    
    //简介
    self.infoLab = [[UILabel alloc]init];
    [self.contentView addSubview:self.infoLab];
    self.infoLab.textColor = kNightModeDescColor;
    self.infoLab.numberOfLines = 3;
    self.infoLab.font = [UIFont systemFontOfSize:16];
    
    [self.rightImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-10);
        make.top.offset(15);
        make.size.mas_equalTo(CGSizeMake(ArticleImg_W, ArticleImg_W));
    }];
    
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(15);
        make.left.offset(10);
        make.height.mas_equalTo(18);
        make.right.mas_equalTo(self.contentView.mas_right).offset(-22-ArticleImg_W-10);
    }];
    [self.infoLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(10);
        make.right.mas_equalTo(self.contentView.mas_right).offset(-22-ArticleImg_W-10);
        make.top.mas_equalTo(self.titleLab.mas_bottom).offset(7);
        make.bottom.offset(-12);
    }];
    
}


-(void)setModel:(SearchModel *)model {
    
    _model = model;
    
    if (model.key.length==0) {
        self.titleLab.attributedText = [[NSString stringWithFormat:@"%@",model.title] attributedStringWithlineSpace:0 font:JSFont(18)];
        
        self.infoLab.attributedText = [[NSString stringWithFormat:@"%@",model.content] attributedStringWithlineSpace:3 font:JSFont(16)];
        
    }else{
        self.titleLab.attributedText = [[NSString stringWithFormat:@"%@",model.title] attributedStringWithKey:model.key lineSpace:0 font:JSFont(18)];
        
        
        self.infoLab.attributedText  = [[NSString stringWithFormat:@"%@",model.content] attributedStringWithKey:model.key lineSpace:3 font:JSFont(16)];
    }
//    model.poster = @"http://admin.jstyle.cn:12000/jstyle_headline/upimage/1520562876150.jpg";
    
//   NSString * urlString = [model.poster stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//    NSLog(@"---%@----%@-----%d",model.poster,model.title,[model.poster isNotBlank]);
    if ([model.poster isNotBlank]) {
        self.rightImg.hidden = NO;
        [self.rightImg sd_setImageWithURL:[NSURL URLWithString:model.poster] placeholderImage:SZ_Place_Header];
        [self.titleLab mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.contentView.mas_right).offset(-22-ArticleImg_W-10);
        }];
        [self.infoLab mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.contentView.mas_right).offset(-22-ArticleImg_W-10);
        }];
    } else {
        self.rightImg.hidden = YES;
        [self.titleLab mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.contentView.mas_right).offset(-10);
        }];
        [self.infoLab mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.contentView.mas_right).offset(-10);
        }];
        
        
    }
    

    

//    [self.rightImg sd_setImageWithURL:[NSURL URLWithString:model.poster] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
    
//        NSLog(@"错误信息:%@",error);
        
//    }];
}


@end
