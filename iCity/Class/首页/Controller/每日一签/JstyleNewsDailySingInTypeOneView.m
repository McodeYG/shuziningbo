//
//  JstyleNewsDailySingInTypeOneView.m
//  JstyleNews
//
//  Created by 王磊 on 2018/3/12.
//  Copyright © 2018年 JstyleNews. All rights reserved.
//

#import "JstyleNewsDailySingInTypeOneView.h"

#define Margin_Left     17
#define Margin_Bottom   33
#define Margin_PosterHeight   37
#define Margin_PictureHeight 464.0

@implementation JstyleNewsDailySingInTypeOneView

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.posterBorderImageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.pictureImageView).offset(Margin_Left);
        make.bottom.equalTo(self.pictureImageView).offset(-Margin_Bottom);
    }];
}

- (UIImage *)renderShareImage {
    
    UIImageView *posterImageView = self.posterImageView;
    CGFloat posterImageViewHeight = posterImageView.height-1;
    
    UIGraphicsBeginImageContextWithOptions(posterImageView.bounds.size, NO, 0.0);
    
    [[UIBezierPath bezierPathWithRoundedRect:posterImageView.bounds cornerRadius:posterImageView.width] addClip];
    
    [posterImageView.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    posterImageView.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(self.pictureImageView.size.width, self.pictureImageView.size.height), YES, 0.0);
    [self.pictureImageView.image drawInRect:CGRectMake(0, 0, self.pictureImageView.width, self.pictureImageView.height)];
    
    
    CGContextTranslateCTM(UIGraphicsGetCurrentContext(), Margin_Left, (Margin_PictureHeight - 22) - posterImageViewHeight + (kScale == 1?0:50.5));
    
    [self.nameLabel.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    CGContextTranslateCTM(UIGraphicsGetCurrentContext(), 0, 0);
    
    [self.posterBorderImageView.image drawInRect:CGRectMake(0, -23.5 + posterImageViewHeight - 28 + 3, self.posterBorderImageView.width, self.posterBorderImageView.height)];
    [posterImageView.image drawInRect:CGRectMake(1, -21.7 + posterImageViewHeight - 29 + 3, posterImageViewHeight, posterImageViewHeight)];
    
    UIImage *shareImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return shareImage;
}

@end
