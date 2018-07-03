//
//  JstylePersonalMediaSquareViewCell.h
//  Exquisite
//
//  Created by 赵涛 on 2017/8/4.
//  Copyright © 2017年 Jstyle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JstylePersonalMediaModel.h"

@interface JstylePersonalMediaSquareViewCell : JstyleNewsBaseCollectionViewCell
@property (weak, nonatomic) IBOutlet YYAnimatedImageView *backImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *introLabel;
@property (weak, nonatomic) IBOutlet UILabel *followNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *articleNumLabel;
@property (weak, nonatomic) IBOutlet UIView *alphaView;

@property (nonatomic, strong) JstylePersonalMediaListModel *model;

@end
