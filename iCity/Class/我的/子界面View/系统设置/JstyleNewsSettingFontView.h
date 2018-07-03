//
//  JstyleNewsSettingFontView.h
//  JstyleNews
//
//  Created by 数字跃动 on 2017/12/26.
//  Copyright © 2017年 JstyleNews. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JstyleNewsSettingFontView : UIView

@property (nonatomic, copy) void(^fontSizeBlock)(NSString *fontString);
@property (nonatomic, copy) void(^cancleBtnBlock)();

@end
