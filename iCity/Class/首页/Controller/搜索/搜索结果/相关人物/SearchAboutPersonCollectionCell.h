//
//  SearchAboutPersonCollectionCell.h
//  iCity
//
//  Created by mayonggang on 2018/6/13.
//  Copyright © 2018年 LongYuan. All rights reserved.
//

#import "JstyleNewsBaseCollectionViewCell.h"
#import "SearchModel.h"

@interface SearchAboutPersonCollectionCell : JstyleNewsBaseCollectionViewCell


/**介绍*/
//@property (nonatomic, strong) UILabel * infoLab;

@property (nonatomic, strong) SearchAboutPersonModel *model;

@property (nonatomic, copy) NSString * key;



@end
