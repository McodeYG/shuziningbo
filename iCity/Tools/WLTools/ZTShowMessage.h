//
//  ShowMessage.h
//  Exquisite
//
//  Created by 赵涛 on 16/4/28.
//  Copyright © 2016年 LanBao. All rights reserved.
//

#import <UIKit/UIKit.h>

#define ZTShowAlertMessage(message) [ZTShowMessage showMessage:message]
#define ZTShowAlertMsgWithAlignment(message, alignment) [ZTShowMessage showMessage:message withAlignment:alignment]
#define ZTShowAlertMsg(message, duration) [ZTShowMessage showMessage:message withDuration:duration]
#define ZTShowAlertMsgInView(message, duration, view) [ZTShowMessage showMessage:message withDuration:duration showInView:view]

typedef NS_ENUM (NSInteger, AlertMessageAlignment){
    AlertMessageAlignmentTop,
    AlertMessageAlignmentCenter,
    AlertMessageAlignmentBottom
};

@interface ZTShowMessage : UIView

+ (void)showMessage:(NSString *)message;

+ (void)showMessage:(NSString *)message withAlignment:(AlertMessageAlignment)alignment;

+ (void)showMessage:(NSString *)message withDuration:(NSTimeInterval)duration;

+ (void)showMessage:(NSString *)message withDuration:(NSTimeInterval)duration showInView:(UIView *)view;

@end
