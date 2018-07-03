//
//  JstyleMyHomeViewCell.h
//  Exquisite
//
//  Created by 赵涛 on 2017/6/12.
//  Copyright © 2017年 Jstyle. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JstyleMyHomeViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *backImageView;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *detailLabel;

@property (strong, nonatomic) UIView *singleLine;

@end
