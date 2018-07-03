//
//  JstyleNewsPlaceholderView.m
//  JstyleNews
//
//  Created by 王磊 on 2018/1/2.
//  Copyright © 2018年 JstyleNews. All rights reserved.
//

#import "JstyleNewsPlaceholderView.h"

@implementation JstyleNewsPlaceholderView

- (instancetype)initWithFrame:(CGRect)frame placeholderImage:(UIImage *)placeholerImage placeholderText:(NSString *)placeholderText{
    if (self = [super initWithFrame:frame]) {
        [self setupUIWithPlaceholderImage:placeholerImage placeholderText:placeholderText];
    }
    return self;
}

- (void)setupUIWithPlaceholderImage:(UIImage *)placeholder placeholderText:(NSString *)placeholderText{
    
    self.backgroundColor = ISNightMode?kNightModeBackColor:JSColor(@"#F9F9F9");
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:placeholder];
    [imageView sizeToFit];
    [self addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.offset(0);
        make.centerY.offset(-130);
    }];
    
    UILabel *label = [UILabel labelWithColor:ISNightMode?kDarkNineColor:kDarkSixColor fontSize:14 text:placeholderText alignment:NSTextAlignmentCenter];
    [label sizeToFit];
    [self addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.offset(0);
        make.centerY.offset(-30);
    }];
}

@end
