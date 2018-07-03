//
//  UIImageView+Extension.h
//  Exquisite
//
//  Created by 赵涛 on 2017/4/6.
//  Copyright © 2017年 Jstyle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImage+Extension.h"

@interface UIImageView (Extension)

// 没有占位图片
- (void)setHeaderUrl:(NSString *)url;
// 带有占位图片
- (void)setHeaderUrl:(NSString *)url withplaceholderImageName:(NSString *)placeholderImageName;

@end
