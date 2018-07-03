//
//  JstyleNewsMyMessagePicturesTableViewCell.h
//  JstyleNews
//
//  Created by 数字跃动 on 2017/10/30.
//  Copyright © 2017年 JstyleNews. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JstyleNewsMyMessageNoticeModel.h"

@interface JstyleNewsMyMessageTableViewCell : JstyleNewsBaseTableViewCell

@property (weak, nonatomic) IBOutlet UIView *holdView;

@property (nonatomic, strong) JstyleNewsMyMessageNoticeModel *model;

@end
