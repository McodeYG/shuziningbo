//
//  JstyleNewsBaseAttentionButton.m
//  JstyleNews
//
//  Created by 王磊 on 2018/4/9.
//  Copyright © 2018年 JstyleNews. All rights reserved.
//

#import "JstyleNewsBaseAttentionButton.h"

#define kButtonHeight 27.0

@implementation JstyleNewsBaseAttentionButton

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self setupUIWithButton:self];
}

+ (instancetype)buttonWithType:(UIButtonType)buttonType {
    
    JstyleNewsBaseAttentionButton *button = [super buttonWithType:buttonType];
    [button setupUIWithButton:button];
    return button;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupUIWithButton:self];
    }
    return self;
}

- (void)setupUIWithButton:(JstyleNewsBaseAttentionButton *)button {
    
    button.layer.cornerRadius = kButtonHeight / 2.0;
    button.layer.borderWidth = 0.5;
    button.layer.borderColor = [UIColor clearColor].CGColor;
    button.layer.masksToBounds = YES;
    button.titleLabel.font = [UIFont fontWithName:@"PingFang SC" size:12];
    button.adjustsImageWhenHighlighted = NO;
    [button setTitle:@"＋关注" forState:UIControlStateNormal];
    [button setTitle:@"已关注" forState:UIControlStateSelected];
    [button setTitleColor:kWhiteColor forState:UIControlStateNormal];
//    [button setTitleColor:JSColor(@"#646464") forState:UIControlStateSelected];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
//    [button setBackgroundImage:[UIImage imageWithColor:kPinkColor] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageWithColor:[UIColor blackColor]] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageWithColor:kWhiteColor] forState:UIControlStateSelected];
    
    //主题换肤
//    button.lee_theme
//    .LeeCustomConfig(ThemeMainBtnTitleOrBorderColor, ^(id item, id value) {
//        UIButton *button = (UIButton *)item;
//        [button setTitleColor:kWhiteColor forState:UIControlStateNormal];
//        [button setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
//        [button setBackgroundImage:[UIImage imageWithColor:value] forState:UIControlStateNormal];
//        [button setBackgroundImage:[UIImage imageWithColor:kWhiteColor] forState:UIControlStateSelected];
//    });
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    

    if (selected) {
        //        self.layer.borderColor = JSColor(@"#DEDEDE").CGColor;
        self.layer.borderColor = [UIColor blackColor].CGColor;
    } else {
        self.layer.borderColor = [UIColor clearColor].CGColor;
        
    }
    

}

- (void)setHighlighted:(BOOL)highlighted {
    //做空highlighted状态
}

-(void)setNormal_title:(NSString *)normal_title {
    _normal_title = normal_title;
    [self setTitle:normal_title forState:UIControlStateNormal];
}



@end
