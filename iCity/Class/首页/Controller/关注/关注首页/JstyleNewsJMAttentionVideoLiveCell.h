//
//  JstyleNewsJMAttentionVideoLiveCell.h
//  JstyleNews
//
//  Created by JingHongMuYun on 2018/3/29.
//  Copyright © 2018年 JstyleNews. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JstyleNewsJMAttentionListModel.h"
#import "JstyleNewsBaseAttentionButton.h"

@interface JstyleNewsJMAttentionVideoLiveCell : JstyleNewsBaseTableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *authorImageView;
@property (weak, nonatomic) IBOutlet JstyleNewsBaseTitleLabel *authorNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet JstyleNewsBaseAttentionButton *focusBtn;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet YYAnimatedImageView *backImageView;
@property (weak, nonatomic) IBOutlet UIButton *videoPlayBtn;
/**黑色小view*/
@property (weak, nonatomic) IBOutlet UIView *holdView;
/**icon*/
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
/**播放数*/
@property (weak, nonatomic) IBOutlet UILabel *playNumLabel;
/**直播icon*/
@property (weak, nonatomic) IBOutlet UIImageView *statusImageView;

@property (nonatomic, copy) void(^focusBtnBlock)(NSString *did);

@property (nonatomic, strong) JstyleNewsJMAttentionListModel *model;

@end
