//
//  ICityPopularActivitiesCollectionView.h
//  iCity
//
//  Created by 王磊 on 2018/5/1.
//  Copyright © 2018年 LongYuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ICityPopularActivitiesCollectionView : JstyleNewsBaseCollectionView

@property (nonatomic, copy) void(^reuseSelectBlock)(NSString *selectID);

@property (nonatomic, strong) NSArray *dataArray;

@end
