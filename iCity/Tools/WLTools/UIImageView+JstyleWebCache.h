//
//  UIImageView+JstyleWebCache.h
//  JstyleNews
//
//  Created by 王磊 on 2017/10/24.
//  Copyright © 2017年 JstyleNews. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (JstyleWebCache)

- (void)js_setImageWithURL:(nullable NSURL *)url
          placeholderImage:(nullable UIImage *)placeholder;

@end
