//
//  JstyleNewsJmNumsDetailLiveViewController.h
//  JstyleNews
//
//  Created by JingHongMuYun on 2018/1/9.
//  Copyright © 2018年 JstyleNews. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZJPageViewController.h"
#import "ZJScrollPageViewDelegate.h"

@interface JstyleNewsJmNumsDetailLiveViewController : ZJPageViewController<ZJScrollPageViewChildVcDelegate>

@property (nonatomic, copy) NSString *did;

@end
