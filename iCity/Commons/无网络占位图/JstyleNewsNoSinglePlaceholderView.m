//
//  JstyleNewsNoSinglePlaceholderView.m
//  JstyleNews
//
//  Created by 王磊 on 2018/1/31.
//  Copyright © 2018年 JstyleNews. All rights reserved.
//

#import "JstyleNewsNoSinglePlaceholderView.h"

@interface JstyleNewsNoSinglePlaceholderView()

@property (nonatomic, strong) UILabel *noConnectedLabel;

@end

@implementation JstyleNewsNoSinglePlaceholderView

-(void)awakeFromNib {
    [super awakeFromNib];
    
    [self setupUI];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    
    self.backgroundColor = kNightModeBackColor;
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"无网页面"]];
    [self addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.offset(-5);
        make.centerY.offset(-50);
    }];
    
    UILabel *label = [UILabel labelWithColor:(ISNightMode? kDarkNineColor : kDarkSixColor) fontSize:14 text:@"网络不给力,点击屏幕重试" alignment:NSTextAlignmentCenter];
    [self addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.offset(0);
        make.top.equalTo(imageView.mas_bottom).offset(35);
    }];
    
    UITapGestureRecognizer *tap  = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick)];
    [self addGestureRecognizer:tap];
    
    [self addNoConnectedLabel];
    
}

- (void)addNoConnectedLabel {
    if ([[JstyleToolManager sharedManager] getCurrentNetStatus] == NotReachable) {
        UILabel *noConnectedLabel = [UILabel labelWithColor:JSColor(@"#2796E3") fontSize:14 text:@"没有网络连接，请检查网络" alignment:NSTextAlignmentCenter];
        self.noConnectedLabel = noConnectedLabel;
        noConnectedLabel.backgroundColor = JSColor(@"#D6E9F7");
        noConnectedLabel.frame = CGRectMake(0, 0, kScreenWidth, 31);
        [self addSubview:noConnectedLabel];
        [self showNoConnectedLabelWithStatus:@"没有网络连接，请检查网络"];
    }
}

- (void)showNoConnectedLabelWithStatus:(NSString *)status {
    self.noConnectedLabel.text = status;
    self.noConnectedLabel.alpha = 0;
    [UIView animateWithDuration:0.5 animations:^{
        self.noConnectedLabel.alpha = 1.0;
    }];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.5 animations:^{
            self.noConnectedLabel.alpha = 0;
        } completion:^(BOOL finished) {
//            [self.noConnectedLabel removeFromSuperview];
        }];
    });
}

- (void)tapClick {
    if (self.reloadBlock) {
        self.reloadBlock();
    }
}

@end
