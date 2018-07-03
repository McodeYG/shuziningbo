//
//  JstyleNewsSearchVideosViewCell.h
//  JstyleNews
//
//  Created by JingHongMuYun on 2017/12/1.
//  Copyright © 2017年 JstyleNews. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SearchModel.h"

@interface JstyleNewsSearchVideosViewCell : JstyleNewsBaseTableViewCell

@property (weak, nonatomic) IBOutlet YYAnimatedImageView *backImageView;
@property (weak, nonatomic) IBOutlet JstyleLabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *tagTimeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *authorImageView;

@property (nonatomic, strong) SearchModel *model;

@end
