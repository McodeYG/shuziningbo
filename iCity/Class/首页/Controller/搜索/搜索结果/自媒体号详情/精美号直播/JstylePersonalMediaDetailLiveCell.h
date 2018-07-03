//
//  JstylePersonalMediaDetailLiveCell.h
//  Exquisite
//
//  Created by 赵涛 on 2017/8/8.
//  Copyright © 2017年 Jstyle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JstylePersonalMediaModel.h"

@interface JstylePersonalMediaDetailLiveCell : JstyleNewsBaseTableViewCell

@property (weak, nonatomic) IBOutlet YYAnimatedImageView *backImageView;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *lookNumLabel;
@property (weak, nonatomic) IBOutlet JstyleLabel *introLabel;

@property (nonatomic, strong) JstylePersonalMediaDetailModel *model;

@end
