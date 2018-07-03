//
//  JstyleNewsAttentionBaseTableViewCell.m
//  JstyleNews
//
//  Created by JingHongMuYun on 2018/4/11.
//  Copyright © 2018年 JstyleNews. All rights reserved.
//

#import "JstyleNewsAttentionBaseTableViewCell.h"

@implementation JstyleNewsAttentionBaseTableViewCell

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

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self applyTheme];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applyTheme) name:NightModeManagerNotification object:nil];
    }
    return self;
}

- (void)applyTheme {
    self.backgroundColor = (ISNightMode)?[UIColor colorFromHexString:@"#252525"]:kBackGroundColor;
    self.contentView.backgroundColor = (ISNightMode)?[UIColor colorFromHexString:@"#252525"]:kBackGroundColor;
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
