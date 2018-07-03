//
//  JstyleNewsHomeCateViewController.h
//  JstyleNews
//
//  Created by JingHongMuYun on 2017/12/7.
//  Copyright © 2017年 JstyleNews. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZJScrollPageViewDelegate.h"

@interface JstyleNewsHomeCateViewController : JstyleNewsBaseViewController<ZJScrollPageViewChildVcDelegate>

@property (nonatomic, copy) NSString *cid;

@end
