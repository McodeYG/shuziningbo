//
//  ICityLifeCollectionViewController.h
//  iCity
//
//  Created by 王磊 on 2018/4/29.
//  Copyright © 2018年 LongYuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZJScrollPageView.h"

@interface ICityLifeCollectionViewController : UICollectionViewController <ZJScrollPageViewChildVcDelegate>

///下载数据的id，必须传
@property (nonatomic, copy) NSString *parentID;
@property (nonatomic, copy) void(^lifeCollectionMenuBlock)(NSString *title, NSString *html);

@end
