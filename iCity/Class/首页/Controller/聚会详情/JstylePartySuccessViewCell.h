//
//  JstylePartySuccessViewCell.h
//  Exquisite
//
//  Created by 数字宁波 on 2017/7/7.
//  Copyright © 2017年 Jstyle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JstylePartyModel.h"
@interface JstylePartySuccessViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIView *singleLine;

@property (nonatomic, strong) JstylePartySuccessInfoModel *model;

@end
