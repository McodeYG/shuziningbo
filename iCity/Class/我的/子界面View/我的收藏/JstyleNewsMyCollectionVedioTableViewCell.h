//
//  JstyleNewsMyCollectionVedioTableViewCell.h
//  JstyleNews
//
//  Created by 数字跃动 on 2017/10/25.
//  Copyright © 2017年 JstyleNews. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JstyleNewsMyCollectionModel.h"
#import "JstyleNewsRecentReadModel.h"

@interface JstyleNewsMyCollectionVedioTableViewCell : JstyleNewsBaseTableViewCell

@property (weak, nonatomic) IBOutlet UIView *holdView;
@property (nonatomic, strong) JstyleNewsMyCollectionModel *model;
@property (nonatomic, strong) JstyleNewsRecentReadModel *recentModel;

@end
