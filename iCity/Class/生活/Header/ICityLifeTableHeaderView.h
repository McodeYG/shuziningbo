//
//  ICityLifeTableHeaderView.h
//  iCity
//
//  Created by 王磊 on 2018/4/28.
//  Copyright © 2018年 LongYuan. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ICityLifeMenuModel;

@interface ICityLifeTableHeaderView : UIView

@property (nonatomic, strong) NSMutableArray *bannerArray;

@property (nonatomic, strong) NSArray<ICityLifeMenuModel *> *menuArray;

@property (nonatomic, copy) void(^bannerClickBlock)(NSInteger index);
@property (nonatomic, copy) void(^menuButtonClickBlock)(NSString *title, NSString *html);

@end
