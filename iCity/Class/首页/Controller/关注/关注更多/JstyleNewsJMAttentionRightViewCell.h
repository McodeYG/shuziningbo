//
//  JstyleNewsJMAttentionRightViewCell.h
//  JstyleNews
//
//  Created by JingHongMuYun on 2018/4/2.
//  Copyright © 2018年 JstyleNews. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SearchModel.h"
#import "JstyleNewsBaseAttentionButton.h"

@interface JstyleNewsJMAttentionRightViewCell : JstyleNewsBaseTableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *introLabel;
@property (weak, nonatomic) IBOutlet JstyleNewsBaseAttentionButton *focusBtn;

@property (nonatomic, strong) SearchModel *model;

@property (nonatomic, copy) void(^focusBlock)(NSString *did);

@end
