//
//  CitysCultureCollectionViewController.h
//  iCity
//
//  Created by mayonggang on 2018/6/14.
//  Copyright © 2018年 LongYuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CitysCultureCollectionViewController : UICollectionViewController

///必传项
@property (nonatomic, copy) NSString *parentID;
@property (nonatomic, copy) void(^lifeCollectionMenuBlock)(NSString *title, NSString *html);

@end
