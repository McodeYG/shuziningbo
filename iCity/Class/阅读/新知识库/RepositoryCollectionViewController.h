//
//  RepositoryCollectionViewController.h
//  iCity
//
//  Created by mayonggang on 2018/6/14.
//  Copyright © 2018年 LongYuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZJScrollPageView.h"

@interface RepositoryCollectionViewController : UICollectionViewController <ZJScrollPageViewChildVcDelegate>

//下载数据用的index_id 必传项
@property (nonatomic, copy) NSString *pid;
@property (nonatomic, copy) void(^lifeCollectionMenuBlock)(NSString *title, NSString *selectID);
//刷新
@property (nonatomic, copy) void(^refreshBlock)(NSInteger count);

@end
