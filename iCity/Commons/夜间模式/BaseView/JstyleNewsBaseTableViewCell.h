//
//  JstyleNewsBaseTableViewCell.h
//  JstyleNews
//
//  Created by 王磊 on 2018/1/25.
//  Copyright © 2018年 JstyleNews. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JstyleNewsBaseTableViewCell : UITableViewCell

///是否设置过3DTouch代理
@property (nonatomic, assign , readonly) BOOL isAllreadySetupPreviewingDelegate;

/**
 给当前Cell设置3DTouch代理,方法内部自动判定是否已经设置过.
 
 @param controller 代理控制器
 */
- (void)setupPreviewingDelegateWithController:(UIViewController<UIViewControllerPreviewingDelegate> *)controller;

- (void)applyTheme;

@end
