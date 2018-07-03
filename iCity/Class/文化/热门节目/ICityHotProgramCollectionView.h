//
//  ICityHotProgramCollectionViewController.h
//  iCity
//
//  Created by 王磊 on 2018/5/1.
//  Copyright © 2018年 LongYuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ICityHotProgramCollectionView : JstyleNewsBaseCollectionView

@property (nonatomic, strong) NSArray *hotProgramArray;
@property (nonatomic, copy) void(^hotProgramClickBlock)(NSString *vid ,NSString *url);

@end
