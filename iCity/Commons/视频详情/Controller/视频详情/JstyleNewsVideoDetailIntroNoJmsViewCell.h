//
//  JstyleNewsVideoDetailIntroNoJmsViewCell.h
//  JstyleNews
//
//  Created by JingHongMuYun on 2017/12/25.
//  Copyright © 2017年 JstyleNews. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZTTagListView.h"
#import "JstyleNewsVideoDetailIntroModel.h"

@interface JstyleNewsVideoDetailIntroNoJmsViewCell : JstyleNewsBaseTableViewCell

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *playImageView;
@property (weak, nonatomic) IBOutlet UILabel *playNumLabel;
@property (nonatomic, strong) ZTTagListView *tagsView;

@property (nonatomic, strong) JstyleNewsVideoDetailIntroModel *model;

@end
