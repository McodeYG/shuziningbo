//
//  JstyleManagementAccountInfoViewCell.h
//  Exquisite
//
//  Created by 赵涛 on 2017/10/16.
//  Copyright © 2017年 Jstyle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JstyleManagementAccountInfoModel.h"

@interface JstyleManagementAccountInfoViewCell : JstyleNewsBaseTableViewCell

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *detailLabel;

@property (nonatomic, strong) JstyleManagementAccountInfoModel *model;

@end
