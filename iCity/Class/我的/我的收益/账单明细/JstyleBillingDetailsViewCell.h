//
//  JstyleBillingDetailsViewCell.h
//  Exquisite
//
//  Created by JingHongMuYun on 2018/3/6.
//  Copyright © 2018年 JstyleStar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JstyleBillingDetailsModel.h"

@interface JstyleBillingDetailsViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *incomeLabel;

@property (nonatomic, strong) JstyleBillingDetailsModel *model;

@end
