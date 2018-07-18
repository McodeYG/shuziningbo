//
//  ICityCultureMenuHeaderView.h
//  iCity
//
//  Created by 王磊 on 2018/5/1.
//  Copyright © 2018年 LongYuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ICityLifeBannerModel.h"

@interface ICityCultureMenuHeaderView : UIView

@property (nonatomic, strong) NSArray<ICityLifeMenuModel *> *menuArray;
@property (nonatomic, copy) void(^menuButtonClickBlock)(NSString *title, NSString *html);



@end
