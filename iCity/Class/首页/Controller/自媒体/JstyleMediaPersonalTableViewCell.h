//
//  JstyleMediaPersonalTableViewCell.h
//  Exquisite
//
//  Created by 赵涛 on 2017/8/29.
//  Copyright © 2017年 Jstyle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JstylePersonalMediaModel.h"

@interface JstyleMediaPersonalTableViewCell : JstyleNewsBaseTableViewCell

@property (weak, nonatomic) IBOutlet YYAnimatedImageView *backImageView;
@property (weak, nonatomic) IBOutlet UIView *holdView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *introLabel;
@property (weak, nonatomic) IBOutlet UILabel *followNumLabel;

@property (nonatomic, strong) JstylePersonalMediaListModel *model;

@end
