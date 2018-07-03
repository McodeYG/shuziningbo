//
//  SearchAllCityUserCell.h
//  iCity
//
//  Created by mayonggang on 2018/6/13.
//  Copyright © 2018年 LongYuan. All rights reserved.
//

#import "JstyleNewsBaseTableViewCell.h"
#import "JstyleNewsJMAttentionTuiJianCollectionView.h"


@interface SearchAllCityUserCell : JstyleNewsBaseTableViewCell


+(instancetype)initWithTableView:(UITableView *)tableView;

@property (nonatomic, strong) JstyleNewsJMAttentionTuiJianCollectionView *tuiJianCollectionView;


@end
