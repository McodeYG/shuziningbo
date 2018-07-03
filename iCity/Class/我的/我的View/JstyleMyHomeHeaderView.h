//
//  JstyleMyHomeHeaderView.h
//  Exquisite
//
//  Created by 王磊 on 2018/3/6.
//  Copyright © 2018年 JstyleStar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JstyleNewsMineLoginUserInfoModel.h"

@interface JstyleMyHomeHeaderView : UIView

@property (strong, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (strong, nonatomic) IBOutlet UIVisualEffectView *effectView;

@property (nonatomic, copy) void(^myMoneyBlock)(UILabel *moneyLabel);
@property (nonatomic, copy) void(^checkMyOrderBlock)(void);
@property (nonatomic, copy) void(^checkOutVIPRightsBlock)(void);
@property (nonatomic, copy) void(^avatorClickBlock)(void);
@property (nonatomic, copy) void(^myCollectionBlock)(void);
@property (nonatomic, copy) void(^mySubcibeBlock)(void);
@property (nonatomic, copy) void(^myRecentBlock)(void);

@property (nonatomic, copy) JstyleNewsMineLoginUserInfoModel *userInfoModel;

@end
