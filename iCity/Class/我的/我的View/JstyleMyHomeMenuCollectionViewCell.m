//
//  JstyleMyHomeMenuCollectionViewCell.m
//  Exquisite
//
//  Created by 王磊 on 2018/3/6.
//  Copyright © 2018年 JstyleStar. All rights reserved.
//

#import "JstyleMyHomeMenuCollectionViewCell.h"

@interface JstyleMyHomeMenuCollectionViewCell ()

@property (strong, nonatomic) IBOutlet UIImageView *menuImageView;
@property (strong, nonatomic) IBOutlet UILabel *menuTitleLabel;

@end

@implementation JstyleMyHomeMenuCollectionViewCell

- (void)setTitle:(NSString *)title {
    _title = title;
    if ([title containsString:@"退款"]) {
        [self.menuImageView setImage:JSImage(@"我的-退款售后")];
    } else {
        [self.menuImageView setImage:[UIImage imageNamed:[NSString stringWithFormat:@"我的-%@",title]]];
    }
    self.menuTitleLabel.text = title;
}

@end
