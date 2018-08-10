//
//  JstyleMyMemuViewCell.h
//  Exquisite
//
//  Created by 数字宁波 on 2016/11/24.
//  Copyright © 2016年 LanBao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JstyleMyMenuViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *menuImageView;

@property (weak, nonatomic) IBOutlet UILabel *menuNameLabel;

@property (nonatomic, strong) UIView *bottomLine;

@end
