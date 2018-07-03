//
//  JstyleNewsThemeCollectionViewCell.m
//  JstyleNews
//
//  Created by 数字跃动 on 2018/1/24.
//  Copyright © 2018年 JstyleNews. All rights reserved.
//

#import "JstyleNewsThemeCollectionViewCell.h"

@interface JstyleNewsThemeCollectionViewCell()

@property (weak, nonatomic) IBOutlet UIImageView *themeImageView;
@property (weak, nonatomic) IBOutlet UIButton *themeBtn;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation JstyleNewsThemeCollectionViewCell

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
    
    [self.themeImageView setImage:[UIImage imageWithColor:kDarkFiveColor]];
    
}

- (void)setTitle:(NSString *)title {
    _title = title;
    
    self.titleLabel.text = title;
    [self.themeImageView setImage:[UIImage imageNamed:title]];
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    
    self.themeBtn.selected = self.selected;
}

@end
