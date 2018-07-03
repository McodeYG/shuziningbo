//
//  JstyleNewsMyMessageNoticeTableViewCell.m
//  JstyleNews
//
//  Created by 数字跃动 on 2017/10/30.
//  Copyright © 2017年 JstyleNews. All rights reserved.
//

#import "JstyleNewsMyMessageNoticeTableViewCell.h"
#import "JstyleNewsMyMessageNoticeModel.h"

@interface JstyleNewsMyMessageNoticeTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIView *lineView;

@end

@implementation JstyleNewsMyMessageNoticeTableViewCell

-(void)awakeFromNib {
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
    self.dateLabel.textColor = kDarkNineColor;
    self.lineView.backgroundColor = kLightLineColor;
}

- (void)setModel:(JstyleNewsMyMessageNoticeModel *)model {
    _model = model;
    
    self.titleLabel.text = model.title;
    self.dateLabel.text = model.ctime;
}

@end
