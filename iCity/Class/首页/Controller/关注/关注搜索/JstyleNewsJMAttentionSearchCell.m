//
//  JstyleNewsJMAttentionSearchCell.m
//  JstyleNews
//
//  Created by 王磊 on 2018/4/2.
//  Copyright © 2018年 JstyleNews. All rights reserved.
//

#import "JstyleNewsJMAttentionSearchCell.h"
#import "JstyleNewsBaseAttentionButton.h"

@interface JstyleNewsJMAttentionSearchCell()

@property (strong, nonatomic) IBOutlet UIImageView *posterImageView;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (strong, nonatomic) IBOutlet JstyleNewsBaseAttentionButton *attentionBtn;

@end

@implementation JstyleNewsJMAttentionSearchCell

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

- (void)setupUI {
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.posterImageView.layer.cornerRadius = 40.0 / 2.0;
    self.posterImageView.layer.masksToBounds = YES;
    self.posterImageView.layer.borderColor = JSColor(@"#DEDEDE").CGColor;
    self.posterImageView.layer.borderWidth = 0.5;
    
    [self.attentionBtn addTarget:self action:@selector(attentionBtnClick:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)attentionBtnClick:(UIButton *)button {
    if (self.attentionBtn) {
        self.attentionBlock();
    }
}

- (void)setModel:(JstyleNewsJMAttentionSearchModel *)model {
    _model = model;
    
    [self.posterImageView setImageWithURL:[NSURL URLWithString:model.head_img] placeholder:JSImage(@"登录头像")];
    self.nameLabel.text = (model.pen_name == nil ? @"" : model.pen_name);
    self.descriptionLabel.text = (model.instruction == nil ? @"" : model.instruction);

    self.attentionBtn.selected = (model.isFollow.integerValue == 1);
}

@end
