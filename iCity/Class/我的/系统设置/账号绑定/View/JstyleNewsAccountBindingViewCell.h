//
//  JstyleNewsAccountBindingViewCell.h
//  JstyleNews
//
//  Created by JingHongMuYun on 2018/4/11.
//  Copyright © 2018年 JstyleNews. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JstyleNewsThirdPartBindStateModel.h"

@interface JstyleNewsAccountBindingViewCell : JstyleNewsBaseTableViewCell

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *bindLabel;

@property (nonatomic, strong) JstyleNewsThirdPartBindStateModel *model;

@end
