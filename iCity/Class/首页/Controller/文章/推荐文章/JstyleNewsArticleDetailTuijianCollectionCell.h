//
//  JstyleNewsArticleDetailTuijianCollectionCell.h
//  JstyleNews
//
//  Created by JingHongMuYun on 2017/12/29.
//  Copyright © 2017年 JstyleNews. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JstyleNewsArticleDetailTuijianModel.h"

@interface JstyleNewsArticleDetailTuijianCollectionCell : JstyleNewsBaseCollectionViewCell

@property (weak, nonatomic) IBOutlet YYAnimatedImageView *backImageView;

@property (weak, nonatomic) IBOutlet JstyleLabel *nameLabel;

@property (nonatomic, strong) JstyleNewsArticleDetailTuijianModel *model;

@end
