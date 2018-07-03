//
//  ICityTVTableViewCell.h
//  ICityTable
//
//  Created by chunzheng wang on 2018/5/1.
//  Copyright © 2018年 chunzheng wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ICityTVModel.h"

@interface ICityTVTableViewCell : UITableViewCell

@property(nonatomic,strong)ICityTVModel *model;

@property (nonatomic, copy) void(^focusBlock)(ICityTVModel *model);

@end
