//
//  JstyleNewsMyCollectionTableViewCell.h
//  JstyleNews
//
//  Created by 数字跃动 on 2017/10/25.
//  Copyright © 2017年 JstyleNews. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JstyleNewsRecentReadModel.h"
#import "JstyleNewsMyCollectionModel.h"
//最近阅读

@interface JstyleNewsMyCollectionTableViewCell : JstyleNewsBaseTableViewCell

@property (weak, nonatomic) IBOutlet UIView *holdView;
@property (nonatomic, strong) JstyleNewsRecentReadModel *model;
@property (nonatomic, strong) JstyleNewsMyCollectionModel *collectionModel;

@end
