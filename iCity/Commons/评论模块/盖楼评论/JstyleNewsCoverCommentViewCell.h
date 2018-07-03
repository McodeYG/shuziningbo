//
//  JstyleNewsCoverCommentViewCell.h
//  JstyleNews
//
//  Created by JingHongMuYun on 2017/12/7.
//  Copyright © 2017年 JstyleNews. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JstyleNewsCommentModel.h"

@interface JstyleNewsCoverCommentViewCell : JstyleNewsBaseTableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@property (weak, nonatomic) IBOutlet UIImageView *crownImageView;
@property (weak, nonatomic) IBOutlet UILabel *nickNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIButton *thumbBtn;
@property (weak, nonatomic) IBOutlet UILabel *thumbNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentLabel;

@property (nonatomic, copy) void(^praiseBlock)(NSString *contentId);

@property (nonatomic, strong) JstyleNewsCommentModel *model;

@end
