//
//  JstyleNewsVideoViewController.h
//  JstyleNews
//
//  Created by 数字跃动 on 2017/9/13.
//  Copyright © 2017年 JstyleNews. All rights reserved.
//

#import "JstyleNewsBaseViewController.h"
#import "ZJScrollPageViewDelegate.h"

@interface JstyleNewsVideoViewController : JstyleNewsBaseViewController<ZJScrollPageViewChildVcDelegate>

@property (nonatomic, copy) NSString *cid;

@property (nonatomic, assign) BOOL showBanner;

@end
