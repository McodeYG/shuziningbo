//
//  JstylePlaceholderView.h
//  Exquisite
//
//  Created by 赵涛 on 2016/12/1.
//  Copyright © 2016年 LanBao. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    JstylePlaceholderViewTypeNoSingle = 0,
    JstylePlaceholderViewTypeShopCar,
    JstylePlaceholderViewTypeDianZiKan,
    JstylePlaceholderViewTypeTeHuiOrder,
    JstylePlaceholderViewTypeTeHuiDianZiQuan,
    JstylePlaceholderViewTypeJuhui,
    JstylePlaceholderViewTypeDingYue
} JstylePlaceholderViewType;

@interface JstylePlaceholderView : UIView

@property (nonatomic, strong) UIButton *button;
@property (nonatomic, copy) void(^btnClickBlock)();

- (instancetype)initWithFrame:(CGRect)frame imageName:(NSString *)imageName title:(NSString *)title;

- (instancetype)initWithFrame:(CGRect)frame imageName:(NSString *)imageName titleStr:(NSString *)titleStr;

- (instancetype)initWithPlaceholderViewType:(JstylePlaceholderViewType)type;

- (instancetype)initWithPlaceholderViewType:(JstylePlaceholderViewType)type offset:(NSInteger)offset;

@end
