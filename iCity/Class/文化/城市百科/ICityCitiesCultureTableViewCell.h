//
//  ICityCitiesCultureTableViewCell.h
//  iCity
//
//  Created by 王磊 on 2018/5/1.
//  Copyright © 2018年 LongYuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ICityCitiesCultureTableViewCell : JstyleNewsBaseTableViewCell

@property (nonatomic, copy) void(^citiesCultureSelectBlock)(NSString *selectID, NSString *title);

@property (nonatomic, strong) NSArray *citiesCultureDataArray;

@end
