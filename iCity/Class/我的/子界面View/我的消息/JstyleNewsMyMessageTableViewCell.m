//
//  JstyleNewsMyMessagePicturesTableViewCell.m
//  JstyleNews
//
//  Created by 数字跃动 on 2017/10/30.
//  Copyright © 2017年 JstyleNews. All rights reserved.
//

#import "JstyleNewsMyMessageTableViewCell.h"

typedef enum : NSUInteger {
    JstyleNewsMyMessageTableViewCellTypeMessage,
    JstyleNewsMyMessageTableViewCellTypeVideo,
    JstyleNewsMyMessageTableViewCellTypePictures,
} JstyleNewsMyMessageTableViewCellType;

@interface JstyleNewsMyMessageTableViewCell ()

@property (nonatomic, assign) JstyleNewsMyMessageTableViewCellType cellType;

@property (weak, nonatomic) IBOutlet UIImageView *posterImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *secondTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *posterNumLabel;

@property (weak, nonatomic) IBOutlet UIView *pictureCountView;
@property (weak, nonatomic) IBOutlet UIImageView *videoIconView;

@end

@implementation JstyleNewsMyMessageTableViewCell

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
    self.holdView.backgroundColor = ISNightMode?kDarkTwoColor:kWhiteColor;
}

- (void)setCellType:(JstyleNewsMyMessageTableViewCellType)cellType {
    _cellType = cellType;
    
    switch (self.cellType) {
        case JstyleNewsMyMessageTableViewCellTypeMessage:
            self.pictureCountView.hidden = YES;
            self.videoIconView.hidden = YES;
            break;
        case JstyleNewsMyMessageTableViewCellTypeVideo:
            self.pictureCountView.hidden = YES;
            self.videoIconView.hidden = NO;
            break;
        case JstyleNewsMyMessageTableViewCellTypePictures:
            self.pictureCountView.hidden = NO;
            self.videoIconView.hidden = YES;
            break;
        default:
            break;
    }
}

- (void)setModel:(JstyleNewsMyMessageNoticeModel *)model {
    _model = model;
    
    [self.posterImageView setImageWithURL:[NSURL URLWithString:model.poster] placeholder:SZ_Place_S_N];
    self.titleLabel.text = model.title;
    self.secondTitleLabel.text = [NSString stringWithFormat:@"#%@",model.cname];
    self.timeLabel.text = model.ctime;
    self.posterNumLabel.text = [NSString stringWithFormat:@"%@图",model.posternum];
    
    if (model.isImageArticle.integerValue == 1) {
        self.cellType = JstyleNewsMyMessageTableViewCellTypePictures;
    } else {
        if (model.type.integerValue == 7 || model.type.integerValue == 8) {
            self.cellType = JstyleNewsMyMessageTableViewCellTypeVideo;
        } else {
            self.cellType = JstyleNewsMyMessageTableViewCellTypeMessage;
        }
    }
}

@end
