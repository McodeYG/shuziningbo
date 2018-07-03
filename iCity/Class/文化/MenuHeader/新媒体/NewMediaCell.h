//
//  NewMediaCell.h
//  iCity
//
//  Created by mayonggang on 2018/6/15.
//  Copyright © 2018年 LongYuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewspaperModel.h"
#import "NewMediaCollectionView.h"


@interface NewMediaCell : UITableViewCell

+(instancetype)initWithTableView:(UITableView *)tableView;

@property (nonatomic, strong) NewspaperModel * model;

//collectionView
@property (nonatomic, strong) NewMediaCollectionView *collectionView;

@end
