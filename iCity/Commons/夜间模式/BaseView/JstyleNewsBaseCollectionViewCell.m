//
//  JstyleNewsBaseCollectionViewCell.m
//  JstyleNews
//
//  Created by JingHongMuYun on 2018/1/25.
//  Copyright © 2018年 JstyleNews. All rights reserved.
//

#import "JstyleNewsBaseCollectionViewCell.h"

@implementation JstyleNewsBaseCollectionViewCell

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)awakeFromNib {
    [super awakeFromNib];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applyTheme) name:NightModeManagerNotification object:nil];
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applyTheme) name:NightModeManagerNotification object:nil];
    }
    return self;
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
    self.contentView.backgroundColor = kNightModeBackColor;
}

@end
