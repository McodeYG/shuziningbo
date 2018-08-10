//
//  JstyleJiFenDetailViewCell.h
//  Exquisite
//
//  Created by 数字宁波 on 2017/2/28.
//  Copyright © 2017年 Jstyle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JMMyJiFenModel.h"

@interface JstyleJiFenDetailViewCell : UITableViewCell

/**积分获取的路径名称*/
@property (weak, nonatomic) IBOutlet UILabel *title;
/**积分获得的时间*/
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
/**分数的label*/
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;

@property (weak, nonatomic) IBOutlet UIView *lineView;

- (void)setViewWithModel:(JMMyJiFenModel *)model;

@end
