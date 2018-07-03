//
//  JstyleNewsVideoDetailIntroViewCell.h
//  JstyleNews
//
//  Created by JingHongMuYun on 2017/12/4.
//  Copyright © 2017年 JstyleNews. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZTTagListView.h"
#import "JstyleNewsVideoDetailIntroModel.h"

typedef void(^PraiseBlock)();

@interface JstyleNewsVideoDetailIntroViewCell : JstyleNewsBaseTableViewCell

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@property (weak, nonatomic) IBOutlet UILabel *nickNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *playImageView;
@property (weak, nonatomic) IBOutlet UILabel *playNumLabel;
@property (weak, nonatomic) IBOutlet UIButton *focusBtn;
@property (weak, nonatomic) IBOutlet UIButton *heartBtn;
@property (nonatomic, strong) ZTTagListView *tagsView;

@property (nonatomic, strong) JstyleNewsVideoDetailIntroModel *model;

@property (nonatomic, copy) void(^focusBlock)();
@property (nonatomic, copy) void(^jmNumDetailBlock)(NSString *did);

@end
