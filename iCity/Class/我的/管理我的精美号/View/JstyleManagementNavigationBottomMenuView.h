//
//  JstyleManagementNavigationBottomMenuView.h
//  Exquisite
//
//  Created by 数字跃动 on 2017/9/25.
//  Copyright © 2017年 Jstyle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JstyleManagementNavigationBottomMenuModel.h"

@interface JstyleManagementNavigationBottomMenuView : UIView

@property (nonatomic, strong) JstyleManagementNavigationBottomMenuModel *model;

@property (nonatomic, strong) UILabel *countLabel;
@property (nonatomic, strong) UILabel *titleLabel;

@end
