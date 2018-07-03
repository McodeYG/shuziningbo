//
//  JstyleNewsBaseView.m
//  JstyleNews
//
//  Created by JingHongMuYun on 2018/1/25.
//  Copyright © 2018年 JstyleNews. All rights reserved.
//

#import "JstyleNewsBaseView.h"

@implementation JstyleNewsBaseView

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self applyTheme];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applyTheme) name:NightModeManagerNotification object:nil];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self applyTheme];
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
    self.backgroundColor = kNightModeBackColor;
}

@end
