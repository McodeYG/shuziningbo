//
//  TopTabView.m
//  NinaPagerView
//
//  Created by RamWire on 2016/11/10.
//  Copyright © 2016年 赵富阳. All rights reserved.
//

#import "TopTabView.h"
#import "UIParameter.h"

@interface TopTabView()
@property (strong, nonatomic) UIImageView *leftImage;
@property (strong, nonatomic) UILabel *rightTitle;
@end

@implementation TopTabView {
    NSString *imageName;
    NSString *titleName;
    UIColor *myTitleColor;
}

- (instancetype)initWithLeftImageName:(NSString *)leftImageName WithRightTitle:(NSString *)rightTitleString WithTitleColor:(UIColor *)titleColor {
    if (self = [super init]) {
        imageName = leftImageName;
        titleName = rightTitleString;
        myTitleColor = titleColor;
        [self addSubview:self.leftImage];
        [self addSubview:self.rightTitle];
        [self initUI];
    }
    return self;
}

#pragma mark - LazyLoad
- (UIImageView *)leftImage {
    if (!_leftImage) {
        _leftImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
    }
    return _leftImage;
}

- (UILabel *)rightTitle {
    if (!_rightTitle) {
        _rightTitle = [UILabel new];
        _rightTitle.text = titleName;
        _rightTitle.textAlignment = NSTextAlignmentCenter;
        _rightTitle.textColor = myTitleColor;
        _rightTitle.font = [UIFont systemFontOfSize:14];
    }
    return _rightTitle;
}

#pragma mark - LayOut 
- (void)initUI {
    CGFloat width = 16 * self.rightTitle.text.length;
    CGFloat totalWidth = 18 + 5 + width;
    self.leftImage.frame = CGRectMake((kScreenWidth/2 - totalWidth)/2, 13, 18, 18);
    self.rightTitle.frame = CGRectMake(self.leftImage.right + 5, 0, width, 44);
}

@end
