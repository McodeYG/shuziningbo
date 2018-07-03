//
//  JstyleNewsVideoTuijianCollectionViewCell.h
//  JstyleNews
//
//  Created by JingHongMuYun on 2017/12/4.
//  Copyright © 2017年 JstyleNews. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JstyleNewsVideoDetailIntroModel.h"

@interface JstyleNewsVideoTuijianCollectionViewCell : JstyleNewsBaseCollectionViewCell

@property (weak, nonatomic) IBOutlet YYAnimatedImageView *backImageView;

@property (weak, nonatomic) IBOutlet JstyleLabel *nameLabel;

@property (nonatomic, strong) JstyleNewsVideoDetailTuijianModel *model;

@end
