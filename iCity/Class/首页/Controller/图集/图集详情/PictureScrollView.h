//
//  PictureScrollView.h
//  图片浏览
//
//  Created by 赵涛 on 2017/4/25.
//  Copyright © 2017年 赵涛. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PictureScrollView : UIScrollView<UIScrollViewDelegate>

@property (nonatomic, copy) NSString *imageUrl;

@property (nonatomic, strong) UIImageView *imageView;

@property (nonatomic, strong) UIImage *placeholderImage;

@property (nonatomic, copy) void(^singleTap)();

@end
