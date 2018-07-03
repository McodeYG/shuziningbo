//
//  JstyleNewsMyCollectionArticleTableViewCell.h
//  JstyleNews
//
//  Created by 数字跃动 on 2017/12/25.
//  Copyright © 2017年 JstyleNews. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JstyleNewsMyCollectionModel.h"

@interface JstyleNewsMyCollectionArticleTableViewCell : JstyleNewsBaseTableViewCell

@property (nonatomic, strong) JstyleNewsMyCollectionModel *model;
@property (weak, nonatomic) IBOutlet UIView *holdView;

@end
