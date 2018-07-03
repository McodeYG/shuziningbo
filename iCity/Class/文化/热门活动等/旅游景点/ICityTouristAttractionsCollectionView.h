//
//  ICityTouristAttractionsCollectionView.h
//  iCity
//
//  Created by 王磊 on 2018/5/2.
//  Copyright © 2018年 LongYuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ICityCultureModel.h"

@interface ICityTouristAttractionsCollectionView : JstyleNewsBaseCollectionView

@property (nonatomic, copy) void(^reuseSelectBlock)(NSString *selectID, ICityCultureModel *model);

@property (nonatomic, strong) NSArray *dataArray;


@end
