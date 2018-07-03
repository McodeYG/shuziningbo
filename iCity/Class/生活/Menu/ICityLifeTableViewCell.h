//
//  ICityLifeTableViewCell.h
//  iCity
//
//  Created by 王磊 on 2018/4/29.
//  Copyright © 2018年 LongYuan. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ICityLifeMenuModel;

@interface ICityLifeTableViewCell : JstyleNewsBaseTableViewCell

@property (nonatomic, strong) NSArray<ICityLifeMenuModel *> *collcetionCatagroyArray;
@property (nonatomic, copy) void(^lifeCollectionMenuBlock)(NSString *title, NSString *html);

@end
