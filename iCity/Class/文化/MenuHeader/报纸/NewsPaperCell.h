//
//  NewsPaperCell.h
//  iCity
//
//  Created by mayonggang on 2018/6/14.
//  Copyright © 2018年 LongYuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewspaperModel.h"

@interface NewsPaperCell : UITableViewCell


+(instancetype)initWithTableView:(UITableView *)tableView;

@property (nonatomic, strong) NewspaperModel * model;

@end
