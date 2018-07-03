//
//  JstyleNewsJMAttentionArticleSmallImageCell.h
//  JstyleNews
//
//  Created by JingHongMuYun on 2018/3/29.
//  Copyright © 2018年 JstyleNews. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JstyleNewsJMAttentionListModel.h"
#import "JstyleNewsBaseAttentionButton.h"

@interface JstyleNewsJMAttentionArticleSmallImageCell : JstyleNewsBaseTableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *authorImageView;
@property (weak, nonatomic) IBOutlet JstyleNewsBaseTitleLabel *authorNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet JstyleNewsBaseAttentionButton *focusBtn;
@property (weak, nonatomic) IBOutlet UIImageView *backImageView;
@property (weak, nonatomic) IBOutlet JstyleNewsBaseTitleLabel *nameLabel;

@property (nonatomic, copy) void(^focusBtnBlock)(NSString *did);

@property (nonatomic, strong) JstyleNewsJMAttentionListModel *model;

@end
