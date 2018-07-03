//
//  JstyleNewsSearchJmNumsViewCell.h
//  JstyleNews
//
//  Created by JingHongMuYun on 2017/12/1.
//  Copyright © 2017年 JstyleNews. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SearchModel.h"

@interface JstyleNewsSearchJmNumsViewCell : JstyleNewsBaseTableViewCell

@property (weak, nonatomic) IBOutlet YYAnimatedImageView *backImageView;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *introLabel;

@property (weak, nonatomic) IBOutlet UIButton *focusOnBtn;

@property (nonatomic, copy) void(^focusOnBlock)(NSString *did);//关注

@property (nonatomic, strong) SearchModel *model;

@end
