//
//  JstyleEarningListViewCell.h
//  Exquisite
//
//  Created by JingHongMuYun on 2018/3/6.
//  Copyright © 2018年 JstyleStar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JstyleEarningListModel.h"

@interface JstyleEarningListViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *rankLabel;
@property (weak, nonatomic) IBOutlet UIImageView *rankImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property (weak, nonatomic) IBOutlet UILabel *incomeLabel;

@property (nonatomic, strong) JstyleEarningListModel *model;

@end
