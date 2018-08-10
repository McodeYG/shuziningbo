//
//  JstyleNewsOnePlusImageVideoViewCell.h
//  JstyleNews
//
//  Created by 数字宁波 on 2017/10/24.
//  Copyright © 2017年 JstyleNews. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JstyleNewsHomeModel.h"

@interface JstyleNewsOnePlusImageVideoViewCell : JstyleNewsBaseTableViewCell

/**标题*/
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
/**背景图*/
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

@property (weak, nonatomic) IBOutlet UIImageView *authorImageView;
@property (weak, nonatomic) IBOutlet UILabel *authorNameLabel;
@property (weak, nonatomic) IBOutlet UIButton *shareBtn;

@property (nonatomic, copy) void(^startPlayVideoBlock)(UIButton *sender);
@property (nonatomic, copy) void(^videoShareBlock)(NSString *shareImgUrl, NSString *shareUrl, NSString *shareTitle, NSString *shareDesc);

@property (nonatomic, strong) JstyleNewsHomePageModel *model;

@end
