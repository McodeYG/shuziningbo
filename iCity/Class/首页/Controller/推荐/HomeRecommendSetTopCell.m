//
//  HomeRecommendSetTopCell.m
//  iCity
//
//  Created by mayonggang on 2018/6/4.
//  Copyright © 2018年 LongYuan. All rights reserved.
//

#import "HomeRecommendSetTopCell.h"

@interface HomeRecommendSetTopCell ()

//图片
@property (nonatomic,strong)UIImageView * imgView;
//标题
@property (nonatomic,strong)UILabel * titleLab;
//发布 时间
@property (nonatomic,strong)UILabel * subLab;
//置顶
@property (nonatomic,strong)UILabel * setTopLab;

@property (nonatomic, strong) JstyleNewsHomePageModel *model;

@end

@implementation HomeRecommendSetTopCell

+ (instancetype)initWithTableView:(UITableView *)tableView
{
    static NSString * cell_ID = @"HomeRecommendSetTopCell_id";
    HomeRecommendSetTopCell * cell = [tableView dequeueReusableCellWithIdentifier:cell_ID];
    if (!cell) {
        cell = [[HomeRecommendSetTopCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:cell_ID];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self setUpSubview];
        
    }
    return self;
}


- (void)setUpSubview
{
    //图片
    self.imgView = [[UIImageView alloc]init];
    [self.contentView addSubview:self.imgView];
    //标题
    self.titleLab = [[UILabel alloc]init];
    self.titleLab.numberOfLines = 2;
    self.titleLab.font = JSTitleFont;
    [self.contentView addSubview:self.titleLab];
    self.titleLab.text = @"哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈啊哈哈哈";

    //发布 时间
    self.subLab = [[UILabel alloc]init];
    self.subLab.font = [UIFont systemFontOfSize:12];
    self.subLab.textColor = kDarkNineColor;
    [self.contentView addSubview:self.subLab];
    //置顶
    self.setTopLab = [[UILabel alloc]init];
    self.setTopLab.font = [UIFont systemFontOfSize:12];
    self.setTopLab.textColor = [UIColor colorFromHexString:@"ee6767"];
    self.setTopLab.layer.borderWidth = 1;
    self.setTopLab.layer.lee_theme
    .LeeConfigBorderColor(@"setupLabelLayer");
    self.setTopLab.hidden = YES;
    
    self.setTopLab.layer.masksToBounds = YES;
    self.setTopLab.layer.cornerRadius = 3;
    self.setTopLab.text = @"置顶";
    self.setTopLab.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:self.setTopLab];
    
    [self updateView];
    [self applyTheme];
}
- (void)updateView {
    
    //图片
    [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.contentView.mas_right).mas_equalTo(-10);
        make.top.mas_equalTo(self.contentView).mas_equalTo(18);
        make.width.mas_equalTo(111);
        make.height.mas_equalTo(70);
    }];
    //标题
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView).offset(10);
        make.right.mas_equalTo(self.imgView.mas_left).mas_equalTo(-8);
        make.top.mas_equalTo(self.contentView).mas_equalTo(16);
    }];
    
    //置顶
    [self.setTopLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.imgView.mas_bottom).offset(1);
        make.left.mas_equalTo(self.contentView).mas_equalTo(10);
        make.width.mas_equalTo(30);
        make.height.mas_equalTo(16);
    }];
    
    //平台 时间
    [self.subLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.imgView.mas_bottom).offset(1);
        make.left.mas_equalTo(self.contentView.mas_left).mas_equalTo(10+30+8);
        make.width.mas_equalTo(129);
        make.height.mas_equalTo(13);
    }];

    
}

- (void)setModel:(JstyleNewsHomePageModel *)model withIndex:(NSIndexPath *)index
{
    _model = model;
    
    [self.imgView setImageWithURL:[NSURL URLWithString:model.poster] placeholder:SZ_Place_S_N options:(YYWebImageOptionSetImageWithFadeAnimation) completion:nil];
    
    self.titleLab.attributedText = [[NSString stringWithFormat:@"%@",model.title] attributedStringWithlineSpace:3 font:JSTitleFont];
    
    if (index.section==0) {
        self.subLab.text = [[NSString stringWithFormat:@"%@",model.author_name] stringByAppendingString:[NSString stringWithFormat:@"   %@",@"刚刚"]];
    }
    //[NSDate compareCurrentTimeWithTimeString:model.ctime]
    if (index.row<2) {
        self.setTopLab.hidden = NO;
        [self.subLab mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.contentView.mas_left).mas_equalTo(10+30+8);

        }];
    }else{
        self.setTopLab.hidden = YES;
        [self.subLab mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.contentView.mas_left).mas_equalTo(10);

        }];
    }
}

- (void)applyTheme {
    [super applyTheme];
    
    self.titleLab.textColor = kNightModeTextColor;
}


@end
