//
//  JstyleNewsVideoFullScreenShareView.h
//  JstyleNews
//
//  Created by JingHongMuYun on 2018/1/31.
//  Copyright © 2018年 JstyleNews. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JstyleNewsVideoFullScreenShareView : UIView

- (instancetype)initWithFrame:(CGRect)frame shareTitle:(NSString *)shareTitle shareDesc:(NSString *)shareDesc shareUrl:(NSString *)shareUrl shareImgUrl:(NSString *)shareImgUrl viewController:(UIViewController *)viewController;

@property (nonatomic, copy) void(^closeBlock)();

@end
