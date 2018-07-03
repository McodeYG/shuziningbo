//
//  JstyleManagementWenZhangTableViewController.h
//  Exquisite
//
//  Created by 数字跃动 on 2017/10/9.
//  Copyright © 2017年 Jstyle. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    JstyleManagementWenZhangTableViewControllerTOrFOriginalTypeYuanChuang = 1, //原创
    JstyleManagementWenZhangTableViewControllerTOrFOriginalTypeJuHe = 2 //聚合
} JstyleManagementWenZhangTableViewControllerTOrFOriginalType;

typedef enum : NSUInteger {
    JstyleManagementWenZhangTableViewControllerStatusTypeDaiShenHe = 0, //待审核
    JstyleManagementWenZhangTableViewControllerStatusTypeWeiTongGuo = 1, //未通过
    JstyleManagementWenZhangTableViewControllerStatusTypeYiFaBu = 2, //已发布
    JstyleManagementWenZhangTableViewControllerStatusTypeCaoGao = 3 //草稿
} JstyleManagementWenZhangTableViewControllerStatusType;

@interface JstyleManagementWenZhangTableViewController : UITableViewController

///刷新文章列表block
@property (nonatomic, copy) void(^wenZhangBlock)(JstyleManagementWenZhangTableViewControllerTOrFOriginalType tOrFOriginalType,JstyleManagementWenZhangTableViewControllerStatusType statusType);
///原创 聚合
@property (nonatomic, assign) JstyleManagementWenZhangTableViewControllerTOrFOriginalType tOrFOriginalType;
///已发布 未通过 草稿 待审核
@property (nonatomic, assign) JstyleManagementWenZhangTableViewControllerStatusType statusType;

@end
