//
//  JstyleNewsRankingListLeftViewCell.h
//  JstyleNews
//
//  Created by JingHongMuYun on 2018/4/24.
//  Copyright © 2018年 JstyleNews. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JstyleNewsJMAttentionLeftCateModel.h"

@interface JstyleNewsRankingListLeftViewCell : JstyleNewsBaseTableViewCell

@property (nonatomic, strong) UILabel *nameLabel;

@property (nonatomic, strong) JstyleNewsJMAttentionLeftCateModel *model;

@end
