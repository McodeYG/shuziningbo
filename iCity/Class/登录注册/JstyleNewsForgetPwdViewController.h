//
//  JstyleNewsForgetPwdViewController.h
//  JstyleNews
//
//  Created by JingHongMuYun on 2017/12/21.
//  Copyright © 2017年 JstyleNews. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JstyleNewsForgetPwdViewController : JstyleNewsBaseViewController

@property (nonatomic, copy) void(^findPwdBlock)(NSString *mobile, NSString *password);

@end
