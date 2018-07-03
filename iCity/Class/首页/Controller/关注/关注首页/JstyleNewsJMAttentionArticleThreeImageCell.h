//
//  JstyleNewsJMAttentionArticleThreeImageCell.h
//  JstyleNews
//
//  Created by JingHongMuYun on 2018/3/29.
//  Copyright © 2018年 JstyleNews. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JstyleNewsJMAttentionListModel.h"
#import "JstylePhotosContainerView.h"
#import "JstyleNewsBaseAttentionButton.h"

@interface JstyleNewsJMAttentionArticleThreeImageCell : JstyleNewsBaseTableViewCell<JstylePhotosContainerViewDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *authorImageView;
@property (weak, nonatomic) IBOutlet JstyleNewsBaseTitleLabel *authorNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet JstyleNewsBaseAttentionButton *focusBtn;
@property (weak, nonatomic) IBOutlet JstyleNewsBaseTitleLabel *nameLabel;
/**三个图背景图*/
@property (nonatomic, strong) JstylePhotosContainerView *photosContainerView;
/**黑色小view*/
@property (weak, nonatomic) IBOutlet UIView *holdView;
/**icon*/
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
/**图片数量*/
@property (weak, nonatomic) IBOutlet UILabel *imageNumLabel;

@property (nonatomic, copy) void(^focusBtnBlock)(NSString *did);

@property (nonatomic, strong) JstyleNewsJMAttentionListModel *model;

@end
