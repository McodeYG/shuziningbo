//
//  PictureCollectionViewCell.h
//  图片浏览
//
//  Created by 赵涛 on 2017/4/25.
//  Copyright © 2017年 赵涛. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PictureModel.h"

typedef void (^GQSingleTap)();

@interface PictureCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet YYAnimatedImageView *backImageView;
@property (nonatomic, copy) GQSingleTap sigleTap;

@property (nonatomic, copy) PictureModel *model;

@end
