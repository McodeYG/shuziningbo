//
//  JstyleNewsVideoHomeAdvertisementCell.h
//  JstyleNews
//
//  Created by JingHongMuYun on 2017/12/7.
//  Copyright © 2017年 JstyleNews. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JstyleNewsVideoHomeModel.h"
@interface JstyleNewsVideoHomeAdvertisementCell : JstyleNewsBaseTableViewCell

@property (weak, nonatomic) IBOutlet JstyleNewsBaseTitleLabel *nameLabel;

@property (weak, nonatomic) IBOutlet YYAnimatedImageView *backImageView;

@property (weak, nonatomic) IBOutlet UILabel *adLabel;

@property (weak, nonatomic) IBOutlet UIImageView *adImageView;

@property (weak, nonatomic) IBOutlet UIView *columnView;

@property (nonatomic, strong) JstyleNewsVideoHomeModel *model;

@end
