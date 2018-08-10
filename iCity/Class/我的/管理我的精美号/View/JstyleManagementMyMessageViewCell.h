//
//  JstyleManagementMyMessageViewCell.h
//  Exquisite
//
//  Created by 数字宁波 on 2017/10/12.
//  Copyright © 2017年 Jstyle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JstyleManagementTableListModel.h"

@interface JstyleManagementMyMessageViewCell : JstyleNewsBaseTableViewCell

@property (weak, nonatomic) IBOutlet UILabel *messageLabel;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (nonatomic, strong) JstyleManagementMyMessageModel *model;

@end
