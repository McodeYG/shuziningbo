//
//  JMMyViewHeaderView.h
//  Exquisite
//
//  Created by apple on 16/5/3.
//  Copyright © 2016年 zhaotao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JMMyViewCell : UITableViewCell

/**图标*/
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
/**标题*/
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
/**右三角*/
@property (weak, nonatomic) IBOutlet UIImageView *rigntImage;
/**电话号码*/
@property (nonatomic, strong) UILabel *phoneLabel;

@end
