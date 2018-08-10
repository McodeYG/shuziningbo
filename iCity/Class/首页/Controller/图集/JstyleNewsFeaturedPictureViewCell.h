//
//  JstyleNewsFeaturedPictureViewCell.h
//  JstyleNews
//
//  Created by 数字宁波 on 2017/10/25.
//  Copyright © 2017年 JstyleNews. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JstyleNewsHomeModel.h"

@interface JstyleNewsFeaturedPictureViewCell : JstyleNewsBaseTableViewCell

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet YYAnimatedImageView *backImageView;
@property (weak, nonatomic) IBOutlet UILabel *subjectLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
/**黑色小view*/
@property (weak, nonatomic) IBOutlet UIView *holdView;
/**icon*/
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
/**图片数量*/
@property (weak, nonatomic) IBOutlet UILabel *imageNumLabel;
@property (weak, nonatomic) IBOutlet UIView *columnView;

@property (nonatomic, strong) JstyleNewsHomePageModel *model;


@end
