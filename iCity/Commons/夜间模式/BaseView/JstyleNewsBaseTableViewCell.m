//
//  JstyleNewsBaseTableViewCell.m
//  JstyleNews
//
//  Created by 王磊 on 2018/1/25.
//  Copyright © 2018年 JstyleNews. All rights reserved.
//

#import "JstyleNewsBaseTableViewCell.h"

@interface JstyleNewsBaseTableViewCell ()

@property (nonatomic, assign) BOOL isAllreadySetupPreviewingDelegate;

@end

@implementation JstyleNewsBaseTableViewCell

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
    self.backgroundColor = kNightModeBackColor;
    self.contentView.backgroundColor = kNightModeBackColor;
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setupPreviewingDelegateWithController:(UIViewController<UIViewControllerPreviewingDelegate> *)controller {
    if (self.isAllreadySetupPreviewingDelegate == YES) {
        return;
    }
    if ([self respondsToSelector:@selector(traitCollection)]) {
        if ([self.traitCollection respondsToSelector:@selector(forceTouchCapability)]) {
            if (self.traitCollection.forceTouchCapability == UIForceTouchCapabilityAvailable) {
                [controller registerForPreviewingWithDelegate:controller sourceView:self];
                self.isAllreadySetupPreviewingDelegate = YES;
            } else {
                self.isAllreadySetupPreviewingDelegate = NO;
            }
        }
    }
}

- (BOOL)isAllreadySetupPreviewingDelegate {
    return _isAllreadySetupPreviewingDelegate;
}

@end
