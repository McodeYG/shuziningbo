//
//  JstyleNewsProtocalViewController.h
//  JstyleNews
//
//  Created by 王磊 on 2018/3/29.
//  Copyright © 2018年 JstyleNews. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JstyleNewsProtocalViewController : UIViewController

//协议地址
@property (nonatomic, copy) NSString *url;
//是push还是modal进来的
@property (nonatomic, assign) BOOL isModal;

@end
