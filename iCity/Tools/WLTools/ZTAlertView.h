//
//  ViewController.m
//  ZTAlertView
//
//  Created by 数字宁波 on 16/5/23.
//  Copyright © 2016年 赵涛. All rights reserved.
//

#import <UIKit/UIKit.h>
//点击按钮回调
typedef void(^AlertResult)(NSInteger index);

@interface ZTAlertView : UIView

/**  */
@property(nonatomic,copy) AlertResult resultIndex;

- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message sureBtn:(NSString *)sureTitle cancleBtn:(NSString *)cancleTitle;

-(void)show;



@end
