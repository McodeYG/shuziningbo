//
//  JstyleNewsBindStateView.h
//  JstyleNews
//
//  Created by JingHongMuYun on 2018/4/12.
//  Copyright © 2018年 JstyleNews. All rights reserved.
//

#import <UIKit/UIKit.h>

#define JSShowBindStateAlert(title, imageName) [JstyleNewsBindStateView showAlertWithTitle:title withImageName:imageName]

@interface JstyleNewsBindStateView : UIView

+ (void)showAlertWithTitle:(NSString *)title withImageName:(NSString *)imageName;

@end
