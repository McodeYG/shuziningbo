//
//  JstyleNewsVideoHomeViewCell.h
//  JstyleNews
//
//  Created by 数字宁波 on 2017/10/30.
//  Copyright © 2017年 JstyleNews. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JstyleNewsVideoHomeModel.h"

@interface JstyleNewsVideoHomeViewCell : JstyleNewsBaseTableViewCell

@property (weak, nonatomic) IBOutlet YYAnimatedImageView *backImageView;
@property (weak, nonatomic) IBOutlet UIButton *videoPlayBtn;
@property (weak, nonatomic) IBOutlet JstyleNewsBaseTitleLabel *nameLabel;
/**黑色小view*/
@property (weak, nonatomic) IBOutlet UIView *holdView;
/**icon*/
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
/**直播icon*/
@property (weak, nonatomic) IBOutlet UIImageView *statusImageView;
/**图片数量-视频播放次数*/
@property (weak, nonatomic) IBOutlet UILabel *imageNumLabel;
@property (weak, nonatomic) IBOutlet UIView *columnView;
@property (weak, nonatomic) IBOutlet UIImageView *authorImageView;
@property (weak, nonatomic) IBOutlet UILabel *authorNameLabel;
@property (weak, nonatomic) IBOutlet UIButton *shareBtn;

@property (nonatomic, copy) void(^startPlayVideoBlock)(UIButton *sender);
@property (nonatomic, copy) void(^videoShareBlock)(NSString *shareImgUrl, NSString *shareUrl, NSString *shareTitle, NSString *shareDesc);

@property (nonatomic, strong) JstyleNewsVideoHomeModel *model;

@end
