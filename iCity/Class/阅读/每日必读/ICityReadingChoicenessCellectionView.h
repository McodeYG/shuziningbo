//
//  ICityReadingChoicenessCellectionView.h
//  iCity
//
//  Created by 王磊 on 2018/4/27.
//  Copyright © 2018年 LongYuan. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ICityLifeBannerModel;

@interface ICityReadingChoicenessCellectionView : JstyleNewsBaseCollectionView

@property (nonatomic, strong) NSArray *readingChoicenessDataArray;

@property (nonatomic, copy) void(^readingBlock)(ICityLifeBannerModel *model);

@end
