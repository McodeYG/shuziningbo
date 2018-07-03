//
//  JstyleManagementWoDeCell.m
//  Exquisite
//
//  Created by 数字跃动 on 2017/10/11.
//  Copyright © 2017年 Jstyle. All rights reserved.
//

#import "JstyleManagementWoDeCell.h"

@interface JstyleManagementWoDeCell ()

@property (weak, nonatomic) IBOutlet UIView *line;

@end

@implementation JstyleManagementWoDeCell

-(void)awakeFromNib {
    [super awakeFromNib];
    
    [self setupUI];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.titleLabel.textColor = ISNightMode?kDarkNineColor:kDarkThreeColor;
    self.line.backgroundColor = kLightLineColor;
}

@end
