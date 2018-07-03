//
//  JstylePersonalMediaDetailArticleCell.h
//  Exquisite
//
//  Created by 赵涛 on 2017/8/8.
//  Copyright © 2017年 Jstyle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JstylePersonalMediaModel.h"

@interface JstylePersonalMediaDetailArticleCell : JstyleNewsBaseTableViewCell

@property (weak, nonatomic) IBOutlet YYAnimatedImageView *backImageView;
@property (weak, nonatomic) IBOutlet JstyleLabel *introLabel;
@property (weak, nonatomic) IBOutlet UILabel *followNumLabel;


@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *readNumberLabel;

@property (nonatomic, strong) JstylePersonalMediaDetailModel *model;

@end
