//
//  SearchVideoCell.m
//  iCity
//
//  Created by mayonggang on 2018/6/13.
//  Copyright © 2018年 LongYuan. All rights reserved.
//

#import "SearchVideoCell.h"
#import "JstyleNewsJMNumDetailsViewController.h"


@interface SearchVideoCell ()


/**文章标题*/
@property (nonatomic, strong) JstyleLabel *titleLab;

/**视频预览图*/
@property (nonatomic, strong) YYAnimatedImageView *videoImgV;

/**作者头像*/
//@property (nonatomic, strong) UIImageView * headerImgV;青姐说暂时不要头像，日后要的话再加

/**时间*/
@property (nonatomic, strong) UILabel * timeLab;

@end


@implementation SearchVideoCell

+(instancetype)initWithTableView:(UITableView *)tableView {
    
    static NSString * cell_id = @"SearchVideoCell_id";
    SearchVideoCell * cell = [tableView dequeueReusableCellWithIdentifier:cell_id];
    if (!cell) {
        cell = [[SearchVideoCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:cell_id];
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
    
    self.titleLab = [[JstyleLabel alloc]init];
    [self.contentView addSubview:self.titleLab];
    self.titleLab.textColor = kNightModeTextColor;
    self.titleLab.numberOfLines = 2;
    self.titleLab.font = [UIFont systemFontOfSize:18];
    
    
    self.videoImgV = [[YYAnimatedImageView alloc]init];
    self.videoImgV.userInteractionEnabled = YES;
    [self.contentView addSubview:self.videoImgV];
    
//    self.headerImgV = [[UIImageView alloc]init];
//    self.headerImgV.layer.cornerRadius = 10;
//    self.headerImgV.layer.masksToBounds = YES;
//    [self.contentView addSubview:self.headerImgV];
    
    //播放按钮
    UIImageView * playImgV = [[UIImageView alloc]init];
    playImgV.userInteractionEnabled = YES;
    playImgV.image = JSImage(@"search_button_viedo");
    [self.videoImgV addSubview:playImgV];
    
    self.timeLab = [[UILabel alloc]init];
    [self.contentView addSubview:self.timeLab];
    self.timeLab.textColor = kNightModeDescColor;
    self.timeLab.numberOfLines = 2;
    self.timeLab.font = [UIFont systemFontOfSize:12];
    
    
    //-----------------------
    
    
//----------------------------------
    
    
    
    [self.videoImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-10);
        make.top.offset(15);
        make.size.mas_equalTo(CGSizeMake(ArticleImg_W, ArticleImg_H));
    }];
    
    [playImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self.videoImgV);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
    
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(10);
        make.right.mas_equalTo(self.videoImgV.mas_left).offset(-22);
        make.top.offset(15);
    }];
    [self.timeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(10);
        make.bottom.offset(-15);
    }];
    
    [self layoutIfNeeded];
    
    //--------------------------------------------------添加手势
     kweakSelf
    UITapGestureRecognizer *authorTap = [[UITapGestureRecognizer alloc]initWithActionBlock:^(id  _Nonnull sender) {
        JstyleNewsJMNumDetailsViewController *jstyleNewsJmNumsDVC = [JstyleNewsJMNumDetailsViewController new];
        jstyleNewsJmNumsDVC.did = weakSelf.model.author_did;
        [[self viewController].navigationController pushViewController:jstyleNewsJmNumsDVC animated:YES];
    }];
    [self.videoImgV addGestureRecognizer:authorTap];
}

-(void)setModel:(SearchModel *)model {
    _model = model;
    
    self.timeLab.text = [[NSString stringWithFormat:@"%@",model.author_name] stringByAppendingString:[NSString stringWithFormat:@"   %@",[NSDate compareCurrentTimeWithTimeString:model.ctime]]];
    
    
    if (model.key.length==0) {
        
        self.titleLab.attributedText = [[NSString stringWithFormat:@"%@",model.title] attributedStringWithlineSpace:3 font:JSFont(18)];
    }else{
        self.titleLab.attributedText = [[NSString stringWithFormat:@"%@",model.title] attributedStringWithKey:model.key lineSpace:3 font:JSFont(18)];
    }
    
    
    [self.videoImgV setImageWithURL:[NSURL URLWithString:model.poster] placeholder:SZ_Place_S_N options:(YYWebImageOptionSetImageWithFadeAnimation) completion:nil];
    
//    [self.headerImgV setImageWithURL:[NSURL URLWithString:model.author_img] placeholder:JSImage(@"placeholder") options:(YYWebImageOptionSetImageWithFadeAnimation) completion:nil];
    
    
}



@end
