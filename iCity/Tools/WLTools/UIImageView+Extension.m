//
//  UIImageView+Extension.m
//  Exquisite
//
//  Created by 数字宁波 on 2017/4/6.
//  Copyright © 2017年 Jstyle. All rights reserved.
//

#import "UIImageView+Extension.h"

@implementation UIImageView (Extension)

- (void)setHeaderUrl:(NSString *)url
{
    [self setCircleHeaderUrl:url];
}

- (void)setCircleHeaderUrl:(NSString *)url
{
    [self sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"img_studio_default"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (image == nil) return;
        self.image = [image circleImage];
    }];
}
- (void)setHeaderUrl:(NSString *)url withplaceholderImageName:(NSString *)placeholderImageName
{
    [self sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:placeholderImageName] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (image == nil) return;
        self.image = [image circleImage];
    }];
    
}

@end
