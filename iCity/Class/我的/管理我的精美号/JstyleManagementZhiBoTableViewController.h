//
//  JstyleManagementZhiBoTableViewController.h
//  Exquisite
//
//  Created by 王磊 on 2017/10/10.
//  Copyright © 2017年 Jstyle. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    JstyleManagementZhiBoTableViewControllerStatusTypeDaiShenHe = 0, //待审核
    JstyleManagementZhiBoTableViewControllerStatusTypeWeiTongGuo = 1, //未通过
    JstyleManagementZhiBoTableViewControllerStatusTypeYiFaBu = 2, //已发布
    JstyleManagementZhiBoTableViewControllerStatusTypeCaoGao = 3 //草稿
} JstyleManagementZhiBoTableViewControllerStatusType;

@interface JstyleManagementZhiBoTableViewController : UITableViewController

///刷新直播列表block
@property (nonatomic, copy) void(^zhiBoBlock)(JstyleManagementZhiBoTableViewControllerStatusType statusType);
///已发布 未通过 草稿 待审核
@property (nonatomic, assign) JstyleManagementZhiBoTableViewControllerStatusType statusType;


@end
