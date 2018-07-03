//
//  UIImageView+JstyleWebCache.m
//  JstyleNews
//
//  Created by 王磊 on 2017/10/24.
//  Copyright © 2017年 JstyleNews. All rights reserved.
//

#import "UIImageView+JstyleWebCache.h"
#import <UIImageView+WebCache.h>

@implementation UIImageView (JstyleWebCache)

- (void)js_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder {
    [self sd_setImageWithURL:url placeholderImage:placeholder];
}



@end
