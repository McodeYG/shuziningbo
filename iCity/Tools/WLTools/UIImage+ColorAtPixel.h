//
//  UIImage+ColorAtPixel.h
//  Exquisite
//
//  Created by 赵涛 on 2017/6/7.
//  Copyright © 2017年 Jstyle. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (ColorAtPixel)

/**按点取色*/
- (UIColor *)colorAtPixel:(CGPoint)point;

/**去主色调*/
+ (UIColor*)mostColor:(UIImage*)image;
@end
