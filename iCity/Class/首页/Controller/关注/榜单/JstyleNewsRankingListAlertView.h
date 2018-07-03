//
//  JstyleNewsRankingListAlertView.h
//  JstyleNews
//
//  Created by JingHongMuYun on 2018/4/24.
//  Copyright © 2018年 JstyleNews. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JstyleNewsRankingListAlertView : UIView

- (instancetype)initWithFrame:(CGRect)frame dataArray:(NSArray *)dataArray;

@property (nonatomic, copy) void(^chooseBlock)(NSString *chooseStr);

@end
