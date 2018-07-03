//
//  RepositoryDetailRightCell.m
//  iCity
//
//  Created by mayonggang on 2018/6/22.
//  Copyright © 2018年 LongYuan. All rights reserved.
//

#import "RepositoryDetailRightCell.h"

#import "JstyleNewsBaseAttentionButton.h"

@interface RepositoryDetailRightCell ()

/**图片*/
@property (nonatomic, strong) UIImageView * headerImg;
/**媒体名*/
@property (nonatomic, strong) UILabel * nameLabel;
/**媒体描述*/
@property (nonatomic, strong) UILabel * desLabel;

/**关注按钮*/
@property (nonatomic, strong) JstyleNewsBaseAttentionButton * attentionBtn;

@end

@implementation RepositoryDetailRightCell


+(instancetype)initWithTableView:(UITableView *)tableView {
    RepositoryDetailRightCell * cell = [tableView dequeueReusableCellWithIdentifier:@"RepositoryDetailRightCell_id"];
    if (!cell) {
        cell = [[RepositoryDetailRightCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"RepositoryDetailRightCell_id"];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews {
    
    //头像
    self.headerImg = [[UIImageView alloc]initWithFrame:CGRectMake(17, 20, 40, 40)];
    [self.contentView addSubview:self.headerImg];
    self.headerImg.layer.cornerRadius = 20;
    self.headerImg.layer.masksToBounds = YES;
    self.headerImg.layer.borderColor = JSColor(@"#DEDEDE").CGColor;
    self.headerImg.layer.borderWidth = 0.5;
    //姓名
    self.nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(17+40+12, 20, SCREEN_W-104-17-40-12-65, 15)];
    [self.contentView addSubview:self.nameLabel];
    self.nameLabel.font = [UIFont systemFontOfSize:15];
    
    //描述
    self.desLabel = [[UILabel alloc]initWithFrame:CGRectMake(17+40+12, 60-12, SCREEN_W-104-17-40-12-65, 12)];
    [self.contentView addSubview:self.desLabel];
    self.desLabel.font = [UIFont systemFontOfSize:15];
    
    //关注按钮
    self.attentionBtn = [JstyleNewsBaseAttentionButton buttonWithType:(UIButtonTypeCustom)];
    self.attentionBtn.frame = CGRectMake(SCREEN_W-104-60, (80-24)/2, 50, 24);
    [self.contentView addSubview:self.attentionBtn];
    
    self.attentionBtn.layer.cornerRadius = 13;
    self.attentionBtn.layer.masksToBounds = YES;

    [self.attentionBtn addTarget:self action:@selector(focusBtnClicked:) forControlEvents:(UIControlEventTouchUpInside)];
    
    [self applyTheme];
}

- (void)setModel:(SearchModel *)model
{
    _model = model;
    [self.headerImg setImageWithURL:[NSURL URLWithString:model.head_img] placeholder:SZ_Place_Header options:(YYWebImageOptionSetImageWithFadeAnimation) completion:nil];
    self.nameLabel.text = model.pen_name;
    self.desLabel.text = model.instruction;
    if ([model.isFollow integerValue] == 1) {
        self.attentionBtn.selected = YES;
    }else{
        self.attentionBtn.selected = NO;
        
    }
}

- (void)focusBtnClicked:(UIButton *)sender
{
    if (self.focusBlock) {
        self.focusBlock(_model.did);
    }
}

-(void)applyTheme {
    [super applyTheme];
    self.nameLabel.textColor = kNightModeTextColor;
    self.desLabel.textColor = kNightModeDescColor;
}



@end
