//
//  JstyleManagementAccountImageViewCell.h
//  Exquisite
//
//  Created by 数字宁波 on 2017/10/16.
//  Copyright © 2017年 Jstyle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JstyleManagementAccountInfoModel.h"

@interface JstyleManagementAccountImageViewCell : JstyleNewsBaseTableViewCell

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;

@property (nonatomic, strong) JstyleManagementAccountInfoModel *model;

@end
