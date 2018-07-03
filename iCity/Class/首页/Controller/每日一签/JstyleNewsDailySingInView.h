//
//  JstyleNewsDailySingInView.h
//  JstyleNews
//
//  Created by 王磊 on 2018/2/2.
//  Copyright © 2018年 JstyleNews. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JstyleNewsDailySingInModel.h"
#import "WLLabel.h"

@interface JstyleNewsDailySingInView : UIView

///海报
@property (nonatomic, strong) UIImageView *pictureImageView;
///头像
@property (nonatomic, strong) UIImageView *posterImageView;
///头像后面红边
@property (nonatomic, strong) UIImageView *posterBorderImageView;
///昵称
@property (nonatomic, strong) WLLabel *nameLabel;

@property (nonatomic, strong) JstyleNewsDailySingInModel *model;
@property (nonatomic, copy) void(^shareImageBlock)(UIImage *shareImage);
@property (nonatomic, copy) void(^chatBlock)(JstyleNewsDailySingInModel *model);

@end
