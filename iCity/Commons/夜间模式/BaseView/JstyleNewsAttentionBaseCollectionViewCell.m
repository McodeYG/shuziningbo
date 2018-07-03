//
//  JstyleNewsAttentionBaseCollectionViewCell.m
//  JstyleNews
//
//  Created by JingHongMuYun on 2018/4/11.
//  Copyright © 2018年 JstyleNews. All rights reserved.
//

#import "JstyleNewsAttentionBaseCollectionViewCell.h"

@implementation JstyleNewsAttentionBaseCollectionViewCell

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype) initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self applyTheme];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applyTheme) name:NightModeManagerNotification object:nil];
    }
    return self;
}
- (void)applyTheme {
    self.contentView.backgroundColor = (ISNightMode)?[UIColor colorFromHexString:@"#252525"]:kBackGroundColor;
}

@end
