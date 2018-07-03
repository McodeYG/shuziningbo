//
//  JstyleNewsJMAttentionSearchCell.h
//  JstyleNews
//
//  Created by 王磊 on 2018/4/2.
//  Copyright © 2018年 JstyleNews. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JstyleNewsJMAttentionSearchModel.h"

@interface JstyleNewsJMAttentionSearchCell : UITableViewCell

@property (nonatomic, copy) JstyleNewsJMAttentionSearchModel *model;

@property (nonatomic, copy) void(^attentionBlock)();

@end
