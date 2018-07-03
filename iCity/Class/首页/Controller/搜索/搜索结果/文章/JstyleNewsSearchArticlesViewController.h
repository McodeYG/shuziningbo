//
//  JstyleNewsSearchArticlesViewController.h
//  JstyleNews
//
//  Created by JingHongMuYun on 2017/12/12.
//  Copyright © 2017年 JstyleNews. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ZJScrollPageViewDelegate.h"

@interface JstyleNewsSearchArticlesViewController : JstyleNewsBaseViewController<ZJScrollPageViewChildVcDelegate>

@property (nonatomic, copy) NSString *keyword;

@end
