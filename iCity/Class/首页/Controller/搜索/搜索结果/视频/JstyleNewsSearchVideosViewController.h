//
//  JstyleNewsSearchVideosViewController.h
//  JstyleNews
//
//  Created by JingHongMuYun on 2017/12/1.
//  Copyright © 2017年 JstyleNews. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZJScrollPageViewDelegate.h"

@interface JstyleNewsSearchVideosViewController : UIViewController<ZJScrollPageViewChildVcDelegate>

@property (nonatomic, copy) NSString *keyword;

@end
