//
//  JstyleManagementShiPinTableViewController.h
//  Exquisite
//
//  Created by 数字跃动 on 2017/10/10.
//  Copyright © 2017年 Jstyle. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    JstyleManagementShiPinTableViewControllerStatusTypeDaiShenHe = 0, //待审核
    JstyleManagementShiPinTableViewControllerStatusTypeWeiTongGuo = 1, //未通过
    JstyleManagementShiPinTableViewControllerStatusTypeYiFaBu = 2, //已发布
    JstyleManagementShiPinTableViewControllerStatusTypeCaoGao = 3 //草稿
} JstyleManagementShiPinTableViewControllerStatusType;

@interface JstyleManagementShiPinTableViewController : UITableViewController

///刷新视频列表block
@property (nonatomic, copy) void(^shiPinBlock)(JstyleManagementShiPinTableViewControllerStatusType statusType);
///已发布 未通过 草稿 待审核
@property (nonatomic, assign) JstyleManagementShiPinTableViewControllerStatusType statusType;


@end
