//
//  JstyleNewsJMAttentionTuiJianCollectionViewCell.h
//  JstyleNews
//
//  Created by JingHongMuYun on 2018/3/28.
//  Copyright © 2018年 JstyleNews. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JstyleNewsBaseAttentionButton.h"
#import "JstyleNewsJMAttentionListModel.h"

@interface JstyleNewsJMAttentionTuiJianCollectionViewCell : JstyleNewsBaseCollectionViewCell

@property (weak, nonatomic) IBOutlet JstyleNewsBaseView *backHoldView;
@property (weak, nonatomic) IBOutlet JstyleNewsBaseView *headerHoldView;
@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@property (weak, nonatomic) IBOutlet JstyleNewsBaseAttentionButton *focusBtn;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *introLabel;

@property (nonatomic, strong) JstyleNewsJMAttentionListModel *model;
@property (nonatomic, copy) void(^focusBtnBlock)(NSString *did);

@end
