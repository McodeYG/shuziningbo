//
//  JstyleNewsAdvertisementViewCell.h
//  JstyleNews
//
//  Created by 数字宁波 on 2017/10/24.
//  Copyright © 2017年 JstyleNews. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JstyleNewsJMAttentionListModel.h"

@interface JstyleNewsAdvertisementViewCell : JstyleNewsBaseTableViewCell

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet YYAnimatedImageView *backImageView;

@property (weak, nonatomic) IBOutlet UILabel *adLabel;

@property (weak, nonatomic) IBOutlet UIImageView *adImageView;

@property (nonatomic, strong) JstyleNewsJMAttentionListModel *model;


@end
