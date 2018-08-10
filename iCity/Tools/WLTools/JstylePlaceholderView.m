//
//  JstylePlaceholderView.m
//  Exquisite
//
//  Created by 数字宁波 on 2016/12/1.
//  Copyright © 2016年 LanBao. All rights reserved.
//

#import "JstylePlaceholderView.h"
#define KScale kScreenWidth / 375.0

@interface JstylePlaceholderView ()

@property (nonatomic, strong) UIView *labelView;


@end

@implementation JstylePlaceholderView

- (instancetype)initWithFrame:(CGRect)frame imageName:(NSString *)imageName title:(NSString *)title{
    CGRect rect = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    if (self = [super initWithFrame:rect]) {
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:frame];
        imageView.image = [UIImage imageNamed:imageName];
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, imageView.y + imageView.height + 30, self.bounds.size.width, 16)];
        label.textColor = kDarkNineColor;
        label.textAlignment = NSTextAlignmentCenter;
        label.text = title;
        
        [self addSubview:imageView];
        [self addSubview:label];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame imageName:(NSString *)imageName titleStr:(NSString *)titleStr{
    CGRect rect = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    if (self = [super initWithFrame:rect]) {
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:frame];
        imageView.image = [UIImage imageNamed:imageName];
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, imageView.y + imageView.height + 30, self.bounds.size.width, 16)];
        label.textColor = kDarkNineColor;
        label.textAlignment = NSTextAlignmentCenter;
        label.text = titleStr;
        
        _button = [[UIButton alloc]initWithFrame:CGRectMake(0, label.y + label.height + 15, 75, 34)];
        _button.centerX = label.centerX;
        [_button setTitle:@"去逛逛" forState:(UIControlStateNormal)];
        _button.titleLabel.font = [UIFont systemFontOfSize:16];
        _button.titleLabel.textAlignment = NSTextAlignmentCenter;
        _button.backgroundColor = kDarkOneColor;
        _button.layer.cornerRadius = 2;
        _button.layer.masksToBounds = YES;
        [_button addTarget:self action:@selector(goBtnClick) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:imageView];
        [self addSubview:label];
        [self addSubview:_button];
    }
    return self;
}

- (instancetype)initWithPlaceholderViewType:(JstylePlaceholderViewType)type {
    
    CGRect rect = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    
    if (self = [super initWithFrame:rect]) {
        
        switch (type) {
            case JstylePlaceholderViewTypeNoSingle:
            {
                [self setupUIWithImageName:@"Rectangle空白" textLabel:@"信号被外星人抓走啦" btnName:@"  刷新试试  " offset:0];
            }
                break;
            case JstylePlaceholderViewTypeShopCar:
            {
                [self setupUIWithImageName:@"购物车空白" textLabel:@"购物车竟然是空的，马上去选购" btnName:@"精品" offset:0];
            }
                break;
            case JstylePlaceholderViewTypeDianZiKan:
            {
                [self setupUIWithImageName:@"电子刊空白" textLabel:@"去阅读我喜欢的" btnName:@"杂志" offset:64];
            }
                break;
            case JstylePlaceholderViewTypeTeHuiDianZiQuan:
            {
                [self setupUIWithImageName:@"电子券空白" textLabel:@"去看看精选" btnName:@"特惠" offset:0];
            }
                break;
            case JstylePlaceholderViewTypeTeHuiOrder:
            {
                [self setupUIWithImageName:@"订单空白" textLabel:@"去看看精选" btnName:@"特惠" offset:0];
            }
                break;
            case JstylePlaceholderViewTypeJuhui:
            {
                [self setupUIWithImageName:@"聚会空白" textLabel:@"丰富生活，没有尬聊，去看看" btnName:@"聚会" offset:0];
            }
                break;
            case JstylePlaceholderViewTypeDingYue:
            {
                [self setupUIWithImageName:@"电子刊空白" textLabel:@"寻找我感兴趣的" btnName:@"iCity号" offset:0];
            }
                break;
            default:
                break;
        }
    }
    return self;
}

- (instancetype)initWithPlaceholderViewType:(JstylePlaceholderViewType)type offset:(NSInteger)offset {
    
    CGRect rect = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    
    if (self = [super initWithFrame:rect]) {
        
        switch (type) {
            case JstylePlaceholderViewTypeNoSingle:
            {
                [self setupUIWithImageName:@"Rectangle空白" textLabel:@"信号被外星人抓走啦" btnName:@"  刷新试试  " offset:offset];
            }
                break;
            case JstylePlaceholderViewTypeShopCar:
            {
                [self setupUIWithImageName:@"购物车空白" textLabel:@"购物车竟然是空的，马上去选购" btnName:@"精品" offset:offset];
            }
                break;
            case JstylePlaceholderViewTypeDianZiKan:
            {
                [self setupUIWithImageName:@"电子刊空白" textLabel:@"去阅读我喜欢的" btnName:@"杂志" offset:offset];
            }
                break;
            case JstylePlaceholderViewTypeTeHuiDianZiQuan:
            {
                [self setupUIWithImageName:@"电子券空白" textLabel:@"去看看精选" btnName:@"特惠" offset:offset];
            }
                break;
            case JstylePlaceholderViewTypeTeHuiOrder:
            {
                [self setupUIWithImageName:@"订单空白" textLabel:@"去看看精选" btnName:@"特惠" offset:offset];
            }
                break;
            case JstylePlaceholderViewTypeJuhui:
            {
                [self setupUIWithImageName:@"聚会空白" textLabel:@"丰富生活，没有尬聊，去看看" btnName:@"聚会" offset:offset];
            }
                break;
            case JstylePlaceholderViewTypeDingYue:
            {
                [self setupUIWithImageName:@"电子刊空白" textLabel:@"寻找我感兴趣的" btnName:@"iCity号" offset:offset];
            }
                break;
            default:
                break;
        }
    }
    return self;
}

- (void)setupUIWithImageName:(NSString *)imageName textLabel:(NSString *)text btnName:(NSString *)btnTitle offset:(NSInteger)offset{
    
    if ([imageName isEqualToString:@"Rectangle空白"]) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        UIImageView *imageView = [self addImageViewWithImageName:imageName];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.offset(-5 * KScale);
            make.top.offset((133 + offset)* KScale);
            make.width.height.offset(110 * KScale);
        }];

        UILabel *label = [self addTextLabelWithText:text];
        [self addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.offset(0);
            make.top.equalTo(imageView.mas_bottom).offset(34 * KScale);
        }];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.layer.borderWidth = 0.8f;
        button.layer.borderColor = kLightGoldColor.CGColor;
        [button setTitle:btnTitle forState:UIControlStateNormal];
        [button setTitleColor:kLightGoldColor forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:14];
        [button sizeToFit];
        [self addSubview:button];
        [button addTarget:self action:@selector(goBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(label.mas_bottom).offset(15 *KScale);
            make.height.offset(25*KScale);
            make.centerX.offset(0);
        }];
        
        return;
    }
    
    UIImageView *imageView = [self addImageViewWithImageName:imageName];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.offset(0);
        make.top.offset((133 + offset)* KScale);
        make.width.height.offset(110 * KScale);
    }];
    
    _labelView = [UIView new];
    [self addSubview:_labelView];
    [_labelView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.offset(-20 * KScale);
        make.top.equalTo(imageView.mas_bottom).offset(34 * KScale);
        make.width.offset(kScreenWidth);
        make.height.offset(20 * KScale);
    }];
    
    UILabel *textLabel = [self addTextLabelWithText:text];
    [textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.offset(0);
        make.top.offset(0);
    }];
    
    UIButton *clickBtn = [self addClickBtnWithBtnName:btnTitle];
    [clickBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(textLabel);
        make.left.equalTo(textLabel.mas_right).offset(0);
    }];
    
    UIButton *goBtn = [self addGoBtn];
    [goBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(clickBtn).offset(-1 * KScale);
        make.left.equalTo(clickBtn.mas_right).offset(2 * KScale);
    }];
}

- (UIImageView *)addImageViewWithImageName:(NSString *)imageName {
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.image = [UIImage imageNamed:imageName];
    [self addSubview:imageView];
    return imageView;
}

- (UILabel *)addTextLabelWithText:(NSString *)text {
    UILabel *textLabel = [UILabel new];
    textLabel.text = text;
    textLabel.font = [UIFont systemFontOfSize:14];
    textLabel.textColor = kDarkSixColor;
    [self.labelView addSubview:textLabel];
    return textLabel;
}

- (UIButton *)addClickBtnWithBtnName:(NSString *)btnName {
    UIButton *clickBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [clickBtn setTitle:btnName forState:UIControlStateNormal];
    [clickBtn setTitleColor:kLightGoldColor forState:UIControlStateNormal];
    clickBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [clickBtn addTarget:self action:@selector(goBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.labelView addSubview:clickBtn];
    return clickBtn;
}

- (UIButton *)addGoBtn {
    UIButton *goBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [goBtn setImage:[UIImage imageNamed:@"订阅更多"] forState:UIControlStateNormal];
    [goBtn sizeToFit];
    [goBtn addTarget:self action:@selector(goBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.labelView addSubview:goBtn];
    return goBtn;
}

- (void)goBtnClick {
    if (self.btnClickBlock) {
        self.btnClickBlock();
    }
}

@end
