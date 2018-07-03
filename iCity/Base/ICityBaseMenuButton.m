//
//  ICityBaseMenuButton.m
//  iCity
//
//  Created by 王磊 on 2018/4/29.
//  Copyright © 2018年 LongYuan. All rights reserved.
//

#import "ICityBaseMenuButton.h"

@implementation ICityBaseMenuButton

+ (instancetype)buttonWithImage:(UIImage *)image title:(NSString *)title {
    ICityBaseMenuButton *button = [ICityBaseMenuButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:title forState:UIControlStateNormal];
    [button setImage:image forState:UIControlStateNormal];
    [button setTitleColor:kDarkThreeColor forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont fontWithName:@"PingFang SC" size:15];
    return button;
}

- (void)layoutSubviews {
    [super layoutSubviews];
        
//    CGFloat marginH = (self.frame.size.height - self.imageView.frame.size.height - self.titleLabel.frame.size.height)/3;
    CGFloat marginH = 17 * kScale;
    self.imageView.width = 40 * kScale;
    self.imageView.height = 40 * kScale;
    CGPoint imageCenter = self.imageView.center;
    imageCenter.x = self.frame.size.width/2;
    imageCenter.y = self.imageView.frame.size.height/2 + marginH;
    self.imageView.center = imageCenter;
    
    CGRect newFrame = self.titleLabel.frame;
    newFrame.origin.x = 0;
    newFrame.origin.y = self.frame.size.height - newFrame.size.height - marginH;
    newFrame.size.width = self.frame.size.width;
    self.titleLabel.frame = newFrame;
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
}

@end
