//
//  JstyleNewFeaturePickTagCollectionViewCell.m
//  Exquisite
//
//  Created by 数字跃动 on 2017/8/24.
//  Copyright © 2017年 Jstyle. All rights reserved.
//

#import "JstyleNewFeaturePickTagCollectionViewCell.h"

#define KScale kScreenWidth / 375.0

@interface JstyleNewFeatureButton : UIButton

@end

@implementation JstyleNewFeatureButton

- (CGRect)imageRectForContentRect:(CGRect)contentRect {
    return CGRectMake(0, 0, self.size.width, self.size.height);
}

@end

@interface JstyleNewFeaturePickTagCollectionViewCell ()

@property (nonatomic, strong) JstyleNewFeatureButton *iconButton;
@property (nonatomic, strong) UIButton *isSelectedButton;
@property (nonatomic, strong) UILabel *tagLabel;
@property (nonatomic, strong) NSArray *iconNamesArray;

@end

@implementation JstyleNewFeaturePickTagCollectionViewCell

- (NSArray *)iconNamesArray {
    if (_iconNamesArray == nil) {
        _iconNamesArray = @[@"娱乐",@"影音",@"时尚",@"穿搭",@"美容",@"艺术",@"生活",@"家居",@"旅行",@"美食",@"运动",@"健康",@"情感",@"街拍",@"科技",@"搞笑",@"宠物",@"心理"];
    }
    return _iconNamesArray;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    
    //icon
    JstyleNewFeatureButton *iconButton = [[JstyleNewFeatureButton alloc] init];
    self.iconButton = iconButton;
    iconButton.contentMode = UIViewContentModeScaleAspectFill;
    iconButton.layer.cornerRadius = (74 * KScale) / 2;
    iconButton.layer.masksToBounds = YES;
    iconButton.layer.borderWidth = 1.7 * KScale;
    iconButton.layer.borderColor = [UIColor colorFromHex:0xDEDEDE].CGColor;
    iconButton.imageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.contentView addSubview:iconButton];
    [iconButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.offset(0);
        make.height.offset(74 * KScale);
    }];
    iconButton.userInteractionEnabled = NO;
    
    //透明遮罩
    UIView *maskView = [UIView new];
    maskView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2];
    [iconButton addSubview:maskView];
    [maskView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(iconButton);
    }];
    
    //title
    UILabel *tagLabel = [UILabel new];
    self.tagLabel = tagLabel;
    tagLabel.textColor = kDarkTwoColor;
    tagLabel.font = [UIFont systemFontOfSize:11];
    tagLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:tagLabel];
    [tagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(iconButton.mas_bottom).offset(6 * KScale);
        make.left.right.bottom.offset(0);
    }];
    
    //对勾
    UIButton *isSelectedButton = [UIButton new];
    self.isSelectedButton = isSelectedButton;
    [isSelectedButton setImage:[UIImage imageNamed:@"选中"] forState:UIControlStateSelected];
    [isSelectedButton sizeToFit];
    [self.contentView addSubview:isSelectedButton];
    [isSelectedButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(56 * KScale);
        make.left.offset(51 * KScale);
    }];
    
}

- (void)setIndexPath:(NSIndexPath *)indexPath {
    _indexPath = indexPath;
    
    [self.iconButton setImage:[UIImage imageNamed:self.iconNamesArray[indexPath.item]] forState:UIControlStateNormal];
    self.tagLabel.text = self.iconNamesArray[indexPath.item];
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    if (selected) {
        self.iconButton.layer.borderColor = JSColor(@"#EE6767").CGColor;
    } else {
        self.iconButton.layer.borderColor = [UIColor colorFromHex:0xDEDEDE].CGColor;
    }
}

@end
